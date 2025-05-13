## Datasets

The original dataset was sourced from [Kaggle.com](https://www.kaggle.com/datasets/alexteboul/heart-disease-health-indicators-dataset/data).

- `hdhi_codebook` = the codebook explaining what each variable in the `heart_disease_health_indicators.csv` dataset means
- `hdhi_eda.rda` – Data that was not sampled to be used in the modelling process and therefore can be used for exploratory data analysis (EDA).  
- `hdhi_folds.rda` – Resampling folds used for cross-validation during model training.  
- `hdhi_split.rda` – Data split object containing the training and testing datasets.  
- `hdhi_test.rda` – Testing dataset extracted from the split.  
- `hdhi_train.rda` – Training dataset extracted from the split.  
- `heart_disease_health_indicators.csv` – Original dataset in CSV format containing heart disease health indicators.  
- `heart_disease_health_indicators.rda` – Same dataset saved in RDA format for faster loading in RStudio.  
- `keep_wflow.rda` – Control object used to specify control options for model tuning.  


*Quick reference for `heart_disease_health_indicators`:*
HeartDiseaseorAttack: Indicates if the person has ever had heart disease or a heart attack before in their life.
HighBP : Indicates if the person has been told by a health professional that they have High Blood Pressure.
HighChol : Indicates if the person has been told by a health professional that they have High Blood Cholesterol.
CholCheck : Cholesterol Check, if the person has their cholesterol levels checked within the last 5 years.
Smoker : Indicates if the person has smoked at least 100 cigarettes.
Stroke : Indicates if the person has a history of stroke.
PhysActivity : Indicates if the person has some form of physical activity in their day-to-day routine.
Fruits : Indicates if the person consumes 1 or more fruit(s) daily.
Veggies : Indicates if the person consumes 1 or more vegetable(s) daily.
HvyAlcoholConsump : Indicates if the person has more than 14 drinks per week.
AnyHealthcare : Indicates if the person has any form of health insurance.
NoDocbcCost : Indicates if the person wanted to visit a doctor within the past 1 year but couldn’t, due to cost.
DiffWalk : Indicates if the person has difficulty while walking or climbing stairs.
Sex : Indicates the gender of the person, where 0 is female and 1 is male.
Diabetes : Indicates if the person has a history of diabetes, or currently in pre-diabetes, or suffers from either type of diabetes.
BMI : Body Mass Index, calculated by dividing the persons weight (in kilogram) by the square of their height (in meters).
GenHlth : Indicates the persons response to how well is their general health, ranging from 1 (excellent) to 5 (poor).
Menthlth : Indicates the number of days, within the past 30 days that the person had bad mental health.
PhysHlth : Indicates the number of days, within the past 30 days that the person had bad physical health.
Age : Indicates the age class of the person, where 1 is 18 years to 24 years up till 13 which is 80 years or older, each interval between has a 5-year increment.
Education : Indicates the highest year of school completed, with 0 being never attended or kindergarten only and 6 being, having attended 4 years of college or more.
Income : Indicates the total household income, ranging from 1 (at least $10,000) to 6 ($75,000+)
