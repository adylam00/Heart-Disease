# L06 Model Tuning ----
# Define and fit null/baseline model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)
library(xgboost) # for boosted tree


# handle common conflicts
tidymodels_prefer()


# load resamples, controls and metrics ----
load(here("data/hdhi_folds.rda"))
load(here("data/keep_wflow.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/hdhi_recipe_null.rda"))


## overall recipe ----
# model specifications ----
null_spec <- null_model() %>% 
  set_engine("parsnip") %>% 
  set_mode("classification") 

# create workflow ----
null_workflow <- workflow() %>% 
  add_model(null_spec) %>% 
  add_recipe(hdhi_recipe_null)

# fit the null model to the resamples ----
null_fit <- null_workflow |>  # not sure if i need this actually
  fit_resamples(
    resamples = hdhi_folds, 
    control = keep_wflow,
    metrics = metric_set(f_meas)
  )

# write out results (fitted/trained workflows) ----
save(null_fit, file = here::here("results/null_fit.rda"))









# note to self: no tuning grid needed
# The null model does not have hyperparameters that need tuning.
# It always predicts the most common class (or random guessing if no dominant class exists).
# Tuning grids are only needed for models like random forest, SVM, KNN, or boosted trees.


# bt_spec <- boost_tree(
#   mode = "regression", 
#   trees = 250, 
#   mtry = tune(), 
#   min_n = tune(), 
#   learn_rate = tune()
# ) |> 
#   set_engine("xgboost")

# define workflows ----
# bt_wflow <- 
#   workflow() |>
#   add_model(bt_spec) |> 
#   add_recipe(carseat_recipe)

# hyperparameter tuning values ----
# check ranges for hyperparameters
# hardhat::extract_parameter_set_dials(bt_spec)

# change hyperparameter ranges
# bt_params <- hardhat::extract_parameter_set_dials(bt_spec) |> 
#   update(
#     mtry = mtry(c(1, 10)), 
#     # for c(1, N), N:= maximum number of random predictor columns we want to try 
#     # should be less than the number of available columns
#     # anything that you're tuning you should have it listed here 
#     min_n = min_n(),
#     learn_rate = learn_rate(c(-5, -0.2))
#   )

# build tuning grid 
# bt_grid <- grid_regular(bt_params, levels = 5)


# fit workflows/models ----
# Set Seed
# set.seed(7654321)

# # parallel processing ----
# num_cores <- parallel::detectCores(logical = FALSE) -1
# registerDoMC(cores = num_cores)

# # Fit Workflows / Models
# bt_tuned <-
#   bt_wflow |> 
#   tune_grid(
#     resamples = carseat_folds,
#     grid = bt_grid,
#     control = keep_wflow,
#     metrics = my_metrics
#   )

# write out results (fitted/trained workflows) ----
# save(bt_tuned, file = here("results/bt_tuned.rda"))

