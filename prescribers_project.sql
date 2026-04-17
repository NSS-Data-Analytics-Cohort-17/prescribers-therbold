--Q1.a
SELECT npi, SUM(total_claim_count) AS total_pres_count
FROM prescription
GROUP BY npi, total_claim_count
ORDER BY total_claim_count DESC;

--Q1.b
SELECT prescription.npi, SUM(total_claim_count) AS total_pres_count,
	prescriber.nppes_provider_last_org_name AS last_name, 
	prescriber.nppes_provider_first_name AS first_name, 
	prescriber.specialty_description AS sp_desc
FROM prescription
LEFT JOIN prescriber ON prescriber.npi = prescription.npi
GROUP BY prescription.npi, last_name, first_name, total_claim_count, sp_desc
ORDER BY total_claim_count DESC;

--Q2.a
SELECT prescriber.specialty_description AS sp_desc,
	SUM(total_claim_count) AS total_pres_count
FROM prescription
LEFT JOIN prescriber ON prescriber.npi = prescription.npi
GROUP BY sp_desc
ORDER BY total_pres_count DESC;
--Family Practice

--Q2.b
SELECT prescriber.specialty_description AS sp_desc,
	SUM(total_claim_count) AS total_pres_count
FROM prescription
LEFT JOIN drug ON prescription.drug_name = drug.drug_name
LEFT JOIN prescriber ON prescription.npi = prescriber.npi
WHERE opioid_drug_flag = 'Y'
GROUP BY sp_desc
ORDER BY total_pres_count DESC;
--Nurse Practitioner

--Q3.a
SELECT DISTINCT(generic_name), SUM(total_drug_cost) AS tot_drug_cost
FROM drug
LEFT JOIN prescription ON prescription.drug_name = drug.drug_name
WHERE total_drug_cost IS NOT NULL
GROUP BY generic_name
ORDER BY tot_drug_cost DESC;
--Insulin

--Q3.b
SELECT DISTINCT(generic_name), 
	ROUND(SUM(total_drug_cost)/SUM(total_day_supply),2) AS daily_drug_cost
FROM drug
LEFT JOIN prescription ON prescription.drug_name = drug.drug_name
WHERE total_drug_cost IS NOT NULL
GROUP BY generic_name
ORDER BY daily_drug_cost DESC;
--C1 Esterase

--Q4.a
SELECT DISTINCT(generic_name),
	CASE 
		WHEN opioid_drug_flag = 'Y' THEN 'opioid' 
		WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic' 
		ELSE 'neither' 
	END AS drug_type
FROM drug;

--Q4.b
SELECT DISTINCT(generic_name), SUM(total_drug_cost::money) AS tot_drug_cost,
	CASE 
		WHEN opioid_drug_flag = 'Y' THEN 'opioid' 
		WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic' 
		ELSE 'neither' 
	END AS drug_type
FROM drug
LEFT JOIN prescription ON prescription.drug_name = drug.drug_name
WHERE total_drug_cost IS NOT NULL
GROUP BY generic_name, opioid_drug_flag, antibiotic_drug_flag
ORDER BY tot_drug_cost DESC;

--Q5.a
SELECT COUNT(cbsa)
FROM cbsa
WHERE cbsaname ILIKE '%TN%';

--Q5.b
SELECT cbsa, SUM(population) AS cbsa_pop
FROM cbsa
LEFT JOIN population ON cbsa.fipscounty = population.fipscounty
WHERE population IS NOT NULL
GROUP BY cbsa
ORDER BY cbsa_pop DESC;

--Q5.c
SELECT *
FROM cbsa

