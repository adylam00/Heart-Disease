# Final Project Tuning ----
# Define and fit boosted tree model

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
load(here("recipes/hdhi_recipe_tree.rda"))

# model specifications (simple) ----
bt_spec_simple <- boost_tree(
  mode = "classification",
  trees = 500,
  mtry = tune(),
  min_n = tune(),
  learn_rate = tune()
) |>
  set_engine("xgboost")

# define workflows (simple) ----
bt_wflow_simple <-
  workflow() |>
  add_model(bt_spec_simple) |>
  add_recipe(hdhi_recipe_null)

# hyperparameter tuning values (simple) ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(bt_spec_simple)

# change hyperparameter ranges (simple)
bt_params_simple <- hardhat::extract_parameter_set_dials(bt_spec_simple) |>
  update(
    mtry = mtry(c(1, 11)),
    # for c(1, N), N:= maximum number of random predictor columns we want to try
    # should be less than the number of available columns
    # anything that you're tuning you should have it listed here
    min_n = min_n(c(5, 20)),
    learn_rate = learn_rate(c(-5, -1))
  )

# build tuning grid (simple)
bt_grid_simple <- grid_regular(bt_params_simple, levels = 5)

# # Fit Workflows / Models (simple)
bt_tuned_simple <-
  bt_wflow_simple |>
  tune_grid(
    resamples = hdhi_folds,
    grid = bt_grid_simple,
    control = keep_wflow,
    metrics = metric_set(f_meas)
  )

# write out results (fitted/trained workflows) (simple) ----
save(bt_tuned_simple, file = here("results/bt_tuned_simple.rda"))


# MORE COMPLEX MODEL ----
# model specifications (complex) ----
bt_spec <- boost_tree(
  mode = "classification",
  trees = 500,
  mtry = tune(),
  min_n = tune(),
  learn_rate = tune()
) |>
  set_engine("xgboost")

# define workflows (complex) ----
bt_wflow <-
  workflow() |>
  add_model(bt_spec) |>
  add_recipe(hdhi_recipe_tree)

# hyperparameter tuning values (complex) ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(bt_spec)

# change hyperparameter ranges (complex)
bt_params <- hardhat::extract_parameter_set_dials(bt_spec) |>
  update(
    mtry = mtry(c(1, 11)),
    # for c(1, N), N:= maximum number of random predictor columns we want to try
    # should be less than the number of available columns
    # anything that you're tuning you should have it listed here
    min_n = min_n(c(5, 20)),
    learn_rate = learn_rate(c(-5, -1))
  )

# build tuning grid (complex)
bt_grid <- grid_regular(bt_params, levels = 5)



# # Fit Workflows / Models (complex) ----
bt_tuned <-
  bt_wflow |>
  tune_grid(
    resamples = hdhi_folds,
    grid = bt_grid,
    control = keep_wflow,
    metrics = metric_set(f_meas)
  )

# write out results (fitted/trained workflows) (complex) ----
save(bt_tuned, file = here("results/bt_tuned.rda"))
