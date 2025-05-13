# L06 Model Tuning ----
# Define and fit random forest model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)
library(xgboost) # for boosted tree


# handle common conflicts
tidymodels_prefer()


# parallel processing ----
num_cores <- parallel::detectCores(logical = FALSE) - 1
registerDoMC(cores = num_cores)

# load resamples, controls and metrics ----
load(here("data/hdhi_folds.rda"))
load(here("data/keep_wflow.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/hdhi_recipe_null.rda"))
load(here("recipes/hdhi_recipe_lm.rda"))

# simple ----
# model specification ----
logistic_spec_simple <-
  logistic_reg() |>  # No penalty argument, as it's a standard logistic regression
  set_engine("glm") |>
  set_mode("classification")

# adding workflow ----
logistic_workflow_simple <- workflow() |>
  add_model(logistic_spec_simple) |>
  add_recipe(hdhi_recipe_null)

# fit the null model to the resamples ----
logistic_fit_simple <- logistic_workflow_simple |>
  fit_resamples(
    resamples = hdhi_folds,
    control = keep_wflow,
    metrics = metric_set(f_meas)
  )

# write out results (fitted/trained workflows) ----
save(logistic_fit_simple, file = here::here("results/logistic_fit_simple.rda"))


# complex ----
# model specification ----
logistic_spec <-
  logistic_reg() |>  # No penalty argument, as it's a standard logistic regression
  set_engine("glm") |>
  set_mode("classification")

# adding workflow ----
logistic_workflow <- workflow() |>
  add_model(logistic_spec) |>
  add_recipe(hdhi_recipe_lm)

# fit the null model to the resamples ----
logistic_fit <- logistic_workflow |>
  fit_resamples(
    resamples = hdhi_folds,
    control = keep_wflow,
    metrics = metric_set(f_meas)
  )

# write out results (fitted/trained workflows) ----
save(logistic_fit, file = here::here("results/logistic_fit.rda"))