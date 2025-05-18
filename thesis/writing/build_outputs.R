# This script builds the tables and figures for the thesis.
# It loads the necessary data and models, generates the tables and figures, and saves them to the specified output directory.
# The objective is to allow for instant knitting of the thesis without having to run the entire analysis again.

# Load dependencies
source("../analysis/data.R")
source("../analysis/data_cleaning.R")
source("../analysis/descriptive_analysis.R")
source("../analysis/survey_design.R")
source("../analysis/thermo_models.R")
source("../analysis/ordinal_models.R")

# === Load AI Treatment Thermometer Models ===
thermo_gap_treat <- readRDS("../outputs/models/thermo_gap_ai_treatment_treat.rds")
thermo_gap_treat_cov <- readRDS("../outputs/models/thermo_gap_ai_treatment_cov.rds")
full_thermo_gap_model <- readRDS("../outputs/models/full_thermo_gap_ai_treatment_model.rds")

thermo_ml_treat <- readRDS("../outputs/models/thermo_ml_ai_treatment_treat.rds")
thermo_ml_treat_cov <- readRDS("../outputs/models/thermo_ml_ai_treatment_cov.rds")
full_thermo_ml_model <- readRDS("../outputs/models/full_thermo_ml_ai_treatment_model.rds")

thermo_ll_treat <- readRDS("../outputs/models/thermo_ll_ai_treatment_treat.rds")
thermo_ll_treat_cov <- readRDS("../outputs/models/thermo_ll_ai_treatment_cov.rds")
full_thermo_ll_model <- readRDS("../outputs/models/full_thermo_ll_ai_treatment_model.rds")

# === Load Label Treatment Thermometer Models ===
thermo_gap_label_treat <- readRDS("../outputs/models/thermo_gap_label_treatment_treat.rds")
thermo_gap_label_treat_cov <- readRDS("../outputs/models/thermo_gap_label_treatment_cov.rds")
full_thermo_gap_label_model <- readRDS("../outputs/models/full_thermo_gap_label_treatment_model.rds")

thermo_ml_label_treat <- readRDS("../outputs/models/thermo_ml_label_treatment_treat.rds")
thermo_ml_label_treat_cov <- readRDS("../outputs/models/thermo_ml_label_treatment_cov.rds")
full_thermo_ml_label_model <- readRDS("../outputs/models/full_thermo_ml_label_treatment_model.rds")

thermo_ll_label_treat <- readRDS("../outputs/models/thermo_ll_label_treatment_treat.rds")
thermo_ll_label_treat_cov <- readRDS("../outputs/models/thermo_ll_label_treatment_cov.rds")
full_thermo_ll_label_model <- readRDS("../outputs/models/full_thermo_ll_label_treatment_model.rds")

# === Save Thermometer Tables ===
save_thermo_table(
    file = "../outputs/tables/thermo_gap_ai_results.tex",
    treat = thermo_gap_treat,
    cov = thermo_gap_treat_cov,
    full = full_thermo_gap_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR)",
    coef_rename = c("ai_treatment" = "AI Treatment", "political_attention" = "Political Attention", "education_recode" = "Education"),
    title = "AI-Generated Content: Thermometer Gap Results \\label{tab:thermo-results}",
    notes = "Note: Models weighted using YouGov survey weights. The coefficients are reported with robust standard errors in parentheses. Main effects of the included moderators are also reported as rows above the moderator treatment effects.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

save_thermo_table(
    file = "../outputs/tables/thermo_ml_ai_results.tex",
    treat = thermo_ml_treat,
    cov = thermo_ml_treat_cov,
    full = full_thermo_ml_model,
    coef_omit = "^(political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR)",
    coef_rename = c("ai_treatment" = "AI Treatment", "age" = "Age", "education_recode" = "Education"),
    title = "AI-Generated Content: Thermometer (mostlikely) Results \\label{tab:thermo-ml-results}",
    notes = "Note: Models weighted using YouGov survey weights. The coefficients are reported with robust standard errors in parentheses. Main effects of the included moderators are also reported as rows above the moderator treatment effects.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

save_thermo_table(
    file = "../outputs/tables/thermo_ll_ai_results.tex",
    treat = thermo_ll_treat,
    cov = thermo_ll_treat_cov,
    full = full_thermo_ll_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|profile_GOR|pastvote_EURef)",
    coef_rename = c("ai_treatment" = "AI Treatment", "pastvote_EURef" = "EURef Vote", "education_recode" = "Education"),
    title = "AI-Generated Content: Thermometer (leastlikely) Results \\label{tab:thermo-ll-results}",
    notes = "Note: Models weighted using YouGov survey weights. The coefficients are reported with robust standard errors in parentheses. Main effects of the included moderators are also reported as rows above the moderator treatment effects.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

save_thermo_table(
    file = "../outputs/tables/thermo_gap_label_results.tex",
    treat = thermo_gap_label_treat,
    cov = thermo_gap_label_treat_cov,
    full = full_thermo_gap_label_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR)",
    coef_rename = c("label_treatment" = "Label Treatment", "political_attention" = "Political Attention"),
    title = "AI-Labelled Content: Thermometer Gap Results \\label{tab:thermo-gap-label-results}",
    notes = "Note: Models weighted using YouGov survey weights. The coefficients are reported with robust standard errors in parentheses. Main effects of the included moderators are also reported as rows above the moderator treatment effects.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

save_thermo_table(
    file = "../outputs/tables/thermo_ml_label_results.tex",
    treat = thermo_ml_label_treat,
    cov = thermo_ml_label_treat_cov,
    full = full_thermo_ml_label_model,
    coef_omit = "^(political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR)",
    coef_rename = c("label_treatment" = "Label Treatment", "political_attention" = "Political Attention"),
    title = "AI-Labelled Content: Thermometer (mostlikely) Results \\label{tab:thermo-ml-label-results}",
    notes = "Note: Models weighted using YouGov survey weights. The coefficients are reported with robust standard errors in parentheses. Main effects of the included moderators are also reported as rows above the moderator treatment effects.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

save_thermo_table(
    file = "../outputs/tables/thermo_ll_label_results.tex",
    treat = thermo_ll_label_treat,
    cov = thermo_ll_label_treat_cov,
    full = full_thermo_ll_label_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR)",
    coef_rename = c("label_treatment" = "Label Treatment", "profile_gender" = "Gender"),
    title = "AI-Labelled Content: Thermometer (leastlikely) Results \\label{tab:thermo-ll-label-results}",
    notes = "Note: Models weighted using YouGov survey weights. The coefficients are reported with robust standard errors in parentheses. Main effects of the included moderators are also reported as rows above the moderator treatment effects.",
    add_rows = tibble(term = "Model", `Treatment Only` = "(1)", `Treatment + Covariates` = "(2)", `Full Model` = "(3)")
)

# === Add save_ordinal_table() calls here as needed ===
# Create the tables for the ordinal models
# Load the ordinal models for AI treatment
agreedisagree_ai_treat <- readRDS("../outputs/models/agreedisagree_ai_treatment_treat.rds")
agreedisagree_ai_cov <- readRDS("../outputs/models/agreedisagree_ai_treatment_cov.rds")
full_agreedisagree_ai_model <- readRDS("../outputs/models/full_agreedisagree_ai_treatment_model.rds")

xtrust_ai_treat <- readRDS("../outputs/models/xtrust_ai_treatment_treat.rds")
xtrust_ai_cov <- readRDS("../outputs/models/xtrust_ai_treatment_cov.rds")
full_xtrust_ai_model <- readRDS("../outputs/models/full_xtrust_ai_treatment_model.rds")

child_ai_treat <- readRDS("../outputs/models/child_ai_treatment_treat.rds")
child_ai_cov <- readRDS("../outputs/models/child_ai_treatment_cov.rds")
full_child_ai_model <- readRDS("../outputs/models/full_child_ai_treatment_model.rds")

save_ordinal_table(
    file = "../outputs/tables/agreedisagree_ai_results.tex",
    treat = agreedisagree_ai_treat,
    cov = agreedisagree_ai_cov,
    full = full_agreedisagree_ai_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat)",
    coef_rename = c(
        "ai_treatment" = "AI Treatment",
        "education_recodeLow" = "Low Education",
        "education_recodeMedium" = "Medium Education",
        "profile_work_statNot working" = "Not Working",
        "profile_work_statOther" = "Other",
        "profile_work_statRetired" = "Retired",
        "profile_work_statUnemployed" = "Unemployed",
        "profile_work_statWorking full time (30 or more hours per week)" = "Working Full Time",
        "profile_work_statWorking part time (8-29 hours a week)" = "Working PT (8–29h)",
        "profile_work_statWorking part time (Less than 8 hours a week)" = "Working PT (<8h)",
        "ai_treatment:education_recodeLow" = "AI Treatment:Low Education",
        "ai_treatment:education_recodeMedium" = "AI Treatment:Medium Education",
        "ai_treatment:profile_work_statNot working" = "AI Treatment:Not Working",
        "ai_treatment:profile_work_statOther" = "AI Treatment:Other",
        "ai_treatment:profile_work_statRetired" = "AI Treatment:Retired",
        "ai_treatment:profile_work_statUnemployed" = "AI Treatment:Unemployed",
        "ai_treatment:profile_work_statWorking full time (30 or more hours per week)" = "AI Treatment:Working Full Time",
        "ai_treatment:profile_work_statWorking part time (8-29 hours a week)" = "AI Treatment:Working PT (8–29h)",
        "ai_treatment:profile_work_statWorking part time (Less than 8 hours a week)" = "AI Treatment:Working PT (<8h)"
    ),
    title = "AI-Generated Content: Agree Out-Party Respect Beliefs \\label{tab:agreedisagree-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of agreement that opposing partisans respect political beliefs. Threshold cutpoints are included but have no substantive interpretation.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

save_ordinal_table(
    file = "../outputs/tables/xtrust_ai_results.tex",
    treat = xtrust_ai_treat,
    cov = xtrust_ai_cov,
    full = full_xtrust_ai_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR)",
    coef_rename = c(
        "ai_treatment" = "AI Treatment",
        "education_recode" = "Education"
    ),
    title = "AI-Generated Content: Trust in Out-Party to Do What Is Right \\label{tab:xtrust-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of trusting that opposing parties will do what is right for the country. Threshold cutpoints are included but have no substantive interpretation.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

save_ordinal_table(
    file = "../outputs/tables/child_ai_results.tex",
    treat = child_ai_treat,
    cov = child_ai_cov,
    full = full_child_ai_model,
    coef_omit = "^(?!(ai_treatment(:|$))).*|\\|",
    coef_rename = c(
        "ai_treatment" = "AI Treatment",
        "education_recode" = "Education Level",
        "profile_GOR" = "Region"
    ),
    title = "AI-Generated Content: Comfort with Child Marrying Opposing Partisan \\label{tab:child-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of comfort with a child marrying an opposing party voter. Threshold cutpoints are included but have no substantive interpretation.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

# Load the ordinal models for Label treatment
agreedisagree_label_treat <- readRDS("../outputs/models/agreedisagree_label_treatment_treat.rds")
agreedisagree_label_cov <- readRDS("../outputs/models/agreedisagree_label_treatment_cov.rds")
full_agreedisagree_label_model <- readRDS("../outputs/models/full_agreedisagree_label_treatment_model.rds")

xtrust_label_treat <- readRDS("../outputs/models/xtrust_label_treatment_treat.rds")
xtrust_label_cov <- readRDS("../outputs/models/xtrust_label_treatment_cov.rds")
full_xtrust_label_model <- readRDS("../outputs/models/full_xtrust_label_treatment_model.rds")

child_label_treat <- readRDS("../outputs/models/child_label_treatment_treat.rds")
child_label_cov <- readRDS("../outputs/models/child_label_treatment_cov.rds")
full_child_label_model <- readRDS("../outputs/models/full_child_label_treatment_model.rds")

# === Save Label Treatment Ordinal Tables ===
save_ordinal_table(
    file = "../outputs/tables/agreedisagree_label_results.tex",
    treat = agreedisagree_label_treat,
    cov = agreedisagree_label_cov,
    full = full_agreedisagree_label_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|profile_GOR)",
    coef_rename = c(
        "label_treatment" = "Label Treatment",
        "political_attention" = "Political Attention",
        "profile_GOR" = "Region"
    ),
    title = "AI-Labelled Content: Agree Out-Party Respect Beliefs \\label{tab:agreedisagree-label-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of agreement that opposing partisans respect political beliefs. Threshold cutpoints are included but have no substantive interpretation.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

save_ordinal_table(
    file = "../outputs/tables/xtrust_label_results.tex",
    treat = xtrust_label_treat,
    cov = xtrust_label_cov,
    full = full_xtrust_label_model,
    coef_omit = "^(age|political_attention|profile_gender|education_recode|profile_work_stat|pastvote_ge_2024|pastvote_EURef|profile_GOR)",
    coef_rename = c(
        "label_treatment" = "Label Treatment",
        "education_recode" = "Education"
    ),
    title = "AI-Labelled Content: Trust in Out-Party to Do What Is Right \\label{tab:xtrust-label-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of trusting that opposing parties will do what is right for the country. Threshold cutpoints are included but have no substantive interpretation.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)

save_ordinal_table(
    file = "../outputs/tables/child_label_results.tex",
    treat = child_label_treat,
    cov = child_label_cov,
    full = full_child_label_model,
    coef_omit = "^(?!(label_treatment(:|$))).*|\\|",
    coef_rename = c(
        "label_treatment" = "Label Treatment",
        "political_attention" = "Political Attention",
        "profile_GOR" = "Region"
    ),
    title = "AI-Labelled Content: Comfort with Child Marrying Opposing Partisan \\label{tab:child-label-results}",
    notes = "Note: Ordered logistic regression with survey weights and robust standard errors in parentheses. Coefficients represent log-odds of comfort with a child marrying an opposing party voter. Threshold cutpoints are included but have no substantive interpretation.",
    add_rows = tibble::tibble(
        term = "Model",
        `Treatment Only` = "(1)",
        `Treatment + Covariates` = "(2)",
        `Full Model` = "(3)"
    )
)



# === Plotting Logic ===

source("../analysis/thermo_models_plots.R")
source("../analysis/ordinal_models_plots.R")

# === Save Thermometer Plots ===
# Descriptive Statstics Plot
save_thermo_gap_plot(
    yougov_data,
    file = "../outputs/figures/thermo_gap_plot.pdf",
    width = 5,
    height = 3
)

# Patchwork Plos for both AI and Label Treatments
# Generate and save the patchwork plot for AI Treatment
plot_thermo_patchwork(
    models = models_ai,
    treatment_var = "ai_treatment",
    subgroups = subgroups_ai,
    output_file = "../outputs/figures/thermo_patchwork_ai_treatment.pdf"
)

# Generate and save the patchwork plot for Label Treatment
plot_thermo_patchwork(
    models = models_label,
    treatment_var = "label_treatment",
    subgroups = subgroups_label,
    output_file = "../outputs/figures/thermo_patchwork_label_treatment.pdf"
)

# === Save Ordinal Plots ===

# Generate the plots for each significant subgroup to plot
plot_disagreement <- generate_plot_for_outcome(
    data = yougov_data,
    outcome = "agreedisagree",
    treatment = "ai_treatment",
    moderators = moderators_agreedisagree_ai,
    covariates = covariates_agreedisagree_ai,
    moderator_terms = subgroups_agreedisagree,
    collapse_levels = c("Strongly disagree", "Tend to disagree"),
    moderator_labels = subgroup_labels_agreedisagree,
    plot_title = "Do not Respect Beliefs (AI Treatment)"
)

plot_trust <- generate_plot_for_outcome(
    data = yougov_data,
    outcome = "xtrust",
    treatment = "ai_treatment",
    moderators = moderators_xtrust_ai,
    covariates = covariates_xtrust_ai,
    moderator_terms = subgroups_trust,
    collapse_levels = c("Almost never", "Once in a while"),
    moderator_labels = subgroup_labels_trust,
    plot_title = "Do not Trust to do Right (AI Treatment)"
)

plot_discomfort <- generate_plot_for_outcome(
    data = yougov_data,
    outcome = "child",
    treatment = "ai_treatment",
    moderators = moderators_child_ai,
    covariates = covariates_child_ai,
    moderator_terms = subgroups_child,
    collapse_levels = c("Extremely upset", "Somewhat upset"),
    moderator_labels = subgroup_labels_child,
    plot_title = "Discomfort with Marrying Out-Group (AI Treatment)"
)

# Combine plots with patchwork
combined_plot <- plot_disagreement + plot_trust + plot_discomfort +
    plot_layout(ncol = 3, guides = "collect") &
    theme(legend.position = "bottom")

ggsave(
    filename = "../outputs/figures/ordinal_patchwork_ai_treatment.pdf",
    plot = combined_plot,
    width = 10, height = 4
)


# === Save Ordinal Plots for Label Treatment ===

plot_disagreement_label <- generate_plot_for_outcome(
    data = yougov_data,
    outcome = "agreedisagree",
    treatment = "label_treatment",
    moderators = moderators_agreedisagree_label,
    covariates = covariates_agreedisagree_label,
    moderator_terms = subgroups_agreedisagree_label,
    collapse_levels = c("Strongly disagree", "Tend to disagree"),
    moderator_labels = labels_agreedisagree_label,
    plot_title = "Do not Respect Beliefs (Label Treatment)"
)

plot_trust_label <- generate_plot_for_outcome(
    data = yougov_data,
    outcome = "xtrust",
    treatment = "label_treatment",
    moderators = moderators_xtrust_label,
    covariates = covariates_xtrust_label,
    moderator_terms = subgroups_trust_label,
    collapse_levels = c("Almost never", "Once in a while"),
    moderator_labels = subgroup_labels_trust_label,
    plot_title = "Do not Trust to do Right (Label Treatment)"
)

plot_discomfort_label <- generate_plot_for_outcome(
    data = yougov_data,
    outcome = "child",
    treatment = "label_treatment",
    moderators = moderators_child_label,
    covariates = covariates_child_label,
    moderator_terms = subgroups_child_label,
    collapse_levels = c("Extremely upset", "Somewhat upset"),
    moderator_labels = subgroup_labels_child_label,
    plot_title = "Discomfort with Marrying Out-Group (Label Treatment)"
)

# Combine and save
combined_plot_label <- plot_disagreement_label + plot_trust_label + plot_discomfort_label +
    plot_layout(ncol = 3, guides = "collect") &
    theme(legend.position = "bottom")

ggsave(
    filename = "../outputs/figures/ordinal_patchwork_label_treatment.pdf",
    plot = combined_plot_label,
    width = 10, height = 4
)
