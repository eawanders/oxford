# The survey design object created for correctly weighting the YouGov data

# Load required libraries
source(here::here("thesis", "analysis", "packages.R"))

# Survey design for AI treatment analysis
yougov_design_ai <- svydesign(
    ids = ~1,
    data = yougov_data_ai,
    weights = ~weight
)

# Survey design for Label treatment analysis
yougov_design_label <- svydesign(
    ids = ~1,
    data = yougov_data_label,
    weights = ~weight
)

# Survey design for source credibility analysis
yougov_design_labelled_ai <- svydesign(
    ids = ~1,
    data = yougov_data_labelled_ai,
    weights = ~weight
)

names(yougov_design_ai$variables)
