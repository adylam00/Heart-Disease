# Final Project ----
# Fit & analyze final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(1932)

# parallel processing
num_cores <-  parallel::detectCores(logical = TRUE) - 1
registerDoMC(cores = num_cores)

# load results ---- (this is corrections)
load(here("results/en_tuned.rda")) 
load(here("data/hdhi_train.rda")) 
load(here("data/hdhi_test.rda")) 

# finalize workflow ----
final_wflow <- en_tuned |> 
  extract_workflow(en_tuned) |>  
  finalize_workflow(select_best(en_tuned, metric = "f_meas"))

# train final model
final_fit <- fit(final_wflow, hdhi_train)

# ASSESSMENT ----
# define metric set 
final_metrics <-  metric_set(accuracy, precision, recall, f_meas, roc_auc)

# Generate probability predictions
final_fit_probs <- final_fit |>
  predict(new_data = hdhi_test, type = "prob")

# Generate class predictions
final_fit_class <- final_fit |>
  predict(new_data = hdhi_test)

# Combine everything
final_fit_raw <- bind_cols(
  final_fit_probs,  # Includes probabilities (for ROC AUC)
  final_fit_class,  # Includes class predictions (for accuracy, precision, etc.)
  hdhi_test |> select(HeartDiseaseorAttack)  # True labels
)

# Calculate ----
final_metric_values <- final_fit_raw |>
  final_metrics(truth = HeartDiseaseorAttack, 
         estimate = .pred_class,
         .pred_No)


# Confusion matrix ----
final_conf_mat <- final_fit_raw |>
  conf_mat(truth = HeartDiseaseorAttack, estimate = .pred_class)


# save output
save(final_fit_raw, file = here::here('results/final_fit_raw.rda'))
save(final_metric_values, file = here::here('results/final_metric_values.rda'))
save(final_conf_mat, file = here::here('results/final_conf_mat.rda'))
