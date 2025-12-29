namespace E_Education.API.Models.DTOs
{
    public class AuthResponseDto
    {
        public string Token { get; set; } = string.Empty;
        public UserDto User { get; set; } = null!;
    }

    public class UserDto
    {
        public int Id { get; set; }
        public string Email { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public string? FullName { get; set; }
        public string? AvatarUrl { get; set; }
        public string? Bio { get; set; }
        public bool IsAdmin { get; set; }
        public bool IsVip { get; set; }
        public DateTime? VipExpiresAt { get; set; }
        public int? DaysRemaining { get; set; } // Calculated field for frontend
    }
}



