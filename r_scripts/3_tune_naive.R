# Final Project ----
# Define and fit naive bayes model


# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)
library(discrim)

# handle common conflicts
tidymodels_prefer()


# load resamples, controls and metrics ----
load(here("data/hdhi_folds.rda"))
load(here("data/keep_wflow.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/hdhi_recipe_null.rda"))
load(here("recipes/hdhi_recipe_naive.rda"))



# Model Specification
nbayes_spec <- naive_Bayes() |> 
  set_engine("klaR") |> 
  set_mode("classification")

# define model workflow
nbayes_workflow <- workflow() |>
  add_model(nbayes_spec) |>
  add_recipe(hdhi_recipe_naive)

# use resamples to train/assess workflow
nbayes_fit <- nbayes_workflow |>  
  fit_resamples(
    resamples = hdhi_folds, 
    control = keep_wflow,
    metrics = metric_set(f_meas)
  )

# write out results
save(nbayes_fit, file = here::here('results/nbayes_fit.rda'))

