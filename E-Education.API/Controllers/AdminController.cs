using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using E_Education.API.Data;
using E_Education.API.Models;

namespace E_Education.API.Controllers
{
    [ApiController]
    [Route("api/admin")]
    [Authorize]
    [Tags("Admin")]
    public class AdminController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<AdminController> _logger;

        public AdminController(ApplicationDbContext context, ILogger<AdminController> logger)
        {
            _context = context;
            _logger = logger;
        }

        private async Task<bool> IsAdminAsync()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
            {
                return false;
            }

            var user = await _context.Users.FindAsync(userId);
            return user?.IsAdmin ?? false;
        }

        /// <summary>
        /// Get dashboard statistics
        /// </summary>
        [HttpGet("stats")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> GetStats()
        {
            if (!await IsAdminAsync())
            {
                return Forbid();
            }

            try
            {
                var totalComponents = await _context.DesignComponents.CountAsync();
                var totalUsers = await _context.Users.CountAsync();
                var totalComments = await _context.Comments.CountAsync();
                var totalFavorites = await _context.Favorites.CountAsync();
                var totalViews = await _context.DesignComponents.SumAsync(c => c.Views);
                var totalLikes = await _context.DesignComponents.SumAsync(c => c.Likes);

                // Components by category
                var componentsByCategory = await _context.DesignComponents
                    .GroupBy(c => c.Category)
                    .Select(g => new { Category = g.Key, Count = g.Count() })
                    .ToListAsync();

                // Recent users (last 7 days)
                var recentUsers = await _context.Users
                    .Where(u => u.CreatedAt >= DateTime.UtcNow.AddDays(-7))
                    .CountAsync();

                // Recent components (last 7 days)
                var recentComponents = await _context.DesignComponents
                    .Where(c => c.CreatedAt >= DateTime.UtcNow.AddDays(-7))
                    .CountAsync();

                return Ok(new
                {
                    totalComponents,
                    totalUsers,
                    totalComments,
                    totalFavorites,
                    totalViews,
                    totalLikes,
                    recentUsers,
                    recentComponents,
                    componentsByCategory
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting admin stats");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }

        /// <summary>
        /// Get all users with pagination
        /// </summary>
        [HttpGet("users")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> GetUsers([FromQuery] int page = 1, [FromQuery] int pageSize = 20, [FromQuery] string? search = null)
        {
            if (!await IsAdminAsync())
            {
                return Forbid();
            }

            try
            {
                var query = _context.Users.AsQueryable();

                if (!string.IsNullOrEmpty(search))
                {
                    var searchLower = search.ToLower();
                    query = query.Where(u =>
                        u.Username.ToLower().Contains(searchLower) ||
                        u.Email.ToLower().Contains(searchLower) ||
                        (u.FullName != null && u.FullName.ToLower().Contains(searchLower))
                    );
                }

                var total = await query.CountAsync();

                var users = await query
                    .OrderByDescending(u => u.CreatedAt)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .Select(u => new
                    {
                        u.Id,
                        u.Username,
                        u.Email,
                        u.FullName,
                        u.IsAdmin,
                        u.IsEmailVerified,
                        u.CreatedAt,
                        u.UpdatedAt,
                        FavoritesCount = u.Favorites.Count,
                        CommentsCount = u.Comments.Count
                    })
                    .ToListAsync();

                return Ok(new
                {
                    data = users,
                    page,
                    pageSize,
                    total,
                    totalPages = (int)Math.Ceiling(total / (double)pageSize)
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting users");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }

        /// <summary>
        /// Get all components with pagination (admin view)
        /// </summary>
        [HttpGet("components")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> GetComponents([FromQuery] int page = 1, [FromQuery] int pageSize = 20, [FromQuery] string? search = null)
        {
            if (!await IsAdminAsync())
            {
                return Forbid();
            }

            try
            {
                var query = _context.DesignComponents.AsQueryable();

                if (!string.IsNullOrEmpty(search))
                {
                    var searchLower = search.ToLower();
                    query = query.Where(c =>
                        c.Name.ToLower().Contains(searchLower) ||
                        c.Description.ToLower().Contains(searchLower) ||
                        c.Category.ToLower().Contains(searchLower)
                    );
                }

                var total = await query.CountAsync();

                var components = await query
                    .OrderByDescending(c => c.CreatedAt)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .Select(c => new
                    {
                        c.Id,
                        c.Name,
                        c.Category,
                        c.Type,
                        c.Views,
                        c.Likes,
                        c.CreatedAt,
                        c.UpdatedAt,
                        CommentsCount = c.Comments.Count,
                        FavoritesCount = c.Favorites.Count
                    })
                    .ToListAsync();

                return Ok(new
                {
                    data = components,
                    page,
                    pageSize,
                    total,
                    totalPages = (int)Math.Ceiling(total / (double)pageSize)
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting components");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }

        /// <summary>
        /// Update user admin status
        /// </summary>
        [HttpPut("users/{userId}/admin")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> UpdateUserAdminStatus(int userId, [FromBody] UpdateAdminStatusDto dto)
        {
            if (!await IsAdminAsync())
            {
                return Forbid();
            }

            try
            {
                var user = await _context.Users.FindAsync(userId);
                if (user == null)
                {
                    return NotFound(new { message = "User not found" });
                }

                user.IsAdmin = dto.IsAdmin;
                user.UpdatedAt = DateTime.UtcNow;
                await _context.SaveChangesAsync();

                return Ok(new { message = "User admin status updated", user = new { user.Id, user.Username, user.IsAdmin } });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating user admin status");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }

        /// <summary>
        /// Delete a user
        /// </summary>
        [HttpDelete("users/{userId}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> DeleteUser(int userId)
        {
            if (!await IsAdminAsync())
            {
                return Forbid();
            }

            try
            {
                var user = await _context.Users.FindAsync(userId);
                if (user == null)
                {
                    return NotFound(new { message = "User not found" });
                }

                // Prevent deleting yourself
                var currentUserId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
                if (user.Id == currentUserId)
                {
                    return BadRequest(new { message = "Cannot delete your own account" });
                }

                _context.Users.Remove(user);
                await _context.SaveChangesAsync();

                return Ok(new { message = "User deleted successfully" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting user");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }

        /// <summary>
        /// Delete a component
        /// </summary>
        [HttpDelete("components/{componentId}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> DeleteComponent(int componentId)
        {
            if (!await IsAdminAsync())
            {
                return Forbid();
            }

            try
            {
                var component = await _context.DesignComponents.FindAsync(componentId);
                if (component == null)
                {
                    return NotFound(new { message = "Component not found" });
                }

                _context.DesignComponents.Remove(component);
                await _context.SaveChangesAsync();

                return Ok(new { message = "Component deleted successfully" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting component");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }
    }

    public class UpdateAdminStatusDto
    {
        public bool IsAdmin { get; set; }
    }
}

