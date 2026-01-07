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
