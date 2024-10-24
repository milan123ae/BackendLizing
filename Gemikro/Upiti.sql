--Napomena: sve veze izmeðu tabela se mogu videti u dijagramu Diagram_0

/*
1. Prikazati sve partnere koji imaju makar jedan aktivan ugovor (status_akt = 'A')
	Rezultat treba da sadrži osnovne podatke o partneru (ID i Naziv) kao i broj aktivnih ugovora. 
	Rezultat sortirati po broju aktivnih ugovora ASC.
*/
SELECT 
    p.PartnerId,
    p.Name,
    COUNT(c.ContractId) AS ActiveContractCount
FROM 
    Partner p
JOIN 
    Contract c ON p.PartnerId = c.PartnerId
WHERE 
    c.Status_akt = 'A'
GROUP BY 
    p.PartnerId, p.Name
HAVING 
    COUNT(c.ContractId) > 0
ORDER BY 
    ActiveContractCount ASC;



/*
2. Izlistati sve ugovore koji nisu zakljuèeni (zakljuèeni = status_akt 'Z') a koji u planu otplate (tabela planotp) imaju više od jednog potraživanja PDV-a (Claim = 'PDV')
	Rezultat treba da vrati samo jedan podatak (svi ugovori odvojeni zarezom kao separatorom). 
	Koristiti varijablu @contractID_list (deklarisati varijablu, smestiti rezultat u ovu varijablu, prikazati rezultat iz ove varijable)
*/
DECLARE @contractID_list VARCHAR(MAX);

SELECT 
    @contractID_list = STRING_AGG(CONVERT(VARCHAR, c.ContractId), ', ')
FROM 
    Contract c
JOIN 
    PlanOtp p ON c.ContractId = p.ContractId
WHERE 
    c.Status_act = 'Z' 
    AND p.Claim = 'VAT'
GROUP BY 
    c.ContractId
HAVING 
    COUNT(p.Claim) > 1;

-- Display the result
SELECT @contractID_list AS ContractIDs;

/*
3. Prikazati sve ugovore koji nemaju plaæenu nijednu fakturu (ne postoji zapis u tabeli invoice) a da su aktivirani u tekuæoj godini
	Rezultat treba da sadrži osnovne podatke o ugovoru i partneru na ugovoru.
*/

SELECT 
    c.ContractId,
    c.Description,
    c.Value,
    c.Status_akt,
    c.dat_akt,
    p.PartnerId,
    p.Name
FROM 
    Contract c
JOIN 
    Partner p ON c.PartnerId = p.PartnerId
WHERE 
    c.ContractId NOT IN (SELECT ContractId FROM Invoice)
    AND YEAR(c.dat_akt) = YEAR(GETDATE());



/*
4. Prikazati ukupni iznos plaæenih faktura (invoice.ammount) sumirano po savetnicima.
	Ukoliko partner nema savetnika default savetnik je id_svet = '99'. 
	Ne uzimati u obzir fakture koje nisu vezane za ugovor (contractID NULL).
	Prikazati osnovne podatke o savetnicima (ID i naziv) kao i ukupni iznos plaæenih faktura
*/
SELECT 
    COALESCE(s.Id_svet, '99') AS AdviserId, 
    COALESCE(s.Savetnik, 'Default Adviser') AS AdviserName,  
    SUM(i.Amount) AS TotalPaidAmount
FROM 
    Invoice i
LEFT JOIN 
    Contract c ON i.ContractId = c.ContractId
LEFT JOIN 
    Savetnici s ON COALESCE(c.PartnerId, '99') = s.Id_svet 
WHERE 
    i.Amount IS NOT NULL 
    AND i.ContractId IS NOT NULL 
GROUP BY 
    COALESCE(s.Id_svet, '99'), 
    COALESCE(s.Savetnik, 'Default Adviser')
ORDER BY 
    AdviserId;

/*
5. Prikazati ukupan iznos duga po ugovorima i procenat otplaæenosti duga za potraživanje RATA (Claim = 'RATA') iz tabele planotp.
	Prikazati podatak o broju ugovora, vrsti potraživanja (kolona Claim), sumu rata (Claim_Value), sumu duga (debt) kao i procenat koliko je ukupno otplaæeno od ovog potraživanja (kolona debt predstavlja podatak o iznosu duga za potraživanje)
*/
--Use a CTE DebtSummary to summarize the data
WITH DebtSummary AS (
    SELECT 
        p.Claim,
        COUNT(DISTINCT c.ContractId) AS NumberOfContracts,
        SUM(p.Claim_Value) AS TotalRataAmount,
        SUM(p.Debt) AS TotalDebt
    FROM 
        PlanOtp p
    JOIN 
        Contract c ON p.ContractId = c.ContractId
    WHERE 
        p.Claim = 'RATA'
    GROUP BY 
        p.Claim
)

SELECT 
    ds.NumberOfContracts,
    ds.Claim,
    ds.TotalRataAmount,
    ds.TotalDebt,
    CASE 
        WHEN ds.TotalDebt > 0 THEN 
            (SUM(ds.TotalRataAmount) / ds.TotalDebt) * 100
        ELSE 
            0 
    END AS PercentageRepaid
FROM 
    DebtSummary ds
GROUP BY 
    ds.NumberOfContracts, ds.Claim, ds.TotalRataAmount, ds.TotalDebt;
