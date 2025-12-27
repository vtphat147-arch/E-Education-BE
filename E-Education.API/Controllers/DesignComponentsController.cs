using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
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
        public async Task<ActionResult<IEnumerable<DesignComponent>>> GetComponents(
            [FromQuery] string? category,
            [FromQuery] string? type,
            [FromQuery] string? search,
            [FromQuery] string? tags)
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

            // Search in name, description
            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(c => 
                    c.Name.ToLower().Contains(search.ToLower()) ||
                    c.Description.ToLower().Contains(search.ToLower()));
            }

            // Filter by tags
            if (!string.IsNullOrEmpty(tags))
            {
                var tagList = tags.ToLower().Split(',');
                query = query.Where(c => 
                    c.Tags != null && 
                    tagList.Any(tag => c.Tags.ToLower().Contains(tag.Trim())));
            }

            var components = await query
                .OrderByDescending(c => c.Views)
                .ThenByDescending(c => c.CreatedAt)
                .ToListAsync();

            return Ok(components);
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

