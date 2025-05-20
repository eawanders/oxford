#' This script provides a function to produce ordinal
#' logistic regression models for affective polarisation outcomes
#'
#' @param data Data frame with survey data
#' @param design Survey design object
#' @param outcomes Character vector of outcome variables (default: c("agreedisagree", "xtrust", "child"))
#' @param treatments Character vector of treatment variables (default: c("ai_treatment", "label_treatment"))
#' @param covariates List of covariate vectors for each outcome (default: NULL)
#' @param moderators List of moderator vectors for each outcome (default: NULL)
#'
#' @return Named list of model objects

# Load required scripts to run the analysis in this file
source("../analysis/data.R")
source("../analysis/data_cleaning.R")
source("../analysis/survey_design.R")


fit_ordinal_models <- function(
    data,
    design,
    outcomes = c("agreedisagree", "xtrust", "child"),
    treatments = c("ai_treatment", "label_treatment"),
    covariates = list(
        agreedisagree = list(
            ai_treatment = c("age", "political_attention", "profile_gender", "education_recode", "profile_work_stat"),
            label_treatment = NULL
        ),
        xtrust = list(
            ai_treatment = c("age", "political_attention", "profile_gender", "education_recode", "profile_work_stat"),
            label_treatment = NULL
        ),
        child = list(
            ai_treatment = c("age", "political_attention", "profile_gender", "education_recode", "profile_work_stat"),
            label_treatment = c("age", "political_attention", "profile_gender", "education_recode", "profile_work_stat", "pastvote_ge_2024", "pastvote_EURef", "profile_GOR")
        )
    ),
    moderators = list(
        agreedisagree = list(
            ai_treatment = c("mostlikely"),
            label_treatment = c("profile_GOR", "mostlikely")
        ),
        xtrust = list(
            ai_treatment = c("profile_work_stat"),
            label_treatment = c("mostlikely")
        ),
        child = list(
            ai_treatment = c("education_recode"),
            label_treatment = c("profile_gender", "profile_GOR", "pastvote_EURef")
        )
    )) {
    results_list <- list()

    for (treat in treatments) {
        for (out in outcomes) {
            # 1. Treatment Only Model
            formula_treat <- reformulate(termlabels = treat, response = out)
            model_treat <- svyolr(formula = formula_treat, design = design)
            results_list[[paste0(out, "_", treat, "_treat")]] <- model_treat

            # 2. Treatment + Covariates Model
            formula_cov <- reformulate(termlabels = c(treat, covariates[[out]][[treat]]), response = out)
            model_cov <- svyolr(formula = formula_cov, design = design)
            results_list[[paste0(out, "_", treat, "_cov")]] <- model_cov

            # 3. Full Model: Treatment + Covariates + Moderators + Interactions
            rhs <- c(
                treat,
                covariates[[out]][[treat]],
                moderators[[out]][[treat]],
                paste(treat, moderators[[out]][[treat]], sep = ":")
            )
            formula_full <- reformulate(termlabels = rhs, response = out)
            model_full <- svyolr(formula = formula_full, design = design)
            results_list[[paste0("full_", out, "_", treat, "_model")]] <- model_full
        }
    }
    return(results_list)
}

#
# Fit all ordinal models for the AI and Label treatments separately
ordinal_models_list_ai <- fit_ordinal_models(
    data = yougov_data_ai,
    design = yougov_design_ai,
    outcomes = c("agreedisagree", "xtrust", "child"),
    treatments = c("ai_treatment")
)

ordinal_models_list_label <- fit_ordinal_models(
    data = yougov_data_label,
    design = yougov_design_label,
    outcomes = c("agreedisagree", "xtrust", "child"),
    treatments = c("label_treatment")
)

# === Save Models ===
# Assign objects for each ai model
agreedisagree_ai_treat <- ordinal_models_list_ai[["agreedisagree_ai_treatment_treat"]]
agreedisagree_ai_cov <- ordinal_models_list_ai[["agreedisagree_ai_treatment_cov"]]
full_agreedisagree_ai_model <- ordinal_models_list_ai[["full_agreedisagree_ai_treatment_model"]]

xtrust_ai_treat <- ordinal_models_list_ai[["xtrust_ai_treatment_treat"]]
xtrust_ai_cov <- ordinal_models_list_ai[["xtrust_ai_treatment_cov"]]
full_xtrust_ai_model <- ordinal_models_list_ai[["full_xtrust_ai_treatment_model"]]

child_ai_treat <- ordinal_models_list_ai[["child_ai_treatment_treat"]]
child_ai_cov <- ordinal_models_list_ai[["child_ai_treatment_cov"]]
full_child_ai_model <- ordinal_models_list_ai[["full_child_ai_treatment_model"]]

# Assign objects for each label model
agreedisagree_label_treat <- ordinal_models_list_label[["agreedisagree_label_treatment_treat"]]
agreedisagree_label_cov <- ordinal_models_list_label[["agreedisagree_label_treatment_cov"]]
full_agreedisagree_label_model <- ordinal_models_list_label[["full_agreedisagree_label_treatment_model"]]

xtrust_label_treat <- ordinal_models_list_label[["xtrust_label_treatment_treat"]]
xtrust_label_cov <- ordinal_models_list_label[["xtrust_label_treatment_cov"]]
full_xtrust_label_model <- ordinal_models_list_label[["full_xtrust_label_treatment_model"]]

child_label_treat <- ordinal_models_list_label[["child_label_treatment_treat"]]
child_label_cov <- ordinal_models_list_label[["child_label_treatment_cov"]]
full_child_label_model <- ordinal_models_list_label[["full_child_label_treatment_model"]]

models_dir <- "../outputs/models"

# Save each model as an .rds
for (model_name in names(ordinal_models_list_ai)) {
    saveRDS(
        ordinal_models_list_ai[[model_name]],
        file = file.path(models_dir, paste0(model_name, ".rds"))
    )
}

for (model_name in names(ordinal_models_list_label)) {
    saveRDS(
        ordinal_models_list_label[[model_name]],
        file = file.path(models_dir, paste0(model_name, ".rds"))
    )
}

# Save Ordinal Results Table as .tex
save_ordinal_table <- function(file, treat, cov, full, coef_omit, coef_rename, title, notes, add_rows) {
    tex <- modelsummary::modelsummary(
        list(
            "Treatment Only" = treat,
            "Treatment + Covariates" = cov,
            "Full Model" = full
        ),
        output = "latex",
        statistic = "({std.error})",
        stars = TRUE,
        coef_omit = coef_omit,
        gof_omit = "IC|Log|Adj",
        coef_rename = coef_rename,
        escape = FALSE,
        title = title,
        notes = notes,
        add_rows = add_rows
    )
    writeLines(as.character(tex), con = file)
    invisible(tex)
}
