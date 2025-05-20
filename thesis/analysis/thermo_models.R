# Thermometer Model Analysis to allow for flexible modeling of different thermometer outcome models

# Source the necessary files to run this script
source("../analysis/data.R")
source("../analysis/data_cleaning.R")
source("../analysis/survey_design.R")

thermo_models <- function(data,
                          design,
                          outcome = c("thermo_gap", "MLthermoMean", "LLthermoMean"),
                          treatment = c("ai_treatment", "label_treatment"),
                          covariates = NULL,
                          moderators = NULL) {
    results_list <- list()

    for (treat in treatment) {
        for (out in outcome) {
            rhs <- treat

            if (!is.null(covariates)) {
                rhs <- c(rhs, covariates)
            }

            if (!is.null(moderators)) {
                rhs <- c(rhs, moderators, paste(treat, moderators, sep = ":"))
            }

            formula_spec <- reformulate(termlabels = rhs, response = out)
            model <- svyglm(formula = formula_spec, design = design)

            model_name <- paste0(out, "_", treat)
            results_list[[model_name]] <- model
        }
    }

    return(results_list)
}

# This function will create a list of models for each combination of outcome and treatment

fit_thermo_models <- function(data, design, treatment_group = c("ai_treatment", "label_treatment")) {
    covariates <- c(
        "age",
        "political_attention",
        "profile_gender",
        "education_recode",
        "profile_work_stat",
        "pastvote_ge_2024",
        "pastvote_EURef",
        "profile_GOR"
    )
    # Explicit list of model specifications with name, outcome, treatment, covariates, and moderators
    model_specs <- list(
        # thermo_gap models with ai_treatment
        list(
            name = "thermo_gap_ai_treatment_treat",
            outcome = "thermo_gap",
            treatment = "ai_treatment",
            covariates = NULL,
            moderators = NULL
        ),
        list(
            name = "thermo_gap_ai_treatment_cov",
            outcome = "thermo_gap",
            treatment = "ai_treatment",
            covariates = covariates,
            moderators = NULL
        ),
        list(
            name = "full_thermo_gap_ai_treatment_model",
            outcome = "thermo_gap",
            treatment = "ai_treatment",
            covariates = covariates,
            moderators = c("pastvote_ge_2024")
        ),
        # MLthermoMean models with ai_treatment
        list(
            name = "thermo_ml_ai_treatment_treat",
            outcome = "MLthermoMean",
            treatment = "ai_treatment",
            covariates = NULL,
            moderators = NULL
        ),
        list(
            name = "thermo_ml_ai_treatment_cov",
            outcome = "MLthermoMean",
            treatment = "ai_treatment",
            covariates = covariates,
            moderators = NULL
        ),
        list(
            name = "full_thermo_ml_ai_treatment_model",
            outcome = "MLthermoMean",
            treatment = "ai_treatment",
            covariates = covariates,
            moderators = c("profile_work_stat")
        ),
        # LLthermoMean models with ai_treatment
        list(
            name = "thermo_ll_ai_treatment_treat",
            outcome = "LLthermoMean",
            treatment = "ai_treatment",
            covariates = NULL,
            moderators = NULL
        ),
        list(
            name = "thermo_ll_ai_treatment_cov",
            outcome = "LLthermoMean",
            treatment = "ai_treatment",
            covariates = covariates,
            moderators = NULL
        ),
        list(
            name = "full_thermo_ll_ai_treatment_model",
            outcome = "LLthermoMean",
            treatment = "ai_treatment",
            covariates = covariates,
            moderators = c("age")
        ),
        # thermo_gap models with label_treatment
        list(
            name = "thermo_gap_label_treatment_treat",
            outcome = "thermo_gap",
            treatment = "label_treatment",
            covariates = NULL,
            moderators = NULL
        ),
        list(
            name = "thermo_gap_label_treatment_cov",
            outcome = "thermo_gap",
            treatment = "label_treatment",
            covariates = covariates,
            moderators = NULL
        ),
        list(
            name = "full_thermo_gap_label_treatment_model",
            outcome = "thermo_gap",
            treatment = "label_treatment",
            covariates = covariates,
            moderators = c("mostlikely", "political_attention")
        ),
        # MLthermoMean models with label_treatment
        list(
            name = "thermo_ml_label_treatment_treat",
            outcome = "MLthermoMean",
            treatment = "label_treatment",
            covariates = NULL,
            moderators = NULL
        ),
        list(
            name = "thermo_ml_label_treatment_cov",
            outcome = "MLthermoMean",
            treatment = "label_treatment",
            covariates = covariates,
            moderators = NULL
        ),
        list(
            name = "full_thermo_ml_label_treatment_model",
            outcome = "MLthermoMean",
            treatment = "label_treatment",
            covariates = covariates,
            moderators = c("age", "political_attention", "mostlikely")
        ),
        # LLthermoMean models with label_treatment
        list(
            name = "thermo_ll_label_treatment_treat",
            outcome = "LLthermoMean",
            treatment = "label_treatment",
            covariates = NULL,
            moderators = NULL
        ),
        list(
            name = "thermo_ll_label_treatment_cov",
            outcome = "LLthermoMean",
            treatment = "label_treatment",
            covariates = covariates,
            moderators = NULL
        ),
        list(
            name = "full_thermo_ll_label_treatment_model",
            outcome = "LLthermoMean",
            treatment = "label_treatment",
            covariates = covariates,
            moderators = c("profile_gender")
        )
    )

    # Filter model_specs to only include models matching the given treatment_group
    model_specs <- Filter(function(spec) spec$treatment == treatment_group, model_specs)

    result <- list()
    for (spec in model_specs) {
        mod <- thermo_models(
            data = data,
            design = design,
            treatment = spec$treatment,
            outcome = spec$outcome,
            covariates = spec$covariates,
            moderators = spec$moderators
        )[[1]]
        result[[spec$name]] <- mod
    }
    return(result)
}

# Flexible function to export modelsummary tables for thermometer models
save_thermo_table <- function(
    file,
    treat, cov, full,
    coef_omit,
    coef_rename,
    title,
    notes,
    add_rows = NULL,
    statistic = "({std.error})",
    stars = TRUE,
    gof_omit = "IC|Log|Adj",
    escape = FALSE,
    output = "latex") {
    model_list <- list(
        "Treatment Only" = treat,
        "Treatment + Covariates" = cov,
        "Full Model" = full
    )
    modelsummary::modelsummary(
        model_list,
        output = file,
        statistic = statistic,
        stars = stars,
        coef_omit = coef_omit,
        gof_omit = gof_omit,
        escape = escape,
        title = title,
        coef_rename = coef_rename,
        notes = notes,
        add_rows = add_rows
    )
}


# Fit all thermometer models for the AI treatment
thermo_models_list_ai <- fit_thermo_models(
    data = yougov_data_ai,
    design = yougov_design_ai,
    treatment_group = "ai_treatment"
)

# Fit all thermometer models for the Label treatment
thermo_models_list_label <- fit_thermo_models(
    data = yougov_data_label,
    design = yougov_design_label,
    treatment_group = "label_treatment"
)

# Assign objects for easier referencing throughout your document (AI models)
thermo_gap_treat <- thermo_models_list_ai[["thermo_gap_ai_treatment_treat"]]
thermo_gap_treat_cov <- thermo_models_list_ai[["thermo_gap_ai_treatment_cov"]]
full_thermo_gap_model <- thermo_models_list_ai[["full_thermo_gap_ai_treatment_model"]]

thermo_ml_treat <- thermo_models_list_ai[["thermo_ml_ai_treatment_treat"]]
thermo_ml_treat_cov <- thermo_models_list_ai[["thermo_ml_ai_treatment_cov"]]
full_thermo_ml_model <- thermo_models_list_ai[["full_thermo_ml_ai_treatment_model"]]

thermo_ll_treat <- thermo_models_list_ai[["thermo_ll_ai_treatment_treat"]]
thermo_ll_treat_cov <- thermo_models_list_ai[["thermo_ll_ai_treatment_cov"]]
full_thermo_ll_model <- thermo_models_list_ai[["full_thermo_ll_ai_treatment_model"]]

models_dir <- "../outputs/models"

# Save each model as an .rds for both AI and Label lists
for (model_name in names(thermo_models_list_ai)) {
    saveRDS(
        thermo_models_list_ai[[model_name]],
        file = file.path(models_dir, paste0(model_name, ".rds"))
    )
}

for (model_name in names(thermo_models_list_label)) {
    saveRDS(
        thermo_models_list_label[[model_name]],
        file = file.path(models_dir, paste0(model_name, ".rds"))
    )
}
