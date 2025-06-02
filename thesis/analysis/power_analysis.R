# Load required packages
library(dplyr)
library(tidyr)
library(purrr)
library(broom)
library(modelr)
library(here)
library(ggplot2)

# Set variables
outcome <- "thermo_gap"
treatment <- "ai_treatment"

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

moderators <- c("mostlikely", "political_attention", "education_recode")

# Load previously estimated model
base_model <- readRDS(here("thesis", "outputs", "models", "full_thermo_gap_ai_treatment_model.rds"))
complete_data <- model.frame(base_model)
coefs <- coef(base_model)
resid_sd <- sigma(base_model)
terms_obj <- terms(base_model)

# Set assumed treatment effect
tau <- 5

# Parametric simulation function
generate_data <- function(n, tau, resid_sd = 1) {
    # Simulate covariates
    age <- rnorm(n, mean = 50, sd = 15)
    political_attention <- rnorm(n, mean = 5, sd = 2)
    gender <- rbinom(n, 1, 0.5) # 1 = male
    education <- factor(sample(c("Low", "Medium", "High"), n, replace = TRUE, prob = c(0.3, 0.5, 0.2)))

    # Simulate treatment assignment
    Z <- rbinom(n, 1, 0.5)

    # Model matrix
    X <- model.matrix(~ Z + age + political_attention + gender + education)

    # Coefficients: assume known values, including tau for treatment
    beta <- setNames(rep(0.1, ncol(X)), colnames(X))
    beta["Z"] <- tau

    # Generate outcome
    Y <- as.numeric(X %*% beta + rnorm(n, 0, resid_sd))

    return(data.frame(Y = Y, Z = Z))
}

# Run simulations and compute power
run_simulations <- function(n, tau, resid_sd = 50, reps = 1000, alpha = 0.05) {
    pvals <- replicate(reps, {
        df <- generate_data(n, tau, resid_sd)
        fit <- lm(Y ~ Z, data = df)
        summary(fit)$coefficients["Z", "Pr(>|t|)"]
    })
    mean(pvals < alpha)
}

# Run for specific sample size
set.seed(123)
power_result <- run_simulations(n = 500, tau = tau)

cat("Estimated Power at N = 500:", power_result, "\n")

# Run across a range of sample sizes
sample_sizes <- seq(500, 5000, by = 500)
power_results <- sapply(sample_sizes, function(n) run_simulations(n, tau = tau))

# Create a data frame of results
power_df <- data.frame(
    SampleSize = sample_sizes,
    EstimatedPower = power_results
)

print(power_df)

# Plot the results using thesis styling
p <- ggplot2::ggplot(power_df, ggplot2::aes(x = SampleSize, y = EstimatedPower)) +
    ggplot2::geom_line() +
    ggplot2::geom_point() +
    ggplot2::geom_hline(yintercept = 0.8, linetype = "dashed", colour = "grey40") +
    ggplot2::labs(
        x = "Sample Size",
        y = "Estimated Power"
    ) +
    ggplot2::ylim(0, 1) +
    ggplot2::theme_classic(base_family = "serif") +
    ggplot2::theme(
        axis.title.x = ggplot2::element_text(size = 10, margin = ggplot2::margin(t = 10)),
        axis.title.y = ggplot2::element_text(size = 10, margin = ggplot2::margin(r = 10)),
        axis.text = ggplot2::element_text(size = 9),
        legend.title = ggplot2::element_text(size = 9),
        legend.text = ggplot2::element_text(size = 9)
    )

print(p)

ggplot2::ggsave(
    filename = here("thesis", "outputs", "figures", "power_analysis.pdf"),
    plot = p,
    width = 5,
    height = 3,
    units = "in"
)
