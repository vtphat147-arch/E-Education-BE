using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using E_Education.API.Data;
using E_Education.API.Models;

namespace E_Education.API.Controllers
{
    [ApiController]
    [Route("api/components/{componentId}/comments")]
    public class CommentsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<CommentsController> _logger;

        public CommentsController(ApplicationDbContext context, ILogger<CommentsController> logger)
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
        /// Get all comments for a component
        /// </summary>
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetComments(int componentId, [FromQuery] int page = 1, [FromQuery] int pageSize = 20)
        {
            try
            {
                // Check if component exists
                var componentExists = await _context.DesignComponents.AnyAsync(c => c.Id == componentId);
                if (!componentExists)
                {
                    return NotFound(new { message = "Component not found" });
                }

                var comments = await _context.Comments
                    .Where(c => c.ComponentId == componentId)
                    .Include(c => c.User)
                    .OrderByDescending(c => c.CreatedAt)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .Select(c => new
                    {
                        c.Id,
                        c.ComponentId,
                        c.Content,
                        c.CreatedAt,
                        c.UpdatedAt,
                        User = new
                        {
                            c.User.Id,
                            c.User.Username,
                            c.User.AvatarUrl,
                            c.User.FullName
                        }
                    })
                    .ToListAsync();

                var total = await _context.Comments
                    .Where(c => c.ComponentId == componentId)
                    .CountAsync();

                return Ok(new
                {
                    data = comments,
                    page,
                    pageSize,
                    total,
                    totalPages = (int)Math.Ceiling(total / (double)pageSize)
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting comments");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }

        /// <summary>
        /// Create a new comment
        /// </summary>
        [HttpPost]
        [Authorize]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> CreateComment(int componentId, [FromBody] CreateCommentDto dto)
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

                if (string.IsNullOrWhiteSpace(dto.Content))
                {
                    return BadRequest(new { message = "Comment content is required" });
                }

                var comment = new Comment
                {
                    UserId = userId,
                    ComponentId = componentId,
                    Content = dto.Content.Trim(),
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };

                _context.Comments.Add(comment);
                await _context.SaveChangesAsync();

                // Load user info
                await _context.Entry(comment).Reference(c => c.User).LoadAsync();

                var result = new
                {
                    comment.Id,
                    comment.ComponentId,
                    comment.Content,
                    comment.CreatedAt,
                    comment.UpdatedAt,
                    User = new
                    {
                        comment.User.Id,
                        comment.User.Username,
                        comment.User.AvatarUrl,
                        comment.User.FullName
                    }
                };

                return CreatedAtAction(nameof(GetComments), new { componentId }, result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating comment");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }

        /// <summary>
        /// Update a comment (only by the owner)
        /// </summary>
        [HttpPut("{commentId}")]
        [Authorize]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> UpdateComment(int componentId, int commentId, [FromBody] UpdateCommentDto dto)
        {
            try
            {
                var userId = GetCurrentUserId();

                var comment = await _context.Comments
                    .Include(c => c.User)
                    .FirstOrDefaultAsync(c => c.Id == commentId && c.ComponentId == componentId);

                if (comment == null)
                {
                    return NotFound(new { message = "Comment not found" });
                }

                // Check if user is the owner or admin
                if (comment.UserId != userId)
                {
                    var user = await _context.Users.FindAsync(userId);
                    if (user == null || !user.IsAdmin)
                    {
                        return Forbid();
                    }
                }

                if (string.IsNullOrWhiteSpace(dto.Content))
                {
                    return BadRequest(new { message = "Comment content is required" });
                }

                comment.Content = dto.Content.Trim();
                comment.UpdatedAt = DateTime.UtcNow;

                await _context.SaveChangesAsync();

                var result = new
                {
                    comment.Id,
                    comment.ComponentId,
                    comment.Content,
                    comment.CreatedAt,
                    comment.UpdatedAt,
                    User = new
                    {
                        comment.User.Id,
                        comment.User.Username,
                        comment.User.AvatarUrl,
                        comment.User.FullName
                    }
                };

                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating comment");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }

        /// <summary>
        /// Delete a comment (only by the owner or admin)
        /// </summary>
        [HttpDelete("{commentId}")]
        [Authorize]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> DeleteComment(int componentId, int commentId)
        {
            try
            {
                var userId = GetCurrentUserId();

                var comment = await _context.Comments
                    .FirstOrDefaultAsync(c => c.Id == commentId && c.ComponentId == componentId);

                if (comment == null)
                {
                    return NotFound(new { message = "Comment not found" });
                }

                // Check if user is the owner or admin
                if (comment.UserId != userId)
                {
                    var user = await _context.Users.FindAsync(userId);
                    if (user == null || !user.IsAdmin)
                    {
                        return Forbid();
                    }
                }

                _context.Comments.Remove(comment);
                await _context.SaveChangesAsync();

                return Ok(new { message = "Comment deleted successfully" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting comment");
                return StatusCode(500, new { message = "An error occurred" });
            }
        }
    }

    public class CreateCommentDto
    {
        public string Content { get; set; } = string.Empty;
    }

    public class UpdateCommentDto
    {
        public string Content { get; set; } = string.Empty;
    }
}

