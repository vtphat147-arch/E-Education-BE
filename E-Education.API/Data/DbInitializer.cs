using E_Education.API.Models;
using Microsoft.EntityFrameworkCore;

namespace E_Education.API.Data
{
    public static class DbInitializer
    {
        public static void Initialize(ApplicationDbContext context, ILogger logger)
        {
            try
            {
                context.Database.EnsureCreated();

                // Check if admin user already exists
                if (!context.Users.Any(u => u.IsAdmin))
                {
                    // Create default admin user
                    // Password: Admin123! (hashed with BCrypt)
                    var adminPasswordHash = BCrypt.Net.BCrypt.HashPassword("Admin123!");
                    
                    var adminUser = new User
                    {
                        Email = "admin@e-education.com",
                        Username = "admin",
                        PasswordHash = adminPasswordHash,
                        FullName = "Administrator",
                        IsAdmin = true,
                        IsEmailVerified = true, // Admin email is auto-verified
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    };

                    context.Users.Add(adminUser);
                    context.SaveChanges();

                    logger.LogInformation("Default admin user created: admin@e-education.com / Admin123!");
                }
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error initializing database");
            }
        }
    }
}



