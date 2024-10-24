using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Gemikro.Models
{
    public class Partner
    {
        [Key]
        public int PartnerId { get; set; }
        public string Name { get; set; }
        public string Adress { get; set; }
        public string StatusSaradnje { get; set; }
        public int Id_svet { get; set; }
        public ICollection<Contract> Contract { get; set; }
    }
}
