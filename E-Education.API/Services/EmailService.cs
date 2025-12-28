using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using Microsoft.Extensions.Configuration;
using SendGrid;
using SendGrid.Helpers.Mail;

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
                // Try SendGrid API first (more reliable than SMTP, avoids timeout)
                var sendGridApiKey = _configuration["SendGrid:ApiKey"] 
                    ?? Environment.GetEnvironmentVariable("SENDGRID_API_KEY")
                    ?? Environment.GetEnvironmentVariable("SMTP__PASSWORD"); // Fallback to SMTP password (SendGrid API key)
                
                if (!string.IsNullOrEmpty(sendGridApiKey))
                {
                    try
                    {
                        await SendViaSendGridApi(email, username, verificationToken, sendGridApiKey);
                        return;
                    }
                    catch (Exception apiEx)
                    {
                        _logger.LogWarning(apiEx, "SendGrid API failed, trying SMTP fallback");
                        // Fall through to SMTP
                    }
                }

                // Fallback to SMTP
                await SendViaSmtp(email, username, verificationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error sending verification email to {email}");
                throw;
            }
        }

        private async Task SendViaSendGridApi(string email, string username, string verificationToken, string apiKey)
        {
            var fromEmail = _configuration["SmtpSettings:FromEmail"] 
                ?? Environment.GetEnvironmentVariable("SMTP__FROMEMAIL") 
                ?? "noreply@e-education.com";
                
            var fromName = _configuration["SmtpSettings:FromName"] 
                ?? Environment.GetEnvironmentVariable("SMTP__FROMNAME") 
                ?? "E-Education";

            var verificationUrl = GetVerificationUrl(verificationToken);

            var client = new SendGridClient(apiKey);
            var from = new EmailAddress(fromEmail, fromName);
            var to = new EmailAddress(email, username);
            var subject = "Xác thực email của bạn - E-Education";
            
            var htmlContent = $@"
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
                </html>";

            var msg = MailHelper.CreateSingleEmail(from, to, subject, htmlContent, htmlContent);
            
            _logger.LogInformation($"Sending email via SendGrid API to: {email}");
            var response = await client.SendEmailAsync(msg);
            
            if (response.IsSuccessStatusCode)
            {
                _logger.LogInformation($"Email sent successfully via SendGrid API to {email}");
            }
            else
            {
                var body = await response.Body.ReadAsStringAsync();
                throw new Exception($"SendGrid API error: {response.StatusCode} - {body}");
            }
        }

        private async Task SendViaSmtp(string email, string username, string verificationToken)
        {
            var smtpSettings = _configuration.GetSection("SmtpSettings");
            
            var smtpHost = smtpSettings["Host"] 
                ?? Environment.GetEnvironmentVariable("SMTP__HOST") 
                ?? "smtp.sendgrid.net";
                
            var smtpPortStr = smtpSettings["Port"] 
                ?? Environment.GetEnvironmentVariable("SMTP__PORT") 
                ?? "587";
            var smtpPort = int.Parse(smtpPortStr);
            
            var smtpUser = smtpSettings["User"] 
                ?? Environment.GetEnvironmentVariable("SMTP__USER")
                ?? "apikey";
                
            var smtpPassword = smtpSettings["Password"] 
                ?? Environment.GetEnvironmentVariable("SMTP__PASSWORD");
                
            var fromEmail = smtpSettings["FromEmail"] 
                ?? Environment.GetEnvironmentVariable("SMTP__FROMEMAIL") 
                ?? "noreply@e-education.com";
                
            var fromName = smtpSettings["FromName"] 
                ?? Environment.GetEnvironmentVariable("SMTP__FROMNAME") 
                ?? "E-Education";

            if (string.IsNullOrEmpty(smtpPassword))
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
                client.Timeout = 15000;
                
                _logger.LogInformation($"Connecting to SMTP server: {smtpHost}:{smtpPort}");
                SecureSocketOptions socketOptions = smtpPort == 465 
                    ? SecureSocketOptions.SslOnConnect 
                    : SecureSocketOptions.StartTls;
                
                await client.ConnectAsync(smtpHost, smtpPort, socketOptions);
                _logger.LogInformation("SMTP connected successfully");
                
                await client.AuthenticateAsync(smtpUser, smtpPassword);
                _logger.LogInformation("SMTP authenticated successfully");
                
                _logger.LogInformation($"Sending email to: {email}");
                await client.SendAsync(message);
                _logger.LogInformation($"Email sent successfully to {email}");
                
                await client.DisconnectAsync(true);
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
