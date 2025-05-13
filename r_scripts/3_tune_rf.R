# L06 Model Tuning ----
# Define and fit random forest model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(123)


# parallel processing ----
num_cores <- parallel::detectCores(logical = FALSE) - 1
registerDoMC(cores = num_cores)

# load resamples, controls and metrics ----
load(here("data/hdhi_folds.rda"))
load(here("data/keep_wflow.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/hdhi_recipe_null.rda"))
load(here("recipes/hdhi_recipe_tree.rda"))


# SIMPLER RECIPE
# overall recipe ----
# model specifications (simple)----
rf_spec_simple <-
  rand_forest(
    trees = 500, # this number was chosen to strike a balance between model performance and training time
    min_n = tune(),
    mtry = tune()
  ) |>
  set_engine("ranger") |>
  set_mode(
    "classification"
  )

# define workflows ----
rf_wflow_simple <-
  workflow() |>
  add_model(rf_spec_simple) |>
  add_recipe(hdhi_recipe_null)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_spec_simple)

# change hyperparameter ranges ----
rf_params_simple <- hardhat::extract_parameter_set_dials(rf_spec_simple) |>
  update(
    mtry = mtry(c(1, 11)),  # reduced the range to fewer options for faster processing
    min_n = min_n(c(5, 20))
  )

# build tuning grid ----
rf_grid_simple <- grid_regular(rf_params_simple, levels = 5)

# fit workflows/models ----
rf_tuned_simple <-
  rf_wflow_simple |>
  tune_grid(
    resamples = hdhi_folds,
    grid = rf_grid_simple,
    control = keep_wflow,
    metrics = metric_set(f_meas)
  )

# write out results (fitted/trained workflows) ----
save(rf_tuned_simple, file = here("results/rf_tuned_simple.rda"))





# COMPLEX RECIPE
# overall recipe ----
# model specifications ----
rf_spec <-
  rand_forest(
    trees = 500, # this number was chosen to strike a balance between model performance and training time
    min_n = tune(),
    mtry = tune()
  ) |>
  set_engine("ranger") |>
  set_mode(
    "classification"
  )

# define workflows ----
rf_wflow <-
  workflow() |>
  add_model(rf_spec) |>
  add_recipe(hdhi_recipe_tree)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_spec)

# change hyperparameter ranges
rf_params <- hardhat::extract_parameter_set_dials(rf_spec) |>
  update(
    mtry = mtry(c(1, 11)),  # reduced the range to fewer options for faster processing
    min_n = min_n(c(5, 20))
  )

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5)

# fit workflows/models ----

rf_tuned <-
  rf_wflow |>
  tune_grid(
    resamples = hdhi_folds,
    grid = rf_grid,
    control = keep_wflow,
    metrics = metric_set(f_meas)
  )

# write out results (fitted/trained workflows) ----
save(rf_tuned, file = here("results/rf_tuned.rda"))


# # checking cores
# library(future)
# plan(multisession, workers = num_cores)



