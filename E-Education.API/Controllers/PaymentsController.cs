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
            // Format: timestamp (13 digits) + userId (6 digits) = 19 digits max
            var timestamp = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
            var payOSOrderCode = long.Parse($"{timestamp % 1000000000000}{userId % 1000000}".PadRight(19, '0').Substring(0, Math.Min(19, 19)));
            
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
                
                var baseUrl = Environment.GetEnvironmentVariable("PayOS__BaseUrl") 
                    ?? _configuration["PayOS:BaseUrl"] 
                    ?? $"{Request.Scheme}://{Request.Host}";
                var returnUrl = Environment.GetEnvironmentVariable("PayOS__ReturnUrl") 
                    ?? _configuration["PayOS:ReturnUrl"] 
                    ?? $"{baseUrl}/payment-success?orderCode={payOSOrderCode}";
                var cancelUrl = Environment.GetEnvironmentVariable("PayOS__CancelUrl") 
                    ?? _configuration["PayOS:CancelUrl"] 
                    ?? $"{baseUrl}/payment-cancel";

                if (string.IsNullOrEmpty(payOSClientId) || string.IsNullOrEmpty(payOSApiKey) || 
                    string.IsNullOrEmpty(payOSChecksumKey))
                {
                    _logger.LogError("PayOS configuration is missing");
                    return StatusCode(500, new { message = "Cấu hình PayOS chưa được thiết lập" });
                }

                // Prepare PayOS payment request according to PayOS API v2
                var payOSRequest = new
                {
                    orderCode = payOSOrderCode,
                    amount = (int)plan.Price,
                    description = $"Nâng cấp {plan.Name}",
                    items = new[]
                    {
                        new
                        {
                            name = plan.Name,
                            quantity = 1,
                            price = (int)plan.Price
                        }
                    },
                    cancelUrl = cancelUrl,
                    returnUrl = returnUrl
                };

                // Create signature: HMACSHA256 of data string with ChecksumKey
                var options = new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };
                var dataString = JsonSerializer.Serialize(payOSRequest, options);
                var signature = CreatePayOSSignature(dataString, payOSChecksumKey);

                var requestBody = new
                {
                    orderCode = payOSRequest.orderCode,
                    amount = payOSRequest.amount,
                    description = payOSRequest.description,
                    items = payOSRequest.items,
                    cancelUrl = payOSRequest.cancelUrl,
                    returnUrl = payOSRequest.returnUrl,
                    signature = signature
                };

                var httpClient = _httpClientFactory.CreateClient();
                httpClient.Timeout = TimeSpan.FromSeconds(30);
                httpClient.DefaultRequestHeaders.Clear();
                httpClient.DefaultRequestHeaders.Add("x-client-id", payOSClientId);
                httpClient.DefaultRequestHeaders.Add("x-api-key", payOSApiKey);

                var jsonContent = JsonSerializer.Serialize(requestBody, options);
                var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");
                
                // PayOS API endpoint
                var payOSApiUrl = Environment.GetEnvironmentVariable("PayOS__ApiUrl") 
                    ?? _configuration["PayOS:ApiUrl"]
                    ?? "https://api.payos.vn/v2/payment-requests";
                
                _logger.LogInformation("Calling PayOS API: {Url}", payOSApiUrl);
                
                HttpResponseMessage response;
                try
                {
                    response = await httpClient.PostAsync(payOSApiUrl, content);
                }
                catch (HttpRequestException ex)
                {
                    _logger.LogError(ex, "Network error calling PayOS API: {Message}", ex.Message);
                    return StatusCode(500, new { message = "Không thể kết nối đến PayOS. Vui lòng thử lại sau.", error = ex.Message });
                }
                catch (TaskCanceledException ex)
                {
                    _logger.LogError(ex, "Timeout calling PayOS API");
                    return StatusCode(500, new { message = "Kết nối đến PayOS quá lâu. Vui lòng thử lại sau." });
                }

                var responseContent = await response.Content.ReadAsStringAsync();

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogError("PayOS API error: {StatusCode} {Response}", response.StatusCode, responseContent);
                    return StatusCode(500, new { message = "Không thể tạo liên kết thanh toán", error = responseContent });
                }

                var payOSResponse = JsonSerializer.Deserialize<JsonElement>(responseContent);
                var paymentUrl = payOSResponse.GetProperty("data").GetProperty("checkoutUrl").GetString();
                var qrCode = payOSResponse.GetProperty("data").TryGetProperty("qrCode", out var qrCodeElement) 
                    ? qrCodeElement.GetString() 
                    : null;

                return Ok(new
                {
                    paymentUrl,
                    qrCode,
                    orderCode = payOSOrderCode.ToString()
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
                // Read from Environment Variables (Render) or Configuration
                var payOSChecksumKey = Environment.GetEnvironmentVariable("PayOS__ChecksumKey") 
                    ?? _configuration["PayOS:ChecksumKey"];
                    
                if (string.IsNullOrEmpty(payOSChecksumKey))
                {
                    _logger.LogError("PayOS ChecksumKey not configured");
                    return BadRequest(new { message = "Invalid configuration" });
                }

                // PayOS webhook format: { "code": "00", "desc": "Success", "data": {...}, "signature": "..." }
                if (!request.TryGetProperty("data", out var dataElement))
                {
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
                var dataString = dataElement.GetRawText();
                var calculatedSignature = CreatePayOSSignature(dataString, payOSChecksumKey);
                
                if (signature != calculatedSignature)
                {
                    _logger.LogWarning("Invalid PayOS webhook signature. Expected: {Expected}, Got: {Actual}", calculatedSignature, signature);
                    return BadRequest(new { message = "Invalid signature" });
                }

                // Extract order code and status
                var orderCode = dataElement.GetProperty("orderCode").GetInt64().ToString();
                var status = dataElement.GetProperty("status").GetString();

                _logger.LogInformation("PayOS webhook received: orderCode={OrderCode}, status={Status}", orderCode, status);

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

                // Update payment status based on PayOS status
                if (status == "PAID")
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
                else if (status == "CANCELLED" || status == "EXPIRED")
                {
                    payment.Status = status.ToLower();
                    await _context.SaveChangesAsync();
                    _logger.LogInformation("Payment {Status}: {OrderCode}", status, orderCode);
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
    }
}
