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
        }
    }
}

