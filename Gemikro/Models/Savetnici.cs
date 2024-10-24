using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Gemikro.Models
{
    public class Savetnici
    {
        [Key]
        public int Id_svet { get; set; }
        public string Savetnik { get; set; }
        public string Novauser { get; set; }
        public string Email { get; set; }
    }
}
