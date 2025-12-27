using Microsoft.EntityFrameworkCore;
using E_Education.API.Data;
using Microsoft.OpenApi.Models;
using System.Reflection;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "E-Education API",
        Version = "v1.0.0",
        Description = "API cho nền tảng học trực tuyến E-Education. Quản lý khóa học, tìm kiếm và lọc khóa học.",
        Contact = new OpenApiContact
        {
            Name = "E-Education Team"
        }
    });

    // Include XML comments if available
    var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
    var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
    if (File.Exists(xmlPath))
    {
        c.IncludeXmlComments(xmlPath);
    }
});


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
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "E-Education API v1");
    c.RoutePrefix = "docs"; // Đổi route từ "swagger" sang "docs" để giống như bạn muốn
    c.DocumentTitle = "E-Education API Documentation";
    c.DefaultModelsExpandDepth(-1); // Ẩn models section mặc định
    c.DisplayRequestDuration();
    c.EnableDeepLinking();
    c.EnableFilter();
    c.ShowExtensions();
    c.EnableValidator();
    c.SupportedSubmitMethods(Swashbuckle.AspNetCore.SwaggerUI.SubmitMethod.Get, 
                            Swashbuckle.AspNetCore.SwaggerUI.SubmitMethod.Post,
                            Swashbuckle.AspNetCore.SwaggerUI.SubmitMethod.Put,
                            Swashbuckle.AspNetCore.SwaggerUI.SubmitMethod.Delete);
});

// Swagger UI được cấu hình ở trên

app.UseCors("AllowFrontend");

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

// Health check endpoint
app.MapGet("/", () => new { message = "E-Education API is running", status = "ok" });

// Đảm bảo database được tạo
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    try
    {
        context.Database.EnsureCreated();
    }
    catch (Exception ex)
    {
        // Log error nhưng không dừng app
        var logger = scope.ServiceProvider.GetRequiredService<ILogger<Program>>();
        logger.LogError(ex, "Error ensuring database is created");
    }
}

app.Run();

