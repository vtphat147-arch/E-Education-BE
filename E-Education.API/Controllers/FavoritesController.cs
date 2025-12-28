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
    [Authorize]
    [Tags("Favorites")]
    public class FavoritesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<FavoritesController> _logger;

        public FavoritesController(ApplicationDbContext context, ILogger<FavoritesController> logger)
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
        /// Get all favorites for current user
        /// </summary>
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> GetFavorites()
        {
            try
            {
                var userId = GetCurrentUserId();
                var favorites = await _context.Favorites
                    .Where(f => f.UserId == userId)
                    .Include(f => f.Component)
                    .OrderByDescending(f => f.CreatedAt)
                    .Select(f => new
                    {
                        f.Id,
                        f.ComponentId,
                        Component = new
                        {
                            f.Component.Id,
                            f.Component.Name,
                            f.Component.Category,
                            f.Component.Type,
                            f.Component.Preview,
                            f.Component.HtmlCode,
                            f.Component.CssCode,
                            f.Component.JsCode,
                            f.Component.Description,
                            f.Component.Views,
                            f.Component.Likes,
                            f.Component.Tags,
                            f.Component.Framework
                        },
                        f.CreatedAt
                    })
                    .ToListAsync();

                return Ok(favorites);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting favorites");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }

        /// <summary>
        /// Add component to favorites
        /// </summary>
        [HttpPost("{componentId}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> AddFavorite(int componentId)
        {
            try
            {
                var userId = GetCurrentUserId();

                // Check if component exists
                var component = await _context.DesignComponents.FindAsync(componentId);
                if (component == null)
                {
                    return NotFound(new { message = "Component not found" });
                }

                // Check if already favorited
                var existingFavorite = await _context.Favorites
                    .FirstOrDefaultAsync(f => f.UserId == userId && f.ComponentId == componentId);

                if (existingFavorite != null)
                {
                    return BadRequest(new { message = "Component already in favorites" });
                }

                // Add to favorites
                var favorite = new Favorite
                {
                    UserId = userId,
                    ComponentId = componentId,
                    CreatedAt = DateTime.UtcNow
                };

                _context.Favorites.Add(favorite);
                await _context.SaveChangesAsync();

                return Ok(new { message = "Added to favorites", id = favorite.Id });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding favorite");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }

        /// <summary>
        /// Remove component from favorites
        /// </summary>
        [HttpDelete("{componentId}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> RemoveFavorite(int componentId)
        {
            try
            {
                var userId = GetCurrentUserId();

                var favorite = await _context.Favorites
                    .FirstOrDefaultAsync(f => f.UserId == userId && f.ComponentId == componentId);

                if (favorite == null)
                {
                    return NotFound(new { message = "Favorite not found" });
                }

                _context.Favorites.Remove(favorite);
                await _context.SaveChangesAsync();

                return Ok(new { message = "Removed from favorites" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error removing favorite");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }

        /// <summary>
        /// Check if component is favorited
        /// </summary>
        [HttpGet("{componentId}/check")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> CheckFavorite(int componentId)
        {
            try
            {
                var userId = GetCurrentUserId();

                var isFavorited = await _context.Favorites
                    .AnyAsync(f => f.UserId == userId && f.ComponentId == componentId);

                return Ok(new { isFavorited });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking favorite");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }
    }
}

