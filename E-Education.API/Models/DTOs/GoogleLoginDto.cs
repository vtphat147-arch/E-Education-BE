using System.ComponentModel.DataAnnotations;

namespace E_Education.API.Models.DTOs
{
    public class GoogleLoginDto
    {
        [Required]
        public string IdToken { get; set; } = string.Empty;
    }
}



