using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Gemikro.Models
{
    public class Contract
    {
        [Key]
        public int ContractId { get; set; }
        public int PartnerId { get; set; }
        public string Description { get; set; }
        public decimal Value { get; set; }
        public string Status_akt { get; set; }
        public DateTime dat_akt { get; set; }
        public Partner Partner { get; set; }
        public ICollection<PlanOtp> PlanOtp { get; set; }
    }
}
