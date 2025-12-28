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
        }
    }
}

