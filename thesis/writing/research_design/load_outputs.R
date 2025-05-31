# Load here package for robust file referencing
library(here)
# This script loads the results from the models used in the thesis.
# It is used to load the models for inline references in the thesis.
# Load only the models needed for inline references (not for rebuilding outputs)



# Thermometer models — AI Treatment
full_thermo_gap_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_gap_ai_treatment_model.rds"))
full_thermo_ml_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_ml_ai_treatment_model.rds"))
full_thermo_ll_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_ll_ai_treatment_model.rds"))

# Thermometer models — Label Treatment
full_thermo_gap_label_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_gap_label_treatment_model.rds"))
full_thermo_ml_label_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_ml_label_treatment_model.rds"))
full_thermo_ll_label_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_ll_label_treatment_model.rds"))

# --- Thermometer models — Labelled AI (Source Credibility Effect) ---
full_thermo_gap_labelled_ai_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_gap_labelled_ai_model.rds"))
full_thermo_ml_labelled_ai_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_ml_labelled_ai_model.rds"))
full_thermo_ll_labelled_ai_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_ll_labelled_ai_model.rds"))

# Ordinal outcome models — AI Treatment
full_agreedisagree_ai_model <- readRDS(here("thesis", "outputs", "models", "full_agreedisagree_ai_treatment_model.rds"))
full_xtrust_ai_model <- readRDS(here("thesis", "outputs", "models", "full_xtrust_ai_treatment_model.rds"))
full_child_ai_model <- readRDS(here("thesis", "outputs", "models", "full_child_ai_treatment_model.rds"))

# --- Ordinal outcome models — Labelled AI (Source Credibility Effect) ---
full_agreedisagree_labelled_ai_model <- readRDS(here("thesis", "outputs", "models", "full_agreedisagree_labelled_ai_treatment_model.rds"))
full_xtrust_labelled_ai_model <- readRDS(here("thesis", "outputs", "models", "full_xtrust_labelled_ai_treatment_model.rds"))
full_child_labelled_ai_model <- readRDS(here("thesis", "outputs", "models", "full_child_labelled_ai_treatment_model.rds"))

# Model outcomes for inline references
model_results <- readRDS(here("thesis", "outputs", "helpers", "model_results.rds"))

# Load the inline results from the model_results.rds file into the global environment
list2env(model_results, envir = globalenv())
