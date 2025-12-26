using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace E_Education.API.Models
{
    public class Course
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(200)]
        public string Title { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string Instructor { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string Category { get; set; } = string.Empty;

        [Column(TypeName = "decimal(3,2)")]
        public decimal Rating { get; set; }

        public int Reviews { get; set; }
        public int Students { get; set; }

        [Column(TypeName = "decimal(12,2)")]
        public decimal Price { get; set; }

        [Column(TypeName = "decimal(12,2)")]
        public decimal? OriginalPrice { get; set; }

        [MaxLength(50)]
        public string Duration { get; set; } = string.Empty;

        public int Lessons { get; set; }

        [MaxLength(500)]
        public string Image { get; set; } = string.Empty;

        [MaxLength(50)]
        public string Level { get; set; } = string.Empty;

        [MaxLength(50)]
        public string? Badge { get; set; }

        public string? Description { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}
