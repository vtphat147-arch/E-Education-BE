using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using E_Education.API.Data;
using E_Education.API.Models;
using System.ComponentModel;

namespace E_Education.API.Controllers
{
    /// <summary>
    /// API quản lý khóa học
    /// </summary>
    [ApiController]
    [Route("api/courses")]
    [Tags("Courses")]
    public class CoursesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public CoursesController(ApplicationDbContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Lấy danh sách tất cả khóa học với tùy chọn tìm kiếm và lọc theo category
        /// </summary>
        /// <param name="search">Tìm kiếm theo tiêu đề hoặc tên giảng viên</param>
        /// <param name="category">Lọc theo category (programming, design, marketing, data, business)</param>
        /// <returns>Danh sách khóa học</returns>
        [HttpGet]
        [ProducesResponseType(typeof(IEnumerable<Course>), StatusCodes.Status200OK)]
        public async Task<ActionResult<IEnumerable<Course>>> GetCourses(
            [FromQuery, Description("Tìm kiếm theo tiêu đề hoặc giảng viên")] string? search,
            [FromQuery, Description("Lọc theo category (all, programming, design, marketing, data, business)")] string? category)
        {
            var query = _context.Courses.AsQueryable();

            // Filter by search term
            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(c => 
                    c.Title.ToLower().Contains(search.ToLower()) ||
                    c.Instructor.ToLower().Contains(search.ToLower()));
            }

            // Filter by category
            if (!string.IsNullOrEmpty(category) && category != "all")
            {
                query = query.Where(c => c.Category == category);
            }

            var courses = await query.OrderByDescending(c => c.CreatedAt).ToListAsync();
            return Ok(courses);
        }

        /// <summary>
        /// Lấy thông tin chi tiết một khóa học theo ID
        /// </summary>
        /// <param name="id">ID của khóa học</param>
        /// <returns>Thông tin khóa học</returns>
        [HttpGet("{id}")]
        [ProducesResponseType(typeof(Course), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Course>> GetCourse(int id)
        {
            var course = await _context.Courses.FindAsync(id);

            if (course == null)
            {
                return NotFound();
            }

            return Ok(course);
        }

        // POST: api/Courses
        [HttpPost]
        public async Task<ActionResult<Course>> CreateCourse(Course course)
        {
            course.CreatedAt = DateTime.UtcNow;
            course.UpdatedAt = DateTime.UtcNow;

            _context.Courses.Add(course);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetCourse), new { id = course.Id }, course);
        }

        // PUT: api/Courses/5
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateCourse(int id, Course course)
        {
            if (id != course.Id)
            {
                return BadRequest();
            }

            course.UpdatedAt = DateTime.UtcNow;

            _context.Entry(course).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CourseExists(id))
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

        // DELETE: api/Courses/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCourse(int id)
        {
            var course = await _context.Courses.FindAsync(id);
            if (course == null)
            {
                return NotFound();
            }

            _context.Courses.Remove(course);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CourseExists(int id)
        {
            return _context.Courses.Any(e => e.Id == id);
        }
    }
}

