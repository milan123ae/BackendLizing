using Gemikro.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Gemikro.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ContractsController : ControllerBase
    {
        private readonly DataContext _context;

        public ContractsController(DataContext context)
        {
            _context = context;
        }

        //1. Prikazati sve partnere koji imaju makar jedan aktivan ugovor (status_akt = A;)
        [HttpGet("active-partners")]
        public async Task<ActionResult<IEnumerable<Partner>>> GetActivePartners()
        {
            var activePartners = await _context.Partner
                .Where(p => p.Contract.Any(c => c.Status_akt == "A"))
                .ToListAsync();

            return Ok(activePartners);
        }
        // 2.Prikazati sve ugovore koji nisu zaključeni (zaključeni = status_akt &#39;Z&#39;) a koji u planu otplate (tabela
       // planotp) imaju više od jednog potraživanja PDV-a(Claim = PDV)
        [HttpGet("not-concluded-contracts")]
        public async Task<ActionResult<IEnumerable<Contract>>> GetUnconcludedVatClaims()
        {
            var contracts = await _context.Contract
                .Where(c => c.Status_akt == "Z" &&
                            _context.PlanOtp.Count(p => p.ContractId == c.ContractId && p.Claim == "PDV") > 1)
                .ToListAsync();

            return Ok(contracts);
        }

        //3.Prikazati sve ugovore koji nemaju plaćenu nijednu fakturu (ne postoji zapis u tabeli invoice) a da su
        //aktivirani u tekućoj godini
       [HttpGet("unpaid-current-year")]
        public async Task<ActionResult<IEnumerable<Contract>>> GetUnpaidContractsCurrentYear()
        {
            var currentYear = DateTime.Now.Year;

            var contracts = await _context.Contract
                .Where(c => !_context.Invoice.Any(i => i.ContractId == c.ContractId) &&
                            c.dat_akt.Year == currentYear)
                .ToListAsync();

            return Ok(contracts);
        }

        //4.Prikazati ukupni iznos plaćenih faktura (invoice.ammount) sumirano po savetnicima.
        [HttpGet("total-paid-invoices-by-adviser")]
        public IActionResult GetTotalPaidInvoicesByAdviser()
        {
            var totalByAdviser =_context.Invoice
                .GroupBy(i => i.Contract.Partner.Id_svet) // Assuming PartnerId relates to an adviser
                .Select(g => new
                {
                    Id_svet = g.Key,
                    TotalAmount = g.Sum(i => i.Amount)
                })
                .ToList();

            return Ok(totalByAdviser);
        }

        //5.Prikazati ukupan iznos duga po ugovorima i procenat otplaćenosti duga za potraživanje RATA (Claim
        //= RATA) iz tabele planotp.
        [HttpGet("debt-repayment-rata")]
        public IActionResult GetDebtRepaymentRata()
        {
            var totalDebt = _context.PlanOtp
                .Where(p => p.Claim == "RATA")
                .Sum(p => p.Debt);

            var totalClaimValue = _context.PlanOtp
                .Where(p => p.Claim == "RATA")
                .Sum(p => p.Claim_Value);

            var repaymentPercentage = totalClaimValue > 0 ? (totalDebt / totalClaimValue) * 100 : 0;

            return Ok(new
            {
                TotalDebt = totalDebt,
                RepaymentPercentage = repaymentPercentage
            });
        }
    }
}
