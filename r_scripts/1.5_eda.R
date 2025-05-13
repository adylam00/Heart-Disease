# Final Project ----
# Stat 301-2: Check for Interactions


# load packages ----
library(tidyverse)
library(tidymodels)
library(patchwork)
library(corrr)
library(MASS)     
library(DT)


# set seed
set.seed(745)

# loading training set and eda set 
load(here::here("data/hdhi_train.rda")) 
load(here::here('data/hdhi_eda.rda'))


hdhi_train |> 
  slice_sample(prop = 0.6)



# EDA OF DATASET
hdhi_train |> 
# count(HighBP) #Not too much imbalance
# count(HighChol) #Okay imo
# count(CholCheck) #Major imbalance between no and yes values.
# count(Smoker) #that's fine
# count(Stroke) #IMBALANCED.
# count(PhysActivity) #a bit imbalanced
# count(Fruits) # a bit imbalanced
# count(Veggies) #quite imbalanced
# count(HvyAlcoholConsump) #IMBALANCED
# count(AnyHealthcare) # IMBALANCED
# count(NoDocbcCost) #imbalanced
# count(DiffWalk) #slightly imbalanced
# count(Sex) nope that's fine
# count(Diabetes) imbalanced but less inclined to do this


# CholCheck, Stroke, HvyAlcoholConsump, AnyHealthcare <- have significant imbalance

# INTERACTIONS ----
# step_interact(terms = ~ HighBP:HighChol) |> #joint effect of high blood pressure and cholesterol, both blood issues
# step_interact(terms = ~ BMI:PhysActivity) |> #bmi not always reflective of health, someone  may have a high bmi but high phys activity which kinda cancels out the negative aspects of bmi
# step_interact(terms = ~ Smoker_Yes:HvyAlcoholConsump_Yes) |> #together could have synergistic negative effects on cardiovascular health.
  # step_interact(terms = ~ Diabetes:HighBP) |>  #combination known to greatly increase cardiovascular risk.
  # step_interact(terms = ~ CholCheck:HighChol) |>  #regular cholesterol checks might influence outcomes differently for individuals with high cholesterol.
  # step_interact(terms = ~ Fruits:Veggies) |>  #dietary patterns would have joint effects on health
  # step_interact(terms = ~ NoDocbcCost:AnyHealthcare) |> #barriers to care may differ based on whether someone has any insurance.
  # step_interact(terms = ~ Menthlth:PhysHlth) |> #interplay between mental and physical health can be crucial for overall well-being.
  

# HighBP X HighCol
# hdhi_train |> 
#   count(HighBP, HighChol, HeartDiseaseorAttack)

bpcol <- hdhi_train |> 
  ggplot(aes(HighChol, fill = HeartDiseaseorAttack)) +
  geom_bar(position = "fill") +
  facet_wrap(~ HighBP) +
  labs(title = 'HighBP x HighChol')
# Definitely seems like there's an interaction here


# BMI X PhysActivity
# hdhi_train |> 
#   count(BMI, PhysActivity, HeartDiseaseorAttack)

bmiphys <- hdhi_train |> 
  ggplot(aes(BMI, fill = HeartDiseaseorAttack)) +
  geom_histogram(position = "fill", bins = 15) +
  facet_wrap(~ PhysActivity) +
  labs(title = 'BMI x PhysActivity')
# Doesn't necessarily seem like there's an interaction


# # Diabetes X HighBP
# hdhi_train |> 
#   count(Diabetes, HighBP, HeartDiseaseorAttack)

diabetesbp <- hdhi_train |> 
  ggplot(aes(HighBP, fill = HeartDiseaseorAttack)) +
  geom_bar(position = "fill") +
  facet_wrap(~ Diabetes) +
  labs(title = 'HighBP x Diabetes')
# Seems like there is an interaction


# # CholCheck X HighChol
# hdhi_train |> 
#   count(CholCheck, HighChol, HeartDiseaseorAttack)

chol2 <- hdhi_train |> 
  ggplot(aes(HighChol, fill = HeartDiseaseorAttack)) +
  geom_bar(position = "fill") +
  facet_wrap(~ CholCheck) +
  labs(title = 'CholCheck x HighChol')
# Very small interaction


# # Fruits X Veggies
# hdhi_train |> 
#   count(Fruits, Veggies, HeartDiseaseorAttack)

fruitveggie <- hdhi_train |> 
  ggplot(aes(Veggies, fill = HeartDiseaseorAttack)) +
  geom_bar(position = "fill") +
  facet_wrap(~ Fruits) +
  labs(title = 'Fruits x Veggies')
# Basically no interaction lmfao


# # NoDocbcCost X AnyHealthcare
# hdhi_train |> 
#   count(NoDocbcCost, AnyHealthcare, HeartDiseaseorAttack)

nodochealthcare <- hdhi_train |> 
  ggplot(aes(AnyHealthcare, fill = HeartDiseaseorAttack)) +
  geom_bar(position = "fill") +
  facet_wrap(~ NoDocbcCost) +
  labs(title = 'NoDocbcCost x Veggies')
# Doesn't appear to have an interaction


# # Menthlth X PhysHlth
# hdhi_train |> 
#   count(MentHlth, PhysHlth, HeartDiseaseorAttack)

mentphyhlth <- hdhi_train |> 
  ggplot(aes(MentHlth, PhysHlth, colour = HeartDiseaseorAttack)) +
  geom_point(alpha = 0.7) +
  #facet_wrap(~ MentHlth) +
  labs(title = 'MentHlth x PhysHlth')
# No i don't think there's an interaction

# # Smoker X HvyAlcoholConsump
# hdhi_train |> 
#   count(Smoker, HvyAlcoholConsump, HeartDiseaseorAttack)

smokalc <- hdhi_train |> 
  ggplot(aes(HvyAlcoholConsump, fill = HeartDiseaseorAttack)) +
  geom_bar(position = "fill") +
  facet_wrap(~ Smoker) +
  labs(title = 'Smoker x Heavy Alcohol Consumption')
# Potentially interact but less clear... don't count it


ggsave(
  filename = here::here("figures/interaction-bpcol.jpg"),
  plot = bpcol)

ggsave(
  filename = here::here("figures/interaction-diabetesbp.jpg"),
  plot = diabetesbp)


# Correlation for numeric variables ----
correlate(hdhi_eda, use = "pairwise.complete.obs")


# Correlation for factor variables ---- 
print(str(hdhi_eda))

# extracting all factor variables
hdhi_eda_chisq <- hdhi_eda |> 
  select(where(\(x) is.factor(x)))

# Get all unique pairs of predictor variables
variable_pairs <- combn(names(hdhi_eda_chisq), 2, simplify = FALSE)

# Run chi-squared tests for each pair
chi_sq_results <- lapply(variable_pairs, function(pair) {
  var1 <- pair[1]
  var2 <- pair[2]
  
  # Compute the chi-squared test
  test <- chisq.test(table(hdhi_eda_chisq[[var1]], hdhi_eda_chisq[[var2]]))
  
  # Store results
  return(data.frame(Variable1 = var1, Variable2 = var2, p_value = test$p.value))
})

# Combine results into a data frame
chi_sq_results_df <- do.call(rbind, chi_sq_results) |>
  arrange(desc(p_value)) |>
  mutate(p_value = round(p_value, digits = 4)) |>
  datatable(
    rownames = FALSE
  ) 

# Print results
save(chi_sq_results_df, file = here::here('results/chi_sq_results_df.rda'))


