# hr_analytics
Enterprise HR Analytics & Employee Performance Portfolio
An end-to-end data analytics project exploring employee performance, retention drivers, and key workforce metrics across 17,417 employees. This project demonstrates end-to-end implementation across MySQL, Python (EDA & Machine Learning), and an interactive Power BI Dashboard.
Business Problem & Objectives

Human Resources leaders need data-driven insights to improve workforce productivity and employee retention. This project covers six core deliverables:
1. Exploratory Data Analysis (EDA): Identify workforce trends, demographic distributions, and performance outliers.
2. Data Preprocessing: Impute missing values, engineer demographic/tenure bands, and prepare clean tables.
3. Key Metrics Analysis: Evaluate relationships between training scores, KPI attainment, service length, and awards.
4. Retention Trends: Map performance density across education levels, departments, and age groups.
5. Predictive Insights: Build a machine learning classification model to identify drivers of high performance.

Dataset Overview
Records: 17,417 Employees
Features: 13 Attributes (employee_id, department, region, education, gender, recruitment_channel, no_of_trainings, age, previous_year_rating, length_of_service, KPIs_met_more_than_80, awards_won, avg_training_score)

Key SQL Techniques Used
1. Data Cleaning & Normalization: Imputed missing education data using mode replacement and handled null rating values via COALESCE().
2. Feature Engineering: Used CASE WHEN constructs to segment workforce into age_group and tenure_band cohorts.
3. Advanced Aggregations & Window Functions: Employed DENSE_RANK() OVER (...) and CTEs to rank department-level KPI completion rates.

Key Python Analysis & Model Results
1. Exploratory Visualizations: Outlier analysis conducted using Seaborn boxplots across continuous attributes (age, length_of_service, avg_training_score).
2. Machine Learning Pipeline: Implemented a Scikit-Learn RandomForestClassifier pipeline utilizing StandardScaler for numeric values and OneHotEncoder for categorical factors.
3. Top Drivers Identified:
-avg_training_score (Primary driver of KPI success)
-previous_year_rating
-length_of_service

Power BI Dashboard Features
Page 1 — Executive Overview: High-level overview displaying Total Headcount (17.4K), KPI Attainment Rate (35.88%), Average Training Score (63.18), and Award Distribution.
Page 2 — Performance & Retention Matrix: Interactive heatmap mapping High Performer Density across Education vs Age Group.
Page 3 — Department Benchmarking: Decomposition Tree breaking down high-performer concentration across organizational units.

Key Actionable Insights for HR
1. Training Impact: Employees completing focused, high-scoring training modules demonstrate higher KPI attainment than those enrolled in repetitive low-scoring sessions.
2. Tenure Vulnerability: Early tenure employees (0–2 years) experience the highest drop-off in target completion; targeted onboarding programs should be prioritized.
3. Department Variations: Sales & Marketing and Legal show lower overall target completion rates compared to Operations and Analytics.
