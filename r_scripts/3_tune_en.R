# L06 Model Tuning ----
# Define and fit elastic net model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

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


# model specifications ----
elastic_spec_simple <-
  logistic_reg(penalty = tune(),
               mixture = tune()) |>
  set_engine("glmnet")

# add workflow ----
elastic_workflow_simple <- workflow() |>
  add_model(elastic_spec_simple) |>
  add_recipe(hdhi_recipe_null)


# hyperparameter tuning values ----
# show which hyperparameters can be adjusted
hardhat::extract_parameter_set_dials(elastic_spec_simple)
# output confirms that elastic net model has two tunable hyperparameters, penalty and mixture

# update the parameters ----
elastic_params_simple <- extract_parameter_set_dials(elastic_spec_simple) |>
  # just an example of how to update
  update(penalty = penalty(range = c(-5, 0))) |>  # controls the amount of shrinkage applied to model coefficients, 0: more complex, higher values: simpler
  update(mixture = mixture(range = c(0, 1)) ) # this searches over the entire range. 0 = ridge, 1 = lasso, 0.5 = elastic net (both)

# build grid ----
elastic_grid_simple <- grid_random(elastic_params_simple, size = 100) #random sampling of 50 hyperparameter combinations



# Tune Grid ----
en_tuned_simple <- tune_grid(elastic_workflow_simple,
                      hdhi_folds,
                      grid = elastic_grid_simple,
                      control = control_resamples(save_workflow = TRUE),
                      metrics = metric_set(f_meas)
                      )

save(en_tuned_simple,
     file = "results/en_tuned_simple.rda")


# More Complex
# model specifications ----
elastic_spec <-
  logistic_reg(penalty = tune(),
               mixture = tune()) |>
  set_engine("glmnet")

# add workflow ----
elastic_workflow <- workflow() |>
  add_model(elastic_spec) |>
  add_recipe(hdhi_recipe_lm)

# hyperparameter tuning values ----
# show which hyperparameters can be adjusted
hardhat::extract_parameter_set_dials(elastic_spec)
# output confirms that elastic net model has two tunable hyperparameters, penalty and mixture

# update the parameters ----
elastic_params <- extract_parameter_set_dials(elastic_spec) |>
  # just an example of how to update
  update(penalty = penalty(range = c(-5, 0))) |>  # controls the amount of shrinkage applied to model coefficients, 0: more complex, higher values: simpler
  update(mixture = mixture(range = c(0, 1)) ) # this searches over the entire range. 0 = ridge, 1 = lasso, 0.5 = elastic net (both)

# build grid ----
elastic_grid <- grid_random(elastic_params, size = 100) #random sampling of 50 hyperparameter combinations


# Tune Grid ----
en_tuned <- tune_grid(elastic_workflow,
                      hdhi_folds,
                      grid = elastic_grid,
                      control = control_resamples(save_workflow = TRUE),
                      metrics = metric_set(f_meas)
                      )

save(en_tuned,
     file = "results/en_tuned.rda")



