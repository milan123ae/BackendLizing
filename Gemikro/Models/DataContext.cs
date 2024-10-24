using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace Gemikro.Models
{
    public class DataContext : DbContext
    {
        public DataContext(DbContextOptions<DataContext> options) : base(options) { }

        public DbSet<Partner> Partner { get; set; }
        public DbSet<Contract> Contract { get; set; }
        public DbSet<PlanOtp> PlanOtp { get; set; }
        public DbSet<Invoice> Invoice { get; set; }
        public DbSet<Savetnici> Savetnici { get; set; }
    }
}
