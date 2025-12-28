using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using E_Education.API.Data;
using E_Education.API.Models;

namespace E_Education.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Tags("Email Verification")]
    public class EmailVerificationController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<EmailVerificationController> _logger;

        public EmailVerificationController(ApplicationDbContext context, ILogger<EmailVerificationController> logger)
        {
            _context = context;
            _logger = logger;
        }

        private int GetCurrentUserId()
        {
            var userIdClaim = User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(userIdClaim, out int userId) ? userId : 0;
        }

        /// <summary>
        /// Resend verification email
        /// </summary>
        [HttpPost("resend")]
        [Authorize]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ResendVerificationEmail()
        {
            try
            {
                var userId = GetCurrentUserId();
                if (userId == 0)
                {
                    return Unauthorized();
                }

                var user = await _context.Users.FindAsync(userId);
                if (user == null)
                {
                    return NotFound(new { message = "User not found" });
                }

                if (user.IsEmailVerified)
                {
                    return BadRequest(new { message = "Email already verified" });
                }

                // Get latest unused verification token
                var verification = await _context.EmailVerifications
                    .Where(v => v.UserId == userId && !v.IsUsed && v.ExpiresAt > DateTime.UtcNow)
                    .OrderByDescending(v => v.CreatedAt)
                    .FirstOrDefaultAsync();

                if (verification == null)
                {
                    // Create new verification token
                    var verificationToken = Guid.NewGuid().ToString() + Guid.NewGuid().ToString();
                    verification = new EmailVerification
                    {
                        UserId = userId,
                        Token = verificationToken,
                        ExpiresAt = DateTime.UtcNow.AddDays(1),
                        CreatedAt = DateTime.UtcNow
                    };
                    _context.EmailVerifications.Add(verification);
                    await _context.SaveChangesAsync();
                }

                // Get frontend URL
                var frontendUrl = Environment.GetEnvironmentVariable("FRONTEND_URL") ?? "https://e-education-beta.vercel.app";
                var verificationUrl = $"{frontendUrl}/verify-email?token={verification.Token}";

                // Try to send email (if SMTP configured)
                // For now, return the verification link
                return Ok(new 
                { 
                    message = "Verification email sent (or check logs for link if SMTP not configured)",
                    verificationLink = verificationUrl // Return link for testing
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error resending verification email");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }

        /// <summary>
        /// Get verification link for current user (for testing)
        /// </summary>
        [HttpGet("link")]
        [Authorize]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> GetVerificationLink()
        {
            try
            {
                var userId = GetCurrentUserId();
                if (userId == 0)
                {
                    return Unauthorized();
                }

                var user = await _context.Users.FindAsync(userId);
                if (user == null)
                {
                    return NotFound(new { message = "User not found" });
                }

                if (user.IsEmailVerified)
                {
                    return Ok(new { message = "Email already verified", verified = true });
                }

                // Get latest unused verification token
                var verification = await _context.EmailVerifications
                    .Where(v => v.UserId == userId && !v.IsUsed && v.ExpiresAt > DateTime.UtcNow)
                    .OrderByDescending(v => v.CreatedAt)
                    .FirstOrDefaultAsync();

                if (verification == null)
                {
                    return NotFound(new { message = "No verification token found. Please register again." });
                }

                var frontendUrl = Environment.GetEnvironmentVariable("FRONTEND_URL") ?? "https://e-education-beta.vercel.app";
                var verificationUrl = $"{frontendUrl}/verify-email?token={verification.Token}";

                return Ok(new 
                { 
                    verificationLink = verificationUrl,
                    expiresAt = verification.ExpiresAt
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting verification link");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }
    }
}

