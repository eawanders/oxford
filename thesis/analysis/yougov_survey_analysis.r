# The following code is used to analyze the YouGov survey data

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
    tableone
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

# Convert character columns to factors
yougov_data <- yougov_data %>%
    mutate(across(c(
        profile_gender,
        profile_GOR,
        voted_ge_2024,
        pastvote_ge_2024,
        pastvote_EURef,
        profile_education_level,
        profile_education_level_recode,
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


# Create a new treatment status variable for AI-generated content
## Where treatment == 1, the respondent was shown AI-generated content
## Where treatment == 0, the respondent was shown human-generated content
## When 'split == 1 or 2', the respondent was shown AI-generated content
yougov_data <- yougov_data %>%
    mutate(ai_treatment = case_when(
        split == 1 ~ 1,
        split == 2 ~ 1,
        split == 3 ~ 0,
        split == 4 ~ 0,
        TRUE ~ NA_real_
    ))

# Create a new treatment status variable for AI-labelled content
## Where treatment == 1, respondents shown content labelled as AI-generated
## Where treatment == 0, respondents shown content labelled as human-generated
## When 'split == 2 or 3', the respondent was shown AI-labelled content
yougov_data <- yougov_data %>%
    mutate(label_treatment = case_when(
        split == 2 ~ 1,
        split == 3 ~ 1,
        split == 1 ~ 0,
        split == 4 ~ 0,
        TRUE ~ NA_real_
    ))

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

# Refactor xtrust variable
yougov_data <- yougov_data %>%
    mutate(xtrust = na_if(xtrust, "Don't know"))

yougov_data <- yougov_data %>%
    mutate(xtrust = factor(xtrust,
        levels = c(
            "Almost never",
            "Once in a while",
            "About hald of the time",
            "Always",
            "Most of the time",
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




# === Balance Check ===
# Create a balance table for some socio-demographic variables
# Use function to test across different treatment groups

# Define a reusable function for covariate balance checking
balance_table <- function(data, strata_var, covariates) {
    table <- tableone::CreateTableOne(
        vars = unlist(covariates),
        strata = strata_var,
        data = data,
        factorVars = covariates$categorical
    )

    print(table, noSpaces = TRUE, showAllLevels = TRUE, test = TRUE)
}

# Define the treatment and control groups to test balance across
treatment_vars <- c("ai_treatment", "label_treatment")

# Define the covariates for balance checking
covariates <- list(
    continuous = c("age", "political_attention"),
    categorical = c(
        "profile_gender",
        "profile_education_level_recode",
        "profile_work_stat",
        "voted_ge_2024",
        "pastvote_ge_2024",
        "pastvote_EURef",
        "profile_GOR"
    )
)

all_covariates <- c(covariates$continuous, covariates$categorical)

# Run the balance table function for each treatment variable
for (strata_var in treatment_vars) {
    balance_table(yougov_data, strata_var, covariates)
}

# The balance check shows that randomisation was successful across
# all covariates for both treatment groups



# === Thermometer Analysis ===
# Create a new variable for the difference between MLthermo and LLthermo
yougov_data <- yougov_data %>%
    mutate(thermo_gap = MLthermoMean - LLthermoMean)

# Function to run models for different treatment,
# outcome, and covariate combinations
thermo_models <- function(data) {
    treatment_vars <- c("ai_treatment", "label_treatment")
    outcome_vars <- c("thermo_gap", "MLthermoMean", "LLthermoMean")

    covariates <- c(
        "age",
        "political_attention",
        "profile_gender",
        "profile_education_level_recode",
        "profile_work_stat",
        "pastvote_ge_2024",
        "pastvote_EURef",
        "profile_GOR"
    )

    for (treatment in treatment_vars) {
        for (outcome in outcome_vars) {
            for (include_covariates in c(TRUE, FALSE)) {
                # Directly define formula terms based on whether covariates are included
                regression_specification <- reformulate(
                    termlabels = if (include_covariates) {
                        c(treatment, covariates)
                    } else {
                        treatment
                    },
                    response = outcome
                )

                model <- lm(formula = regression_specification, data = data)
                print(summary(model))
            }
        }
    }
}

# Call the function to run the models
thermo_models(yougov_data)


# === Additional Outcome Variable Analysis ===
ordinal_models <- function(data) {
    # Define outcome variables (all ordinal factors)
    outcome_vars <- c("agreedisagree", "xtrust", "child")

    # Define treatment variables
    treatment_vars <- c("ai_treatment", "label_treatment")

    # Loop over all outcome-treatment combinations
    for (outcome in outcome_vars) {
        for (treatment in treatment_vars) {
            cat("\n\n=== Outcome:", outcome, "| Treatment:", treatment, "===\n\n")

            # Build regression formula without covariates
            regression_specification <- reformulate(
                termlabels = treatment,
                response = outcome
            )

            # Fit ordinal logistic regression model
            model <- polr(
                formula = regression_specification,
                data = data,
                Hess = TRUE
            )

            # Predicted probabilities by treatment group
            predicted_probs <- emmeans(
                model,
                specs = as.formula(paste0("~", treatment)),
                mode = "prob",
                at = list() # prevents generating massive grids
            )

            # Print predicted probabilities
            print(predicted_probs)

            # Compare predicted probabilities across treatment groups
            print(pairs(predicted_probs))
        }
    }
}
# Call the function to run the models
ordinal_models(yougov_data)


for (outcome in c("agreedisagree", "xtrust", "child")) {
    for (treatment in c("ai_treatment", "label_treatment")) {
        cat("\n\n===", outcome, "by", treatment, "===\n")
        print(table(yougov_data[[outcome]], yougov_data[[treatment]], useNA = "ifany"))
    }
}

for (outcome in c("agreedisagree", "xtrust", "child")) {
    for (treatment in c("ai_treatment", "label_treatment")) {
        n <- nrow(yougov_data %>% select(all_of(c(outcome, treatment))) %>% drop_na())
        cat(outcome, "with", treatment, "→ complete cases:", n, "\n")
    }
}

## NEXT: combine high and low outcomes into one
