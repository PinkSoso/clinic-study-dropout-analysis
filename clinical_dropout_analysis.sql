-- Global participants dropout --
SELECT 
COUNT(*) AS Total_participants,
SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) AS nb_dropout_participants, -- dropout = 1
ROUND(100*SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),2) As Dropout_rate
FROM clinical_dropout.`clinical_trial_dataset_1000(1)`;

-- Gender and Disease Dropout Analysis --
WITH ranked_dropout AS (
  SELECT
    Gender,
    Health_Condition,
    COUNT(*) AS nb_participants,
    SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) AS nb_dropout,
    ROUND(100.0 * SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Dropout_rate,
    DENSE_RANK() OVER (ORDER BY 
      100.0 * SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) DESC
    ) AS risk_rank
  FROM clinical_dropout.`clinical_trial_dataset_1000(1)`
  GROUP BY Gender, Health_Condition
  HAVING COUNT(*) >= 5
)
SELECT
  risk_rank,
  Gender,
  Health_Condition,
  nb_participants,
  nb_dropout,
  Dropout_rate
FROM ranked_dropout
ORDER BY risk_rank;

WITH ranked_dropout AS (
  SELECT
    Gender,
    FLOOR(Age/10)*10 AS age_group,
    Health_Condition,
    COUNT(*) AS nb_participants,
    SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) AS nb_dropout,
    ROUND(100.0 * SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Dropout_rate,
    DENSE_RANK() OVER (ORDER BY 
      100.0 * SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) DESC
    ) AS risk_rank
  FROM clinical_dropout.`clinical_trial_dataset_1000(1)`
  GROUP BY Gender, FLOOR(Age/10)*10, Health_Condition
  HAVING COUNT(*) >= 5
)
SELECT
  risk_rank,
  Gender,
  age_group,
  Health_Condition,
  nb_participants,
  nb_dropout,
  Dropout_rate
FROM ranked_dropout
ORDER BY risk_rank
LIMIT 5;

-- Dropout Phases Analysis 
-- All participants --
WITH ranked_phases_global AS (
  SELECT
    Trial_Phase,
    COUNT(*) AS nb_participants,
    SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) AS nb_dropout,
    ROUND(100.0 * SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Dropout_rate,
    DENSE_RANK() OVER (ORDER BY 100.0 * SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) DESC) AS risk_rank
  FROM clinical_dropout.`clinical_trial_dataset_1000(1)`
  GROUP BY Trial_Phase
  HAVING COUNT(*) >= 5 -- more reliable after 5 participants
)
SELECT * FROM ranked_phases_global ORDER BY risk_rank;

-- Rank phases per age
WITH phase_ranking AS (
  SELECT
    Trial_Phase,
    Gender,
    FLOOR(Age/10)*10 AS age_group,
    ROUND(100.0 * SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Dropout_rate,
    DENSE_RANK() OVER (PARTITION BY Trial_Phase ORDER BY 100.0 * SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) DESC) AS rank_per_phase
  FROM clinical_dropout.`clinical_trial_dataset_1000(1)`
  WHERE Trial_Phase = 'Phase I' 
    AND Age BETWEEN 20 AND 49
  GROUP BY Trial_Phase, Gender, FLOOR(Age/10)*10
  HAVING COUNT(*) >= 5
)
SELECT * FROM phase_ranking 
WHERE rank_per_phase <= 3
ORDER BY Trial_Phase, rank_per_phase;

-- Zoom in for 20-49 years at phase 1
SELECT 
  'Phase I - 20-49 years' AS target_population,
  COUNT(*) AS total_participants,
  SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) AS total_dropouts,
  ROUND(100.0 * SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS dropout_rate_global
FROM clinical_dropout.`clinical_trial_dataset_1000(1)`
WHERE Trial_Phase = 'Phase I' 
  AND Age BETWEEN 20 AND 49;

-- by gender and age --
WITH ranked_phases AS (
SELECT 
Trial_Phase,
Gender,
FLOOR(Age/10)*10 AS age_group,
COUNT(*) AS nb_participants,
SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) AS nb_dropout,
ROUND(100*SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),2) AS dropout_rate,
DENSE_RANK () OVER (ORDER BY 100*SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) DESC) AS risk_rank
FROM clinical_dropout.`clinical_trial_dataset_1000(1)`
 GROUP BY Trial_Phase, Gender, FLOOR(Age/10)*10
  HAVING COUNT(*) >= 5
)
SELECT * FROM ranked_phases ORDER BY risk_rank
LIMIT 7;

-- TOP 10 risks profils within adherence_score
WITH risk_with_adherence AS (
  SELECT 
    Gender,
    FLOOR(Age/10)*10 AS age_group,
    Health_Condition,
    Trial_Phase,
    AVG(previous_adherence_score) AS Avg_historic_adherence,
    COUNT(*) AS nb_participants,
    SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) AS nb_dropout,
    ROUND(100.0 * SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS dropout_rate,
    
    -- NOUVEAU SCORE COMBINÉ (Random Forest amélioré)
    DENSE_RANK() OVER (ORDER BY (1-AVG(previous_adherence_score))*30 +  -- Mauvaise adhérence passée = +risque
      (SUM(CASE WHEN Dropout_Flag = 'Yes' THEN 1 ELSE 0 END)/COUNT(*))*70 DESC) AS combined_risk_rank -- Dropout actuel
  FROM clinical_dropout.`clinical_trial_dataset_1000(1)`
  GROUP BY Gender, FLOOR(Age/10)*10, Health_Condition, Trial_Phase
  HAVING COUNT(*) >= 5
)
SELECT 
  combined_risk_rank,
  Gender, age_group, Health_Condition, Trial_Phase,
  Avg_historic_adherence,
  dropout_rate,
  CASE 
    WHEN Avg_historic_adherence < 0.3 THEN '🚨 HYPER-RISQUE (mauvaise histoire)'
    WHEN Avg_historic_adherence < 0.6 THEN '⚠️  RISQUE ÉLEVÉ'
    ELSE '✅ RISQUE MODÉRÉ'
  END AS adherence_status
FROM risk_with_adherence
ORDER BY combined_risk_rank
LIMIT 10;