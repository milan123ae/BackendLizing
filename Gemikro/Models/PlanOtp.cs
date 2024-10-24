using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Gemikro.Models
{
    public class PlanOtp
    {
        [Key]
        public int PlanpId { get; set; }
        public int ContractId { get; set; }
        public string Claim { get; set; }
        public decimal Claim_Value { get; set; }
        public decimal Debt { get; set; }
        public Contract Contract { get; set; }
    }
}
