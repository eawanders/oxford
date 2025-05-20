# This script is for the analysis of the YouGov survey data
# The data is from a survey conducted by YouGov  
# === R Script Setup ===

# Load necessary packages using pacman
if (!requireNamespace("pacman", quietly = TRUE)) {
    install.packages("pacman")
}

pacman::p_load(
    tidyverse,
    haven,
    MASS,
    dplyr,
    emmeans,
    ggplot2,
    tableone,
    survey
)

# Set working directory
setwd("/Users/edwardanders/Documents/GitHub/oxford/thesis/data/yougov")


# === Data Import and Review ===

# Load .csv file into R
yougov_data <- read_csv("uniom_results.csv")

# View summary of the data
summary(yougov_data)
str(yougov_data)
glimpse(yougov_data)


# === Data Cleaning and Transformation ===

# Check for missing values
## The only missing values are found in pastvote_ge_2024
## But these are as a result of voted_ge_2024 being
## 'No, did not vote' or 'Don't know'
missing_values <- sapply(yougov_data, function(x) sum(is.na(x)))

# Remove columns that are not needed
yougov_data <- yougov_data %>%
    dplyr::select(-c(
        randMOSTLEAST,
        MLthermo,
        LLthermo
    ))

# Convert any values == 'Not asked' to NA
yougov_data <- yougov_data %>%
    mutate(across(where(is.character), ~ na_if(., "Not asked")))

# Convert any values == '997' to NA
yougov_data <- yougov_data %>%
    mutate(across(where(is.character), ~ na_if(., "997")))

# Convert 'Cant Remember' to NA
yougov_data <- yougov_data %>%
    mutate(
        pastvote_EURef = na_if(pastvote_EURef, "Can’t remember")
    )

# Convert character columns to factors
yougov_data <- yougov_data %>%
    mutate(across(c(
        profile_gender,
        profile_GOR,
        voted_ge_2024,
        pastvote_ge_2024,
        pastvote_EURef,
        profile_education_level,
        education_recode,
        profile_work_stat,
        xconsent,
        mostlikely,
        leastlikely,
        agreedisagree,
        xtrust,
        child,
    ), as.factor))

# Convert relevant columns to numeric
yougov_data <- yougov_data %>%
    mutate(across(c(
        MLthermo_KB,
        MLthermo_KS,
        MLthermo_NF,
        MLthermo_ED,
        MLthermo_CD,
        MLthermo_AR,
        LLthermo_KB,
        LLthermo_KS,
        LLthermo_NF,
        LLthermo_ED,
        LLthermo_CD,
        LLthermo_AR
    ), ~ as.numeric(as.character(.))))

# Remove rows where 'xconsent == I do not with to continue with this study'
yougov_data <- yougov_data %>%
    filter(xconsent != "I do not wish to continue with this study")


# Create new MLthermo and LLthermo mean variables
# Variable is mean of values in MLthermo/LLthermo columns
yougov_data <- yougov_data %>%
    mutate(
        MLthermoMean = rowMeans(pick(starts_with("MLthermo_")), na.rm = TRUE),
        LLthermoMean = rowMeans(pick(starts_with("LLthermo_")), na.rm = TRUE)
    )

# Remove rows where 'mostlikely == None of these'
# and 'leastlikely == None of these'
yougov_data <- yougov_data %>%
    filter(mostlikely != "None of these" & leastlikely != "None of these")



# Refactor child variable
yougov_data <- yougov_data %>%
    mutate(child = na_if(child, "Don't know")) %>%
    mutate(child = na_if(child, "Not Asked"))

yougov_data <- yougov_data %>%
    mutate(child = factor(child,
        levels = c(
            "Extremely upset",
            "Somewhat upset",
            "Neither happy nor upset",
            "Somewhat happy",
            "Extremely happy"
        ),
        ordered = TRUE
    ))

# Refactor `Pastvote_EURef` variable
yougov_data <- yougov_data %>%
    mutate(
        pastvote_EURef = factor(pastvote_EURef),
        pastvote_EURef = relevel(pastvote_EURef, ref = "I voted to Remain")
    )

# Refactor xtrust variable
yougov_data <- yougov_data %>%
    mutate(xtrust = na_if(xtrust, "Don't know"))

yougov_data <- yougov_data %>%
    mutate(xtrust = factor(xtrust,
        levels = c(
            "Almost never",
            "Once in a while",
            "About half of the time",
            "Always",
            "Most of the time"
        ),
        ordered = TRUE
    ))

# Refactor agreedisagree variable
yougov_data <- yougov_data %>%
    mutate(agreedisagree = na_if(agreedisagree, "Don't know"))

yougov_data <- yougov_data %>%
    mutate(agreedisagree = factor(agreedisagree,
        levels = c(
            "Strongly disagree",
            "Tend to disagree",
            "Neither agree nor disagree",
            "Tend to agree",
            "Strongly agree"
        ),
        ordered = TRUE
    ))

# Drop levels from `mostlikely` that have no observations
yougov_data$mostlikely <- droplevels(
    yougov_data$mostlikely
)

# Rename profile_education_level_recode
yougov_data <- yougov_data %>%
    rename(
        education_recode = profile_education_level_recode
    )




# === Thermometer Analysis ===
# Analysis of the thermometer outcome variables on a continuous scale
# Analysis done using weighted least squares regression inc. robust standard errors

library(survey)

# Create thermometer gap variable
yougov_data <- yougov_data %>%
    mutate(thermo_gap = MLthermoMean - LLthermoMean)

# Create AI treatment subset: AI-generated vs Human-generated (no labels)
yougov_data_ai <- yougov_data %>%
    filter(split %in% c(1, 4)) %>%
    mutate(ai_treatment = case_when(
        split == 1 ~ 1,
        split == 4 ~ 0
    ))

# Create Label treatment subset: Labelled AI vs Unlabelled AI
yougov_data_label <- yougov_data %>%
    filter(split %in% c(1, 2)) %>%
    mutate(label_treatment = case_when(
        split == 2 ~ 1,
        split == 1 ~ 0
    ))

# Define survey designs
yougov_design_ai <- svydesign(
    ids = ~1,
    data = yougov_data_ai,
    weights = ~weight
)

yougov_design_label <- svydesign(
    ids = ~1,
    data = yougov_data_label,
    weights = ~weight
)

# Flexible function to run linear models for thermometer outcomes
thermo_models <- function(data,
                          design,
                          outcome = c("thermo_gap", "MLthermoMean", "LLthermoMean"),
                          treatment = c("ai_treatment", "label_treatment"),
                          covariates = NULL,
                          moderators = NULL) {
    for (treat in treatment) {
        for (out in outcome) {
            # Start with treatment as predictor
            rhs <- treat

            # Add covariates (if specified)
            if (!is.null(covariates)) {
                rhs <- c(rhs, covariates)
            }

            # Add moderators and interaction terms (if specified)
            if (!is.null(moderators)) {
                rhs <- c(rhs, moderators, paste(treat, moderators, sep = ":"))
            }

            # Build formula
            formula_spec <- reformulate(termlabels = rhs, response = out)

            # Print model setup
            cat(
                "\n\n=== LINEAR | Outcome:", out,
                "| Treatment:", treat,
                "| Covariates:", if (is.null(covariates)) "None" else paste(covariates, collapse = ", "),
                "| Moderators:", if (is.null(moderators)) "None" else paste(moderators, collapse = ", "), "===\n\n"
            )

            # Fit model
            model <- svyglm(formula = formula_spec, design = design)
            # Cluster SE

            # Output summary
            print(summary(model))
        }
    }
}


# Specify the function call that I want to make
thermo_models(
    data = yougov_data_label,
    design = yougov_design_label,
    treatment = "label_treatment",
    outcome = "thermo_gap",
    covariates = c(
        "age",
        "political_attention",
        "profile_gender",
        "education_recode",
        "profile_work_stat",
        "pastvote_ge_2024",
        "pastvote_EURef",
        "profile_GOR"
    ),
    moderators = c("mostlikely", "profile_work_stat", "profile_GOR")
)

# Specify the function call that I want to make
thermo_models(
    data = yougov_data_label,
    design = yougov_design_label,
    treatment = "label_treatment",
    outcome = "MLthermoMean",
    covariates = c(
        "age",
        "political_attention",
        "profile_gender",
        "education_recode",
        "profile_work_stat",
        "pastvote_ge_2024",
        "pastvote_EURef",
        "profile_GOR"
    ),
    moderators = c("political_attention", "profile_work_stat", "profile_GOR", "mostlikely")
)


# Specify the function call that I want to make
thermo_models(
    data = yougov_data_label,
    design = yougov_design_label,
    treatment = "label_treatment",
    outcome = "LLthermoMean",
    covariates = c(
        "age",
        "political_attention",
        "profile_gender",
        "education_recode",
        "profile_work_stat",
        "pastvote_ge_2024",
        "pastvote_EURef",
        "profile_GOR"
    ),
    moderators = c("mostlikely", "profile_work_stat")
)


# === Additional Outcome Variable Analysis ===

# Function to run ordinal logistic regression models
# for the collapsed outcome variables and treatment groups
ordinal_models <- function(data,
                           design,
                           outcome = c("agreedisagree", "xtrust", "child"),
                           treatment = c("ai_treatment", "label_treatment"),
                           moderators = NULL,
                           covariates = NULL) {
    for (treat in treatment) {
        for (out in outcome) {
            # Start with treatment as predictor
            rhs <- treat

            # Add covariates (if specified)
            if (!is.null(covariates)) {
                rhs <- c(rhs, covariates)
            }

            # Add moderators and interactions with treatment
            if (!is.null(moderators)) {
                rhs <- c(
                    rhs, moderators,
                    paste(treat, moderators, sep = ":")
                )
            }

            # Create formula
            formula_spec <- reformulate(termlabels = rhs, response = out)

            # Print model setup
            cat(
                "\n\n=== ORDINAL | Outcome:", out,
                "| Treatment:", treat,
                "| Covariates:", if (is.null(covariates)) "None" else paste(covariates, collapse = ", "),
                "| Moderators:", if (is.null(moderators)) "None" else paste(moderators, collapse = ", "), "===\n\n"
            )

            # Fit model
            model <- svyolr(formula = formula_spec, design = design)

            # Output summary
            print(summary(model))
        }
    }
}

# Call the function to run the models
ordinal_models(
    data = yougov_data_label,
    design = yougov_design_label,
    treatment = "label_treatment",
    outcome = "child",
    covariates = c(
        "age",
        "political_attention",
        "profile_gender",
        "education_recode",
        "profile_work_stat",
        "pastvote_ge_2024",
        "pastvote_EURef",
        "profile_GOR"
    ),
    moderators = c("profile_gender", "profile_GOR", "pastvote_EURef")
)

ordinal_models(
    data = yougov_data_ai,
    design = yougov_design_ai,
    treatment = "ai_treatment",
    outcome = "xtrust",
    covariates = NULL,
    moderators = c("mostlikely", "profile_work_stat")
)

ordinal_models(
    data = yougov_data_label,
    design = yougov_design_label,
    treatment = "label_treatment",
    outcome = "agreedisagree",
    moderators = c("mostlikely")
)
