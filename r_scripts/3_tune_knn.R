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

# SIMPLE ----
# model specifications ----
knn_spec_simple <- nearest_neighbor(
  mode = "classification",
  neighbors = tune()
  ) |>
  set_engine("kknn")


# define workflows ----
knn_wflow_simple <- workflow() |>
  add_model(knn_spec_simple) |>
  add_recipe(hdhi_recipe_null)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(knn_spec_simple)

# change hyperparameter ranges
knn_params_simple <- hardhat::extract_parameter_set_dials(knn_spec_simple) |>
  update(
    neighbors = neighbors(range = c(1, 75)),   # Search between 1 and 75 neighbors, increased from before
  )

# build tuning grid
knn_grid_simple <- grid_random(knn_params_simple, size = 30)

# fit workflows/models ----
# Tune the model using resampling
knn_tuned_simple <-
  knn_wflow_simple |>
  tune_grid(
    resamples = hdhi_folds,
    grid = knn_grid_simple,
    control = keep_wflow,
    metrics = metric_set(f_meas)
  )

# write out results (fitted/trained workflows) ----
save(knn_tuned_simple, file = here("results/knn_tuned_simple.rda"))


# # COMPLEX ----
# # model specifications ----
# knn_spec <- nearest_neighbor(
#   mode = "classification",
#   neighbors = tune()
# ) |>
#   set_engine("kknn")
# 
# 
# # define workflows ----
# knn_wflow <- workflow() |>
#   add_model(knn_spec) |>
#   add_recipe(hdhi_recipe_tree)
# 
# # hyperparameter tuning values ----
# # check ranges for hyperparameters
# hardhat::extract_parameter_set_dials(knn_spec)
# 
# # change hyperparameter ranges
# knn_params <- hardhat::extract_parameter_set_dials(knn_spec) |>
#   update(
#     neighbors = neighbors(range = c(1, 75)),   # Search between 1 and 75 neighbors (increased from previous)
#   )
# 
# # build tuning grid
# knn_grid <- grid_random(knn_params, size = 30)
# 
# # fit workflows/models ----
# # Tune the model using resampling
# knn_tuned <-
#   knn_wflow |>
#   tune_grid(
#     resamples = hdhi_folds,
#     grid = knn_grid,
#     control = keep_wflow,
#     metrics = metric_set(f_meas)
#   )
# 
# # write out results (fitted/trained workflows) ----
# save(knn_tuned, file = here("results/knn_tuned.rda"))



