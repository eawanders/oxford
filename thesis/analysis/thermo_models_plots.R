# --- Helper: Extract means and standard errors from model for Control and Treatment groups for Liberal Democrat subgroup ---

get_means_ldem <- function(model, treatment_var) {
    coefs <- coef(model)
    ses <- sqrt(diag(vcov(model)))

    interaction_term <- paste0(treatment_var, ":mostlikelyLiberal Democrats")

    main_mostlikely <- coefs["mostlikelyLiberal Democrats"]
    main_mostlikely_se <- ses["mostlikelyLiberal Democrats"]
    intercept <- coefs["(Intercept)"]
    intercept_se <- ses["(Intercept)"]
    treatment_effect <- coefs[treatment_var]
    treatment_se <- ses[treatment_var]
    interaction_effect <- coefs[interaction_term]
    interaction_se <- ses[interaction_term]

    mean_control <- intercept + main_mostlikely
    mean_treat <- intercept + main_mostlikely + treatment_effect + interaction_effect

    se_control <- sqrt(intercept_se^2 + main_mostlikely_se^2)
    se_treat <- sqrt(intercept_se^2 + main_mostlikely_se^2 + treatment_se^2 + interaction_se^2)

    tibble(
        Group = c("Control", "Treatment"),
        Mean = pmax(0, pmin(c(mean_control, mean_treat), 100)),
        SE = c(se_control, se_treat)
    )
}
# --- Plot function for Liberal Democrat subgroup (Most Likely) ---
plot_ate_ldem <- function(models, treatment_var, title) {
    all_means <- bind_rows(
        get_means_ldem(models$ML, treatment_var) %>% mutate(Outcome = "Most Likely"),
        get_means_ldem(models$LL, treatment_var) %>% mutate(Outcome = "Least Likely"),
        get_means_ldem(models$GAP, treatment_var) %>% mutate(Outcome = "Thermometer Gap")
    )
    colours <- c("Most Likely" = "#4b4b4b", "Least Likely" = "#bdbdbd", "Thermometer Gap" = "black")
    ggplot(all_means, aes(x = Group, y = Mean, group = Outcome, colour = Outcome, linetype = Outcome)) +
        geom_line(size = 0.75) +
        geom_point(size = 2) +
        geom_errorbar(aes(ymin = Mean - SE, ymax = Mean + SE), width = 0.2, position = position_dodge(width = 0.2)) +
        scale_colour_manual(values = colours) +
        scale_linetype_manual(values = c("Most Likely" = "solid", "Least Likely" = "solid", "Thermometer Gap" = "solid")) +
        labs(
            x = NULL,
            y = "Thermometer Score",
            colour = NULL,
            linetype = NULL,
            title = title
        ) +
        theme_classic(base_family = "serif") +
        ylim(0, 100) +
        theme(
            axis.title.y = element_text(size = 10, family = "serif"),
            axis.text.x = element_text(angle = 0, hjust = 0.5, size = 9, family = "serif"),
            axis.text = element_text(size = 9, family = "serif"),
            legend.text = element_text(size = 9, family = "serif"),
            plot.title = element_text(size = 10, family = "serif", hjust = 0.5),
            legend.position = "bottom"
        )
}
# Script to create plots for Average Treatment Effects (ATE) from Thermometer Models

# --- Helper: Extract means and standard errors from model for Control and Treatment groups ---
get_means <- function(model, treatment_var) {
    coefs <- coef(model)
    ses <- sqrt(diag(vcov(model)))
    if (!"(Intercept)" %in% names(coefs)) stop("Intercept not found in model coefficients.")
    if (!treatment_var %in% names(coefs)) {
        stop(paste0(
            "Treatment variable '", treatment_var, "' not found in model coefficients.\n",
            "Available coefficients: ", paste(names(coefs), collapse = ", ")
        ))
    }
    intercept <- coefs["(Intercept)"]
    intercept_se <- ses["(Intercept)"]
    treatment_effect <- coefs[treatment_var]
    treatment_se <- ses[treatment_var]
    res <- tibble(
        Group = c("Control", "Treatment"),
        Mean = c(intercept, intercept + treatment_effect),
        SE = c(intercept_se, sqrt(intercept_se^2 + treatment_se^2))
    )
    return(res)
}

# --- Plot function for a single scenario (AI, Source Cred, Detection) ---
plot_ate <- function(models, treatment_var, title) {
    outcome_labels <- c("MLthermoMean", "LLthermoMean", "thermo_gap")
    pretty_outcomes <- c("Most Likely", "Least Likely", "Thermometer Gap")
    colours <- c("Most Likely" = "#4b4b4b", "Least Likely" = "#bdbdbd", "Thermometer Gap" = "black")

    all_means <- bind_rows(
        get_means(models$ML, treatment_var) %>% mutate(Outcome = "Most Likely"),
        get_means(models$LL, treatment_var) %>% mutate(Outcome = "Least Likely"),
        get_means(models$GAP, treatment_var) %>% mutate(Outcome = "Thermometer Gap")
    )
    # Truncate Mean values to [0, 100]
    all_means <- all_means %>%
        mutate(Mean = pmax(0, pmin(Mean, 100)))

    p <- ggplot(all_means, aes(x = Group, y = Mean, group = Outcome, colour = Outcome, linetype = Outcome)) +
        geom_line(size = 0.75) +
        geom_point(size = 2) +
        geom_errorbar(aes(ymin = Mean - SE, ymax = Mean + SE), width = 0.2, position = position_dodge(width = 0.2)) + # Error bars represent ±1 SE (edit as needed for 95% CI)
        scale_colour_manual(values = colours) +
        scale_linetype_manual(values = c("Most Likely" = "solid", "Least Likely" = "solid", "Thermometer Gap" = "solid")) +
        labs(
            x = NULL,
            y = "Thermometer Score",
            colour = NULL,
            linetype = NULL,
            title = title
        ) +
        theme_classic(base_family = "serif") +
        ylim(0, 100) +
        theme(
            axis.title.y = element_text(size = 10, family = "serif"),
            axis.text.x = element_text(angle = 0, hjust = 0.5, size = 9, family = "serif"),
            axis.text = element_text(size = 9, family = "serif"),
            legend.text = element_text(size = 9, family = "serif"),
            plot.title = element_text(size = 10, family = "serif", hjust = 0.5),
            legend.position = "bottom"
        )
    return(p)
}

# --- Models: Assign using your actual objects ---
models_ai <- list(
    ML = full_thermo_ml_model,
    LL = full_thermo_ll_model,
    GAP = full_thermo_gap_model
)
models_labelled_ai <- list(
    ML = full_thermo_ml_labelled_ai_model,
    LL = full_thermo_ll_labelled_ai_model,
    GAP = full_thermo_gap_labelled_ai_model
)
models_label <- list(
    ML = full_thermo_ml_label_model,
    LL = full_thermo_ll_label_model,
    GAP = full_thermo_gap_label_model
)

# --- Create each plot ---
plot_ai <- plot_ate(models_ai, "ai_treatment", "AI Effect (Discounting and Detection)")
plot_sourcecred <- plot_ate(models_labelled_ai, "labelled_ai_treatment", "Credibility Effect")
plot_detection <- plot_ate(models_label, "label_treatment", "Detection Effect")

# --- Combine into 1x3 patchwork ---
overall_patchwork <- plot_ai + plot_sourcecred + plot_detection +
    plot_layout(ncol = 3, guides = "collect") &
    theme(legend.position = "bottom")

# --- Save the patchwork plot ---
ggsave(
    filename = here::here("thesis", "outputs", "figures", "thermo_patchwork_overall.pdf"),
    plot = overall_patchwork,
    width = 12, height = 4
)


# --- Liberal Democrat (Most Likely) subgroup 1x3 patchwork ---
plot_ai_ldem <- plot_ate_ldem(models_ai, "ai_treatment", "AI Effect (Discounting and Detection))")
plot_sourcecred_ldem <- plot_ate_ldem(models_labelled_ai, "labelled_ai_treatment", "Credibility Effect")
plot_detection_ldem <- plot_ate_ldem(models_label, "label_treatment", "Detection Effect")

patchwork_ldem <- plot_ai_ldem + plot_sourcecred_ldem + plot_detection_ldem +
    plot_layout(ncol = 3, guides = "collect") &
    theme(legend.position = "bottom")

ggsave(
    filename = here::here("thesis", "outputs", "figures", "thermo_patchwork_ldem.pdf"),
    plot = patchwork_ldem,
    width = 12, height = 4
)
