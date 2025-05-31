# Use here for project-rooted file paths
library(here)
# This script builds the tables and figures for the thesis.
# It loads the necessary data and models, generates the tables and figures, and saves them to the specified output directory.
# The objective is to allow for instant knitting of the thesis without having to run the entire analysis again.

# setwd() is no longer required due to here()

# Load dependencies
source(here("thesis", "analysis", "data.R"))
source(here("thesis", "analysis", "data_cleaning.R"))
source(here("thesis", "analysis", "descriptive_analysis.R"))
source(here("thesis", "analysis", "survey_design.R"))
source(here("thesis", "analysis", "thermo_models.R"))
source(here("thesis", "analysis", "ordinal_models.R"))

# === Load AI Treatment Thermometer Models ===
thermo_gap_treat <- readRDS(here("thesis", "outputs", "models", "thermo_gap_ai_treatment_treat.rds"))
thermo_gap_treat_cov <- readRDS(here("thesis", "outputs", "models", "thermo_gap_ai_treatment_cov.rds"))
full_thermo_gap_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_gap_ai_treatment_model.rds"))

thermo_ml_treat <- readRDS(here("thesis", "outputs", "models", "thermo_ml_ai_treatment_treat.rds"))
thermo_ml_treat_cov <- readRDS(here("thesis", "outputs", "models", "thermo_ml_ai_treatment_cov.rds"))
full_thermo_ml_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_ml_ai_treatment_model.rds"))

thermo_ll_treat <- readRDS(here("thesis", "outputs", "models", "thermo_ll_ai_treatment_treat.rds"))
thermo_ll_treat_cov <- readRDS(here("thesis", "outputs", "models", "thermo_ll_ai_treatment_cov.rds"))
full_thermo_ll_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_ll_ai_treatment_model.rds"))

# === Load Label Treatment Thermometer Models ===
thermo_gap_label_treat <- readRDS(here("thesis", "outputs", "models", "thermo_gap_label_treatment_treat.rds"))
thermo_gap_label_treat_cov <- readRDS(here("thesis", "outputs", "models", "thermo_gap_label_treatment_cov.rds"))
full_thermo_gap_label_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_gap_label_treatment_model.rds"))

thermo_ml_label_treat <- readRDS(here("thesis", "outputs", "models", "thermo_ml_label_treatment_treat.rds"))
thermo_ml_label_treat_cov <- readRDS(here("thesis", "outputs", "models", "thermo_ml_label_treatment_cov.rds"))
full_thermo_ml_label_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_ml_label_treatment_model.rds"))

thermo_ll_label_treat <- readRDS(here("thesis", "outputs", "models", "thermo_ll_label_treatment_treat.rds"))
thermo_ll_label_treat_cov <- readRDS(here("thesis", "outputs", "models", "thermo_ll_label_treatment_cov.rds"))
full_thermo_ll_label_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_ll_label_treatment_model.rds"))

# === Load Labelled AI Treatment Thermometer Models ===
thermo_gap_labelled_ai_treat <- readRDS(here("thesis", "outputs", "models", "thermo_gap_labelled_ai_treatment_treat.rds"))
thermo_gap_labelled_ai_treat_cov <- readRDS(here("thesis", "outputs", "models", "thermo_gap_labelled_ai_treatment_cov.rds"))
full_thermo_gap_labelled_ai_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_gap_labelled_ai_model.rds"))

thermo_ml_labelled_ai_treat <- readRDS(here("thesis", "outputs", "models", "thermo_ml_labelled_ai_treatment_treat.rds"))
thermo_ml_labelled_ai_treat_cov <- readRDS(here("thesis", "outputs", "models", "thermo_ml_labelled_ai_treatment_cov.rds"))
full_thermo_ml_labelled_ai_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_ml_labelled_ai_model.rds"))

thermo_ll_labelled_ai_treat <- readRDS(here("thesis", "outputs", "models", "thermo_ll_labelled_ai_treatment_treat.rds"))
thermo_ll_labelled_ai_treat_cov <- readRDS(here("thesis", "outputs", "models", "thermo_ll_labelled_ai_treatment_cov.rds"))
full_thermo_ll_labelled_ai_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_ll_labelled_ai_model.rds"))



# === Save Thermometer Tables (Revised, Theory-Aligned Naming) ===

# === Overall AI Treatment Effect ===

save_thermo_table(
    file = here("thesis", "outputs", "tables", "thermo_gap_overall_ai_effect.tex"),
    treat = thermo_gap_treat,
    cov = thermo_gap_treat_cov,
    full = full_thermo_gap_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR|mostlikely)",
    coef_rename = c(
        "ai_treatment" = "AI Treatment",
        "political_attention" = "Political Attention",
        "education_recode" = "Education Level"
    ),
    title = "AI-Generated Content: Thermometer Gap Results (Overall Treatment Effect) \\label{tab:thermo-gap-overall}",
    notes = "Treatment compares AI-generated content to human-generated content. Models weighted using YouGov survey weights. Coefficients are reported with robust standard errors in parentheses. Main effects of included moderators are also reported as rows above the moderator treatment effects.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

save_thermo_table(
    file = here("thesis", "outputs", "tables", "thermo_ml_overall_ai_effect.tex"),
    treat = thermo_ml_treat,
    cov = thermo_ml_treat_cov,
    full = full_thermo_ml_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR|mostlikely)",
    coef_rename = c(
        "ai_treatment" = "AI Treatment",
        "political_attention" = "Political Attention",
        "education_recode" = "Education Level"
    ),
    title = "AI-Generated Content: Thermometer (Most Likely) Results (Overall Treatment Effect) \\label{tab:thermo-ml-overall}",
    notes = "Treatment compares AI-generated content to human-generated content. Models weighted using YouGov survey weights. Coefficients are reported with robust standard errors in parentheses.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

save_thermo_table(
    file = here("thesis", "outputs", "tables", "thermo_ll_overall_ai_effect.tex"),
    treat = thermo_ll_treat,
    cov = thermo_ll_treat_cov,
    full = full_thermo_ll_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR|mostlikely)",
    coef_rename = c(
        "ai_treatment" = "AI Treatment",
        "political_attention" = "Political Attention",
        "education_recode" = "Education Level"
    ),
    title = "AI-Generated Content: Thermometer (Least Likely) Results (Overall Treatment Effect) \\label{tab:thermo-ll-overall}",
    notes = "Treatment compares AI-generated content to human-generated content. Models weighted using YouGov survey weights. Coefficients are reported with robust standard errors in parentheses.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

# === Source Credibility Effect ===

save_thermo_table(
    file = here("thesis", "outputs", "tables", "thermo_gap_source_credibility.tex"),
    treat = thermo_gap_labelled_ai_treat,
    cov = thermo_gap_labelled_ai_treat_cov,
    full = full_thermo_gap_labelled_ai_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR|mostlikely)",
    coef_rename = c(
        "labelled_ai_treatment" = "Label Treatment",
        "political_attention" = "Political Attention",
        "education_recode" = "Education Level"
    ),
    title = "Source Credibility Effect: Thermometer Gap Results (Labelled AI vs Human, No Label) \\label{tab:thermo-gap-source-cred}",
    notes = "Treatment compares labelled AI-generated content to unlabelled human-generated content. Models weighted using YouGov survey weights. Coefficients are reported with robust standard errors in parentheses.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

save_thermo_table(
    file = here("thesis", "outputs", "tables", "thermo_ml_source_credibility.tex"),
    treat = thermo_ml_labelled_ai_treat,
    cov = thermo_ml_labelled_ai_treat_cov,
    full = full_thermo_ml_labelled_ai_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR|mostlikely)",
    coef_rename = c(
        "labelled_ai_treatment" = "Label Treatment",
        "political_attention" = "Political Attention",
        "education_recode" = "Education Level"
    ),
    title = "Source Credibility Effect: Thermometer (Most Likely) Results (Labelled AI vs Human, No Label) \\label{tab:thermo-ml-source-cred}",
    notes = "Treatment compares labelled AI-generated content to unlabelled human-generated content. Models weighted using YouGov survey weights. Coefficients are reported with robust standard errors in parentheses.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

save_thermo_table(
    file = here("thesis", "outputs", "tables", "thermo_ll_source_credibility.tex"),
    treat = thermo_ll_labelled_ai_treat,
    cov = thermo_ll_labelled_ai_treat_cov,
    full = full_thermo_ll_labelled_ai_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR|mostlikely)",
    coef_rename = c(
        "labelled_ai_treatment" = "Label Treatment",
        "political_attention" = "Political Attention",
        "education_recode" = "Education Level"
    ),
    title = "Source Credibility Effect: Thermometer (Least Likely) Results (Labelled AI vs Human, No Label) \\label{tab:thermo-ll-source-cred}",
    notes = "Treatment compares labelled AI-generated content to unlabelled human-generated content. Models weighted using YouGov survey weights. Coefficients are reported with robust standard errors in parentheses.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

# === Detection Effect ===

save_thermo_table(
    file = here("thesis", "outputs", "tables", "thermo_gap_detection_effect.tex"),
    treat = thermo_gap_label_treat,
    cov = thermo_gap_label_treat_cov,
    full = full_thermo_gap_label_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR|mostlikely)",
    coef_rename = c(
        "label_treatment" = "Label Treatment",
        "political_attention" = "Political Attention",
        "education_recode" = "Education Level"
    ),
    title = "Detection Effect: Thermometer Gap Results (Labelled AI vs Unlabelled AI) \\label{tab:thermo-gap-detection}",
    notes = "Treatment compares labelled AI-generated content to unlabelled AI-generated content. Models weighted using YouGov survey weights. Coefficients are reported with robust standard errors in parentheses.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

save_thermo_table(
    file = here("thesis", "outputs", "tables", "thermo_ml_detection_effect.tex"),
    treat = thermo_ml_label_treat,
    cov = thermo_ml_label_treat_cov,
    full = full_thermo_ml_label_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR|mostlikely)",
    coef_rename = c(
        "label_treatment" = "Label Treatment",
        "political_attention" = "Political Attention",
        "education_recode" = "Education Level"
    ),
    title = "Detection Effect: Thermometer (Most Likely) Results (Labelled AI vs Unlabelled AI) \\label{tab:thermo-ml-detection}",
    notes = "Treatment compares labelled AI-generated content to unlabelled AI-generated content. Models weighted using YouGov survey weights. Coefficients are reported with robust standard errors in parentheses.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

save_thermo_table(
    file = here("thesis", "outputs", "tables", "thermo_ll_detection_effect.tex"),
    treat = thermo_ll_label_treat,
    cov = thermo_ll_label_treat_cov,
    full = full_thermo_ll_label_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR|mostlikely)",
    coef_rename = c(
        "label_treatment" = "Label Treatment",
        "political_attention" = "Political Attention",
        "education_recode" = "Education Level"
    ),
    title = "Detection Effect: Thermometer (Least Likely) Results (Labelled AI vs Unlabelled AI) \\label{tab:thermo-ll-detection}",
    notes = "Treatment compares labelled AI-generated content to unlabelled AI-generated content. Models weighted using YouGov survey weights. Coefficients are reported with robust standard errors in parentheses.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

# === Add save_ordinal_table() calls here as needed ===
# Create the tables for the ordinal models
# Load the ordinal models for AI treatment
models_dir <- here("thesis", "outputs", "models")
agreedisagree_ai_treat <- readRDS(file.path(models_dir, "agreedisagree_ai_treatment_treat.rds"))
agreedisagree_ai_cov <- readRDS(file.path(models_dir, "agreedisagree_ai_treatment_cov.rds"))
full_agreedisagree_ai_model <- readRDS(file.path(models_dir, "full_agreedisagree_ai_treatment_model.rds"))

xtrust_ai_treat <- readRDS(file.path(models_dir, "xtrust_ai_treatment_treat.rds"))
xtrust_ai_cov <- readRDS(file.path(models_dir, "xtrust_ai_treatment_cov.rds"))
full_xtrust_ai_model <- readRDS(file.path(models_dir, "full_xtrust_ai_treatment_model.rds"))

child_ai_treat <- readRDS(file.path(models_dir, "child_ai_treatment_treat.rds"))
child_ai_cov <- readRDS(file.path(models_dir, "child_ai_treatment_cov.rds"))
full_child_ai_model <- readRDS(file.path(models_dir, "full_child_ai_treatment_model.rds"))

save_ordinal_table(
    file = here("thesis", "outputs", "tables", "agreedisagree_ai_results.tex"),
    treat = agreedisagree_ai_treat,
    cov = agreedisagree_ai_cov,
    full = full_agreedisagree_ai_model,
    coef_omit = "^(?!(ai_treatment(:|$))).*|\\|",
    coef_rename = c(
        "ai_treatment" = "AI Treatment",
        "education_recode" = "Education Level",
        "political_attention" = "Political Attention"
    ),
    title = "Respect: AI Content vs Human Control (Detection Condition) \\label{tab:agreedisagree-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of agreement that opposing partisans respect political beliefs. Threshold cutpoints are not included as they have no substantive interpretation in this context.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

save_ordinal_table(
    file = here("thesis", "outputs", "tables", "xtrust_ai_results.tex"),
    treat = xtrust_ai_treat,
    cov = xtrust_ai_cov,
    full = full_xtrust_ai_model,
    coef_omit = "^(?!(ai_treatment(:|$))).*|\\|",
    coef_rename = c(
        "ai_treatment" = "AI Treatment",
        "education_recode" = "Education Level",
        "political_attention" = "Political Attention"
    ),
    title = "Trust: AI Content vs Human Control (Detection Condition) \\label{tab:xtrust-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of trusting that opposing parties will do what is right for the country. Threshold cutpoints are not included as they have no substantive interpretation in this context.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

save_ordinal_table(
    file = here("thesis", "outputs", "tables", "child_ai_results.tex"),
    treat = child_ai_treat,
    cov = child_ai_cov,
    full = full_child_ai_model,
    coef_omit = "^(?!(ai_treatment(:|$))).*|\\|",
    coef_rename = c(
        "ai_treatment" = "AI Treatment",
        "education_recode" = "Education Level",
        "political_attention" = "Political Attention"
    ),
    title = "Discomfort: AI Content vs Human Control (Detection Condition) \\label{tab:child-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of comfort with a child marrying an opposing party voter. Threshold cutpoints are not included as they have no substantive interpretation in this context.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

# Load the ordinal models for Label treatment
agreedisagree_label_treat <- readRDS(file.path(models_dir, "agreedisagree_label_treatment_treat.rds"))
agreedisagree_label_cov <- readRDS(file.path(models_dir, "agreedisagree_label_treatment_cov.rds"))
full_agreedisagree_label_model <- readRDS(file.path(models_dir, "full_agreedisagree_label_treatment_model.rds"))

xtrust_label_treat <- readRDS(file.path(models_dir, "xtrust_label_treatment_treat.rds"))
xtrust_label_cov <- readRDS(file.path(models_dir, "xtrust_label_treatment_cov.rds"))
full_xtrust_label_model <- readRDS(file.path(models_dir, "full_xtrust_label_treatment_model.rds"))

child_label_treat <- readRDS(file.path(models_dir, "child_label_treatment_treat.rds"))
child_label_cov <- readRDS(file.path(models_dir, "child_label_treatment_cov.rds"))
full_child_label_model <- readRDS(file.path(models_dir, "full_child_label_treatment_model.rds"))

# Load the ordinal models for Labelled AI Treatment (Source Credibility)
agreedisagree_labelled_ai_treat <- readRDS(file.path(models_dir, "agreedisagree_labelled_ai_treatment_treat.rds"))
agreedisagree_labelled_ai_cov <- readRDS(file.path(models_dir, "agreedisagree_labelled_ai_treatment_cov.rds"))
full_agreedisagree_labelled_ai_treatment <- readRDS(file.path(models_dir, "full_agreedisagree_labelled_ai_treatment_model.rds"))

xtrust_labelled_ai_treat <- readRDS(file.path(models_dir, "xtrust_labelled_ai_treatment_treat.rds"))
xtrust_labelled_ai_cov <- readRDS(file.path(models_dir, "xtrust_labelled_ai_treatment_cov.rds"))
full_xtrust_labelled_ai_treatment <- readRDS(file.path(models_dir, "full_xtrust_labelled_ai_treatment_model.rds"))

child_labelled_ai_treat <- readRDS(file.path(models_dir, "child_labelled_ai_treatment_treat.rds"))
child_labelled_ai_cov <- readRDS(file.path(models_dir, "child_labelled_ai_treatment_cov.rds"))
full_child_labelled_ai_treatment <- readRDS(file.path(models_dir, "full_child_labelled_ai_treatment_model.rds"))

# === Save Labelled AI Treatment (Source Credibility) Ordinal Tables ===
save_ordinal_table(
    file = here("thesis", "outputs", "tables", "agreedisagree_labelled_ai_results.tex"),
    treat = agreedisagree_labelled_ai_treat,
    cov = agreedisagree_labelled_ai_cov,
    full = full_agreedisagree_labelled_ai_treatment,
    coef_omit = "^(?!(labelled_ai_treatment(:|$))).*|\\|",
    coef_rename = c(
        "labelled_ai_treatment" = "Label Treatment",
        "education_recode" = "Education Level",
        "political_attention" = "Political Attention"
    ),
    title = "Respect: Labelled AI Content vs Human Control (Source Credibility Condition) \\label{tab:agreedisagree-labelled-ai-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of agreement that opposing partisans respect political beliefs. Threshold cutpoints are not included as they have no substantive interpretation in this context.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

save_ordinal_table(
    file = here("thesis", "outputs", "tables", "xtrust_labelled_ai_results.tex"),
    treat = xtrust_labelled_ai_treat,
    cov = xtrust_labelled_ai_cov,
    full = full_xtrust_labelled_ai_treatment,
    coef_omit = "^(?!(labelled_ai_treatment(:|$))).*|\\|",
    coef_rename = c(
        "labelled_ai_treatment" = "Label Treatment",
        "education_recode" = "Education Level",
        "political_attention" = "Political Attention"
    ),
    title = "Trust: Labelled AI Content vs Human Control (Source Credibility Condition) \\label{tab:xtrust-labelled-ai-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of trusting that opposing parties will do what is right for the country. Threshold cutpoints are not included as they have no substantive interpretation in this context.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

save_ordinal_table(
    file = here("thesis", "outputs", "tables", "child_labelled_ai_results.tex"),
    treat = child_labelled_ai_treat,
    cov = child_labelled_ai_cov,
    full = full_child_labelled_ai_treatment,
    coef_omit = "^(?!(labelled_ai_treatment(:|$))).*|\\|",
    coef_rename = c(
        "labelled_ai_treatment" = "Label Treatment",
        "education_recode" = "Education Level",
        "political_attention" = "Political Attention"
    ),
    title = "Discomfort: Labelled AI Content vs Human Control (Source Credibility Condition) \\label{tab:child-labelled-ai-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of comfort with a child marrying an opposing party voter. Threshold cutpoints are not included as they have no substantive interpretation in this context.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

# === Save Label Treatment Ordinal Tables ===
save_ordinal_table(
    file = here("thesis", "outputs", "tables", "agreedisagree_label_results.tex"),
    treat = agreedisagree_label_treat,
    cov = agreedisagree_label_cov,
    full = full_agreedisagree_label_model,
    coef_omit = "^(?!(label_treatment(:|$))).*|\\|",
    coef_rename = c(
        "label_treatment" = "Label Treatment",
        "education_recode" = "Education Level",
        "political_attention" = "Political Attention"
    ),
    title = "Respect: Unlabelled vs Labelled AI Content (Detection Effect) \\label{tab:agreedisagree-label-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of agreement that opposing partisans respect political beliefs. Threshold cutpoints are not included as they have no substantive interpretation in this context.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

save_ordinal_table(
    file = here("thesis", "outputs", "tables", "xtrust_label_results.tex"),
    treat = xtrust_label_treat,
    cov = xtrust_label_cov,
    full = full_xtrust_label_model,
    coef_omit = "^(?!(label_treatment(:|$))).*|\\|",
    coef_rename = c(
        "label_treatment" = "Label Treatment",
        "education_recode" = "Education Level",
        "political_attention" = "Political Attention"
    ),
    title = "Trust: Unlabelled vs Labelled AI Content (Detection Effect) \\label{tab:xtrust-label-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of trusting that opposing parties will do what is right for the country. Threshold cutpoints are not included as they have no substantive interpretation in this context.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

save_ordinal_table(
    file = here("thesis", "outputs", "tables", "child_label_results.tex"),
    treat = child_label_treat,
    cov = child_label_cov,
    full = full_child_label_model,
    coef_omit = "^(?!(label_treatment(:|$))).*|\\|",
    coef_rename = c(
        "label_treatment" = "Label Treatment",
        "education_recode" = "Education Level",
        "political_attention" = "Political Attention"
    ),
    title = "Discomfort: Unlabelled vs Labelled AI Content (Detection Effect) \\label{tab:child-label-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of comfort with a child marrying an opposing party voter. Threshold cutpoints are not included as they have no substantive interpretation in this context.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

# === Plotting Logic ===
source(here("thesis", "analysis", "thermo_models_plots.R"))


# === Inline Results ===

model_results <- list()

# Extract coefficients from all models
model_results$ai_thermo_gap_coef <- coef(full_thermo_gap_model)["ai_treatment"]
model_results$ai_thermo_ml_coef <- coef(full_thermo_ml_model)["ai_treatment"]
model_results$ai_thermo_ll_coef <- coef(full_thermo_ll_model)["ai_treatment"]

model_results$label_thermo_gap_coef <- coef(full_thermo_gap_label_model)["label_treatment"]
model_results$label_thermo_ml_coef <- coef(full_thermo_ml_label_model)["label_treatment"]
model_results$label_thermo_ll_coef <- coef(full_thermo_ll_label_model)["label_treatment"]

model_results$labelled_thermo_gap_coef <- coef(full_thermo_gap_labelled_ai_model)["labelled_ai_treatment"]
model_results$labelled_thermo_ml_coef <- coef(full_thermo_ml_labelled_ai_model)["labelled_ai_treatment"]
model_results$labelled_thermo_ll_coef <- coef(full_thermo_ll_labelled_ai_model)["labelled_ai_treatment"]


model_results$label_agreedisagree_coef <- coef(full_agreedisagree_label_model)["label_treatment"]
model_results$label_xtrust_coef <- coef(full_xtrust_label_model)["label_treatment"]
model_results$label_child_coef <- coef(full_child_label_model)["label_treatment"]

model_results$labelled_agreedisagree_coef <- coef(full_agreedisagree_labelled_ai_treatment)["labelled_ai_treatment"]
model_results$labelled_xtrust_coef <- coef(full_xtrust_labelled_ai_treatment)["labelled_ai_treatment"]
model_results$labelled_child_coef <- coef(full_child_labelled_ai_treatment)["labelled_ai_treatment"]

model_results$ai_agreedisagree_coef <- coef(full_agreedisagree_ai_model)["ai_treatment"]
model_results$ai_xtrust_coef <- coef(full_xtrust_ai_model)["ai_treatment"]
model_results$ai_child_coef <- coef(full_child_ai_model)["ai_treatment"]

# Moderation effects from full_thermo_gap_model
model_results$gap_ai_mostlikely_conservative <- coef(full_thermo_gap_model)["ai_treatment:mostlikelyConservative Party"]
model_results$gap_ai_mostlikely_green <- coef(full_thermo_gap_model)["ai_treatment:mostlikelyGreen Party"]
model_results$gap_ai_mostlikely_labour <- coef(full_thermo_gap_model)["ai_treatment:mostlikelyLabour Party"]
model_results$gap_ai_mostlikely_ldem <- coef(full_thermo_gap_model)["ai_treatment:mostlikelyLiberal Democrats"]
model_results$gap_ai_polattn <- coef(full_thermo_gap_model)["ai_treatment:political_attention"]
model_results$gap_ai_edu_high <- coef(full_thermo_gap_model)["ai_treatment:education_recodeHigh"]
model_results$gap_ai_edu_medium <- coef(full_thermo_gap_model)["ai_treatment:education_recodeMedium"]

# Moderation effects from full_thermo_ml_model
model_results$ml_ai_mostlikely_conservative <- coef(full_thermo_ml_model)["ai_treatment:mostlikelyConservative Party"]
model_results$ml_ai_mostlikely_green <- coef(full_thermo_ml_model)["ai_treatment:mostlikelyGreen Party"]
model_results$ml_ai_mostlikely_labour <- coef(full_thermo_ml_model)["ai_treatment:mostlikelyLabour Party"]
model_results$ml_ai_mostlikely_ldem <- coef(full_thermo_ml_model)["ai_treatment:mostlikelyLiberal Democrats"]
model_results$ml_ai_polattn <- coef(full_thermo_ml_model)["ai_treatment:political_attention"]
model_results$ml_ai_edu_high <- coef(full_thermo_ml_model)["ai_treatment:education_recodeHigh"]
model_results$ml_ai_edu_medium <- coef(full_thermo_ml_model)["ai_treatment:education_recodeMedium"]

# Moderation effects from full_thermo_ll_model
model_results$ll_ai_mostlikely_conservative <- coef(full_thermo_ll_model)["ai_treatment:mostlikelyConservative Party"]
model_results$ll_ai_mostlikely_green <- coef(full_thermo_ll_model)["ai_treatment:mostlikelyGreen Party"]
model_results$ll_ai_mostlikely_labour <- coef(full_thermo_ll_model)["ai_treatment:mostlikelyLabour Party"]
model_results$ll_ai_mostlikely_ldem <- coef(full_thermo_ll_model)["ai_treatment:mostlikelyLiberal Democrats"]
model_results$ll_ai_polattn <- coef(full_thermo_ll_model)["ai_treatment:political_attention"]
model_results$ll_ai_edu_high <- coef(full_thermo_ll_model)["ai_treatment:education_recodeHigh"]
model_results$ll_ai_edu_medium <- coef(full_thermo_ll_model)["ai_treatment:education_recodeMedium"]

# Moderation effects from full_thermo_gap_label_model
model_results$gap_label_mostlikely_conservative <- coef(full_thermo_gap_label_model)["label_treatment:mostlikelyConservative Party"]
model_results$gap_label_mostlikely_green <- coef(full_thermo_gap_label_model)["label_treatment:mostlikelyGreen Party"]
model_results$gap_label_mostlikely_labour <- coef(full_thermo_gap_label_model)["label_treatment:mostlikelyLabour Party"]
model_results$gap_label_mostlikely_ldem <- coef(full_thermo_gap_label_model)["label_treatment:mostlikelyLiberal Democrats"]
model_results$gap_label_polattn <- coef(full_thermo_gap_label_model)["label_treatment:political_attention"]
model_results$gap_label_edu_high <- coef(full_thermo_gap_label_model)["label_treatment:education_recodeHigh"]
model_results$gap_label_edu_medium <- coef(full_thermo_gap_label_model)["label_treatment:education_recodeMedium"]

# Moderation effects from full_thermo_ml_label_model
model_results$ml_label_mostlikely_conservative <- coef(full_thermo_ml_label_model)["label_treatment:mostlikelyConservative Party"]
model_results$ml_label_mostlikely_green <- coef(full_thermo_ml_label_model)["label_treatment:mostlikelyGreen Party"]
model_results$ml_label_mostlikely_labour <- coef(full_thermo_ml_label_model)["label_treatment:mostlikelyLabour Party"]
model_results$ml_label_mostlikely_ldem <- coef(full_thermo_ml_label_model)["label_treatment:mostlikelyLiberal Democrats"]
model_results$ml_label_polattn <- coef(full_thermo_ml_label_model)["label_treatment:political_attention"]
model_results$ml_label_edu_high <- coef(full_thermo_ml_label_model)["label_treatment:education_recodeHigh"]
model_results$ml_label_edu_medium <- coef(full_thermo_ml_label_model)["label_treatment:education_recodeMedium"]

# Moderation effects from full_thermo_ll_label_model
model_results$ll_label_mostlikely_conservative <- coef(full_thermo_ll_label_model)["label_treatment:mostlikelyConservative Party"]
model_results$ll_label_mostlikely_green <- coef(full_thermo_ll_label_model)["label_treatment:mostlikelyGreen Party"]
model_results$ll_label_mostlikely_labour <- coef(full_thermo_ll_label_model)["label_treatment:mostlikelyLabour Party"]
model_results$ll_label_mostlikely_ldem <- coef(full_thermo_ll_label_model)["label_treatment:mostlikelyLiberal Democrats"]
model_results$ll_label_polattn <- coef(full_thermo_ll_label_model)["label_treatment:political_attention"]
model_results$ll_label_edu_high <- coef(full_thermo_ll_label_model)["label_treatment:education_recodeHigh"]
model_results$ll_label_edu_medium <- coef(full_thermo_ll_label_model)["label_treatment:education_recodeMedium"]

# Moderation effects from full_thermo_gap_labelled_ai_model
model_results$gap_labelled_mostlikely_conservative <- coef(full_thermo_gap_labelled_ai_model)["labelled_ai_treatment:mostlikelyConservative Party"]
model_results$gap_labelled_mostlikely_green <- coef(full_thermo_gap_labelled_ai_model)["labelled_ai_treatment:mostlikelyGreen Party"]
model_results$gap_labelled_mostlikely_labour <- coef(full_thermo_gap_labelled_ai_model)["labelled_ai_treatment:mostlikelyLabour Party"]
model_results$gap_labelled_mostlikely_ldem <- coef(full_thermo_gap_labelled_ai_model)["labelled_ai_treatment:mostlikelyLiberal Democrats"]
model_results$gap_labelled_polattn <- coef(full_thermo_gap_labelled_ai_model)["labelled_ai_treatment:political_attention"]
model_results$gap_labelled_edu_high <- coef(full_thermo_gap_labelled_ai_model)["labelled_ai_treatment:education_recodeHigh"]
model_results$gap_labelled_edu_medium <- coef(full_thermo_gap_labelled_ai_model)["labelled_ai_treatment:education_recodeMedium"]

# Moderation effects from full_thermo_ml_labelled_ai_model
model_results$ml_labelled_mostlikely_conservative <- coef(full_thermo_ml_labelled_ai_model)["labelled_ai_treatment:mostlikelyConservative Party"]
model_results$ml_labelled_mostlikely_green <- coef(full_thermo_ml_labelled_ai_model)["labelled_ai_treatment:mostlikelyGreen Party"]
model_results$ml_labelled_mostlikely_labour <- coef(full_thermo_ml_labelled_ai_model)["labelled_ai_treatment:mostlikelyLabour Party"]
model_results$ml_labelled_mostlikely_ldem <- coef(full_thermo_ml_labelled_ai_model)["labelled_ai_treatment:mostlikelyLiberal Democrats"]
model_results$ml_labelled_polattn <- coef(full_thermo_ml_labelled_ai_model)["labelled_ai_treatment:political_attention"]
model_results$ml_labelled_edu_high <- coef(full_thermo_ml_labelled_ai_model)["labelled_ai_treatment:education_recodeHigh"]
model_results$ml_labelled_edu_medium <- coef(full_thermo_ml_labelled_ai_model)["labelled_ai_treatment:education_recodeMedium"]

# Moderation effects from full_thermo_ll_labelled_ai_model
model_results$ll_labelled_mostlikely_conservative <- coef(full_thermo_ll_labelled_ai_model)["labelled_ai_treatment:mostlikelyConservative Party"]
model_results$ll_labelled_mostlikely_green <- coef(full_thermo_ll_labelled_ai_model)["labelled_ai_treatment:mostlikelyGreen Party"]
model_results$ll_labelled_mostlikely_labour <- coef(full_thermo_ll_labelled_ai_model)["labelled_ai_treatment:mostlikelyLabour Party"]
model_results$ll_labelled_mostlikely_ldem <- coef(full_thermo_ll_labelled_ai_model)["labelled_ai_treatment:mostlikelyLiberal Democrats"]
model_results$ll_labelled_polattn <- coef(full_thermo_ll_labelled_ai_model)["labelled_ai_treatment:political_attention"]
model_results$ll_labelled_edu_high <- coef(full_thermo_ll_labelled_ai_model)["labelled_ai_treatment:education_recodeHigh"]
model_results$ll_labelled_edu_medium <- coef(full_thermo_ll_labelled_ai_model)["labelled_ai_treatment:education_recodeMedium"]

# Moderation effects from full_agreedisagree_label_model
model_results$agreedisagree_label_mostlikely_conservative <- coef(full_agreedisagree_label_model)["label_treatment:mostlikelyConservative Party"]
model_results$agreedisagree_label_mostlikely_green <- coef(full_agreedisagree_label_model)["label_treatment:mostlikelyGreen Party"]
model_results$agreedisagree_label_mostlikely_labour <- coef(full_agreedisagree_label_model)["label_treatment:mostlikelyLabour Party"]
model_results$agreedisagree_label_mostlikely_ldem <- coef(full_agreedisagree_label_model)["label_treatment:mostlikelyLiberal Democrats"]
model_results$agreedisagree_label_polattn <- coef(full_agreedisagree_label_model)["label_treatment:political_attention"]
model_results$agreedisagree_label_edu_high <- coef(full_agreedisagree_label_model)["label_treatment:education_recodeHigh"]
model_results$agreedisagree_label_edu_medium <- coef(full_agreedisagree_label_model)["label_treatment:education_recodeMedium"]

# Moderation effects from full_xtrust_label_model
model_results$xtrust_label_mostlikely_conservative <- coef(full_xtrust_label_model)["label_treatment:mostlikelyConservative Party"]
model_results$xtrust_label_mostlikely_green <- coef(full_xtrust_label_model)["label_treatment:mostlikelyGreen Party"]
model_results$xtrust_label_mostlikely_labour <- coef(full_xtrust_label_model)["label_treatment:mostlikelyLabour Party"]
model_results$xtrust_label_mostlikely_ldem <- coef(full_xtrust_label_model)["label_treatment:mostlikelyLiberal Democrats"]
model_results$xtrust_label_polattn <- coef(full_xtrust_label_model)["label_treatment:political_attention"]
model_results$xtrust_label_edu_high <- coef(full_xtrust_label_model)["label_treatment:education_recodeHigh"]
model_results$xtrust_label_edu_medium <- coef(full_xtrust_label_model)["label_treatment:education_recodeMedium"]

# Moderation effects from full_child_label_model
model_results$child_label_mostlikely_conservative <- coef(full_child_label_model)["label_treatment:mostlikelyConservative Party"]
model_results$child_label_mostlikely_green <- coef(full_child_label_model)["label_treatment:mostlikelyGreen Party"]
model_results$child_label_mostlikely_labour <- coef(full_child_label_model)["label_treatment:mostlikelyLabour Party"]
model_results$child_label_mostlikely_ldem <- coef(full_child_label_model)["label_treatment:mostlikelyLiberal Democrats"]
model_results$child_label_polattn <- coef(full_child_label_model)["label_treatment:political_attention"]
model_results$child_label_edu_high <- coef(full_child_label_model)["label_treatment:education_recodeHigh"]
model_results$child_label_edu_medium <- coef(full_child_label_model)["label_treatment:education_recodeMedium"]

# Moderation effects from full_agreedisagree_labelled_ai_treatment
model_results$agreedisagree_labelled_mostlikely_conservative <- coef(full_agreedisagree_labelled_ai_treatment)["labelled_ai_treatment:mostlikelyConservative Party"]
model_results$agreedisagree_labelled_mostlikely_green <- coef(full_agreedisagree_labelled_ai_treatment)["labelled_ai_treatment:mostlikelyGreen Party"]
model_results$agreedisagree_labelled_mostlikely_labour <- coef(full_agreedisagree_labelled_ai_treatment)["labelled_ai_treatment:mostlikelyLabour Party"]
model_results$agreedisagree_labelled_mostlikely_ldem <- coef(full_agreedisagree_labelled_ai_treatment)["labelled_ai_treatment:mostlikelyLiberal Democrats"]
model_results$agreedisagree_labelled_polattn <- coef(full_agreedisagree_labelled_ai_treatment)["labelled_ai_treatment:political_attention"]
model_results$agreedisagree_labelled_edu_high <- coef(full_agreedisagree_labelled_ai_treatment)["labelled_ai_treatment:education_recodeHigh"]
model_results$agreedisagree_labelled_edu_medium <- coef(full_agreedisagree_labelled_ai_treatment)["labelled_ai_treatment:education_recodeMedium"]

# Moderation effects from full_xtrust_labelled_ai_treatment
model_results$xtrust_labelled_mostlikely_conservative <- coef(full_xtrust_labelled_ai_treatment)["labelled_ai_treatment:mostlikelyConservative Party"]
model_results$xtrust_labelled_mostlikely_green <- coef(full_xtrust_labelled_ai_treatment)["labelled_ai_treatment:mostlikelyGreen Party"]
model_results$xtrust_labelled_mostlikely_labour <- coef(full_xtrust_labelled_ai_treatment)["labelled_ai_treatment:mostlikelyLabour Party"]
model_results$xtrust_labelled_mostlikely_ldem <- coef(full_xtrust_labelled_ai_treatment)["labelled_ai_treatment:mostlikelyLiberal Democrats"]
model_results$xtrust_labelled_polattn <- coef(full_xtrust_labelled_ai_treatment)["labelled_ai_treatment:political_attention"]
model_results$xtrust_labelled_edu_high <- coef(full_xtrust_labelled_ai_treatment)["labelled_ai_treatment:education_recodeHigh"]
model_results$xtrust_labelled_edu_medium <- coef(full_xtrust_labelled_ai_treatment)["labelled_ai_treatment:education_recodeMedium"]

# Moderation effects from full_child_labelled_ai_treatment
model_results$child_labelled_mostlikely_conservative <- coef(full_child_labelled_ai_treatment)["labelled_ai_treatment:mostlikelyConservative Party"]
model_results$child_labelled_mostlikely_green <- coef(full_child_labelled_ai_treatment)["labelled_ai_treatment:mostlikelyGreen Party"]
model_results$child_labelled_mostlikely_labour <- coef(full_child_labelled_ai_treatment)["labelled_ai_treatment:mostlikelyLabour Party"]
model_results$child_labelled_mostlikely_ldem <- coef(full_child_labelled_ai_treatment)["labelled_ai_treatment:mostlikelyLiberal Democrats"]
model_results$child_labelled_polattn <- coef(full_child_labelled_ai_treatment)["labelled_ai_treatment:political_attention"]
model_results$child_labelled_edu_high <- coef(full_child_labelled_ai_treatment)["labelled_ai_treatment:education_recodeHigh"]
model_results$child_labelled_edu_medium <- coef(full_child_labelled_ai_treatment)["labelled_ai_treatment:education_recodeMedium"]

# Moderation effects from full_agreedisagree_ai_model
model_results$agreedisagree_ai_mostlikely_conservative <- coef(full_agreedisagree_ai_model)["ai_treatment:mostlikelyConservative Party"]
model_results$agreedisagree_ai_mostlikely_green <- coef(full_agreedisagree_ai_model)["ai_treatment:mostlikelyGreen Party"]
model_results$agreedisagree_ai_mostlikely_labour <- coef(full_agreedisagree_ai_model)["ai_treatment:mostlikelyLabour Party"]
model_results$agreedisagree_ai_mostlikely_ldem <- coef(full_agreedisagree_ai_model)["ai_treatment:mostlikelyLiberal Democrats"]
model_results$agreedisagree_ai_polattn <- coef(full_agreedisagree_ai_model)["ai_treatment:political_attention"]
model_results$agreedisagree_ai_edu_high <- coef(full_agreedisagree_ai_model)["ai_treatment:education_recodeHigh"]
model_results$agreedisagree_ai_edu_medium <- coef(full_agreedisagree_ai_model)["ai_treatment:education_recodeMedium"]

# Moderation effects from full_xtrust_ai_model
model_results$xtrust_ai_mostlikely_conservative <- coef(full_xtrust_ai_model)["ai_treatment:mostlikelyConservative Party"]
model_results$xtrust_ai_mostlikely_green <- coef(full_xtrust_ai_model)["ai_treatment:mostlikelyGreen Party"]
model_results$xtrust_ai_mostlikely_labour <- coef(full_xtrust_ai_model)["ai_treatment:mostlikelyLabour Party"]
model_results$xtrust_ai_mostlikely_ldem <- coef(full_xtrust_ai_model)["ai_treatment:mostlikelyLiberal Democrats"]
model_results$xtrust_ai_polattn <- coef(full_xtrust_ai_model)["ai_treatment:political_attention"]
model_results$xtrust_ai_edu_high <- coef(full_xtrust_ai_model)["ai_treatment:education_recodeHigh"]
model_results$xtrust_ai_edu_medium <- coef(full_xtrust_ai_model)["ai_treatment:education_recodeMedium"]

# Moderation effects from full_child_ai_model
model_results$child_ai_mostlikely_conservative <- coef(full_child_ai_model)["ai_treatment:mostlikelyConservative Party"]
model_results$child_ai_mostlikely_green <- coef(full_child_ai_model)["ai_treatment:mostlikelyGreen Party"]
model_results$child_ai_mostlikely_labour <- coef(full_child_ai_model)["ai_treatment:mostlikelyLabour Party"]
model_results$child_ai_mostlikely_ldem <- coef(full_child_ai_model)["ai_treatment:mostlikelyLiberal Democrats"]
model_results$child_ai_polattn <- coef(full_child_ai_model)["ai_treatment:political_attention"]
model_results$child_ai_edu_high <- coef(full_child_ai_model)["ai_treatment:education_recodeHigh"]
model_results$child_ai_edu_medium <- coef(full_child_ai_model)["ai_treatment:education_recodeMedium"]

saveRDS(model_results, file = here("thesis", "outputs", "helpers", "model_results.rds"))
