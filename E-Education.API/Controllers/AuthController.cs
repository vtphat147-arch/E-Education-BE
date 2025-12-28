using Microsoft.AspNetCore.Mvc;
using E_Education.API.Models.DTOs;
using E_Education.API.Services;

namespace E_Education.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Tags("Authentication")]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;
        private readonly IGoogleAuthService _googleAuthService;
        private readonly IEmailService _emailService;
        private readonly ILogger<AuthController> _logger;

        public AuthController(
            IAuthService authService, 
            IGoogleAuthService googleAuthService,
            IEmailService emailService,
            ILogger<AuthController> logger)
        {
            _authService = authService;
            _googleAuthService = googleAuthService;
            _emailService = emailService;
            _logger = logger;
        }

        /// <summary>
        /// Register a new user
        /// </summary>
        [HttpPost("register")]
        [ProducesResponseType(typeof(AuthResponseDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> Register([FromBody] RegisterDto registerDto)
        {
            try
            {
                var result = await _authService.RegisterAsync(registerDto, _emailService);
                return Ok(result);
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during registration");
                return StatusCode(500, new { message = "An error occurred during registration" });
            }
        }

        /// <summary>
        /// Login user
        /// </summary>
        [HttpPost("login")]
        [ProducesResponseType(typeof(AuthResponseDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        public async Task<IActionResult> Login([FromBody] LoginDto loginDto)
        {
            try
            {
                var result = await _authService.LoginAsync(loginDto);
                return Ok(result);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Unauthorized(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during login");
                return StatusCode(500, new { message = "An error occurred during login" });
            }
        }

        /// <summary>
        /// Login with Google
        /// </summary>
        [HttpPost("google")]
        [ProducesResponseType(typeof(AuthResponseDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        public async Task<IActionResult> GoogleLogin([FromBody] GoogleLoginDto googleLoginDto)
        {
            try
            {
                var result = await _googleAuthService.AuthenticateAsync(googleLoginDto.IdToken);
                return Ok(result);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Unauthorized(new { message = ex.Message });
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during Google login");
                return StatusCode(500, new { message = "An error occurred during Google login" });
            }
        }

        /// <summary>
        /// Verify email with token
        /// </summary>
        [HttpPost("verify-email")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> VerifyEmail([FromQuery] string token)
        {
            try
            {
                var verified = await _authService.VerifyEmailTokenAsync(token);
                if (verified)
                {
                    return Ok(new { message = "Email verified successfully" });
                }
                else
                {
                    return BadRequest(new { message = "Invalid or expired verification token" });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error verifying email");
                return StatusCode(500, new { message = "An error occurred during email verification" });
            }
        }
    }
}

