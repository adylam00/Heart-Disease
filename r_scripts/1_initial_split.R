# Final Project Progress Memo 1: Target variable EDA & Initial Split ----
# Stat 301-2


# load packages ----
library(tidyverse)
library(tidymodels)

# handle conflicts
tidymodels_prefer()

# randomly sample 40,000 out of 200,000 ----
set.seed(123)  

# load data ----
heart_disease_health_indicators <-  read_csv(here::here("data/heart_disease_health_indicators.csv")) |>
    relocate(`Diabetes`, `BMI`, `GenHlth`, `MentHlth`, `PhysHlth`, `Age`, `Education`, `Income`, .after = `Sex`) |>
    mutate(across(c(`HeartDiseaseorAttack`:`Sex`), 
                  ~ factor(.x, 
                           levels = c(0, 1), 
                           labels = c("No", "Yes")
                           )
                  ),
           `Diabetes` = factor(`Diabetes`,
                               levels = c(0, 1, 2),
                               labels = c("No Diabetes", "Pre-Diabetes", "Diabetes")
                              )
           ) |> 
  mutate(id = row_number())

hdhi_yes <- heart_disease_health_indicators |> 
  filter(HeartDiseaseorAttack == 'Yes') 

hdhi_no_sample <- heart_disease_health_indicators |> 
  filter(HeartDiseaseorAttack == 'No') |> 
  slice_sample(n = nrow(hdhi_yes))

hdhi_sample <- bind_rows(hdhi_yes, hdhi_no_sample) 
  # count(HeartDiseaseorAttack)

hdhi_eda <- heart_disease_health_indicators |>
  anti_join(hdhi_sample, by = "id") |> 
  select(-id)

hdhi_sample <-  hdhi_sample |>
  select(-id)

# split data ----
hdhi_split <- hdhi_sample |>
  initial_split(prop = 0.8,  #80% of the data in the training set, 20% in the testing set.
                strata = `HeartDiseaseorAttack` #Stratifies the split based on HeartDiseaseorAttack to ensure both sets have similar distributions of log-transformed prices.
  )

# extract the training and testing datasets from the split object kc_split.
hdhi_train <- hdhi_split |> training()
hdhi_test <- hdhi_split |> testing()



# setup resamples (fold the data) ----
hdhi_folds <- hdhi_train |> #this creates a cross-validation object
  vfold_cv(
    v = 7, # into 7 objects because 10 was taking too long
    repeats = 5, # repeating the cross-validation process 5 times to reduce variability in performance estimates.
    strata = `HeartDiseaseorAttack`
  )


# controls for fitting to resamples ----
keep_wflow <- control_grid(save_workflow = TRUE)
# my_metrics <- metric_set(mae, rmse, rsq, mape) for reference only. using F1 so don't need this


# write-out / save outputs
# .RDA can be much more complex, can package together many itmes at once and then load all items at once too 
save(heart_disease_health_indicators, file = here::here("data/heart_disease_health_indicators.rda"))
save(hdhi_eda, file = here::here("data/hdhi_eda.rda"))
save(hdhi_split, file = here::here("data/hdhi_split.rda"))
save(hdhi_train, file = here::here("data/hdhi_train.rda"))
save(hdhi_test, file = here::here("data/hdhi_test.rda"))
save(hdhi_folds, file = here::here('data/hdhi_folds.rda'))

save(keep_wflow, file = here::here('data/keep_wflow.rda'))




# Heart Disease or Attack univariate EDA ----
hdhi_barchart <- ggplot(heart_disease_health_indicators, aes(`HeartDiseaseorAttack`)) +
  geom_bar() +
  labs(
    title = 'Number of Americans who have\nhad heart disease/a heart attack',
    x = element_blank()
  )

# saving graphic
ggsave(
  filename = here::here("figures/hdhi_barchart.png"),
  plot = hdhi_barchart,
  height = 3,
  width = 3.5)

hdhi_outcome_table <- hdhi_train |>
  count(`HeartDiseaseorAttack`) |>
  mutate(`Proportion` = (100 * n / sum(n)) |> round(digits = 1)) |>
  knitr::kable()

