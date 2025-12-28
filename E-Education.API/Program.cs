using Microsoft.EntityFrameworkCore;
using E_Education.API.Data;
using E_Education.API.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add JWT Authentication
var jwtSettings = builder.Configuration.GetSection("JwtSettings");
var secretKey = jwtSettings["SecretKey"] ?? "your-secret-key-at-least-32-characters-long-for-security";
var issuer = jwtSettings["Issuer"] ?? "E-Education-API";
var audience = jwtSettings["Audience"] ?? "E-Education-Client";

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new Microsoft.IdentityModel.Tokens.TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = issuer,
        ValidAudience = audience,
        IssuerSigningKey = new Microsoft.IdentityModel.Tokens.SymmetricSecurityKey(
            System.Text.Encoding.UTF8.GetBytes(secretKey)
        )
    };
});

builder.Services.AddAuthorization();

// Register services
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<IGoogleAuthService, GoogleAuthService>();
builder.Services.AddScoped<IEmailService, EmailService>();


// Database Configuration
// Render cung cấp DATABASE_URL, nhưng EF Core cần ConnectionStrings__DefaultConnection
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

// Nếu không có trong appsettings, thử đọc từ DATABASE_URL (Render)
if (string.IsNullOrEmpty(connectionString))
{
    var databaseUrl = Environment.GetEnvironmentVariable("DATABASE_URL");
    if (!string.IsNullOrEmpty(databaseUrl))
    {
        // Parse DATABASE_URL format: postgresql://user:password@host:port/database
        // Convert sang format .NET: Host=host;Port=port;Database=database;Username=user;Password=password
        var uri = new Uri(databaseUrl);
        var host = uri.Host;
        var port = uri.Port > 0 ? uri.Port : 5432;
        var database = uri.LocalPath.TrimStart('/');
        var username = uri.UserInfo.Split(':')[0];
        var password = uri.UserInfo.Split(':').Length > 1 ? uri.UserInfo.Split(':')[1] : "";

        connectionString = $"Host={host};Port={port};Database={database};Username={username};Password={password};SSL Mode=Require;Trust Server Certificate=true";
    }
}

if (string.IsNullOrEmpty(connectionString))
{
    throw new InvalidOperationException("Connection string not found. Please set DATABASE_URL or ConnectionStrings__DefaultConnection");
}

builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseNpgsql(connectionString));

// CORS Configuration
var frontendUrl = Environment.GetEnvironmentVariable("FRONTEND_URL") ?? "https://*.vercel.app";
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.WithOrigins(
                "http://localhost:5173",
                "http://localhost:5174",
                "https://*.vercel.app"
            )
            .SetIsOriginAllowedToAllowWildcardSubdomains()
            .AllowAnyMethod()
            .AllowAnyHeader()
            .AllowCredentials();

        // Nếu có FRONTEND_URL từ env, thêm vào
        if (!string.IsNullOrEmpty(frontendUrl) && !frontendUrl.Contains("vercel.app"))
        {
            policy.WithOrigins(frontendUrl);
        }
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline
app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("AllowFrontend");

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

// Health check endpoint
app.MapGet("/", () => new { message = "UI Components API is running", status = "ok" });

// Đảm bảo database được tạo và seed data
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    var logger = scope.ServiceProvider.GetRequiredService<ILogger<Program>>();
    try
    {
        context.Database.EnsureCreated();
        // Initialize database with default admin user
        E_Education.API.Data.DbInitializer.Initialize(context, logger);
    }
    catch (Exception ex)
    {
        // Log error nhưng không dừng app
        logger.LogError(ex, "Error ensuring database is created");
    }
}

app.Run();

