# Final Project Progress Memo 1: Data Quality & Complexity Check ----
# Stat 301-2


# load packages ----
library(tidyverse)
library(tidymodels)
library(naniar) # for exploring missingness (but skimr covers that actually oops nvm)
library(skimr) # for a detailed summary of all variables, including counts of missing values, data types, and statistics
library(DT)
library(themis)


# loading training set 
load(here::here("data/hdhi_train.rda"))
load(here::here("data/heart_disease_health_indicators.rda"))



# recipe building ----
# suggested order 
# Impute
# Handle factor levels
# Individual transformations for skewness and other issues
# Discretize (if needed and if you have no other choice)
# Create dummy variables
# Create interactions
# Normalization steps (center, scale, range, etc)
# Multivariate transformation (e.g. PCA, spatial sign, etc)

# basic for null 
hdhi_recipe_null <- 
  recipe(`HeartDiseaseorAttack` ~ ., data = hdhi_train) |> 
  step_impute_median(all_numeric_predictors())|> 
  step_impute_mode(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_dummy(all_nominal_predictors()) |> 
  step_normalize(all_numeric_predictors()) 
# decided not to use step_other() because no need to group infrequent factor levels into an “other” category

# basic for naive
hdhi_recipe_naive <- 
  recipe(`HeartDiseaseorAttack` ~ ., data = hdhi_train) |> 
  step_impute_median(all_numeric_predictors())|> 
  step_impute_mode(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors()) 

# more complex tree-based recipe ----
hdhi_recipe_tree <- 
  recipe(`HeartDiseaseorAttack` ~ ., data = hdhi_train) |> 
  step_impute_median(all_numeric_predictors()) |> 
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors()) 
# tree-based methods (such as random forests or boosted trees) are inherently non-linear and often 
# capture interactions automatically, so explicit interaction terms might not always improve performance and 
# could even add unnecessary complexity. That said, if you have strong theoretical reasons to suspect that certain 
# interactions are critical, including them can be worthwhile. 
hdhi_recipe_tree |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

# more complex logistic regression recipe ----
hdhi_recipe_lm <- 
  recipe(`HeartDiseaseorAttack` ~ ., data = hdhi_train) |> 
  step_impute_median(all_numeric_predictors()) %>% 
  step_impute_mode(all_nominal_predictors()) %>%
  step_dummy(all_nominal_predictors())  |> 
  # MAKE SOME INTERACTIONS!!! 
  step_interact(terms = ~ HighBP_Yes:HighChol_Yes) |> #joint effect of high blood pressure and cholesterol, both blood issues
  step_interact(terms = ~ starts_with('Diabetes'):HighBP_Yes) |>  #combination known to greatly increase cardiovascular risk.
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors())
# not even using this yet but is this too much???? 

hdhi_recipe_lm |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()


# # effect of food / consumption? 
# hdhi_recipe_food <- 
#   recipe(`HeartDiseaseorAttack` ~ `Fruits`, `Veggies`, `HvyAlcoholConsump`, data = hdhi_train) |> 
#   step_impute_median(all_numeric_predictors()) %>% 
#   step_impute_mode(all_nominal_predictors()) %>%
#   step_dummy(all_nominal_predictors(), one_hot = TRUE)
# 
#   
# # effect on socioeconomic status
# hdhi_recipe_ses <- 
#   recipe(`HeartDiseaseorAttack` ~ `AnyHealthcare` + `NoDocbcCost` + `Income` + `Education`, data = hdhi_train) |> 
#   step_impute_median(all_numeric_predictors()) %>% 
#   step_impute_mode(all_nominal_predictors()) %>%
#   step_dummy(all_nominal_predictors(), one_hot = TRUE)


# save recipes 
save(hdhi_recipe_null, file = here::here("recipes/hdhi_recipe_null.rda"))
save(hdhi_recipe_tree, file = here::here("recipes/hdhi_recipe_tree.rda"))
save(hdhi_recipe_lm, file = here::here("recipes/hdhi_recipe_lm.rda"))
save(hdhi_recipe_naive, file = here::here("recipes/hdhi_recipe_naive.rda"))


# check recipes ----
# prep(hdhi_recipe_ses) |> 
#   bake(new_data = NULL)



# outcome variable table count
hdhi_outcome_table <- heart_disease_health_indicators |>
  mutate(`Reported Previous Heart Disease/Attack?` = HeartDiseaseorAttack) |>
  count(`Reported Previous Heart Disease/Attack?`) |>
  mutate(Proportion = (100 * n / sum(n)) |> round(digits = 1)) 

# data quality check - overall ----
summary_table <- heart_disease_health_indicators |>
  summarise(
    `Total Observations` = nrow(heart_disease_health_indicators),
    `Total Variables` = ncol(heart_disease_health_indicators),
    `Categorical Variables` = sum(sapply(heart_disease_health_indicators, is.factor)),
    `Numerical Variables` = sum(sapply(heart_disease_health_indicators, is.numeric)),
    `Missing Values` = sum(is.na(heart_disease_health_indicators))
  ) 

# data quality check - individual variables
individual_variables_check <- heart_disease_health_indicators |>
  skim() |>
  select(skim_type:factor.top_counts) |>
  datatable(
    rownames = FALSE
  ) 

# missingness (not used)
miss_var_summary(heart_disease_health_indicators)

# save outputs of data quality checks
save(summary_table, file = here::here('figures/summary_table.rda'))
save(individual_variables_check, file = here::here('figures/individual_variables_check.rda'))
save(hdhi_outcome_table, file = here::here('figures/hdhi_outcome_table.rda'))