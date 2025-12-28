using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace E_Education.API.Models
{
    public class EmailVerification
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int UserId { get; set; }

        [Required]
        [MaxLength(255)]
        public string Token { get; set; } = string.Empty;

        public DateTime ExpiresAt { get; set; }

        public bool IsUsed { get; set; } = false;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // Navigation property
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;
    }
}

