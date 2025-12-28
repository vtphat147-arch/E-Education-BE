using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using E_Education.API.Data;

namespace E_Education.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    [Tags("View History")]
    public class ViewHistoryController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<ViewHistoryController> _logger;

        public ViewHistoryController(ApplicationDbContext context, ILogger<ViewHistoryController> logger)
        {
            _context = context;
            _logger = logger;
        }

        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.Parse(userIdClaim ?? "0");
        }

        /// <summary>
        /// Get view history for current user
        /// </summary>
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> GetViewHistory([FromQuery] int page = 1, [FromQuery] int pageSize = 20)
        {
            try
            {
                var userId = GetCurrentUserId();

                var history = await _context.ComponentViewHistory
                    .Where(v => v.UserId == userId)
                    .Include(v => v.Component)
                    .OrderByDescending(v => v.ViewedAt)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .Select(v => new
                    {
                        v.Id,
                        v.ComponentId,
                        Component = new
                        {
                            v.Component.Id,
                            v.Component.Name,
                            v.Component.Category,
                            v.Component.Type,
                            v.Component.Preview,
                            v.Component.Description,
                            v.Component.Views,
                            v.Component.Likes
                        },
                        v.ViewedAt
                    })
                    .ToListAsync();

                var total = await _context.ComponentViewHistory
                    .Where(v => v.UserId == userId)
                    .CountAsync();

                return Ok(new
                {
                    data = history,
                    page,
                    pageSize,
                    total,
                    totalPages = (int)Math.Ceiling(total / (double)pageSize)
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting view history");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }
    }
}

