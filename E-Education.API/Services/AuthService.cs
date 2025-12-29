using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using E_Education.API.Data;
using E_Education.API.Models;
using E_Education.API.Models.DTOs;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using E_Education.API.Services;

namespace E_Education.API.Services
{
    public interface IAuthService
    {
        Task<AuthResponseDto> RegisterAsync(RegisterDto registerDto);
        Task<AuthResponseDto> RegisterAsync(RegisterDto registerDto, IEmailService? emailService);
        Task<AuthResponseDto> LoginAsync(LoginDto loginDto);
        string GenerateJwtToken(User user);
        Task<bool> VerifyEmailTokenAsync(string token);
    }

    public class AuthService : IAuthService
    {
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;
        private readonly ILogger<AuthService>? _logger;

        public AuthService(ApplicationDbContext context, IConfiguration configuration, ILogger<AuthService>? logger = null)
        {
            _context = context;
            _configuration = configuration;
            _logger = logger;
        }

        public async Task<AuthResponseDto> RegisterAsync(RegisterDto registerDto, IEmailService? emailService = null)
        {
            // Check if email already exists
            if (await _context.Users.AnyAsync(u => u.Email == registerDto.Email))
            {
                throw new InvalidOperationException("Email already exists");
            }

            // Check if username already exists
            if (await _context.Users.AnyAsync(u => u.Username == registerDto.Username))
            {
                throw new InvalidOperationException("Username already exists");
            }

            // Hash password
            var passwordHash = BCrypt.Net.BCrypt.HashPassword(registerDto.Password);

            // Create user
            var user = new User
            {
                Email = registerDto.Email,
                Username = registerDto.Username,
                PasswordHash = passwordHash,
                FullName = registerDto.FullName,
                IsEmailVerified = false, // Email needs verification
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            // Generate email verification token
            if (emailService != null)
            {
                var verificationToken = Guid.NewGuid().ToString() + Guid.NewGuid().ToString();
                var verification = new EmailVerification
                {
                    UserId = user.Id,
                    Token = verificationToken,
                    ExpiresAt = DateTime.UtcNow.AddDays(1),
                    CreatedAt = DateTime.UtcNow
                };

                _context.EmailVerifications.Add(verification);
                await _context.SaveChangesAsync();

                // Send verification email
                try
                {
                    _logger?.LogInformation($"Attempting to send verification email to: {user.Email}");
                    await emailService.SendVerificationEmailAsync(user.Email, user.Username, verificationToken);
                    _logger?.LogInformation($"Verification email process completed for: {user.Email}");
                }
                catch (Exception ex)
                {
                    // Log but don't fail registration
                    _logger?.LogError(ex, $"Failed to send verification email to {user.Email}. Error: {ex.Message}. Inner: {ex.InnerException?.Message}");
                }
            }

            // Generate token
            var token = GenerateJwtToken(user);

            // Check VIP status
            bool isVip = user.IsVip && user.VipExpiresAt.HasValue && user.VipExpiresAt.Value > DateTime.UtcNow;
            int? daysRemaining = null;
            if (isVip && user.VipExpiresAt.HasValue)
            {
                daysRemaining = Math.Max(0, (int)(user.VipExpiresAt.Value - DateTime.UtcNow).TotalDays);
            }

            return new AuthResponseDto
            {
                Token = token,
                User = new UserDto
                {
                    Id = user.Id,
                    Email = user.Email,
                    Username = user.Username,
                    FullName = user.FullName,
                    AvatarUrl = user.AvatarUrl,
                    Bio = user.Bio,
                    IsAdmin = user.IsAdmin,
                    IsVip = isVip,
                    VipExpiresAt = user.VipExpiresAt,
                    DaysRemaining = daysRemaining
                }
            };
        }

        public async Task<AuthResponseDto> LoginAsync(LoginDto loginDto)
        {
            // Find user by email
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == loginDto.Email);

            if (user == null)
            {
                throw new UnauthorizedAccessException("Invalid email or password");
            }

            // Verify password
            if (!BCrypt.Net.BCrypt.Verify(loginDto.Password, user.PasswordHash))
            {
                throw new UnauthorizedAccessException("Invalid email or password");
            }

            // Generate token
            var token = GenerateJwtToken(user);

            // Check VIP status
            bool isVip = user.IsVip && user.VipExpiresAt.HasValue && user.VipExpiresAt.Value > DateTime.UtcNow;
            int? daysRemaining = null;
            if (isVip && user.VipExpiresAt.HasValue)
            {
                daysRemaining = Math.Max(0, (int)(user.VipExpiresAt.Value - DateTime.UtcNow).TotalDays);
            }

            return new AuthResponseDto
            {
                Token = token,
                User = new UserDto
                {
                    Id = user.Id,
                    Email = user.Email,
                    Username = user.Username,
                    FullName = user.FullName,
                    AvatarUrl = user.AvatarUrl,
                    Bio = user.Bio,
                    IsAdmin = user.IsAdmin,
                    IsVip = isVip,
                    VipExpiresAt = user.VipExpiresAt,
                    DaysRemaining = daysRemaining
                }
            };
        }

        public string GenerateJwtToken(User user)
        {
            var jwtSettings = _configuration.GetSection("JwtSettings");
            var secretKey = jwtSettings["SecretKey"] ?? "your-secret-key-at-least-32-characters-long-for-security";
            var issuer = jwtSettings["Issuer"] ?? "E-Education-API";
            var audience = jwtSettings["Audience"] ?? "E-Education-Client";
            var expiryMinutes = int.Parse(jwtSettings["ExpiryMinutes"] ?? "1440"); // 24 hours default

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Name, user.Username),
                new Claim("IsAdmin", user.IsAdmin.ToString())
            };

            var token = new JwtSecurityToken(
                issuer: issuer,
                audience: audience,
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(expiryMinutes),
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        // Overload without email service for backward compatibility
        public async Task<AuthResponseDto> RegisterAsync(RegisterDto registerDto)
        {
            return await RegisterAsync(registerDto, null);
        }

        public async Task<bool> VerifyEmailTokenAsync(string token)
        {
            var verification = await _context.EmailVerifications
                .Include(v => v.User)
                .FirstOrDefaultAsync(v => v.Token == token && !v.IsUsed);

            if (verification == null)
            {
                return false;
            }

            if (verification.ExpiresAt < DateTime.UtcNow)
            {
                return false;
            }

            verification.IsUsed = true;
            verification.User.IsEmailVerified = true;
            await _context.SaveChangesAsync();

            return true;
        }
    }
}

