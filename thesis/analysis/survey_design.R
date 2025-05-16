# The survey design object created for correctly weighting the YouGov data

yougov_design <- svydesign(
    ids = ~1,
    data = yougov_data,
    weights = ~weight
)
