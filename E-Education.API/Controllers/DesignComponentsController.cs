using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using E_Education.API.Data;
using E_Education.API.Models;

namespace E_Education.API.Controllers
{
    [ApiController]
    [Route("api/components")]
    public class DesignComponentsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public DesignComponentsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // Helper method to check if user is VIP
        private async Task<bool> IsUserVip(int? userId)
        {
            if (!userId.HasValue) return false;
            
            var user = await _context.Users.FindAsync(userId.Value);
            if (user == null) return false;

            // Check if VIP and not expired
            if (user.IsVip && user.VipExpiresAt.HasValue && user.VipExpiresAt.Value > DateTime.UtcNow)
            {
                return true;
            }

            // Auto-expire VIP if expired
            if (user.IsVip && (!user.VipExpiresAt.HasValue || user.VipExpiresAt.Value <= DateTime.UtcNow))
            {
                user.IsVip = false;
                await _context.SaveChangesAsync();
            }

            return false;
        }

        // GET: api/components
        [HttpGet]
        public async Task<ActionResult> GetComponents(
            [FromQuery] string? category,
            [FromQuery] string? type,
            [FromQuery] string? search,
            [FromQuery] string? tags,
            [FromQuery] string? framework,
            [FromQuery] string? sortBy = "popular", // popular, newest, mostLiked, name
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 20,
            [FromQuery] int? minViews = null,
            [FromQuery] int? minLikes = null)
        {
            // Get user ID if authenticated
            var userIdClaim = User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            int? userId = !string.IsNullOrEmpty(userIdClaim) && int.TryParse(userIdClaim, out int uid) ? uid : null;
            
            // Check VIP status
            bool isVip = await IsUserVip(userId);

            var query = _context.DesignComponents.AsQueryable();

            // Filter premium components: Normal users only see free components
            if (!isVip)
            {
                query = query.Where(c => !c.IsPremium);
            }

            // Filter by category (header, footer, sidebar, layout, typography)
            if (!string.IsNullOrEmpty(category))
            {
                query = query.Where(c => c.Category.ToLower() == category.ToLower());
            }

            // Filter by type
            if (!string.IsNullOrEmpty(type))
            {
                query = query.Where(c => c.Type.ToLower().Contains(type.ToLower()));
            }

            // Search in name, description, tags
            if (!string.IsNullOrEmpty(search))
            {
                var searchLower = search.ToLower();
                query = query.Where(c => 
                    c.Name.ToLower().Contains(searchLower) ||
                    c.Description.ToLower().Contains(searchLower) ||
                    (c.Tags != null && c.Tags.ToLower().Contains(searchLower)));
            }

            // Filter by tags
            if (!string.IsNullOrEmpty(tags))
            {
                var tagList = tags.ToLower().Split(',').Select(t => t.Trim());
                query = query.Where(c => 
                    c.Tags != null && 
                    tagList.Any(tag => c.Tags.ToLower().Contains(tag)));
            }

            // Filter by framework
            if (!string.IsNullOrEmpty(framework))
            {
                query = query.Where(c => c.Framework != null && c.Framework.ToLower() == framework.ToLower());
            }

            // Filter by min views
            if (minViews.HasValue)
            {
                query = query.Where(c => c.Views >= minViews.Value);
            }

            // Filter by min likes
            if (minLikes.HasValue)
            {
                query = query.Where(c => c.Likes >= minLikes.Value);
            }

            // Sorting
            query = sortBy.ToLower() switch
            {
                "newest" => query.OrderByDescending(c => c.CreatedAt),
                "mostliked" => query.OrderByDescending(c => c.Likes).ThenByDescending(c => c.Views),
                "name" => query.OrderBy(c => c.Name),
                "popular" or _ => query.OrderByDescending(c => c.Views).ThenByDescending(c => c.CreatedAt)
            };

            // Get total count before pagination
            var total = await query.CountAsync();

            // Pagination
            var components = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return Ok(new
            {
                data = components,
                pagination = new
                {
                    page,
                    pageSize,
                    total,
                    totalPages = (int)Math.Ceiling(total / (double)pageSize)
                }
            });
        }

        // GET: api/components/5
        [HttpGet("{id}")]
        public async Task<ActionResult<DesignComponent>> GetComponent(int id)
        {
            var component = await _context.DesignComponents.FindAsync(id);

            if (component == null)
            {
                return NotFound();
            }

            // Check if component is premium and user is not VIP
            var userIdClaim = User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            int? userId = !string.IsNullOrEmpty(userIdClaim) && int.TryParse(userIdClaim, out int uid) ? uid : null;
            bool isVip = await IsUserVip(userId);

            if (component.IsPremium && !isVip)
            {
                return StatusCode(403, new { 
                    message = "Component này yêu cầu tài khoản VIP để xem", 
                    error = "VIP_REQUIRED",
                    requiresVip = true
                });
            }

            // Track view history if user is authenticated (only once per user-component, update ViewedAt if exists)
            var userIdClaim = User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (!string.IsNullOrEmpty(userIdClaim) && int.TryParse(userIdClaim, out int userId))
            {
                var existingHistory = await _context.ComponentViewHistory
                    .FirstOrDefaultAsync(v => v.UserId == userId && v.ComponentId == id);
                
                if (existingHistory == null)
                {
                    // Only increment views and create history if this is the first time viewing
                    component.Views++;
                    
                    // Create new history record
                    var viewHistory = new ComponentViewHistory
                    {
                        UserId = userId,
                        ComponentId = id,
                        ViewedAt = DateTime.UtcNow
                    };
                    _context.ComponentViewHistory.Add(viewHistory);
                }
                else
                {
                    // Update ViewedAt if already exists (but don't increment views)
                    existingHistory.ViewedAt = DateTime.UtcNow;
                }
            }
            else
            {
                // For non-authenticated users, increment views on every request
                // (could be improved with session/cookie tracking)
                component.Views++;
            }

            await _context.SaveChangesAsync();

            return Ok(component);
        }

        // GET: api/components/categories
        [HttpGet("categories")]
        public async Task<ActionResult> GetCategories()
        {
            var categories = await _context.DesignComponents
                .Select(c => c.Category)
                .Distinct()
                .ToListAsync();

            return Ok(categories);
        }

        // GET: api/components/types/{category}
        [HttpGet("types/{category}")]
        public async Task<ActionResult> GetTypesByCategory(string category)
        {
            var types = await _context.DesignComponents
                .Where(c => c.Category.ToLower() == category.ToLower())
                .Select(c => c.Type)
                .Distinct()
                .ToListAsync();

            return Ok(types);
        }

        // POST: api/components
        [HttpPost]
        public async Task<ActionResult<DesignComponent>> CreateComponent(DesignComponent component)
        {
            component.CreatedAt = DateTime.UtcNow;
            component.UpdatedAt = DateTime.UtcNow;

            _context.DesignComponents.Add(component);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetComponent), new { id = component.Id }, component);
        }

        // PUT: api/components/5
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateComponent(int id, DesignComponent component)
        {
            if (id != component.Id)
            {
                return BadRequest();
            }

            component.UpdatedAt = DateTime.UtcNow;

            _context.Entry(component).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ComponentExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/components/5/like (Toggle like/unlike)
        [HttpPost("{id}/like")]
        [Authorize]
        public async Task<IActionResult> LikeComponent(int id)
        {
            try
            {
                var userIdClaim = User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
                {
                    return Unauthorized(new { message = "User not authenticated", error = "INVALID_TOKEN" });
                }

                var component = await _context.DesignComponents.FindAsync(id);
                if (component == null)
                {
                    return NotFound(new { message = "Component not found", error = "COMPONENT_NOT_FOUND" });
                }

                // Use transaction to ensure data consistency
                using var transaction = await _context.Database.BeginTransactionAsync();
                try
                {
                    // Check if user already liked this component
                    var existingLike = await _context.ComponentLikes
                        .FirstOrDefaultAsync(l => l.UserId == userId && l.ComponentId == id);

                    if (existingLike != null)
                    {
                        // Unlike: Remove like record and decrease likes count
                        _context.ComponentLikes.Remove(existingLike);
                        component.Likes = Math.Max(0, component.Likes - 1);
                        
                        await _context.SaveChangesAsync();
                        await transaction.CommitAsync();

                        return Ok(new { likes = component.Likes, isLiked = false, message = "Component unliked" });
                    }
                    else
                    {
                        // Like: Create like record and increase likes count
                        // Double-check to prevent duplicate likes (race condition)
                        var duplicateCheck = await _context.ComponentLikes
                            .FirstOrDefaultAsync(l => l.UserId == userId && l.ComponentId == id);
                        
                        if (duplicateCheck != null)
                        {
                            // Already liked by another request, rollback and return existing state
                            await transaction.RollbackAsync();
                            return Ok(new { likes = component.Likes, isLiked = true, message = "Component already liked" });
                        }

                        var like = new ComponentLike
                        {
                            UserId = userId,
                            ComponentId = id,
                            LikedAt = DateTime.UtcNow
                        };
                        _context.ComponentLikes.Add(like);
                        component.Likes++;
                        
                        await _context.SaveChangesAsync();
                        await transaction.CommitAsync();

                        return Ok(new { likes = component.Likes, isLiked = true, message = "Component liked" });
                    }
                }
                catch (Exception)
                {
                    await transaction.RollbackAsync();
                    throw;
                }
            }
            catch (DbUpdateException ex)
            {
                // Handle unique constraint violations or other DB errors
                return BadRequest(new { message = "Failed to update like status. Please try again.", error = "DB_ERROR", details = ex.Message });
            }
            catch (Exception)
            {
                return StatusCode(500, new { message = "An error occurred while processing your request", error = "INTERNAL_ERROR" });
            }
        }

        // GET: api/components/5/like/check - Check if user liked this component
        [HttpGet("{id}/like/check")]
        [Authorize]
        public async Task<IActionResult> CheckLike(int id)
        {
            try
            {
                var userIdClaim = User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
                {
                    return Ok(new { isLiked = false });
                }

                // Verify component exists
                var componentExists = await _context.DesignComponents.AnyAsync(c => c.Id == id);
                if (!componentExists)
                {
                    return NotFound(new { message = "Component not found", isLiked = false });
                }

                var isLiked = await _context.ComponentLikes
                    .AnyAsync(l => l.UserId == userId && l.ComponentId == id);

                return Ok(new { isLiked });
            }
            catch (Exception)
            {
                // Return false on error to allow UI to continue functioning
                return Ok(new { isLiked = false });
            }
        }

        // DELETE: api/components/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteComponent(int id)
        {
            var component = await _context.DesignComponents.FindAsync(id);
            if (component == null)
            {
                return NotFound();
            }

            _context.DesignComponents.Remove(component);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ComponentExists(int id)
        {
            return _context.DesignComponents.Any(e => e.Id == id);
        }
    }
}


