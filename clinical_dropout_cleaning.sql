-- PARTIE 1 : NETTOYAGE DES DATAS / DATA CLEANING --

-- 'Appointment' Table--
--View Creation--
CREATE VIEW mis602_ass2.appointment_clean AS
SELECT
appointment_id,
patient_id,
doctor_id,
appointment_date,
notes,
status,
FROM mis602_ass2.appointment;

-- Identifier les NULLS/ Valeurs Manquantes/ Chaînes Vides/ Espace (OK)
SELECT
COUNT(*) AS Total_rows,
SUM(CASE WHEN appointment_id IS NULL THEN 1 ELSE 0 END) AS null_appointment_id,
  SUM(CASE WHEN patient_id IS NULL THEN 1 ELSE 0 END) AS null_patient_id,
  SUM(CASE WHEN doctor_id IS NULL THEN 1 ELSE 0 END) AS null_doctor_id,
  SUM(CASE WHEN appointment_date IS NULL THEN 1 ELSE 0 END) AS null_appointment_date,
  SUM(CASE WHEN notes IS NULL THEN 1 ELSE 0 END) AS null_notes,
  SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS null_status
  FROM mis602_ass2.appointment_clean;

-- Compter le nombre de ligne avec Espace ou des valeurs NULL dans la table 'appointment' colonne 'status'
SELECT
COUNT(*) AS total_rows,
SUM(CASE 
WHEN status IS NOT NULL AND (status = '' OR NULLIF(TRIM(status), '') IS NULL) THEN 1 ELSE 0 END) AS empty_only,
SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS Null_Value
FROM mis602_ass2.appointment_clean;

-- Remplacer les valeurs NULLS de la table 'appointment' (OK)
SELECT
status,
COALESCE(status, 'unknown') AS clean_status,
COALESCE(notes, 'unknown') AS clean_notes,
COALESCE(appointment_date, 'unknown') AS clean_appointment_date,
COALESCE(doctor_id, 0) AS clean_doctor_id,
COALESCE(patient_id, 0) AS clean_patient_id,
COALESCE(appointment_id, 0) AS clean_appointment_id
FROM mis602_ass2.appointment_clean;

-- Identifier dans la PK (appointment_id) de la table 'appointment' des doublons--
SELECT
*
FROM
(SELECT
appointment_id,
COUNT(*) OVER (PARTITION BY appointment_id) AS CheckPK
FROM mis602_ass2.appointment_clean
) t 
WHERE CheckPK > 1;


-- 'Doctor' table --
--Create a view--
CREATE VIEW mis602_ass2.doctor_clean AS
SELECT
doctor_id,
name,
phone_number,
speciality_id,
FROM mis602_ass2.doctor;

-- Identifier les Valeurs Nulles + Remplacer les valeurs NULLS de la table 'doctor' version CTE
WITH clean_doctor_report AS (
SELECT
COUNT(*) AS Total_rows,
SUM(CASE WHEN doctor_id IS NULL THEN 1 ELSE 0 END) AS null_doctor_id,
  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_name,
  SUM(CASE WHEN phone_number IS NULL THEN 1 ELSE 0 END) AS null_phone_number,
  SUM(CASE WHEN speciality_id IS NULL THEN 1 ELSE 0 END) AS null_speciality_id
  FROM mis602_ass2.doctor_clean
  )
SELECT
doctor_id,
name,
phone_number,
speciality_id,
COALESCE(speciality_id, 0) AS clean_speciality_id
FROM mis602_ass2.doctor_clean;

-- Nettoyer la table Doctor et remplacer les valeurs NULLs par une valeur 'Unknown'
SELECT 
  *,
  CASE 
    WHEN status IS NULL OR status = '' OR NULLIF(TRIM(doctor_id), '') IS NULL 
    THEN 'UNKNOWN'
    ELSE UPPER(TRIM(speciality_id))
  END AS clean_speciality_id
  FROM doctor_clean;

-- Identifier les doublons de PK (doctor_id) de la table 'doctor' (ok no duplicates)
SELECT
*
FROM (
SELECT
doctor_id,
COUNT(*) OVER (PARTITION BY doctor_id) AS CheckPK
FROM doctor_clean
) t
WHERE CheckPK > 1;


-- Table 'medication' --
-- Create view --
CREATE VIEW mis602_ass2.medication_clean AS
SELECT
medication_id,
name,
manufacturer,
dosage_form,
strength,
description
FROM mis602_ass2.medication;

-- Identifier les Valeurs Nulles + Remplacer les valeurs NULLS de la table 'medication' version CTE --
SELECT
COUNT(*) AS Total_rows,
SUM(CASE WHEN medication_id IS NULL THEN 1 ELSE 0 END) AS null_medication_id,
  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_name,
  SUM(CASE WHEN manufacturer IS NULL THEN 1 ELSE 0 END) AS null_manufacturer,
  SUM(CASE WHEN dosage_form IS NULL THEN 1 ELSE 0 END) AS null_dosage_form,
  SUM(CASE WHEN strength IS NULL THEN 1 ELSE 0 END) AS null_strength,
  SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) AS null_description
  FROM mis602_ass2.medication_clean;

-- Identifier les doublon de PK (medication_id) de la table 'medication' (ok no duplicates)
SELECT
*
FROM (
SELECT
medication_id,
COUNT(*) OVER (PARTITION BY medication_id) AS CheckPK
FROM medication_clean
) t
WHERE CheckPK > 1;



-- Table patient--
-- Creat view table--
CREATE VIEW mis602_ass2.patient_id_clean AS
SELECT
patient_id,
name,
dob,
gender,
phone_number,
address,
state_code
FROM mis602_ass2.patient;

-- Identifier les Valeurs Nulles + Remplacer les valeurs NULLS de la table 'patient' version CTE (ok no Null values)
WITH clean_patient AS (
SELECT
COUNT(*) AS Total_rows,
SUM(CASE WHEN patient_id IS NULL THEN 1 ELSE 0 END) AS null_patient_id
FROM mis602_ass2.doctor_clean
)
SELECT 
*
FROM patient
WHERE patient_id IS NULL
AND name IS NULL
AND dob IS NULL
AND gender IS NULL
AND address IS NULL
AND state_code IS NULL

-- Identifier les doublons de PK (patient_id) de la table 'patient' (ok no duplicates)
SELECT
*
FROM (
SELECT
patient_id,
COUNT(*) OVER (PARTITION BY patient_id) AS CheckPK
FROM patient_id_clean
) t
WHERE CheckPK > 1;


--'Prescription' Table--
--Create view
CREATE VIEW mis602_ass2.prescription_clean AS
SELECT
prescription_id,
appointment_id,
medication_id
FROM mis602_ass2.prescription;

-- Identifier les Valeurs Nulles + Remplacer les valeurs NULLS de la table 'prescription' (ok no null values)
SELECT *
FROM mis602_ass2.prescription_clean
WHERE prescription_id IS NULL
AND appointment_id IS NULL
AND medication_id IS NULL;

-- Identifier les doublons de PK (prescription_id) de la table 'prescription' (ok no duplicates)
SELECT
*
FROM (
SELECT
prescription_id,
COUNT(*) OVER (PARTITION BY prescription_id) AS CheckPK
FROM mis602_ass2.prescription_clean
) t
WHERE CheckPK > 1;

--Table 'speciality'--
--Create View--
CREATE VIEW mis602_ass2.speciality_clean AS
SELECT
speciality_id,
name
FROM mis602_ass2.speciality;

-- Table speciality (ok no NULL values)
SELECT *
FROM mis602_ass2.speciality_clean
WHERE speciality_id IS NULL
AND name IS NULL;

-- Identifier si doublon de PK (speciality_id) de la table 'speciality'
SELECT 
speciality_id,
COUNT(speciality_id) AS Duplicates
FROM mis602_ass2.speciality_clean
GROUP BY speciality_id
HAVING COUNT(speciality_id) > 1;
