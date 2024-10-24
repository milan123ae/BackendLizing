using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Gemikro.Models
{
    public class Invoice
    {
        [Key]
        public int InvoiceId { get; set; }
        public int PartnerId { get; set; }
        public DateTime InvoiceDate { get; set; }
        public decimal Amount { get; set; }
        public int ContractId { get; set; }
        public Contract Contract { get; set; }
    }
}
