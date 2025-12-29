using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace E_Education.API.Models
{
    public class Payment
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int UserId { get; set; }

        [Required]
        public int VipPlanId { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal Amount { get; set; }

        [MaxLength(10)]
        public string Currency { get; set; } = "VND";

        [Required]
        [MaxLength(255)]
        public string PayOSOrderCode { get; set; } = string.Empty; // Unique order code from PayOS

        [MaxLength(255)]
        public string? PayOSTransactionCode { get; set; } // Transaction code after payment

        [Required]
        [MaxLength(50)]
        public string Status { get; set; } = "pending"; // pending, completed, cancelled, failed

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime? CompletedAt { get; set; }

        // Navigation properties
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;

        [ForeignKey("VipPlanId")]
        public virtual VipPlan VipPlan { get; set; } = null!;
    }
}
