🇫🇷 **Français** | [🇬🇧 English](#clinical-trial-dropout-prediction)

# Prédiction de l'abandon dans les essais cliniques

Projet personnel de data science visant à prédire l'abandon (dropout) de participants dans un essai clinique à partir de leurs caractéristiques démographiques et médicales, avec une démarche volontairement rigoureuse sur l'évaluation du modèle plutôt que sur la seule recherche de performance.

## Sommaire

- [Contexte](#contexte)
- [Dataset](#dataset)
- [Méthodologie](#méthodologie)
- [Résultats](#résultats)
- [Conclusion](#conclusion)
- [Limites et perspectives](#limites-et-perspectives)
- [Stack technique](#stack-technique)

## Contexte

L'abandon de participants est un problème coûteux et fréquent dans la conduite d'essais cliniques. L'objectif de ce projet est d'évaluer si un modèle de machine learning simple peut identifier, à partir de données disponibles en amont, les participants les plus à risque d'abandon — dans une logique d'aide à la décision plutôt que de prédiction automatisée.

Au-delà du modèle lui-même, ce projet documente une démarche complète de diagnostic critique : identifier les limites d'un modèle, tester plusieurs pistes de correction, et conclure honnêtement plutôt que de présenter un chiffre de performance flatteur mais trompeur.

## Dataset

Dataset synthétique de 1000 participants, 10 colonnes brutes (23 après encodage) :

| Colonne | Description |
|---|---|
| `Participant_ID` | Identifiant unique |
| `Age` | Âge du participant |
| `Gender` | Genre |
| `Ethnicity` | Origine ethnique |
| `Health_Condition` | Condition de santé principale |
| `Comorbidities` | Comorbidités éventuelles |
| `Previous_Adherence_Score` | Score d'adhérence à un traitement antérieur (0 à 1) |
| `Trial_Phase` | Phase de l'essai (I, II, III) |
| `Dropout_Flag` | Cible — abandon (1) ou non (0) |
| `Dropout_Reason` | Motif de l'abandon, renseigné uniquement si `Dropout_Flag = 1` |

**Répartition de la cible** : 738 non-abandons (73.8 %) / 262 abandons (26.2 %) — un déséquilibre de classes modéré mais réel, central dans les résultats ci-dessous.

## Méthodologie

### 1. Modèle de référence

`RandomForestClassifier` (scikit-learn), entraîné sur un split 90/10 après encodage one-hot des variables catégorielles.

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report

model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)
y_pred = model.predict(X_test)
print(classification_report(y_test, y_pred))
```

**Premier résultat — une accuracy trompeuse :**

| | precision | recall | f1-score | support |
|---|---|---|---|---|
| 0 (pas d'abandon) | 0.75 | 0.96 | 0.84 | 73 |
| 1 (abandon) | 0.20 | 0.04 | 0.06 | 27 |
| **accuracy** | | | **0.70** | 100 |

Une accuracy de 70 % semble correcte, mais elle masque un recall de seulement **4 %** sur la classe qui nous intéresse réellement : sur 27 abandons présents dans le jeu de test, le modèle n'en détecte qu'un seul. Un modèle "paresseux" qui prédirait systématiquement "pas d'abandon" obtiendrait déjà ~74 % d'accuracy — le modèle entraîné ne fait donc quasiment pas mieux qu'une prédiction par défaut.

**Diagnostic : déséquilibre de classes.** Ce piège classique en ML — accuracy globale flatteuse, performance nulle sur la classe minoritaire — est le fil conducteur de la suite de la démarche.

### 2. Tentative de correction — `class_weight="balanced"`

```python
model_balanced = RandomForestClassifier(
    n_estimators=100, random_state=42, class_weight="balanced"
)
model_balanced.fit(X_train, y_train)
```

**Résultat : aucun effet significatif** (recall classe 1 toujours à 0.04). C'est une limite documentée de `class_weight` avec les forêts aléatoires : le rééquilibrage des poids interagit mal avec le bootstrap sampling propre à cet algorithme (contrairement à des modèles comme la régression logistique, où l'effet est généralement net).

### 3. Ajustement du seuil de décision

Plutôt que d'agir sur les poids du modèle, ajustement direct du seuil de classification (par défaut 0.5) :

```python
y_proba = model_balanced.predict_proba(X_test)[:, 1]
y_pred_threshold = (y_proba >= 0.3).astype(int)
print(classification_report(y_test, y_pred_threshold))
```

**Résultat à seuil = 0.3 :** recall classe 1 multiplié par ~5 (0.04 → 0.22), au prix d'une accuracy globale qui chute (0.70 → 0.48) et d'une precision qui reste basse (0.16). Un compromis attendu, pas une amélioration "gratuite" : on déplace le curseur sur la même courbe de compromis precision/recall.

### 4. Courbe precision-recall et évaluation indépendante du seuil

```python
from sklearn.metrics import precision_recall_curve, average_precision_score

precisions, recalls, thresholds = precision_recall_curve(y_test, y_proba)
pr_auc = average_precision_score(y_test, y_proba)
```

La courbe montre un point d'équilibre autour de **seuil ≈ 0.35-0.4** (precision et recall tous deux autour de 0.08-0.15), avec un pic de precision isolé vers 0.59 identifié comme un artefact statistique (trop peu de prédictions à ce seuil pour être fiable) plutôt qu'un vrai optimum.

**PR-AUC obtenu : 0.227**, à comparer à la baseline naïve de 0.262 (la proportion réelle d'abandons). **Le modèle se situe en dessous de cette baseline** — sur une métrique indépendante du seuil choisi, il n'apporte pas de valeur prédictive démontrable.

### 5. Test de profils extrêmes et vérification de représentativité

Pour illustrer concrètement cette limite, comparaison de deux profils fictifs opposés sur les deux variables les plus importantes du modèle (`Age`, `Previous_Adherence_Score`) :

```python
profil_jeune = {"Age": 22, "Previous_Adherence_Score": 0.95, ...}
profil_age   = {"Age": 82, "Previous_Adherence_Score": 0.20, ...}
```

**Résultat :** 29.0 % vs 47.0 % de probabilité d'abandon — un écart de 18 points qui pourrait suggérer, à tort, que le modèle capte un vrai signal.

**Vérification critique :** recherche des participants réels correspondant à ce profil "âgé, faible adhérence" dans le dataset.

```python
proche_profil = df[(df['Age'] >= 75) & (df['Previous_Adherence_Score'] <= 0.3)]
```

**Résultat : un seul participant réel** correspond à ce profil sur 1000 — et celui-ci **n'a pas abandonné** (`Dropout_Flag = 0`), à l'inverse de ce que prédisait le modèle. Ceci confirme que l'écart de prédiction observé résulte d'une extrapolation du modèle sur une zone du dataset extrêmement peu représentée, plutôt que d'un signal généralisable.

## Résultats

| Version | Accuracy | Precision (classe 1) | Recall (classe 1) | F1 Score |
|---|---|---|---|---|
| Référence (seuil 0.5) | 0.70 | 0.20 | 0.04 | 0.06 |
| `class_weight="balanced"` | 0.69 | 0.17 | 0.04 | 0.06 |
| Seuil ajusté à 0.3 | 0.48 | 0.16 | 0.22 | 0.19 |

**PR-AUC (indépendant du seuil) : 0.227** — inférieur à la baseline naïve de 0.262.

## Visualisations

**Répartition réelle des abandons** — pose le contexte du déséquilibre de classes central à toute l'analyse.

![Répartition des abandons](images/dropout_distribution.png)

**Comparaison des matrices de confusion** — visualise où se trompe chaque version du modèle. Les deux premières se ressemblent presque trait pour trait, confirmant que `class_weight="balanced"` n'a eu qu'un effet marginal. La troisième montre le compromis du seuil ajusté : plus de vrais abandons détectés (6 au lieu de 1), au prix de plus de fausses alertes (31 au lieu de 4-5).

![Matrices de confusion](images/confusion_matrices.png)

**Importance des variables** — seules `Age` et `Previous_Adherence_Score` portent un poids réel dans les décisions du modèle ; toutes les autres variables sont quasi à égalité, ce qui confirme la faiblesse et la concentration du signal exploité par le modèle.

![Feature importance](images/feature_importance.png)

## Conclusion

L'analyse menée au-delà de l'accuracy révèle que ce modèle, malgré un score global en apparence correct, **ne dispose pas d'un pouvoir prédictif fiable** sur la classe d'intérêt (l'abandon). Deux pistes de correction ont été testées :
- le rééquilibrage des poids de classes, sans effet mesurable ;
- l'ajustement du seuil de décision, avec un gain réel mais limité sur le recall, au prix d'une perte de precision et d'accuracy globale.

La vérification finale sur des profils extrêmes, confrontée à leur représentativité réelle dans les données, confirme que le modèle **extrapole sur des zones peu peuplées du dataset** plutôt que de capter une relation généralisable entre les caractéristiques des participants et leur probabilité d'abandon.

**Conclusion assumée : sur ce dataset synthétique, la relation entre les variables disponibles et l'abandon est trop faible pour justifier un déploiement prédictif fiable.** Cette conclusion négative est en soi un résultat valide et documenté, plutôt qu'un chiffre de performance présenté hors contexte.

## Limites et perspectives

- **Taille du dataset** : 1000 lignes, dont seulement 262 abandons — un jeu de données plus large permettrait de mieux distinguer signal réel et bruit statistique.
- **Nature synthétique des données** : les relations entre variables et cible peuvent avoir été injectées de façon simplifiée lors de la génération du dataset.
- **Prochaine étape envisagée** : construction d'un dashboard Power BI (modélisation en schéma en étoile, mesures DAX) pour explorer les données de façon descriptive — indépendamment de la limite du modèle prédictif, ce volet reste utile pour l'analyse business et la restitution des tendances par segment (site, phase, condition de santé).
- Techniques non testées ici mais identifiées comme pistes : SMOTE (sur-échantillonnage synthétique de la classe minoritaire), d'autres algorithmes (gradient boosting), ou l'enrichissement du dataset avec des variables supplémentaires.

## Stack technique

- **Python** : pandas, scikit-learn, matplotlib, seaborn
- **Modèle** : RandomForestClassifier
- **Évaluation** : classification_report, precision_recall_curve, average_precision_score
- **Sauvegarde du modèle** : joblib
- **À venir** : Power BI (Power Query, DAX)

## Installation

```bash
pip install -r requirements.txt
```

## Structure du repo

```
├── README.md
├── requirements.txt
├── clinical_trial_dataset.csv
├── notebook.ipynb
└── images/
    ├── dropout_distribution.png
    ├── confusion_matrices.png
    └── feature_importance.png
```

---

[🇫🇷 Français](#prédiction-de-labandon-dans-les-essais-cliniques) | 🇬🇧 **English**

# Clinical Trial Dropout Prediction

Personal data science project predicting participant dropout in a clinical trial based on demographic and medical characteristics, with a deliberately rigorous focus on model evaluation rather than on chasing performance alone.

## Table of contents

- [Context](#context)
- [Dataset](#dataset-1)
- [Methodology](#methodology)
- [Results](#results)
- [Conclusion](#conclusion-1)
- [Limitations and next steps](#limitations-and-next-steps)
- [Tech stack](#tech-stack)

## Context

Participant dropout is a costly and common problem in clinical trial management. This project evaluates whether a simple machine learning model can identify, from data available upfront, the participants most at risk of dropping out — as a decision-support tool rather than an automated prediction system.

Beyond the model itself, this project documents a complete critical-diagnosis process: identifying a model's limitations, testing several correction approaches, and reaching an honest conclusion rather than presenting a flattering but misleading performance figure.

## Dataset

Synthetic dataset of 1,000 participants, 10 raw columns (23 after encoding):

| Column | Description |
|---|---|
| `Participant_ID` | Unique identifier |
| `Age` | Participant's age |
| `Gender` | Gender |
| `Ethnicity` | Ethnic background |
| `Health_Condition` | Primary health condition |
| `Comorbidities` | Any comorbidities |
| `Previous_Adherence_Score` | Adherence score to a prior treatment (0 to 1) |
| `Trial_Phase` | Trial phase (I, II, III) |
| `Dropout_Flag` | Target — dropout (1) or not (0) |
| `Dropout_Reason` | Reason for dropout, only populated when `Dropout_Flag = 1` |

**Target distribution**: 738 non-dropouts (73.8%) / 262 dropouts (26.2%) — a moderate but real class imbalance, central to the results below.

## Methodology

### 1. Baseline model

`RandomForestClassifier` (scikit-learn), trained on a 90/10 split after one-hot encoding of categorical variables.

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report

model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)
y_pred = model.predict(X_test)
print(classification_report(y_test, y_pred))
```

**First result — a misleading accuracy:**

| | precision | recall | f1-score | support |
|---|---|---|---|---|
| 0 (no dropout) | 0.75 | 0.96 | 0.84 | 73 |
| 1 (dropout) | 0.20 | 0.04 | 0.06 | 27 |
| **accuracy** | | | **0.70** | 100 |

A 70% accuracy looks reasonable at first glance, but it hides a recall of only **4%** on the class that actually matters: out of 27 real dropouts in the test set, the model only catches one. A "lazy" model that always predicted "no dropout" would already reach ~74% accuracy — the trained model barely outperforms a default guess.

**Diagnosis: class imbalance.** This classic ML trap — a flattering global accuracy paired with near-zero performance on the minority class — is the thread running through the rest of the process.

### 2. First correction attempt — `class_weight="balanced"`

```python
model_balanced = RandomForestClassifier(
    n_estimators=100, random_state=42, class_weight="balanced"
)
model_balanced.fit(X_train, y_train)
```

**Result: no meaningful effect** (class 1 recall still at 0.04). This is a documented limitation of `class_weight` with random forests: rebalancing interacts poorly with the algorithm's bootstrap sampling (unlike models such as logistic regression, where the effect is usually clear-cut).

### 3. Decision threshold adjustment

Rather than acting on model weights, the classification threshold (default 0.5) was adjusted directly:

```python
y_proba = model_balanced.predict_proba(X_test)[:, 1]
y_pred_threshold = (y_proba >= 0.3).astype(int)
print(classification_report(y_test, y_pred_threshold))
```

**Result at threshold = 0.3:** class 1 recall roughly multiplied by 5 (0.04 → 0.22), at the cost of a drop in overall accuracy (0.70 → 0.48) and precision staying low (0.16). An expected trade-off, not a "free" improvement — this simply moves the operating point along the same precision/recall trade-off curve.

### 4. Precision-recall curve and threshold-independent evaluation

```python
from sklearn.metrics import precision_recall_curve, average_precision_score

precisions, recalls, thresholds = precision_recall_curve(y_test, y_proba)
pr_auc = average_precision_score(y_test, y_proba)
```

The curve shows a balance point around **threshold ≈ 0.35-0.4** (precision and recall both around 0.08-0.15), with an isolated precision spike near 0.59 identified as a statistical artifact (too few predictions at that threshold to be reliable) rather than a genuine optimum.

**PR-AUC obtained: 0.227**, compared to a naive baseline of 0.262 (the actual proportion of dropouts). **The model falls below this baseline** — on a metric independent of the chosen threshold, it does not demonstrate real predictive value.

### 5. Extreme-profile testing and representativeness check

To make this limitation concrete, two opposite fictional profiles were compared on the model's two most important variables (`Age`, `Previous_Adherence_Score`):

```python
young_profile = {"Age": 22, "Previous_Adherence_Score": 0.95, ...}
older_profile = {"Age": 82, "Previous_Adherence_Score": 0.20, ...}
```

**Result:** 29.0% vs 47.0% dropout probability — an 18-point gap that might wrongly suggest the model is picking up on a real signal.

**Critical check:** searching for real participants matching this "older, low adherence" profile in the dataset.

```python
similar_profile = df[(df['Age'] >= 75) & (df['Previous_Adherence_Score'] <= 0.3)]
```

**Result: only one real participant** matches this profile out of 1,000 — and that participant **did not drop out** (`Dropout_Flag = 0`), contradicting the model's prediction. This confirms that the observed prediction gap results from the model extrapolating over an extremely underrepresented region of the dataset, rather than capturing a generalizable signal.

## Results

| Version | Accuracy | Precision (class 1) | Recall (class 1) | F1 Score |
|---|---|---|---|---|
| Baseline (threshold 0.5) | 0.70 | 0.20 | 0.04 | 0.06 |
| `class_weight="balanced"` | 0.69 | 0.17 | 0.04 | 0.06 |
| Threshold adjusted to 0.3 | 0.48 | 0.16 | 0.22 | 0.19 |

**PR-AUC (threshold-independent): 0.227** — below the naive baseline of 0.262.

## Visualizations

**Actual dropout distribution** — sets the context of the class imbalance central to the whole analysis.

![Dropout distribution](images/dropout_distribution.png)

**Confusion matrix comparison** — shows where each model version makes mistakes. The first two are nearly identical, confirming that `class_weight="balanced"` had only a marginal effect. The third shows the threshold trade-off: more true dropouts caught (6 instead of 1), at the cost of more false alarms (31 instead of 4-5).

![Confusion matrices](images/confusion_matrices.png)

**Feature importance** — only `Age` and `Previous_Adherence_Score` carry real weight in the model's decisions; all other variables are roughly tied, confirming how weak and concentrated the signal the model relies on actually is.

![Feature importance](images/feature_importance.png)

## Conclusion

Looking beyond accuracy reveals that this model, despite an apparently decent overall score, **does not have reliable predictive power** on the class of interest (dropout). Two correction approaches were tested:
- class weight rebalancing, with no measurable effect;
- decision threshold adjustment, with a real but limited gain in recall, at the cost of lower precision and overall accuracy.

The final check on extreme profiles, confronted with their actual representativeness in the data, confirms that the model **extrapolates over sparsely populated regions of the dataset** rather than capturing a generalizable relationship between participant characteristics and dropout probability.

**Bottom line: on this synthetic dataset, the relationship between the available variables and dropout is too weak to justify a reliable predictive deployment.** This negative conclusion is, in itself, a valid and well-documented result — rather than a performance figure presented out of context.

## Limitations and next steps

- **Dataset size**: 1,000 rows, only 262 dropouts — a larger dataset would help better distinguish real signal from statistical noise.
- **Synthetic nature of the data**: the relationships between variables and the target may have been injected in a simplified way when the dataset was generated.
- **Planned next step**: building a Power BI dashboard (star schema modeling, DAX measures) for descriptive data exploration — independent of the predictive model's limitations, this remains useful for business analysis and reporting trends by segment (site, phase, health condition).
- Techniques not tested here but identified as potential next steps: SMOTE (synthetic minority oversampling), other algorithms (gradient boosting), or enriching the dataset with additional variables.

## Tech stack

- **Python**: pandas, scikit-learn, matplotlib, seaborn
- **Model**: RandomForestClassifier
- **Evaluation**: classification_report, precision_recall_curve, average_precision_score
- **Model persistence**: joblib
- **Coming up**: Power BI (Power Query, DAX)

## Installation

```bash
pip install -r requirements.txt
```

## Repo structure

```
├── README.md
├── requirements.txt
├── clinical_trial_dataset.csv
├── notebook.ipynb
└── images/
    ├── dropout_distribution.png
    ├── confusion_matrices.png
    └── feature_importance.png
```
