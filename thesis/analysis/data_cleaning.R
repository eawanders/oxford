# This script cleans the YouGov data for analysis

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

# Refactor pastvote_EURef variable
yougov_data <- yougov_data %>%
    mutate(
        pastvote_EURef = na_if(pastvote_EURef, "Can’t remember"),
        pastvote_EURef = droplevels(pastvote_EURef),
        pastvote_EURef = relevel(pastvote_EURef, ref = "I voted to Remain")
    )

# Rename profile_education_level_recode
yougov_data <- yougov_data %>%
    rename(
        education_recode = profile_education_level_recode
    )

# Drop levels from `mostlikely` that have no observations
yougov_data$mostlikely <- droplevels(
    yougov_data$mostlikely
)

# Create a new `thermo_gap` variable for the difference between MLthermo and LLthermo
yougov_data <- yougov_data %>%
    mutate(thermo_gap = MLthermoMean - LLthermoMean)

# Create AI treatment subset: AI-generated vs Human-generated (no labels)
yougov_data_ai <- yougov_data %>%
    filter(split %in% c(1, 4)) %>%
    mutate(ai_treatment = case_when(
        split == 1 ~ 1, # AI-generated, unlabelled
        split == 4 ~ 0 # Human-generated, unlabelled
    ))

# Create Label treatment subset: Labelled AI vs Unlabelled AI
yougov_data_label <- yougov_data %>%
    filter(split %in% c(1, 2)) %>%
    mutate(label_treatment = case_when(
        split == 2 ~ 1, # AI-generated, labelled
        split == 1 ~ 0 # AI-generated, unlabelled
    ))
