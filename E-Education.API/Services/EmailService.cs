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
                var smtpHost = smtpSettings["Host"] ?? "smtp.gmail.com";
                var smtpPort = int.Parse(smtpSettings["Port"] ?? "587");
                var smtpUser = smtpSettings["User"];
                var smtpPassword = smtpSettings["Password"];
                var fromEmail = smtpSettings["FromEmail"] ?? smtpUser;
                var fromName = smtpSettings["FromName"] ?? "E-Education";

                // If SMTP is not configured, log and skip (for development)
                if (string.IsNullOrEmpty(smtpUser) || string.IsNullOrEmpty(smtpPassword))
                {
                    _logger.LogWarning("SMTP settings not configured. Email verification skipped.");
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

                using (var client = new SmtpClient())
                {
                    await client.ConnectAsync(smtpHost, smtpPort, SecureSocketOptions.StartTls);
                    await client.AuthenticateAsync(smtpUser, smtpPassword);
                    await client.SendAsync(message);
                    await client.DisconnectAsync(true);
                }

                _logger.LogInformation($"Verification email sent to {email}");
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
            var frontendUrl = _configuration["FrontendUrl"] ?? "http://localhost:5173";
            return $"{frontendUrl}/verify-email?token={token}";
        }
    }
}

