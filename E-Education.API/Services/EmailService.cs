using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using Microsoft.Extensions.Configuration;

namespace E_Education.API.Services
{
    public interface IEmailService
    {
        Task SendVerificationEmailAsync(string email, string username, string verificationToken);
        Task<bool> VerifyEmailAsync(string token);
    }

    public class EmailService : IEmailService
    {
        private readonly IConfiguration _configuration;
        private readonly ILogger<EmailService> _logger;

        public EmailService(IConfiguration configuration, ILogger<EmailService> logger)
        {
            _configuration = configuration;
            _logger = logger;
        }

        public async Task SendVerificationEmailAsync(string email, string username, string verificationToken)
        {
            try
            {
                var smtpSettings = _configuration.GetSection("SmtpSettings");
                
                // Try to get from configuration first, then fallback to environment variables
                var smtpHost = smtpSettings["Host"] 
                    ?? Environment.GetEnvironmentVariable("SMTP__HOST") 
                    ?? "smtp.gmail.com";
                    
                var smtpPortStr = smtpSettings["Port"] 
                    ?? Environment.GetEnvironmentVariable("SMTP__PORT") 
                    ?? "587";
                var smtpPort = int.Parse(smtpPortStr);
                
                var smtpUser = smtpSettings["User"] 
                    ?? Environment.GetEnvironmentVariable("SMTP__USER");
                    
                var smtpPassword = smtpSettings["Password"] 
                    ?? Environment.GetEnvironmentVariable("SMTP__PASSWORD");
                    
                var fromEmail = smtpSettings["FromEmail"] 
                    ?? Environment.GetEnvironmentVariable("SMTP__FROMEMAIL") 
                    ?? smtpUser;
                    
                var fromName = smtpSettings["FromName"] 
                    ?? Environment.GetEnvironmentVariable("SMTP__FROMNAME") 
                    ?? "E-Education";

                // Log for debugging
                _logger.LogInformation("SMTP Config - Host: {Host}, Port: {Port}, User: {HasUser}, Password: {HasPassword}", 
                    smtpHost, smtpPort, !string.IsNullOrEmpty(smtpUser), !string.IsNullOrEmpty(smtpPassword));

                // If SMTP is not configured, log and skip (for development)
                if (string.IsNullOrEmpty(smtpUser) || string.IsNullOrEmpty(smtpPassword))
                {
                    _logger.LogWarning("SMTP settings not configured. Email verification skipped. User: {User}, Password: {HasPassword}", 
                        smtpUser ?? "null", !string.IsNullOrEmpty(smtpPassword));
                    _logger.LogInformation($"Verification link: {GetVerificationUrl(verificationToken)}");
                    return;
                }

                var message = new MimeMessage();
                message.From.Add(new MailboxAddress(fromName, fromEmail));
                message.To.Add(new MailboxAddress(username, email));
                message.Subject = "Xác thực email của bạn - E-Education";

                var verificationUrl = GetVerificationUrl(verificationToken);

                message.Body = new TextPart("html")
                {
                    Text = $@"
                    <html>
                    <body style='font-family: Arial, sans-serif; padding: 20px;'>
                        <h2>Xin chào {username}!</h2>
                        <p>Cảm ơn bạn đã đăng ký tài khoản tại E-Education.</p>
                        <p>Vui lòng click vào link bên dưới để xác thực email của bạn:</p>
                        <p style='margin: 20px 0;'>
                            <a href='{verificationUrl}' style='background-color: #4F46E5; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; display: inline-block;'>
                                Xác thực email
                            </a>
                        </p>
                        <p>Hoặc copy link này vào trình duyệt:</p>
                        <p style='word-break: break-all; color: #4F46E5;'>{verificationUrl}</p>
                        <p>Link này sẽ hết hạn sau 24 giờ.</p>
                        <p>Nếu bạn không yêu cầu đăng ký, vui lòng bỏ qua email này.</p>
                        <hr style='margin: 20px 0; border: none; border-top: 1px solid #ddd;' />
                        <p style='color: #666; font-size: 12px;'>E-Education Team</p>
                    </body>
                    </html>"
                };

                try
                {
                    using (var client = new SmtpClient())
                    {
                        // Set timeout
                        client.Timeout = 10000; // 10 seconds
                        
                        // Try SSL first (port 465), fallback to StartTLS (port 587)
                        if (smtpPort == 465)
                        {
                            _logger.LogInformation($"Connecting with SSL to {smtpHost}:{smtpPort}");
                            await client.ConnectAsync(smtpHost, smtpPort, SecureSocketOptions.SslOnConnect);
                        }
                        else
                        {
                            _logger.LogInformation($"Connecting with StartTLS to {smtpHost}:{smtpPort}");
                            await client.ConnectAsync(smtpHost, smtpPort, SecureSocketOptions.StartTls);
                        }
                        
                        _logger.LogInformation("SMTP connected successfully");
                        _logger.LogInformation($"Authenticating as: {smtpUser}");
                        await client.AuthenticateAsync(smtpUser, smtpPassword);
                        _logger.LogInformation("SMTP authenticated successfully");
                        
                        _logger.LogInformation($"Sending email to: {email}");
                        await client.SendAsync(message);
                        _logger.LogInformation($"Email sent successfully to {email}");
                        
                        await client.DisconnectAsync(true);
                    }
                }
                catch (Exception smtpEx)
                {
                    _logger.LogError(smtpEx, $"SMTP Error: {smtpEx.Message}. Inner: {smtpEx.InnerException?.Message}");
                    throw;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error sending verification email to {email}");
                throw;
            }
        }

        public async Task<bool> VerifyEmailAsync(string token)
        {
            // This will be implemented in the AuthService
            return await Task.FromResult(false);
        }

        private string GetVerificationUrl(string token)
        {
            var frontendUrl = _configuration["FrontendUrl"] 
                ?? Environment.GetEnvironmentVariable("FRONTEND_URL") 
                ?? "https://e-education-beta.vercel.app";
            return $"{frontendUrl}/verify-email?token={token}";
        }
    }
}

