using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using E_Education.API.Data;
using E_Education.API.Models;

namespace E_Education.API.Controllers
{
    [ApiController]
    [Route("api/payments")]
    public class PaymentsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly ILogger<PaymentsController> _logger;

        public PaymentsController(
            ApplicationDbContext context,
            IConfiguration configuration,
            IHttpClientFactory httpClientFactory,
            ILogger<PaymentsController> logger)
        {
            _context = context;
            _configuration = configuration;
            _httpClientFactory = httpClientFactory;
            _logger = logger;
        }

        // GET: api/payments/vip-status
        [HttpGet("vip-status")]
        [Authorize]
        public async Task<ActionResult> GetVipStatus()
        {
            var userIdClaim = User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
            {
                return Unauthorized();
            }

            var user = await _context.Users.FindAsync(userId);
            if (user == null)
            {
                return NotFound();
            }

            // Check if VIP expired
            bool isVip = user.IsVip && user.VipExpiresAt.HasValue && user.VipExpiresAt.Value > DateTime.UtcNow;
            if (user.IsVip && !isVip)
            {
                // Auto-expire
                user.IsVip = false;
                await _context.SaveChangesAsync();
            }

            int? daysRemaining = null;
            if (isVip && user.VipExpiresAt.HasValue)
            {
                daysRemaining = Math.Max(0, (int)(user.VipExpiresAt.Value - DateTime.UtcNow).TotalDays);
            }

            return Ok(new
            {
                isVip,
                expiresAt = user.VipExpiresAt,
                daysRemaining
            });
        }

        // GET: api/payments/plans
        [HttpGet("plans")]
        [AllowAnonymous]
        public async Task<ActionResult> GetPlans()
        {
            try
            {
                var plans = await _context.VipPlans
                    .Where(p => p.IsActive)
                    .OrderBy(p => p.Days)
                    .Select(p => new
                    {
                        p.Id,
                        p.Name,
                        p.Days,
                        p.Price,
                        p.IsActive
                    })
                    .ToListAsync();
                
                return Ok(plans);
            }
            catch
            {
                return Ok(new List<object>());
            }
        }

        // POST: api/payments/create-order
        [HttpPost("create-order")]
        [Authorize]
        public async Task<ActionResult> CreateOrder([FromBody] CreateOrderRequest request)
        {
            var userIdClaim = User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
            {
                return Unauthorized();
            }

            // Find plan
            var plan = await _context.VipPlans.FindAsync(request.PlanId);
            if (plan == null || !plan.IsActive)
            {
                return BadRequest(new { message = "Gói VIP không hợp lệ" });
            }

            // Generate unique order code - PayOS requires integer orderCode (max 19 digits)
            // Use Unix timestamp in seconds (like PayOS Java demo: System.currentTimeMillis() / 1000)
            // This ensures uniqueness and simplicity
            var payOSOrderCode = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
            
            // Store original order code for reference
            var orderCode = $"VIP_{userId}_{payOSOrderCode}";

            // Create payment record
            var payment = new Payment
            {
                UserId = userId,
                VipPlanId = plan.Id,
                Amount = plan.Price,
                Currency = "VND",
                PayOSOrderCode = payOSOrderCode.ToString(), // Store PayOS order code
                Status = "pending",
                CreatedAt = DateTime.UtcNow
            };

            _context.Payments.Add(payment);
            await _context.SaveChangesAsync();

            // Call PayOS API to create payment link
            try
            {
                // Read from Environment Variables (Render) or Configuration (appsettings.json)
                // Format trên Render: PayOS__ClientId hoặc PayOS:ClientId
                var payOSClientId = Environment.GetEnvironmentVariable("PayOS__ClientId") 
                    ?? _configuration["PayOS:ClientId"];
                var payOSApiKey = Environment.GetEnvironmentVariable("PayOS__ApiKey") 
                    ?? _configuration["PayOS:ApiKey"];
                var payOSChecksumKey = Environment.GetEnvironmentVariable("PayOS__ChecksumKey") 
                    ?? _configuration["PayOS:ChecksumKey"];
                
                // PayOS URLs - MUST be set in environment variables
                var returnUrl = Environment.GetEnvironmentVariable("PayOS__ReturnUrl") 
                    ?? _configuration["PayOS:ReturnUrl"];
                var cancelUrl = Environment.GetEnvironmentVariable("PayOS__CancelUrl") 
                    ?? _configuration["PayOS:CancelUrl"];
                
                if (string.IsNullOrEmpty(returnUrl) || string.IsNullOrEmpty(cancelUrl))
                {
                    _logger.LogError("PayOS ReturnUrl or CancelUrl is missing");
                    return StatusCode(500, new { message = "Cấu hình PayOS URL chưa được thiết lập" });
                }
                
                _logger.LogInformation("PayOS URLs - Return: {ReturnUrl}, Cancel: {CancelUrl}", returnUrl, cancelUrl);

                if (string.IsNullOrEmpty(payOSClientId) || string.IsNullOrEmpty(payOSApiKey) || 
                    string.IsNullOrEmpty(payOSChecksumKey))
                {
                    _logger.LogError("PayOS configuration is missing");
                    return StatusCode(500, new { message = "Cấu hình PayOS chưa được thiết lập" });
                }

                // Prepare PayOS payment request according to PayOS API v2
                // PayOS API v2 uses "items" (array) in the request body
                var payOSItems = new[]
                {
                    new
                    {
                        name = plan.Name,
                        quantity = 1,
                        price = (int)plan.Price
                    }
                };

                var amount = (int)plan.Price;
                var description = $"Nâng cấp {plan.Name}";

                // Create signature: PayOS requires signature from query string format (alphabetically sorted)
                // Format: amount=$amount&cancelUrl=$cancelUrl&description=$description&orderCode=$orderCode&returnUrl=$returnUrl
                // NOTE: Do NOT URL encode - use raw URL strings
                var signatureData = $"amount={amount}&cancelUrl={cancelUrl}&description={description}&orderCode={payOSOrderCode}&returnUrl={returnUrl}";
                var signature = CreatePayOSSignature(signatureData, payOSChecksumKey);
                
                _logger.LogInformation("PayOS Signature Data: {Data}", signatureData);
                _logger.LogInformation("PayOS Signature (first 16 chars): {Signature}", signature?.Substring(0, Math.Min(16, signature?.Length ?? 0)) + "...");

                var requestBody = new
                {
                    orderCode = payOSOrderCode,
                    amount = amount,
                    description = description,
                    items = payOSItems,  // PayOS API v2 uses "items" (array)
                    cancelUrl = cancelUrl,
                    returnUrl = returnUrl,
                    signature = signature
                };

                var httpClient = _httpClientFactory.CreateClient();
                httpClient.Timeout = TimeSpan.FromSeconds(30);
                httpClient.DefaultRequestHeaders.Clear();
                httpClient.DefaultRequestHeaders.Add("x-client-id", payOSClientId);
                httpClient.DefaultRequestHeaders.Add("x-api-key", payOSApiKey);

                var options = new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };
                var jsonContent = JsonSerializer.Serialize(requestBody, options);
                var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");
                
                // PayOS API endpoint - Hardcoded (Production)
                const string payOSApiUrl = "https://api-merchant.payos.vn/v2/payment-requests";
                
                _logger.LogInformation("Calling PayOS API: {Url}", payOSApiUrl);
                _logger.LogInformation("PayOS ClientId: {ClientId}", payOSClientId?.Substring(0, Math.Min(8, payOSClientId?.Length ?? 0)) + "...");
                
                // Retry logic for DNS resolution issues
                HttpResponseMessage response = null;
                int maxRetries = 3;
                for (int attempt = 1; attempt <= maxRetries; attempt++)
                {
                    try
                    {
                        _logger.LogInformation("PayOS API call attempt {Attempt}/{MaxRetries}", attempt, maxRetries);
                        response = await httpClient.PostAsync(payOSApiUrl, content);
                        break; // Success, exit retry loop
                    }
                    catch (HttpRequestException ex) when (ex.Message.Contains("Name or service not known") && attempt < maxRetries)
                    {
                        _logger.LogWarning(ex, "DNS resolution failed, attempt {Attempt}/{MaxRetries}. Retrying in {Delay}ms...", attempt, maxRetries, attempt * 1000);
                        await Task.Delay(attempt * 1000); // Exponential backoff: 1s, 2s, 3s
                        continue;
                    }
                    catch (HttpRequestException ex)
                    {
                        _logger.LogError(ex, "Network error calling PayOS API: {Message}", ex.Message);
                        return StatusCode(500, new { message = "Không thể kết nối đến PayOS. Vui lòng thử lại sau.", error = ex.Message });
                    }
                    catch (TaskCanceledException ex)
                    {
                        if (attempt < maxRetries)
                        {
                            _logger.LogWarning(ex, "Timeout calling PayOS API, attempt {Attempt}/{MaxRetries}. Retrying...", attempt, maxRetries);
                            await Task.Delay(attempt * 1000);
                            continue;
                        }
                        _logger.LogError(ex, "Timeout calling PayOS API after {MaxRetries} attempts", maxRetries);
                        return StatusCode(500, new { message = "Kết nối đến PayOS quá lâu. Vui lòng thử lại sau." });
                    }
                }
                
                if (response == null)
                {
                    _logger.LogError("Failed to get response from PayOS API after {MaxRetries} attempts", maxRetries);
                    return StatusCode(500, new { message = "Không thể kết nối đến PayOS sau nhiều lần thử. Vui lòng thử lại sau." });
                }

                var responseContent = await response.Content.ReadAsStringAsync();

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogError("PayOS API error: {StatusCode} {Response}", response.StatusCode, responseContent);
                    return StatusCode(500, new { message = "Không thể tạo liên kết thanh toán", error = responseContent });
                }

                // Log full response for debugging
                _logger.LogInformation("PayOS API response: {Response}", responseContent);

                var payOSResponse = JsonSerializer.Deserialize<JsonElement>(responseContent);

                // Check if response has error code
                if (payOSResponse.TryGetProperty("code", out var codeElement))
                {
                    var code = codeElement.GetString();
                    if (code != "00")
                    {
                        var desc = payOSResponse.TryGetProperty("desc", out var descElement) 
                            ? descElement.GetString() 
                            : "Unknown error";
                        _logger.LogError("PayOS API returned error code: {Code}, desc: {Desc}, full response: {Response}", code, desc, responseContent);
                        return StatusCode(500, new { message = $"PayOS error: {desc}", error = responseContent });
                    }
                }

                // Safely check for data field
                if (!payOSResponse.TryGetProperty("data", out var dataElement) || 
                    dataElement.ValueKind == JsonValueKind.Null)
                {
                    _logger.LogError("PayOS response missing 'data' field. Full response: {Response}", responseContent);
                    return StatusCode(500, new { message = "PayOS trả về dữ liệu không hợp lệ", error = "Missing or null data field in response" });
                }

                // Safely get checkoutUrl and orderCode from PayOS response
                if (!dataElement.TryGetProperty("checkoutUrl", out var checkoutUrlElement) || 
                    checkoutUrlElement.ValueKind == JsonValueKind.Null)
                {
                    _logger.LogError("PayOS response missing 'checkoutUrl'. Data: {Data}", dataElement.GetRawText());
                    return StatusCode(500, new { message = "PayOS không trả về link thanh toán", error = "Missing checkoutUrl in response data" });
                }

                var paymentUrl = checkoutUrlElement.GetString();
                var qrCode = dataElement.TryGetProperty("qrCode", out var qrCodeElement) && qrCodeElement.ValueKind != JsonValueKind.Null
                    ? qrCodeElement.GetString() 
                    : null;

                // Get orderCode from PayOS response (it's long type)
                // Note: PayOS returns orderCode as long, we store it as string in DB
                long payOSResponseOrderCode = payOSOrderCode; // Default to our generated code
                if (dataElement.TryGetProperty("orderCode", out var orderCodeElement) && 
                    orderCodeElement.ValueKind == JsonValueKind.Number)
                {
                    payOSResponseOrderCode = orderCodeElement.GetInt64();
                    // Update payment record with actual orderCode from PayOS (if different)
                    if (payment.PayOSOrderCode != payOSResponseOrderCode.ToString())
                    {
                        payment.PayOSOrderCode = payOSResponseOrderCode.ToString();
                        await _context.SaveChangesAsync();
                    }
                }

                _logger.LogInformation("Payment URL generated successfully: {Url}, orderCode: {OrderCode}", paymentUrl, payOSResponseOrderCode);

                return Ok(new
                {
                    paymentUrl,
                    qrCode,
                    orderCode = payOSResponseOrderCode.ToString()
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating PayOS order");
                return StatusCode(500, new { message = "Lỗi khi tạo đơn hàng", error = ex.Message });
            }
        }

        // POST: api/payments/webhook (PayOS callback)
        [HttpPost("webhook")]
        [AllowAnonymous]
        public async Task<ActionResult> HandleWebhook([FromBody] JsonElement request)
        {
            try
            {
                _logger.LogInformation("PayOS webhook received: {Request}", request.GetRawText());
                
                // Read from Environment Variables (Render) or Configuration
                var payOSChecksumKey = Environment.GetEnvironmentVariable("PayOS__ChecksumKey") 
                    ?? _configuration["PayOS:ChecksumKey"];
                    
                if (string.IsNullOrEmpty(payOSChecksumKey))
                {
                    _logger.LogError("PayOS ChecksumKey not configured");
                    return BadRequest(new { message = "Invalid configuration" });
                }

                // PayOS webhook format: { "code": "00", "desc": "Success", "data": {...}, "signature": "..." }
                // PayOS test request might not have "data" field - handle gracefully
                if (!request.TryGetProperty("data", out var dataElement))
                {
                    // This might be a test request from PayOS during webhook setup
                    // Check if it's a test request or actual webhook
                    if (request.TryGetProperty("code", out var codeElement))
                    {
                        var code = codeElement.GetString();
                        _logger.LogInformation("PayOS webhook test/verification request received: code={Code}", code);
                        // Return 200 OK for test requests
                        return Ok(new { code = "00", desc = "Webhook is working" });
                    }
                    
                    _logger.LogWarning("Invalid webhook format: missing data");
                    return BadRequest(new { message = "Invalid webhook format" });
                }

                var signature = request.TryGetProperty("signature", out var sigElement) 
                    ? sigElement.GetString() 
                    : null;

                if (string.IsNullOrEmpty(signature))
                {
                    _logger.LogWarning("Missing signature in webhook");
                    return BadRequest(new { message = "Missing signature" });
                }

                // Verify signature: HMACSHA256 of data JSON string
                // PayOS uses the raw JSON string of the data object for signature
                var dataString = dataElement.GetRawText();
                var calculatedSignature = CreatePayOSSignature(dataString, payOSChecksumKey);
                
                if (!string.Equals(signature, calculatedSignature, StringComparison.OrdinalIgnoreCase))
                {
                    _logger.LogWarning("Invalid PayOS webhook signature. Expected: {Expected}, Got: {Actual}", 
                        calculatedSignature?.Substring(0, Math.Min(32, calculatedSignature?.Length ?? 0)) + "...", 
                        signature?.Substring(0, Math.Min(32, signature?.Length ?? 0)) + "...");
                    _logger.LogWarning("Data string used for signature: {DataString}", dataString);
                    return BadRequest(new { message = "Invalid signature" });
                }
                
                _logger.LogInformation("PayOS webhook signature verified successfully");

                // Extract order code from data
                if (!dataElement.TryGetProperty("orderCode", out var orderCodeElement))
                {
                    _logger.LogWarning("Invalid webhook format: missing orderCode in data");
                    return BadRequest(new { message = "Invalid webhook format: missing orderCode" });
                }

                var orderCode = orderCodeElement.GetInt64().ToString();
                
                // Check success status and code in data
                var success = request.TryGetProperty("success", out var successElement) && successElement.GetBoolean();
                var dataCode = dataElement.TryGetProperty("code", out var dataCodeElement) 
                    ? dataCodeElement.GetString() 
                    : null;
                var dataDesc = dataElement.TryGetProperty("desc", out var dataDescElement) 
                    ? dataDescElement.GetString() 
                    : null;

                _logger.LogInformation("PayOS webhook received: orderCode={OrderCode}, success={Success}, dataCode={DataCode}, dataDesc={DataDesc}", 
                    orderCode, success, dataCode, dataDesc);

                // Find payment by PayOS order code
                var payment = await _context.Payments
                    .Include(p => p.User)
                    .Include(p => p.VipPlan)
                    .FirstOrDefaultAsync(p => p.PayOSOrderCode == orderCode);

                if (payment == null)
                {
                    _logger.LogWarning("Payment not found for order code: {OrderCode}", orderCode);
                    return NotFound(new { message = "Payment not found" });
                }

                if (payment.Status == "completed")
                {
                    _logger.LogInformation("Payment already processed: {OrderCode}", orderCode);
                    return Ok(new { code = "00", desc = "Already processed" });
                }

                // Update payment status based on PayOS response
                // Success = true and data.code = "00" means payment was successful (PAID)
                if (success && dataCode == "00")
                {
                    payment.Status = "completed";
                    payment.CompletedAt = DateTime.UtcNow;
                    
                    if (dataElement.TryGetProperty("transactionDateTime", out var transDateTime))
                    {
                        payment.PayOSTransactionCode = transDateTime.GetString();
                    }

                    // Update user VIP status
                    var user = payment.User;
                    var plan = payment.VipPlan;

                    // Extend VIP if already VIP, otherwise set from now
                    var newExpiresAt = user.VipExpiresAt.HasValue && user.VipExpiresAt.Value > DateTime.UtcNow
                        ? user.VipExpiresAt.Value.AddDays(plan.Days)
                        : DateTime.UtcNow.AddDays(plan.Days);

                    user.IsVip = true;
                    user.VipExpiresAt = newExpiresAt;
                    user.VipSubscriptionId = payment.PayOSOrderCode;
                    user.UpdatedAt = DateTime.UtcNow;

                    await _context.SaveChangesAsync();

                    _logger.LogInformation("VIP activated for user {UserId}, expires at {ExpiresAt}", user.Id, newExpiresAt);
                }
                else
                {
                    // Payment failed, cancelled, or expired
                    payment.Status = "failed";
                    await _context.SaveChangesAsync();
                    _logger.LogInformation("Payment failed/cancelled for order code: {OrderCode}, code: {Code}, desc: {Desc}", 
                        orderCode, dataCode, dataDesc);
                }

                return Ok(new { code = "00", desc = "Success" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing PayOS webhook");
                return StatusCode(500, new { code = "99", desc = "Error processing webhook", error = ex.Message });
            }
        }

        // GET: api/payments/verify/{orderCode} - Verify payment status (for frontend polling)
        [HttpGet("verify/{orderCode}")]
        [Authorize]
        public async Task<ActionResult> VerifyPayment(string orderCode)
        {
            var userIdClaim = User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
            {
                return Unauthorized();
            }

            var payment = await _context.Payments
                .Include(p => p.User)
                .Include(p => p.VipPlan)
                .FirstOrDefaultAsync(p => p.PayOSOrderCode == orderCode && p.UserId == userId);

            if (payment == null)
            {
                return NotFound(new { message = "Payment not found" });
            }

            return Ok(new
            {
                status = payment.Status,
                completedAt = payment.CompletedAt,
                isVip = payment.User.IsVip,
                vipExpiresAt = payment.User.VipExpiresAt
            });
        }

        // POST: api/payments/confirm-webhook - Confirm/update PayOS webhook URL
        [HttpPost("confirm-webhook")]
        [AllowAnonymous] // PayOS will call this without auth
        public async Task<ActionResult> ConfirmWebhook([FromBody] ConfirmWebhookRequest request)
        {
            try
            {
                var payOSClientId = Environment.GetEnvironmentVariable("PayOS__ClientId") 
                    ?? _configuration["PayOS:ClientId"];
                var payOSApiKey = Environment.GetEnvironmentVariable("PayOS__ApiKey") 
                    ?? _configuration["PayOS:ApiKey"];
                    
                if (string.IsNullOrEmpty(payOSClientId) || string.IsNullOrEmpty(payOSApiKey))
                {
                    _logger.LogError("PayOS configuration is missing");
                    return StatusCode(500, new { message = "Cấu hình PayOS chưa được thiết lập" });
                }

                var httpClient = _httpClientFactory.CreateClient();
                httpClient.Timeout = TimeSpan.FromSeconds(30);
                httpClient.DefaultRequestHeaders.Clear();
                httpClient.DefaultRequestHeaders.Add("x-client-id", payOSClientId);
                httpClient.DefaultRequestHeaders.Add("x-api-key", payOSApiKey);

                var requestBody = new { webhookUrl = request.WebhookUrl };
                var options = new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };
                var jsonContent = JsonSerializer.Serialize(requestBody, options);
                var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

                var response = await httpClient.PostAsync(
                    "https://api-merchant.payos.vn/v2/confirm-webhook",
                    content
                );

                var responseContent = await response.Content.ReadAsStringAsync();
                
                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogError("PayOS confirm-webhook failed: {StatusCode}, {Response}", 
                        response.StatusCode, responseContent);
                    return StatusCode((int)response.StatusCode, new { message = "Failed to confirm webhook" });
                }

                _logger.LogInformation("PayOS webhook confirmed: {WebhookUrl}", request.WebhookUrl);
                
                // Parse and return PayOS response
                var payOSResponse = JsonSerializer.Deserialize<JsonElement>(responseContent);
                return Ok(payOSResponse);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error confirming PayOS webhook");
                return StatusCode(500, new { message = "Error confirming webhook", error = ex.Message });
            }
        }

        // GET: api/payments/history
        [HttpGet("history")]
        [Authorize]
        public async Task<ActionResult> GetPaymentHistory()
        {
            var userIdClaim = User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
            {
                return Unauthorized();
            }

            var payments = await _context.Payments
                .Include(p => p.VipPlan)
                .Where(p => p.UserId == userId)
                .OrderByDescending(p => p.CreatedAt)
                .ToListAsync();

            return Ok(payments);
        }

        // Helper method to create PayOS signature (HMACSHA256)
        private string CreatePayOSSignature(string data, string key)
        {
            using var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(key));
            var hashBytes = hmac.ComputeHash(Encoding.UTF8.GetBytes(data));
            return BitConverter.ToString(hashBytes).Replace("-", "").ToLower();
        }

        public class CreateOrderRequest
        {
            public int PlanId { get; set; }
        }

        public class ConfirmWebhookRequest
        {
            public string WebhookUrl { get; set; } = string.Empty;
        }
    }
}
