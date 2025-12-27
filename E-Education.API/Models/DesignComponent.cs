using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace E_Education.API.Models
{
    public class DesignComponent
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(255)]
        public string Name { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string Category { get; set; } = string.Empty; // header, footer, sidebar, layout, typography

        [Required]
        [MaxLength(100)]
        public string Type { get; set; } = string.Empty; // navbar, sticky-header, glass-footer, etc.

        [Required]
        public string Preview { get; set; } = string.Empty; // Base64 image hoặc URL

        [Required]
        public string HtmlCode { get; set; } = string.Empty; // HTML code của component

        [Required]
        public string CssCode { get; set; } = string.Empty; // CSS code

        public string? JsCode { get; set; } // JavaScript code (optional)

        [Required]
        public string Description { get; set; } = string.Empty;

        [MaxLength(50)]
        public string? Tags { get; set; } // Comma separated: modern,responsive,glass

        [MaxLength(50)]
        public string? Framework { get; set; } // react, vue, html, tailwind

        public int Views { get; set; } = 0;

        public int Likes { get; set; } = 0;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}

