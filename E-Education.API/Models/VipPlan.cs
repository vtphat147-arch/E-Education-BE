using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace E_Education.API.Models
{
    public class VipPlan
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string Name { get; set; } = string.Empty; // VIP 1 Tháng, VIP 3 Tháng, VIP 1 Năm

        public int Days { get; set; } // 30, 90, 365

        [Column(TypeName = "decimal(18,2)")]
        public decimal Price { get; set; } // 150000, 400000, 1200000

        public bool IsActive { get; set; } = true;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // Navigation properties
        public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
    }
}
