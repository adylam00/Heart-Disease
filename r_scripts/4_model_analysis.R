# Final Project ----
# Analysis of tuned and trained models (comparisons)
# Select final model
# Fit & analyze final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load fits ----
paths <-  list.files(path = here('results/'), pattern = ".rda", full.names = TRUE)
for (path in paths){
  load(path)
}


# clean up space
rm(path, paths)


## workflow set ----
# Package fits together
model_results <-
  as_workflow_set(
    # null = null_fit,
    # `naive bayes` = nbayes_fit,
    # `binary logistic (simple)` = logistic_fit_simple,
    # `binary logistic` = logistic_fit,
    # `random forest (simple)` = rf_tuned_simple,
    # `random forest` = rf_tuned,
    # `elastic net (simple)` = en_tuned_simple,
    # `elastic net` = en_tuned,
    # `nearest neighbours (simple)` = knn_tuned_simple,
    # `nearest neighbours` = knn_tuned,
    # `boosted trees (simple)` = bt_tuned_simple,
    `boosted trees` = bt_tuned
  )

model_best_hyperparameters <- 
  bind_rows(
    # mutate(select_best(null_fit, metric = "f_meas"), `Model Type` = "null"),
    # mutate(select_best(nbayes_fit, metric = "f_meas"), `Model Type` = "naive bayes"),
    # mutate(select_best(logistic_fit_simple, metric = "f_meas"), `Model Type` = "binary logistic (simple)"),
    # mutate(select_best(logistic_fit, metric = "f_meas"), `Model Type` = "binary logistic"),
    # mutate(select_best(rf_tuned_simple, metric = "f_meas"), `Model Type` = "random forest (simple)"),
    # mutate(select_best(rf_tuned, metric = "f_meas"), `Model Type` = "random forest"),
    # mutate(select_best(en_tuned_simple, metric = "f_meas"), `Model Type` = "elastic net (simple)"),
    # mutate(select_best(en_tuned, metric = "f_meas"), `Model Type` = "elastic net"),
    # mutate(select_best(knn_tuned_simple, metric = "f_meas"), `Model Type` = "nearest neighbours (simple)"),
    # mutate(select_best(knn_tuned, metric = "f_meas"), `Model Type` = "nearest neighbours"),
    # mutate(select_best(bt_tuned_simple, metric = "f_meas"), `Model Type` = "boosted trees (simple)"),
    mutate(select_best(bt_tuned, metric = "roc_auc"), `Model Type` = "boosted trees")
    ) |>
  select(-.config) |>
  pivot_longer(
    cols = mtry:learn_rate,
    names_to = 'Tuning Parameters',
    values_to = 'Value'
  ) |>
  drop_na() |>
  mutate(
    Value = round(Value, digits = 3)
  )

# Create Table
model_f1_metrics <- model_results |> 
  collect_metrics() |> 
  slice_max(mean, by = wflow_id) |> 
  arrange(desc(mean)) |> 
  select(.config, wflow_id, model, .metric, mean, std_err, n) |> 
  knitr::kable(
    col.names = c("Configuration", "Workflow ID", "Model", "Metric", "Mean", "Standard Error", "N"),
    digits = 5
  ) 

# model analyses
model_comparison_autoplot <- model_results |>
  autoplot(metric = 'f_meas',
           select_best = TRUE, 
           std_errs = 1)


# checking hyperparameters
knn_simple_autoplot <- knn_tuned_simple  |>
  autoplot() #again do again
knn_autoplot <- knn_tuned |> 
  autoplot(metric = 'f_meas') # this suggests it hasn't fully plateaued yet so maybe increase the number of nearest neighbours

rf_simple_autoplot <- rf_tuned_simple |> 
  autoplot(metric = 'f_meas') #this one did better than more complex, min_n = 20 highest, maybe can go higher. but tbh already quite extensive range so no need.
rf_autoplot <- rf_tuned |> 
  autoplot(metric = 'f_meas')

bt_simple_autoplot <- bt_tuned_simple |> 
  autoplot(metric = 'f_meas', ylim = c(0.745, 0.760))
bt_autoplot <- bt_tuned |> 
  autoplot(metric = 'f_meas', ylim = c(0.745, 0.760))

en_simple_autoplot <- en_tuned_simple |> 
  autoplot(metric = 'f_meas')
en_autoplot <- en_tuned |> 
  autoplot(metric = 'f_meas') 
# As regularization increases (moving to the left), the model generally maintains a high F-measure. However, as you approach a certain threshold, the performance drops, indicating the model may be over-regularized.
# A mix of Ridge and Lasso penalties (elastic net) seems to offer stable performance. However, as you increase the proportion of Lasso (toward 1.0), the model's performance deteriorates.

# selecting  the best hyperparameters
best_en <- select_best(en_tuned, metric = "f_meas") |>
  mutate(
    model = 'elastic net'
  )

# saving
save(model_results, file = here("results/model_results.rda"))
save(model_f1_metrics, file = here("results/model_f1_metrics.rda"))
save(model_best_hyperparameters, file = here("results/model_best_hyperparameters.rda"))
save(best_en, file = here("results/best_en.rda"))

ggsave(
  filename = here::here("figures/knn_simple_autoplot.jpg"),
  plot = knn_simple_autoplot)
ggsave(
  filename = here::here("figures/knn_autoplot.jpg"),
  plot = knn_autoplot)

ggsave(
  filename = here::here("figures/rf_simple_autoplot.jpg"),
  plot = rf_simple_autoplot)
ggsave(
  filename = here::here("figures/rf_autoplot.jpg"),
  plot = rf_autoplot)

ggsave(
  filename = here::here("figures/bt_simple_autoplot.jpg"),
  plot = bt_simple_autoplot)
ggsave(
  filename = here::here("figures/bt_autoplot.jpg"),
  plot = bt_autoplot)

ggsave(
  filename = here::here("figures/en_simple_autoplot.jpg"),
  plot = en_simple_autoplot)
ggsave(
  filename = here::here("figures/en_autoplot.jpg"),
  plot = en_autoplot)

ggsave(
  filename = here::here("figures/model_comparison_autoplot.jpg"),
  plot = model_comparison_autoplot)
