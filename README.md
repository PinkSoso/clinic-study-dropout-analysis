# 🧪 Analyse du taux d'abandon au sein des essais cliniques
Exploiter la data & l’IA pour réduire l’abandon des participants – Industrie de la santé

## 📘 Préambule

Problème métier : Pourquoi les patients abandonnent-ils les essais, et comment réduire ce taux de dropout ?

Rôle : Data Analyst

Outils : SQL + Python + Power BI
   
Objectifs :
       Comprendre où, quand et pourquoi les patients quittent l’étude, Identifier les profils à risque et les signaux d’alerte et proposer des actions concrètes pour améliorer la rétention.

Résultats clés :
        Identification des phases les plus critiques en termes d’abandon
        Mise en évidence de profils et comportements à haut risque
        Modèle prédictif (Random Forest, ~70% de précision) pour anticiper le risque de dropout
        Recommandations data-driven pour améliorer la rétention et la fiabilité des essais

## 📘 Résumé

Dans ce projet, j’ai analysé des données d’essais cliniques à l’aide de **SQL, Python et Power BI** pour comprendre et réduire les taux d’abandon des participants, un enjeu majeur en recherche clinique.
J’ai construit une pipeline analytique de bout en bout :

  extraction et structuration des données d’essais sous SQL,
  exploration des comportements des participants et des patterns de dropout sous Python,
  conception de dashboards Power BI pour suivre les indicateurs clés d’abandon.

L’analyse a permis d’identifier des moments critiques dans le parcours, des profils à risque, ainsi que des variables d’engagement déterminantes. Sur cette base, j’ai formulé des recommandations opérationnelles et des pistes d’amélioration supportées par l’IA, pour aider les équipes cliniques à anticiper le risque de dropout et à optimiser le design et le pilotage des essais.

## 🎯 Problème métier

Les essais cliniques sont une étape essentielle dans le développement de nouveaux traitements, mais ils sont fortement pénalisés par les abandons de participants. Un taux de dropout élevé entraîne :

des retards dans les calendriers d’étude,
une augmentation des coûts opérationnels et de recrutement,
une baisse de la puissance statistique et de la fiabilité des résultats,
un accès plus lent aux traitements pour les patients.

L’objectif du projet est de soutenir les équipes de recherche clinique en utilisant la data et l’IA pour :

   comprendre quand et pourquoi les participants abandonnent,
   détecter les signaux précoces d’un risque de dropout,
   permettre des interventions proactives pour améliorer la rétention.

Le projet cherche ainsi à transformer le dropout :

   d’un risque subi et réactif,
   en un risque métier piloté grâce aux données.

Questions clés adressées :

   Compréhension du dropout
        À quelles étapes du protocole les abandons sont-ils les plus fréquents ?
        Quels sont les facteurs principaux (comportement, santé, design de l’essai) associés à ces abandons ?
    
   Identification des profils à risque
        Quels profils démographiques ou comportementaux présentent des taux d’abandon plus élevés ?
        Peut-on segmenter les participants en profils de risque pour mieux cibler les efforts de rétention ?

   Prédiction & prévention
      Peut-on utiliser des modèles prédictifs pour anticiper le risque de dropout en cours d’essai ?
      À quel moment du parcours peut-on détecter ce risque suffisamment tôt pour agir ?

   Interventions actionnables
      Quelles actions (communication, suivi, ajustement du protocole, incitations) peuvent réduire le dropout ?
      Comment les insights data peuvent-ils guider une allocation plus efficace des ressources et améliorer le taux de complétion des essais ?

## 🧠 Approche analytique & méthodologie
🔄 Workflow du projet

    Compréhension métier

        Définition du dropout dans le contexte clinique (participant qui ne va pas au terme de l’essai).

        Formalisation des questions avec un angle business : impact sur coûts, délais, qualité scientifique.

    Extraction & nettoyage (SQL)

        Extraction de données à partir de plusieurs tables relationnelles (patients, visites, traitements, centres, événements).

        Jointures, CTE, agrégations pour reconstruire un dataset patient-level.

        Gestion des valeurs manquantes, des statuts incohérents et des doublons pour fiabiliser les indicateurs.

    Analyse exploratoire & modélisation (Python)

        Analyses exploratoires des taux de dropout par phase, par centre, par profil patient (Pandas, Matplotlib, Seaborn).

        Création de nouvelles features (adhérence, fréquence de visites, variables de santé).

        Entraînement d’un modèle de classification (Random Forest – Scikit-learn) pour prédire le risque de dropout.

    Business Intelligence & data storytelling (Power BI)

        Construction d’un dashboard pour suivre les KPI de dropout : taux par phase, par centre, par segment, évolution temporelle.

        Mise à disposition d’une vue opérationnelle pour les équipes cliniques afin de monitorer la rétention et prioriser les actions.

🧰 Compétences mobilisées

    SQL : CTE, jointures, agrégations, nettoyage et préparation de données sur plusieurs tables.

    Power BI : DAX, colonnes calculées, ETL, modélisation de données, visualisation orientée décision.

    Python : Pandas, NumPy, Matplotlib, Seaborn, Scikit-learn, statistiques descriptives et modélisation.

    Soft skills : formulation de problématiques métier, vulgarisation des résultats, recommandations actionnables.

🗂️ Résultats & recommandations métier

    Le modèle prédictif (Random Forest) a permis d’analyser plus de 1 000 enregistrements d’essais cliniques pour identifier les facteurs influençant le dropout.

    Le modèle atteint environ 70% de précision globale, avec de bonnes performances sur les participants non dropouts, mais une sensibilité faible (~4%) sur les cas de dropout, en raison d’un fort déséquilibre de classes et d’un signal limité côté abandon.
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

        rééquilibrant les classes (oversampling/undersampling, class weights),

        enrichissant les variables de comportement et de contexte (communication, logistique, historique médical).

    Intégrer le scoring de risque dans un outil opérationnel utilisé par les équipes terrain.

    Tester différentes stratégies d’intervention et mesurer leur impact sur la rétention dans le temps.

