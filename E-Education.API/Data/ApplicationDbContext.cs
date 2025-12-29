using Microsoft.EntityFrameworkCore;
using E_Education.API.Models;

namespace E_Education.API.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<DesignComponent> DesignComponents { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<Favorite> Favorites { get; set; }
        public DbSet<Comment> Comments { get; set; }
        public DbSet<ComponentViewHistory> ComponentViewHistory { get; set; }
        public DbSet<EmailVerification> EmailVerifications { get; set; }
        public DbSet<ComponentLike> ComponentLikes { get; set; }
        public DbSet<VipPlan> VipPlans { get; set; }
        public DbSet<Payment> Payments { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<DesignComponent>(entity =>
            {
                entity.ToTable("DesignComponents");
                entity.HasIndex(e => e.Category);
                entity.HasIndex(e => e.Type);
                entity.HasIndex(e => e.Name);
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("Users");
                entity.HasIndex(e => e.Email).IsUnique();
                entity.HasIndex(e => e.Username).IsUnique();
                entity.HasIndex(e => e.GoogleId);
            });

            modelBuilder.Entity<EmailVerification>(entity =>
            {
                entity.ToTable("EmailVerifications");
                entity.HasIndex(e => e.Token).IsUnique();
                entity.HasIndex(e => e.UserId);
                entity.HasOne(e => e.User)
                    .WithMany()
                    .HasForeignKey(e => e.UserId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            modelBuilder.Entity<Favorite>(entity =>
            {
                entity.ToTable("Favorites");
                entity.HasIndex(e => new { e.UserId, e.ComponentId }).IsUnique();
                entity.HasOne(e => e.User)
                    .WithMany(u => u.Favorites)
                    .HasForeignKey(e => e.UserId)
                    .OnDelete(DeleteBehavior.Cascade);
                entity.HasOne(e => e.Component)
                    .WithMany()
                    .HasForeignKey(e => e.ComponentId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            modelBuilder.Entity<Comment>(entity =>
            {
                entity.ToTable("Comments");
                entity.HasIndex(e => e.ComponentId);
                entity.HasIndex(e => e.CreatedAt);
                entity.HasOne(e => e.User)
                    .WithMany(u => u.Comments)
                    .HasForeignKey(e => e.UserId)
                    .OnDelete(DeleteBehavior.Cascade);
                entity.HasOne(e => e.Component)
                    .WithMany()
                    .HasForeignKey(e => e.ComponentId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            modelBuilder.Entity<ComponentViewHistory>(entity =>
            {
                entity.ToTable("ComponentViewHistory");
                entity.HasIndex(e => new { e.UserId, e.ComponentId });
                entity.HasIndex(e => e.ViewedAt);
                entity.HasOne(e => e.User)
                    .WithMany(u => u.ViewHistory)
                    .HasForeignKey(e => e.UserId)
                    .OnDelete(DeleteBehavior.Cascade);
                entity.HasOne(e => e.Component)
                    .WithMany()
                    .HasForeignKey(e => e.ComponentId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            modelBuilder.Entity<ComponentLike>(entity =>
            {
                entity.ToTable("ComponentLikes");
                entity.HasIndex(e => new { e.UserId, e.ComponentId }).IsUnique(); // Ensure one like per user per component
                entity.HasIndex(e => e.ComponentId);
                entity.HasIndex(e => e.LikedAt);
                entity.HasOne(e => e.User)
                    .WithMany(u => u.ComponentLikes)
                    .HasForeignKey(e => e.UserId)
                    .OnDelete(DeleteBehavior.Cascade);
                entity.HasOne(e => e.Component)
                    .WithMany()
                    .HasForeignKey(e => e.ComponentId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            modelBuilder.Entity<VipPlan>(entity =>
            {
                entity.ToTable("VipPlans");
                entity.HasIndex(e => e.IsActive);
            });

            modelBuilder.Entity<Payment>(entity =>
            {
                entity.ToTable("Payments");
                entity.HasIndex(e => e.UserId);
                entity.HasIndex(e => e.PayOSOrderCode).IsUnique();
                entity.HasIndex(e => e.Status);
                entity.HasOne(e => e.User)
                    .WithMany(u => u.Payments)
                    .HasForeignKey(e => e.UserId)
                    .OnDelete(DeleteBehavior.Cascade);
                entity.HasOne(e => e.VipPlan)
                    .WithMany(p => p.Payments)
                    .HasForeignKey(e => e.VipPlanId)
                    .OnDelete(DeleteBehavior.Restrict);
            });
        }
    }
}

