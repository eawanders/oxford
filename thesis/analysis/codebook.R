# Add here package for robust file path handling
library(here)
# This script generates a codebook for the YouGov UniOM Survey data.

# Codebook definition into a tibble
codebook <- tribble(
    ~Variable, ~Type, ~Description, ~Values,
    "identity_client", "Identifier", "Unique identifier for the respondent", "Alphanumeric string",
    "weight", "Continuous", "Survey weight to ensure national representativeness", "Continuous float (e.g., 0.982, 1.034)",
    "age", "Continuous", "Age of the respondent", "Integer values, typically 18–90",
    "profile_gender", "Categorical", "Gender of the respondent", "Female; Male",
    "profile_GOR", "Categorical", "Government Office Region (region of residence)", "East Midlands; East of England; London; North East; North West; Scotland; South East; South West; Wales; West Midlands; Yorkshire and the Humber",
    "voted_ge_2024", "Categorical", "Did the respondent vote in the 2024 General Election?", "Don’t know; No, did not vote; Yes, voted",
    "pastvote_ge_2024", "Categorical", "How the respondent voted in the 2024 General Election", "Conservative; Don't know; Green; Labour; Liberal Democrat; Other; Plaid Cymru; Reform UK; Scottish National Party (SNP); Skipped",
    "pastvote_EURef", "Categorical", "How the respondent voted in the 2016 EU Referendum", "Can’t remember; I did not vote; I voted to Leave; I voted to Remain",
    "education_recode", "Categorical", "Re-coded education level (grouped)", "High; Medium; Low",
    "profile_work_stat", "Categorical", "Employment status", "Full time student; Not working; Other; Retired; Unemployed; Working full time (30+ hrs); Working part time (8–29 hrs); Working part time (<8 hrs)",
    "political_attention", "Continuous", "How much attention the respondent pays to politics", "Scale (e.g., 0–10 or continuous values)",
    "split", "Categorical", "Randomly assigned treatment group (1–4)", "1 = AI-generated, not labelled as AI-generated; 2 = AI-generated and labelled as AI-generated; 3 = Human-generated but labelled as AI-generated; 4 = Human-generated, not labelled as AI-generated",
    "xconsent", "Categorical", "Consent to participate in the survey", "I consent to taking part in this study; I do not wish to continue with this study",
    "mostlikely", "Categorical", "Which of these parties would you be most likley to vote for?", "Conservative Party; Green Party; Labour Party; Liberal Democrats; Reform UK",
    "leastlikely", "Categorical", "Which of these parties would you be least likley to vote for?", "Conservative Party; Green Party; Labour Party; Liberal Democrats; Reform UK; None of these; Not Asked",
    "MLthermo_KB", "Continuous", "Thermometer rating for Kemi Badenoch (most likely party)", "0–100",
    "MLthermo_KS", "Continuous", "Thermometer rating for Keir Starmer", "0–100",
    "MLthermo_NF", "Continuous", "Thermometer rating for Nigel Farage", "0–100",
    "MLthermo_ED", "Continuous", "Thermometer rating for Ed Davey", "0–100",
    "MLthermo_CD", "Continuous", "Thermometer rating for Carla Denyer", "0–100",
    "MLthermo_AR", "Continuous", "Thermometer rating for Adrian Ramsay", "0–100",
    "LLthermo_KB", "Continuous", "Thermometer rating for Kemi Badenoch (least likely party)", "0–100",
    "LLthermo_KS", "Continuous", "Thermometer rating for Keir Starmer", "0–100",
    "LLthermo_NF", "Continuous", "Thermometer rating for Nigel Farage", "0–100",
    "LLthermo_ED", "Continuous", "Thermometer rating for Ed Davey", "0–100",
    "LLthermo_CD", "Continuous", "Thermometer rating for Carla Denyer", "0–100",
    "LLthermo_AR", "Continuous", "Thermometer rating for Adrian Ramsay", "0–100",
    "agreedisagree", "Ordinal", "Trait-based measure of whether out-groups respect in-group beliefs ", "Strongly disagree; Tend to disagree; Neither agree nor disagree; Tend to agree; Strongly agree",
    "xtrust", "Ordinal", "Level of trust in out-group to do what is right", "Almost never; Once in a while; About half of the time; Most of the time; Always",
    "child", "Ordinal", "Social-disance measure of a child marry an out-group voter", "Extremely upset; Somewhat upset; Neither happy nor upset; Somewhat happy; Extremely happy",
    "MLthermoMean", "Continuous", "Average thermometer score for most likely party", "0–100 (row mean of MLthermo scores)",
    "LLthermoMean", "Continuous", "Average thermometer score for least likely party", "0–100 (row mean of LLthermo scores)",
    "thermo_gap", "Continuous", "Difference between MLthermoMean and LLthermoMean", "0–100 (MLthermoMean - LLthermoMean)",
    "ai_treatment", "Binary", "Treatment status for AI-generated content", "1 = Treated (shown AI-generated); 0 = Control (shown human-generated)",
    "label_treatment", "Binary", "Treatment status for AI-labelled content", "1 = Treated (labelled as AI-generated); 0 = Control (labelled as human-generated)"
)

codebook <- codebook %>%
    mutate(Variable = paste0("\\verb|", Variable, "|"))

create_codebook_table <- function() {
    as.character(
        kable(
            codebook,
            format = "latex",
            booktabs = TRUE,
            longtable = TRUE,
            escape = FALSE,
            caption = "YouGov UniOM Survey Codebook \\label{tab:codebook-table}"
        ) %>%
            kable_styling(
                latex_options = c("repeat_header"),
                font_size = 9
            ) %>%
            column_spec(1, width = "3.2cm") %>%
            column_spec(3, width = "5cm") %>%
            column_spec(4, width = "5cm")
    )
}


 # Save the codebook table as a LaTeX file
save_codebook_table <- function(file = here("thesis", "outputs", "tables", "codebook_table.tex")) {
    kb <- kable(
        codebook,
        format = "latex",
        booktabs = TRUE,
        longtable = TRUE,
        escape = FALSE,
        caption = "YouGov UniOM Survey Codebook"
    ) %>%
        kable_styling(
            latex_options = c("repeat_header"),
            font_size = 9
        ) %>%
        column_spec(1, width = "3.2cm") %>%
        column_spec(3, width = "5cm") %>%
        column_spec(4, width = "5cm")
    writeLines(kb, file)
}

# Actually run to save
save_codebook_table()
