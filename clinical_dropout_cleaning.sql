-- PARTIE 1 : NETTOYAGE DES DATAS / DATA CLEANING --

-- Table 'Appointment'
-- Identifier les NULLS/ Valeurs Manquantes/ Chaînes Vides/ Espace (OK)
SELECT
COUNT(*) AS Total_rows,
SUM(CASE WHEN appointment_id IS NULL THEN 1 ELSE 0 END) AS null_appointment_id,
  SUM(CASE WHEN patient_id IS NULL THEN 1 ELSE 0 END) AS null_patient_id,
  SUM(CASE WHEN doctor_id IS NULL THEN 1 ELSE 0 END) AS null_doctor_id,
  SUM(CASE WHEN appointment_date IS NULL THEN 1 ELSE 0 END) AS null_appointment_date,
  SUM(CASE WHEN notes IS NULL THEN 1 ELSE 0 END) AS null_notes,
  SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS null_status
  FROM appointment_clean;

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

-- Table Doctor --
-- Identifier les Valeurs Nulles + Remplacer les valeurs NULLS de la table 'doctor' (CTE NE MARCHE PAS 1er pavé NON CONCLUANT)
WITH clean_doctor_report AS (
SELECT
COUNT(*) AS Total_rows,
SUM(CASE WHEN doctor_id IS NULL THEN 1 ELSE 0 END) AS null_doctor_id,
  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_name,
  SUM(CASE WHEN phone_number IS NULL THEN 1 ELSE 0 END) AS null_phone_number,
  SUM(CASE WHEN speciality_id IS NULL THEN 1 ELSE 0 END) AS null_speciality_id
  FROM doctor_clean
  )
SELECT
doctor_id,
name,
phone_number,
speciality_id,
COALESCE(speciality_id, 0) AS clean_speciality_id
FROM doctor_clean;

-- Table medication (ok aucun NULL trouvé)
SELECT
COUNT(*) AS Total_rows,
SUM(CASE WHEN medication_id IS NULL THEN 1 ELSE 0 END) AS null_medication_id,
  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_name,
  SUM(CASE WHEN manufacturer IS NULL THEN 1 ELSE 0 END) AS null_manufacturer,
  SUM(CASE WHEN dosage_form IS NULL THEN 1 ELSE 0 END) AS null_dosage_form,
  SUM(CASE WHEN strength IS NULL THEN 1 ELSE 0 END) AS null_strength,
  SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) AS null_description
  FROM medication_clean;

-- Table patient (Next)
SELECT
COUNT(*) AS Total_rows,
SUM(CASE WHEN patient_id IS NULL THEN 1 ELSE 0 END) AS null_patient_id;


SELECT 
*
FROM patient
WHERE patient_id IS NULL
AND name IS NULL
AND dob IS NULL
AND gender IS NULL
AND address IS NULL
AND state_code IS NULL;

-- Table prescription
SELECT *
FROM prescription
WHERE prescription_id IS NULL
AND appointment_id IS NULL
AND medication_id IS NULL;

-- Table speciality
SELECT *
FROM speciality
WHERE speciality_id IS NULL
AND name IS NULL;

-- Compter le nombre de ligne avec Espace ou des valeurs NULL dans la table 'appointment' colonne 'status' (OK)
SELECT
COUNT(*) AS total_rows,
SUM(CASE 
WHEN status IS NOT NULL AND (status = '' OR NULLIF(TRIM(status), '') IS NULL) THEN 1 ELSE 0 END) AS empty_only,
SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS Null_Value
FROM appointment_clean;

-- Création d'une copie de la table pour une table plus clean, modifiable et d'ajout de colonne (OK)
CREATE VIEW mis602_ass2.appointment_clean AS
SELECT
appointment_id,
patient_id,
doctor_id,
appointment_date,
notes,
status,
COALESCE(status, 'unknown') AS clean_status
FROM mis602_ass2.appointment_clean;


CREATE VIEW mis602_ass2.medication_clean AS
SELECT
medication_id,
name,
manufacturer,
dosage_form,
strength,
description
FROM mis602_ass2.medication;

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

CREATE VIEW mis602_ass2.prescription_clean AS
SELECT
prescription_id,
appointment_id,
medication_id
FROM mis602_ass2.prescription;

CREATE VIEW mis602_ass2.speciality_clean AS
SELECT
speciality_id,
name
FROM mis602_ass2.speciality;

-- Nettoyer la table Doctor et remplacer les valeurs NULLs par une valeur 'Unknown'
SELECT 
  *,
  CASE 
    WHEN status IS NULL OR status = '' OR NULLIF(TRIM(doctor_id), '') IS NULL 
    THEN 'UNKNOWN'
    ELSE UPPER(TRIM(speciality_id))
  END AS clean_speciality_id
  FROM doctor_clean;

-- Identifier dans la PK (appointment_id) de la table 'appointment' des doublons (ok no duplicates)
SELECT
*
FROM
(SELECT
appointment_id,
COUNT(*) OVER (PARTITION BY appointment_id) AS CheckPK
FROM mis602_ass2.appointment_clean
) t 
WHERE CheckPK > 1;

-- Identifier si doublon de PK (speciality_id) de la table 'speciality' (ok no duplicates)
SELECT 
speciality_id,
COUNT(speciality_id) AS Duplicates
FROM speciality
GROUP BY speciality_id
HAVING COUNT(speciality_id) > 1;

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

-- Identifier les doublons de PK (prescription_id) de la table 'prescription' (ok no duplicates)
SELECT
*
FROM (
SELECT
prescription_id,
COUNT(*) OVER (PARTITION BY prescription_id) AS CheckPK
FROM prescription_clean
) t
WHERE CheckPK > 1;

-- Remplacer les valeurs NULLS de la table 'appointment' concernant la colonne 'status' (OK)
SELECT
status,
COALESCE(status, 'unknown') AS clean_status
FROM mis602_ass2.appointment_clean;

-- Remplacer les valeurs NULLS de la table '' concernant la colonne '' (OK)

-- PARTIE 2 : ANALYSE DES DATAS --

-- Compter le nombre unique de patients, de docteurs et de status (OK)
SELECT 
  COUNT(DISTINCT patient_id) AS unique_patients,
  COUNT(DISTINCT doctor_id) AS unique_doctors,
  COUNT(DISTINCT status) AS unique_status,
  COUNT(*) AS total_appointments
FROM appointment_clean;

-- Compter le total des 'completed' en clean_status (KO) 
SELECT
clean_status,
patient_id,
COUNT(DISTINCT(clean_status)) OVER (PARTITION BY patient_id) AS total_status
FROM mis602_ass2.appointment_clean
WHERE clean_status = 'completed';

-- Decompter le nombre de clean_status 'unkown', 'completed' et 'cancelled' par patient (OK)
WITH clean_status_total AS
(
SELECT
clean_status,
count(*) AS Total_status
FROM appointment_clean
GROUP BY clean_status
ORDER BY clean_status DESC
)
SELECT
patient_id,
COUNT(*) OVER (PARTITION BY patient_id) AS Total_status_per_client
FROM appointment_clean
ORDER BY Patient_id DESC;

SELECT
patient_id,
clean_status,
COUNT(*) OVER (PARTITION BY patient_id) AS total_per_patient
FROM appointment_clean
GROUP by patient_id, clean_status
ORDER BY patient_id ASC;

-- Isoler les patients qui ont des doublons de status (OK)
WITH patient_clean_status_duplicates AS
(
SELECT
patient_id,
clean_status,
COUNT(*) OVER (PARTITION BY patient_id) AS total_per_patient
FROM appointment_clean
GROUP by patient_id, clean_status
ORDER BY patient_id ASC
)
SELECT 
patient_id,
clean_status,
total_per_patient
FROM patient_clean_status_duplicates
WHERE total_per_patient >= 2
ORDER BY patient_id;
-- on peut voir que 5 patient on des doublons de status ce qui va interefere dans nos résultats 

-- Comptabiliser le nombre d'appointment_id par patient (OK)
WITH patient_appointments_duplicates AS
(
SELECT
patient_id,
appointment_id,
COUNT(*) OVER (PARTITION BY patient_id) AS total_appointment_per_patient
FROM appointment_clean
GROUP by patient_id, appointment_id
ORDER BY patient_id ASC
)
SELECT 
patient_id,
appointment_id,
total_appointment_per_patient
FROM patient_appointments_duplicates
WHERE total_appointment_per_patient >= 2
ORDER BY patient_id;

-- PARTIE 2: ANALYSE/ANALISIS--

CREATE VIEW `mis602_ass2`.v_patient_last_status AS
SELECT
  a.patient_id,
  MAX(a.appointment_date) AS last_appointment_date,
  -- statut du dernier rendez-vous (window function)
  SUBSTRING_INDEX(
    SUBSTRING_INDEX(
      GROUP_CONCAT(a.clean_status ORDER BY a.appointment_date DESC),
      ',', 1
    ),
    ',', -1
  ) AS last_clean_status
FROM appointment_clean a
GROUP BY a.patient_id;