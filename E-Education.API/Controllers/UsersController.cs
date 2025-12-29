using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using E_Education.API.Data;
using E_Education.API.Models;
using E_Education.API.Models.DTOs;

namespace E_Education.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    [Tags("Users")]
    public class UsersController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<UsersController> _logger;

        public UsersController(ApplicationDbContext context, ILogger<UsersController> logger)
        {
            _context = context;
            _logger = logger;
        }

        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.Parse(userIdClaim ?? "0");
        }

        private async Task<UserDto> MapToUserDto(User user)
        {
            // Check if VIP expired
            bool isVip = user.IsVip && user.VipExpiresAt.HasValue && user.VipExpiresAt.Value > DateTime.UtcNow;
            if (user.IsVip && !isVip)
            {
                user.IsVip = false;
                await _context.SaveChangesAsync();
            }

            int? daysRemaining = null;
            if (isVip && user.VipExpiresAt.HasValue)
            {
                daysRemaining = Math.Max(0, (int)(user.VipExpiresAt.Value - DateTime.UtcNow).TotalDays);
            }

            return new UserDto
            {
                Id = user.Id,
                Email = user.Email,
                Username = user.Username,
                FullName = user.FullName,
                AvatarUrl = user.AvatarUrl,
                Bio = user.Bio,
                IsAdmin = user.IsAdmin,
                IsVip = isVip,
                VipExpiresAt = user.VipExpiresAt,
                DaysRemaining = daysRemaining
            };
        }

        /// <summary>
        /// Get current user profile
        /// </summary>
        [HttpGet("me")]
        [ProducesResponseType(typeof(UserDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetCurrentUser()
        {
            try
            {
                var userId = GetCurrentUserId();
                var user = await _context.Users.FindAsync(userId);

                if (user == null)
                {
                    return NotFound(new { message = "User not found" });
                }

                var userDto = await MapToUserDto(user);
                return Ok(userDto);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting current user");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }

        /// <summary>
        /// Update user profile
        /// </summary>
        [HttpPut("me")]
        [ProducesResponseType(typeof(UserDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateProfile([FromBody] UpdateProfileDto dto)
        {
            try
            {
                var userId = GetCurrentUserId();
                var user = await _context.Users.FindAsync(userId);

                if (user == null)
                {
                    return NotFound(new { message = "User not found" });
                }

                if (!string.IsNullOrEmpty(dto.Username) && dto.Username != user.Username)
                {
                    if (await _context.Users.AnyAsync(u => u.Username == dto.Username))
                    {
                        return BadRequest(new { message = "Username already exists" });
                    }
                    user.Username = dto.Username;
                }

                if (!string.IsNullOrEmpty(dto.FullName))
                {
                    user.FullName = dto.FullName;
                }

                if (dto.Bio != null)
                {
                    user.Bio = dto.Bio;
                }

                if (!string.IsNullOrEmpty(dto.AvatarUrl))
                {
                    user.AvatarUrl = dto.AvatarUrl;
                }

                user.UpdatedAt = DateTime.UtcNow;
                await _context.SaveChangesAsync();

                var userDto = await MapToUserDto(user);
                return Ok(userDto);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating profile");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }
    }

    public class UpdateProfileDto
    {
        public string? Username { get; set; }
        public string? FullName { get; set; }
        public string? Bio { get; set; }
        public string? AvatarUrl { get; set; }
    }
}



