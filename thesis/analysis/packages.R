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
    survey,
    kableExtra,
    stringr,
    purrr,
    tibble,
    modelsummary,
    equatiomatic,
    knitr,
    ggeffects,
    patchwork
)
