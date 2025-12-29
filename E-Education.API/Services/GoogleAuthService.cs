using Google.Apis.Auth;
using E_Education.API.Data;
using E_Education.API.Models;
using E_Education.API.Models.DTOs;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace E_Education.API.Services
{
    public interface IGoogleAuthService
    {
        Task<AuthResponseDto> AuthenticateAsync(string idToken);
    }

    public class GoogleAuthService : IGoogleAuthService
    {
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;
        private readonly IAuthService _authService;
        private readonly ILogger<GoogleAuthService> _logger;

        public GoogleAuthService(
            ApplicationDbContext context,
            IConfiguration configuration,
            IAuthService authService,
            ILogger<GoogleAuthService> logger)
        {
            _context = context;
            _configuration = configuration;
            _authService = authService;
            _logger = logger;
        }

        public async Task<AuthResponseDto> AuthenticateAsync(string idToken)
        {
            try
            {
                if (string.IsNullOrEmpty(idToken))
                {
                    throw new InvalidOperationException("ID token is required");
                }

                // Try to get ClientId from configuration (supports appsettings.json and environment variables)
                var clientId = _configuration["GoogleOAuth:ClientId"] 
                    ?? Environment.GetEnvironmentVariable("GOOGLE_OAUTH__CLIENT_ID")
                    ?? Environment.GetEnvironmentVariable("GoogleOAuth__ClientId");
                
                // Log for debugging
                _logger.LogInformation("Attempting to load Google OAuth ClientId. Found: {HasValue}", !string.IsNullOrEmpty(clientId));
                
                if (string.IsNullOrEmpty(clientId))
                {
                    var configValue = _configuration["GoogleOAuth:ClientId"];
                    var envValue1 = Environment.GetEnvironmentVariable("GOOGLE_OAUTH__CLIENT_ID");
                    var envValue2 = Environment.GetEnvironmentVariable("GoogleOAuth__ClientId");
                    
                    _logger.LogError(
                        "Google OAuth ClientId not found. Config value: {ConfigValue}, Env GOOGLE_OAUTH__CLIENT_ID: {Env1}, Env GoogleOAuth__ClientId: {Env2}",
                        configValue ?? "null",
                        envValue1 ?? "null",
                        envValue2 ?? "null"
                    );
                    
                    throw new InvalidOperationException("Google OAuth ClientId is not configured. Please set GOOGLE_OAUTH__CLIENT_ID environment variable on Render.");
                }

                // Verify Google ID token
                var settings = new GoogleJsonWebSignature.ValidationSettings
                {
                    Audience = new[] { clientId }
                };

                GoogleJsonWebSignature.Payload payload;
                try
                {
                    payload = await GoogleJsonWebSignature.ValidateAsync(idToken, settings);
                }
                catch (InvalidJwtException ex)
                {
                    throw new UnauthorizedAccessException($"Invalid Google token: {ex.Message}");
                }
                catch (Exception ex)
                {
                    throw new UnauthorizedAccessException($"Token validation failed: {ex.Message}");
                }

                // Check if user exists by Google ID
                var user = await _context.Users
                    .FirstOrDefaultAsync(u => u.GoogleId == payload.Subject || u.Email == payload.Email);

                if (user == null)
                {
                    // Create new user
                    var username = payload.Email.Split('@')[0];
                    var baseUsername = username;
                    var counter = 1;

                    // Ensure username is unique
                    while (await _context.Users.AnyAsync(u => u.Username == username))
                    {
                        username = $"{baseUsername}{counter}";
                        counter++;
                    }

                    user = new User
                    {
                        Email = payload.Email,
                        Username = username,
                        FullName = payload.Name,
                        AvatarUrl = payload.Picture,
                        GoogleId = payload.Subject,
                        GoogleEmail = payload.Email,
                        IsEmailVerified = true, // Google emails are already verified
                        PasswordHash = "", // No password for Google users
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    };

                    _context.Users.Add(user);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    // Update Google info if needed
                    if (string.IsNullOrEmpty(user.GoogleId))
                    {
                        user.GoogleId = payload.Subject;
                        user.GoogleEmail = payload.Email;
                    }

                    if (string.IsNullOrEmpty(user.AvatarUrl) && !string.IsNullOrEmpty(payload.Picture))
                    {
                        user.AvatarUrl = payload.Picture;
                    }

                    user.IsEmailVerified = true; // Ensure email is verified
                    user.UpdatedAt = DateTime.UtcNow;
                    await _context.SaveChangesAsync();
                }

                // Generate JWT token
                var token = _authService.GenerateJwtToken(user);

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
            catch (InvalidJwtException ex)
            {
                throw new UnauthorizedAccessException("Invalid Google token: " + ex.Message);
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException("Error authenticating with Google: " + ex.Message);
            }
        }
    }
}

