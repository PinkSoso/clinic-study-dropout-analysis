# 🧪 Analyse du taux d'abandon au sein des essais cliniques
Exploiter la data & l’IA pour réduire l’abandon des participants lors de tests cliniques – Industrie de la santé

## 📘 Résumé

Les équipes de recherche clinique font souvent face à des patients abandonnant leur essais cliniques en cours de route ce qui a une forte répercussion sur les résultats de ces essais. Pour comprendre la tendance et l'éviter j'ai donc  utilisé la data et l’IA pour comprendre pourquoi ils quittaient l’étude et comment les garder jusqu’au bout de celle-ci. Je vise ainsi à faire passer le dropout d’un aléa subi à un risque anticipé et maîtrisé grâce à l’exploitation des donnée pour les équipes de recherche.

**Problème métier : Pourquoi les patients abandonnent-ils les essais en cours, et comment réduire ce taux de dropout ?**

Outils & Compétences utilisées :                                                    
*SQL : CTE, jointures, agrégations, windows functions, nettoyage et préparation de données sur plusieurs tables.      
Power BI : DAX, colonnes calculées, ETL, modélisation de données, visualisation orientée décision.                                                                                                                            
Python : Pandas, NumPy, Matplotlib, Seaborn, Scikit-learn, statistiques descriptives et modélisation.                                                   
Soft skills : formulation de problématiques métier, vulgarisation des résultats & recommandations actionnables.*
   
Objectifs :              
- Comprendre où, quand et pourquoi les patients quittent l’étude en cours,
- Identifier les profils à risque et les signaux d’alerte,
- Anticiper le risque de dropout à l'avenir et                                              
- Proposer des actions concrètes pour améliorer la rétention des patients.

Résultats clés : 

        1. Taux de drop out sur 1000 patients dans l'essai => **26,20%**
   
        2. Mise en évidence de profils et comportements à haut risque => **Le genre masculin tranche d'âge 60 - 69 ans souffrant d'Asthme predomine à 66,67% de dropout en phase 2** 
        
        3. Identification des phases les plus critiques en termes d’abandon =>  **26,69% en phase 1 de l'essai clinique concernant tous les partipants, prédominance sur les 20-49 ans avec 30,52% de drop out en Phase 1**             
        4. Modèle prédictif (Random Forest, ~70% de précision) pour anticiper le risque de dropout => **prédiction en fonction de l'adherence_scoring le genre féminin âgé de 20-29 ans sans souci de santé est plus a risque modéré de drop out à 80% en phase 3** 
        
        5. Recommandations data-driven pour améliorer la rétention et la fiabilité des essais => suivi infirmier/médecin, rappel 2 jours avant pour le RDV, coordination des RDV.

## 🔍 Explication du Projet

Dans ce projet, j’ai analysée des données d’essais cliniques à l’aide de **SQL, Python et Power BI** pour comprendre et réduire les taux d’abandon des participants en cours d'essais cliniques, un enjeu majeur dans la recherche en milieu clinique.
Pour cela, j’ai construit une pipeline analytique de bout en bout :

  - Extraction et structuration des données d’essais sous *SQL*                                              
  - Exploration des comportements des participants et des patterns de dropout sous *Python*,  
  - Conception de dashboards *Power BI* pour suivre les indicateurs clés d’abandon.

Mon analyse a alors permis d’identifier des moments critiques dans le parcours, des profils à risque, ainsi que des variables d’engagement déterminantes. Sur cette base, j’ai formulé des recommandations opérationnelles et des pistes d’amélioration supportées par l’IA, pour aider les équipes cliniques à anticiper le risque de dropout et à optimiser le pilotage des essais.

## 🎯 Problème métier

Grâce aux multiples échanges avec les experts cliniques, j'ai compris que les essais sont une étape essentielle dans le développement de nouveaux traitements, mais ils sont également fortement pénalisés par les abandons de participants. Ma comprehension du problème m'amène a penser qu'un taux de dropout élevé entraîne donc :

- des retards dans les calendriers d’étude,
- une augmentation des coûts opérationnels et de recrutement,
- une baisse de la fiabilité des résultats,
- un accès plus lent aux traitements pour les patients.

**L’objectif de mon projet ici est de soutenir les équipes clinique en utilisant mon expertise en data et IA afin de :**   
**1. comprendre quand et pourquoi les participants abandonnent ?**   
**2. détecter les signaux précoces d’un risque de dropout**
**3. et enfin permettre des interventions proactives pour améliorer la rétention par la suite.**

**Je cherche ainsi à transformer le dropout d’un risque subi et réactif en un risque piloté et maitrisé grâce aux données.**

Cela m'amène donc à la refléxion suivante quant aux questions clés que je me suis posé en tant que Data Analyst concernant:

   **1 - La compréhension du dropout :**
      *À quelles étapes du protocole les abandons sont-ils les plus fréquents ?
      Quels sont les facteurs principaux (comportement, santé...) associés à ces abandons ?*
    
   **2- L'identification des profils à risque :**
      *Quels profils démographiques ou comportementaux présentent des taux d’abandon plus élevés ?
      Peut-on segmenter les participants en profils de risque pour mieux cibler les efforts de rétention ?*

   **3 - La prédiction & la prévention :**
      *Peut-on utiliser des modèles prédictifs pour anticiper le risque de dropout en cours d’essai ?
      À quel moment du parcours peut-on détecter ce risque suffisamment tôt pour agir ?*

   **4- Les interventions possible :**
      *Quelles actions (communication, suivi, ajustement du protocole, incitations) peuvent réduire le dropout ?
      Comment les insights data peuvent-ils guider une allocation plus efficace des ressources et améliorer le taux de complétion des essais ?*

## 🧠 Mon approche analytique & méthodologique
🔄 Workflow du projet

La compréhension de la problématique est hyper importante en tant que data Analyst afin de ne pas s'égarer au cours de route et approvisionner les bons KPI par la suite. J'ai donc tout simplement definis avec les experts métiers ce qu'ils appellent un "abandons" dans leur jargon aun sein d'un contexte clinique et il s'avère que la définition est la suivante :
  *"Tout participant qui ne va pas jusqu'au bout de l'essai clinique"*.

  Une fois cette definition établis je peux ensuite passer aux étapes plus techniques :
  
   - Extraction & nettoyage (SQL) des données

     Extraction de données à partir de plusieurs tables relationnelles (patients, visites, traitements, centres, événements).
     Jointures, CTE, agrégations, Windows functions pour reconstruire un dataset patient propres.
     Gestion des valeurs manquantes, des statuts incohérents et des doublons pour fiabiliser les indicateurs.

   - Analyse exploratoire & modélisation (Python)

     Analyses exploratoires des taux de dropout par phase, par centre, par profil patient (Pandas, Matplotlib, Seaborn).
     Création de nouvelles features (adhérence, fréquence de visites, variables de santé).
     Entraînement d’un modèle de classification (Random Forest – Scikit-learn - Pandas) pour prédire le risque de dropout.

   - Business Intelligence (Power BI)

     Construction d’un dashboard pour suivre les KPI de dropout : taux par phase, par centre, par segment, évolution temporelle.
     Mise à disposition d’une vue opérationnelle pour les équipes cliniques afin de monitorer la rétention et prioriser les actions.

🧰 Compétences mobilisées

*SQL : CTE, jointures, agrégations, Windows functions, nettoyage et préparation de données sur plusieurs tables.      
Power BI : DAX, colonnes calculées, ETL, modélisation de données, visualisation orientée décision.                                                                                                                            
Python : Pandas, NumPy, Matplotlib, Seaborn, Scikit-learn, statistiques descriptives et modélisation.                                                   
Soft skills : formulation de problématiques métier, vulgarisation des résultats & recommandations actionnables.*

🗂️ Résultats & recommandations métier

   Le modèle prédictif (Random Forest) a permis d’analyser plus de 1 000 enregistrements d’essais cliniques pour identifier les facteurs influençant le dropout.
    
   Le modèle atteint environ 73% de précision globale, avec de bonnes performances sur les participants non dropouts, mais une sensibilité faible (~26%) sur les cas de dropout, en raison d’un fort déséquilibre de classes et d’un signal limité côté abandon.
    <img width="469" height="437" alt="image" src="https://github.com/user-attachments/assets/205765d5-a12e-4839-bd3e-12f3ce6f0553" />

   Les analyses exploratoires montrent que des variables d’engagement (adhérence aux visites, fréquence des rendez-vous, certains indicateurs de santé et la phase de l’essai) sont parmi les prédicteurs les plus influents de la rétention.
    <img width="919" height="527" alt="image" src="https://github.com/user-attachments/assets/0fc426a4-f2db-446b-8a16-97c46f7127c3" />

   La distribution très déséquilibrée du dropout (majorité de participants restant dans l’essai) explique en partie la difficulté du modèle à bien capter les abandons, et ouvre des pistes d’amélioration (rééchantillonnage, features additionnelles).

💡 Recommandations concrètes pour les équipes cliniques

   Détection précoce du risque
   Utiliser le modèle et les features d’adhérence pour flagger les participants à risque en amont et déclencher des actions ciblées (appels, rappels, accompagnement).

   Renforcement de l’engagement
   Prioriser le suivi des patients avec faible adhérence ou irrégularité dans les visites, par exemple via des contacts plus fréquents ou des supports pédagogiques supplémentaires.

   Optimisation du design d’essai
   Réexaminer les phases où le taux d’abandon est le plus élevé pour simplifier les procédures ou adapter le protocole (fréquence des visites, charges pour le patient).

   Pilotage continu via BI
   Intégrer le dashboard Power BI dans les comités de suivi d’essais pour suivre en continu les KPI de dropout, comparer les sites/centres, et ajuster la stratégie de rétention en temps réel.

📊 Next Steps

   Améliorer la performance du modèle de prédiction en :

   rééquilibrant les classes (oversampling/undersampling, class weights), enrichissant les variables de comportement et de contexte (communication, logistique, historique médical).
   Intégrer le scoring de risque dans un outil opérationnel utilisé par les équipes terrain.
   Tester différentes stratégies d’intervention et mesurer leur impact sur la rétention dans le temps.




# 🧪 Clinical Trial Dropout Analysis
Leveraging Data & AI to Improve Participant Retention - Healthcare Industry

## 📘 Executive Summary

In this project, I analyzed clinical trial participant data using **SQL, Python and Power BI** to understand and reduce participant dropout rates, a major challenge in clinical research.
I built an end-to-end analysis pipeline:

1. Extracted and structured trial data using **SQL**,
2. Explored participant behavior and dropout patterns using **Python**,
3. Designed interactive dashboards in **Power BI** to monitor key dropout indicators.

The analysis revealed critical dropout points during the trial lifecycle and identified high-risk participant profiles.
Based on these insights, I proposed data-driven and AI-supported recommendations to improve participant engagement and reduce attrition, ultimately leading to faster, more reliable and cost-effective clinical trials.

## 🎯 Business Problem
Clinical trials are a crucial step in the development of new drugs and medical treatments. However, one of the most significant challenges faced by researchers is the **high dropout rate** of participants before trial completion. This not only **delays research timelines**, but also **increases costs** and reduces the reliability of results.
High dropout rates is a real problem as it lead to : Delayed trial timelines, Increased operational and recruitment costs, Reduced statistical reliability of trial outcomes, Slower access to life-saving treatments.

The aim here is to support clinical research teams by using data and AI to:
- Understand when and why participants drop out,
- Detect early warning signals of dropout,
- Enable proactive interventions to improve retention.

Despite the strategic importance of clinical trials, participant dropout remains one of the main causes of delays, cost overruns, and unreliable outcomes.
However, dropout is often treated as an unavoidable risk rather than a data-driven problem that can be anticipated and mitigated.

This project aims to transform dropout from a reactive issue into a proactively managed business risk by answering the following key questions:

1. Understanding the dropout problem
At which stages of a clinical trial do participants most frequently drop out, and what are the underlying drivers of these dropouts?
Which behavioral or engagement signals act as early warning indicators of disengagement before a participant leaves the trial?

2. Identifying high-risk profiles
Are there identifiable demographic or behavioral patterns associated with higher dropout rates?
Can participants be segmented into risk profiles to better prioritize retention efforts?

3. Predicting and preventing dropout
Can we leverage predictive analytics and machine learning to flag participants at high risk of dropout early in the trial lifecycle?
How early can risk be detected while still allowing meaningful intervention?

4. Driving actionable interventions
Which targeted interventions (communication, follow-ups, incentives, trial design adjustments) are most effective in reducing dropout rates?
How can data-driven insights help clinical teams allocate resources more efficiently and improve trial completion rates?

## 🧠 Analytical Approach & Methodology
- Wrote **SQL** queries to extract, clean, and transform raw data from the clinical database for comprehensive dropout analysis.​
- Built a **Power BI** dashboard to monitor patient appointments and dropout rates across key stages of the clinical journey, helping to pinpoint where and when patients are most likely to discontinue treatment.
- Conducted in-depth dropout analysis using **Python** (Pandas, Matplotlib, Seaborn, Scikit-learn) to identify risk factors, simulate improvement scenarios, and prioritize high-impact intervention areas​
- Leveraged **GitHub** for code versioning, project documentation, and seamless collaboration throughout the case study

 ## 📌 Skills
  - **SQL** : CTEs, Joins, Aggregate functions
  - **Power BI** : Dax, Writing Functions, ETL, Caluclated Columns, Data Visualization, Data Modelling
  - **Python** : Pandas, Matlplotlib, Numpy, Writing Functions, Statistics
 
## 🗂️ Results & Business Recommendation
The predictive model successfully processed and analyzed over 1,000 clinical trial records to identify key factors influencing participant dropout. Using a Random Forest Classifier, the model achieved an overall accuracy of 70%, with strong recall for non-dropout participants but limited sensitivity (4%) for actual dropouts — indicating a need for better data balance or feature signal improvement.

Exploratory analyses highlighted that participant engagement variables (such as adherence scores, health condition, and trial phase) were among the most influential predictors of retention. The class imbalance visualized through the dropout distribution pie chart confirmed that most participants remained in trials, further explaining the low recall for dropout cases.
<img width="469" height="437" alt="image" src="https://github.com/user-attachments/assets/205765d5-a12e-4839-bd3e-12f3ce6f0553" />

The feature importance chart revealed that previous adherence, visit frequency, and health-related variables had the highest contribution to prediction, providing actionable insights for clinical teams.
<img width="919" height="527" alt="image" src="https://github.com/user-attachments/assets/0fc426a4-f2db-446b-8a16-97c46f7127c3" />

## 📊 Next Steps

1. Train a **machine learning model** to predict dropout risk.
2. Present findings with key takeaways and retention strategies.
