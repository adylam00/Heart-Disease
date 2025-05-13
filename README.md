# **Summary of Heart Disease Predictive Modeling with R**  

This repo was created by Ady Lam in February 2025 for her final project, including project memos, final report and suppporting code. The objective of this final project was to properly develop a predictive model for heart disease using supervised learning methods.

---

## **📂 Repository Contents**  

### **🔹 Data**
A folder containing the Heart Disease or Attack dataset and its various resulting forms, including:

- `hdhi_codebook` = the codebook explaining what each variable in the `heart_disease_health_indicators.csv` dataset means
- `hdhi_eda.rda` – Data that was not sampled to be used in the modelling process and therefore can be used for exploratory data analysis (EDA).  
- `hdhi_folds.rda` – Resampling folds used for cross-validation during model training.  
- `hdhi_split.rda` – Data split object containing the training and testing datasets.  
- `hdhi_test.rda` – Testing dataset extracted from the split.  
- `hdhi_train.rda` – Training dataset extracted from the split.  
- `heart_disease_health_indicators.csv` – Original dataset in CSV format containing heart disease health indicators.  
- `heart_disease_health_indicators.rda` – Same dataset saved in RDA format for faster loading in RStudio.  
- `keep_wflow.rda` – Control object used to specify control options for model tuning.  

---

### **🔹 Figures**
A folder containing relevant figures including autoplots for tunable models, interaction EDAs, and data check tables:

- `bt_autoplot.jpg` – Autoplot visualization of the tuned Boosted Trees model.  
- `bt_simple_autoplot.jpg` – Autoplot of the simplified Boosted Trees model.  
- `en_autoplot.jpg` – Autoplot visualization of the tuned Elastic Net model.  
- `en_simple_autoplot.jpg` – Autoplot of the simplified Elastic Net model.  
- `hdhi_barchart.png` – Bar chart showing the distribution of people who have had heart disease/a heart attack.  
- `hdhi_outcome_table.rda` – Table summarizing the raw count and proportion of outcomes from the dataset.  
- `individual_variables_check.rda` – Data frame or table summarizing the distribution of individual variables.  
- `interaction-bpcol.jpg` – EDA plot showing interaction between high blood pressure and high cholesterol.  
- `interaction-diabetesbp.jpg` – EDA plot showing interaction between diabetes and high blood pressure.  
- `knn_autoplot.jpg` – Autoplot visualization of the tuned K-Nearest Neighbors model.  
- `knn_simple_autoplot.jpg` – Autoplot of the simplified K-Nearest Neighbors model.  
- `model_comparison_autoplot.jpg` – Autoplot comparing the performance of different models.  
- `rf_autoplot.jpg` – Autoplot visualization of the tuned Random Forest model.  
- `rf_simple_autoplot.jpg` – Autoplot of the simplified Random Forest model.  
- `summary_table.rda` – Table summarizing overall data quality check.  


### **🔹 Presentation of Findings**
- `Lam_Ady_executive_summary.html` - The rendered  HTML output of the corresponding `.qmd` file
- `Lam_Ady_executive_summary.qmd` - Executive summary for Heart Disease Predictive Modelling in R.  
- `Lam_Ady_Final_Report.html` - The rendered  HTML output of the corresponding `.qmd` file
- `Lam_Ady_Final_Report.qmd` - Final report for Heart Disease Predictive Modelling in R.  


### **🔹 Memos **
A folder containing the relevant QMDs and resulting HTMLs of the progress memos created earlier in the modelling process to show progress.

- `Lam_Ady_progress_memo_1.html` - The rendered  HTML output of the corresponding `.qmd` file
- `Lam_Ady_progress_memo_1.qmd` - First memo to display progress made on this project
- `Lam_Ady_progress_memo_2.html`- The rendered  HTML output of the corresponding `.qmd` file
- `Lam_Ady_progress_memo_2.qmd` - Second memo to display progress made on this project


### **🔹 R Scripts **
A folder containing the R scripts of the entire model specification, tuning, fitting and evaluation process.

- `1_initial_split.R` – Filters and samples the dataset, Splits the dataset into training and testing datasets, and performs resampling.  
- `1.5_eda.R` - Checks for interactions between selected pairs of predictor variables and correlations between all possible pairs of predictor variables
- `2_recipes.R` – Defines and checks recipes for data preprocessing.  
- `3_tune_bt.R` – Template for Boosted Trees regression model workflow.  
- `3_tune_en.R` – Template for Elastic Net regression model workflow. 
- `3_tune_knn.R` – Template for K-Nearest Neighbors regression model workflow. 
- `3_tune_log.R` – Template for binary logistic regression model workflow.  
- `3_tune_naive.R` – Template for naive Bayes regression model workflow.  
- `3_tune_null.R` – Template for null model workflow.  
- `3_tune_rf.R` – Template for Random Forest regression model workflow.  
- `4_model_analysis.R` – Packages model fits together to evaluate their performance and obtain their optimal hyperparameters
- `5_train_final_model.R` – Fits the best model (based on prior comparisons) to the entire training dataset. 
- `6_assess_final_model.R` – Evaluates overall performance of training the final model.

### **🔹 Recipes**
A folder that stores data preprocessing recipes
- `hdhi_recipe_lm.rda` - Recipe for the more complex logistic regression models 
- `hdhi_recipe_naive.rda` - Recipe for the naive Bayes baseline model
- `hdhi_recipe_null.rda` - Recipe for the null baseline model, as well as the simpler forms of the tunable models 
- `hdhi_recipe_tree.rda` - Recipe for the more complex tree-based models


### **🔹 Results**
A folder that stores model fitting results, corresponding predictions, and results of other processes that needed to be displayed in the final report.  

- `best_en.rda` – Stores the best Elastic Net model based on the tuning process.  
- `bt_tuned_simple.rda` – Simplified version of the tuned Boosted Trees model.  
- `bt_tuned.rda` – Full tuned Boosted Trees model, including workflow and parameters.  
- `chi_sq_results_df.rda` – Data frame containing results from the Chi-squared tests.  
- `en_tuned_simple.rda` – Simplified version of the tuned Elastic Net model.  
- `en_tuned.rda` – Full tuned Elastic Net model, including workflow and parameters.  
- `final_conf_mat.rda` – The confusion matrix from evaluating the final model.  
- `final_fit_raw.rda` – Raw results from fitting the final model, including predictions.  
- `final_fit.rda` – Final fitted model with pre-processing and tuning applied.  
- `final_metric_values.rda` – Values for 5 key performance metrics of the final model.  
- `final_metrics.rda` – Metric set of accuracy, precision, recall, f_meas, roc_auc.  
- `knn_tuned_simple.rda` – Simplified version of the tuned K-Nearest Neighbors model.  
- `knn_tuned.rda` – Full tuned K-Nearest Neighbors model, including workflow and parameters.  
- `logistic_fit_simple.rda` – Simplified version of the fitted logistic regression model.  
- `logistic_fit.rda` – Full fitted logistic regression model.  
- `model_best_hyperparameters.rda` – RDA file with the best hyperparameters from the tuning process for each tunable model.  
- `model_f1_metrics.rda` – Stores F1-score metrics of all models for model evaluation.  
- `nbayes_fit.rda` – Fitted Naive Bayes model.  
- `null_fit.rda` – Fitted Null model (baseline model).  
- `rf_tuned_simple.rda` – Simplified version of the tuned Random Forest model.  
- `rf_tuned.rda` – Full tuned Random Forest model, including workflow and parameters.  



---


