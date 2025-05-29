# This file contains the code to create balance tables for covariates by treatment groups.

library(here)

# Function to create and save a formatted balance table as .tex
save_balance_table <- function(data, treatment_var, covariates, caption, file, treatment_levels = c("Control", "Treatment")) {
    actual_levels <- levels(factor(data[[treatment_var]]))

    clean_names <- c(
        "age..mean..SD.." = "Age",
        "political_attention..mean..SD.." = "Political attention",
        "profile_gender...." = "Gender (male)",
        "X" = "Female",
        "education_recode...." = "Education level (High)",
        "X.1" = "Low",
        "X.2" = "Medium",
        "profile_work_stat...." = "Employment status (Full time student)",
        "X.3" = "Not working",
        "X.4" = "Other",
        "X.5" = "Retired",
        "X.6" = "Unemployed",
        "X.7" = "Working full time (30 or more hours per week)",
        "X.8" = "Working part time (8-29 hours a week)",
        "X.9" = "Working part time (Less than 8 hours a week)",
        "voted_ge_2024...." = "Voted in 2024 General Election (Don't know)",
        "X.10" = "No, did not vote",
        "X.11" = "Yes, voted",
        "pastvote_ge_2024...." = "Vote in 2024 General Election (Conservative)",
        "X.12" = "Don't know",
        "X.13" = "Green",
        "X.14" = "Labour",
        "X.15" = "Liberal Democrat",
        "X.16" = "Other",
        "X.17" = "Plaid Cymru",
        "X.18" = "Reform UK",
        "X.19" = "Scottish National Party (SNP)",
        "X.20" = "Skipped",
        "pastvote_EURef...." = "Vote in EU Referendum (Can’t remember)",
        "X.21" = "I did not vote",
        "X.22" = "I voted to Leave",
        "X.23" = "I voted to Remain",
        "profile_GOR...." = "Region (East Midlands)",
        "X.24" = "East of England",
        "X.25" = "London",
        "X.26" = "North East",
        "X.27" = "North West",
        "X.28" = "Scotland",
        "X.29" = "South East",
        "X.30" = "South West",
        "X.31" = "Wales",
        "X.32" = "West Midlands",
        "X.33" = "Yorkshire and the Humber"
    )

    # Create the balance table object
    balance_tbl_object <- tableone::CreateTableOne(
        vars = unlist(c(covariates$continuous, covariates$categorical)),
        strata = treatment_var,
        data = data,
        factorVars = covariates$categorical,
        test = TRUE
    )

    # Extract and format results
    balance_df <- print(balance_tbl_object,
        noSpaces = TRUE,
        showAllLevels = TRUE,
        printToggle = FALSE,
        test = TRUE
    ) %>%
        as.data.frame.matrix() %>%
        dplyr::select(actual_levels[1], actual_levels[2], "p") %>%
        setNames(c(treatment_levels[1], treatment_levels[2], "p-value")) %>%
        tibble::rownames_to_column("Variable") %>%
        dplyr::filter(Variable != "n") %>%
        dplyr::mutate(
            Variable = Variable %>%
                stringr::str_remove(fixed(" (mean (SD))")) %>%
                stringr::str_replace("=", " ") %>%
                stringr::str_remove("\\s\\(%\\)$") %>%
                dplyr::recode(!!!clean_names),
            `p-value` = as.numeric(`p-value`),
            Signif. = dplyr::case_when(
                `p-value` < 0.001 ~ "***",
                `p-value` < 0.01 ~ "**",
                `p-value` < 0.05 ~ "*",
                `p-value` > 0.05 ~ "-",
                TRUE ~ ""
            ),
            `p-value` = format.pval(`p-value`, digits = 3, eps = 0.001)
        )

    # Save as LaTeX table
    kableExtra::kable(balance_df,
        format = "latex",
        booktabs = TRUE,
        caption = caption,
        align = c("l", "c", "c", "c", "c"),
        col.names = c("Variable", treatment_levels[1], treatment_levels[2], "p-value", "Signif.")
    ) %>%
        kableExtra::kable_styling(
            font_size = 10
        ) %>%
        kableExtra::footnote(
            general = "P-values are from t-tests (continuous) or chi-squared tests (categorical) comparing groups. \\\\ Significance levels: * p < 0.05, ** p < 0.01, *** p < 0.001.",
            threeparttable = TRUE,
            escape = FALSE
        ) %>%
        kableExtra::save_kable(file)
}

# Covariates and treatments (keep these outside the function)
balance_covariates <- list(
    continuous = c("age", "political_attention"),
    categorical = c(
        "profile_gender",
        "education_recode",
        "profile_work_stat",
        "voted_ge_2024",
        "pastvote_ge_2024",
        "pastvote_EURef",
        "profile_GOR"
    )
)

# Generate balance tables for AI and Label treatments
cat(save_balance_table(
    data = yougov_data_ai,
    treatment_var = "ai_treatment",
    covariates = balance_covariates,
    caption = "Balance Table of Covariates by AI Treatment Group \\label{tab:ai-balance}",
    file = here("thesis", "outputs", "tables", "balance_ai_treatment.tex")
))

cat(save_balance_table(
    data = yougov_data_label,
    treatment_var = "label_treatment",
    covariates = balance_covariates,
    caption = "Balance Table of Covariates by Label Treatment Group \\label{tab:label-balance}",
    file = here("thesis", "outputs", "tables", "balance_label_treatment.tex")
))
