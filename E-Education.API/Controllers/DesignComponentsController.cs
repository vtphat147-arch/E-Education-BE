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
            var query = _context.DesignComponents.AsQueryable();

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

            // Increment views
            component.Views++;
            
            // Track view history if user is authenticated
            var userIdClaim = User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (!string.IsNullOrEmpty(userIdClaim) && int.TryParse(userIdClaim, out int userId))
            {
                var viewHistory = new ComponentViewHistory
                {
                    UserId = userId,
                    ComponentId = id,
                    ViewedAt = DateTime.UtcNow
                };
                _context.ComponentViewHistory.Add(viewHistory);
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

        // POST: api/components/5/like
        [HttpPost("{id}/like")]
        public async Task<IActionResult> LikeComponent(int id)
        {
            var component = await _context.DesignComponents.FindAsync(id);
            if (component == null)
            {
                return NotFound();
            }

            component.Likes++;
            await _context.SaveChangesAsync();

            return Ok(new { likes = component.Likes });
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


