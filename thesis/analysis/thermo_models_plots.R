#' Create a patchwork plot for thermometer models
#'
#' @param models        A named list with model objects. Should include models for MLthermoMean, LLthermoMean, and thermo_gap.
#' @param treatment_var The name of the treatment variable as string, e.g. "ai_treatment" or "label_treatment".
#' @param subgroups     A named list, where each element is a list with:
#'                      - name: string to show in plot
#'                      - interaction_terms: named vector, outcome -> interaction term for each outcome model (e.g. c(MLthermoMean="ai_treatment:mostlikelyGreen Party", ...))
#' @param output_file   Path for the saved plot
#' @param width, height Plot dimensions (inches)

plot_thermo_patchwork <- function(models, treatment_var, subgroups, output_file,
                                  width = 7.5, height = 6.5) {
    # Helper for means
    get_means <- function(model, treatment_var) {
        coefs <- coef(model)
        intercept <- coefs["(Intercept)"]
        treatment_effect <- coefs[treatment_var]
        tibble(
            Group = c("Control", "Treatment"),
            Mean = c(intercept, intercept + treatment_effect)
        )
    }
    # Helper for interaction means
    get_interaction_means <- function(model, treatment_var, interaction_term) {
        coefs <- coef(model)
        intercept <- coefs["(Intercept)"]
        treatment_effect <- coefs[treatment_var]
        interaction_effect <- ifelse(!is.null(interaction_term) && interaction_term %in% names(coefs), coefs[interaction_term], 0)
        tibble(
            Group = c("Control", "Treatment"),
            Mean = c(intercept, intercept + treatment_effect + interaction_effect)
        )
    }
    # Standard plot function
    standardise_plot <- function(p, ylab = "Thermometer Score", title = "") {
        p +
            labs(y = ylab, x = NULL, colour = NULL, title = title) +
            theme(
                axis.title.y = element_text(size = 9, family = "serif"),
                axis.text.x = element_text(angle = 0, hjust = 0.5, family = "serif"),
                axis.text = element_text(size = 9, family = "serif"),
                legend.text = element_text(size = 9, family = "serif"),
                plot.title = element_text(size = 9, family = "serif", hjust = 0.5),
                legend.title = element_blank()
            )
    }

    plots <- list()
    outcomes <- c("ML", "LL", "GAP")
    outcome_labels <- c(ML = "MLthermoMean", LL = "LLthermoMean", GAP = "thermo_gap")
    outcome_colours <- c("MLthermoMean" = "#4b4b4b", "LLthermoMean" = "#bdbdbd", "thermo_gap" = "black")
    outcome_legends <- c("Most Likely", "Least Likely", "Thermometer Gap")

    for (sub in names(subgroups)) {
        subgroup <- subgroups[[sub]]
        plot_dfs <- list()
        for (outcome in outcomes) {
            outcome_name <- outcome_labels[outcome]
            model <- models[[outcome]]
            if (is.null(subgroup$interaction_terms)) {
                df <- get_means(model, treatment_var)
            } else {
                interaction_term <- subgroup$interaction_terms[[outcome]]
                df <- get_interaction_means(model, treatment_var, interaction_term)
            }
            plot_dfs[[outcome]] <- df %>% mutate(Outcome = outcome_name)
        }
        plot_data <- bind_rows(plot_dfs) %>%
            mutate(Outcome = factor(Outcome, levels = outcome_labels))
        p <- ggplot(plot_data, aes(x = Group, y = Mean, group = Outcome, colour = Outcome)) +
            geom_line(size = 0.75) +
            geom_point(size = 2) +
            scale_colour_manual(
                values = outcome_colours,
                labels = outcome_legends
            ) +
            labs(x = NULL, y = NULL, colour = NULL) +
            theme_classic(base_family = "serif") +
            ylim(0, 100)
        plots[[sub]] <- standardise_plot(p, ylab = "Thermometer Score", title = subgroup$name)
    }

    # Combine (assume 2x2 layout for 4 subgroups, adjust if more/less)
    if (length(plots) == 4) {
        patch <- ((plots[[1]] + plots[[2]]) /
            (plots[[3]] + plots[[4]])) +
            patchwork::plot_layout(guides = "collect") &
            theme(legend.position = "bottom")
    } else if (length(plots) == 2) {
        patch <- (plots[[1]] + plots[[2]]) +
            patchwork::plot_layout(guides = "collect") &
            theme(legend.position = "bottom")
    } else {
        patch <- patchwork::wrap_plots(plots) +
            patchwork::plot_layout(guides = "collect") &
            theme(legend.position = "bottom")
    }

    ggsave(filename = output_file, plot = patch, width = width, height = height, units = "in")
    invisible(output_file)
}

## Patchwork Plot for AI Treatment
models_ai <- list(
    ML = thermo_models_list_ai[["full_thermo_ml_ai_treatment_model"]],
    LL = thermo_models_list_ai[["full_thermo_ll_ai_treatment_model"]],
    GAP = thermo_models_list_ai[["full_thermo_gap_ai_treatment_model"]]
)

# Define the subgroups for plotting
subgroups_ai <- list(
    Overall = list(
        name = "Average Treatment Effect",
        interaction_terms = NULL
    ),
    LibDem = list(
        name = "Liberal Democrat Subgroup",
        interaction_terms = c(
            ML = "ai_treatment:mostlikelyLiberal Democrats",
            LL = "ai_treatment:mostlikelyLiberal Democrats",
            GAP = "ai_treatment:mostlikelyLiberal Democrats"
        )
    ),
    Green = list(
        name = "Green Party Subgroup",
        interaction_terms = c(
            ML = "ai_treatment:mostlikelyGreen Party",
            LL = "ai_treatment:mostlikelyGreen Party",
            GAP = "ai_treatment:mostlikelyGreen Party"
        )
    ),
    PartTime = list(
        name = "Part Time Work",
        interaction_terms = c(
            ML = "ai_treatment:profile_work_statWorking part time (Less than 8 hours a week)",
            LL = "ai_treatment:profile_work_statWorking part time (Less than 8 hours a week)",
            GAP = "ai_treatment:profile_work_statWorking part time (Less than 8 hours a week)"
        )
    )
)

## Patchwork Plot for Label Treatment
models_label <- list(
    ML = thermo_models_list_label[["full_thermo_ml_label_treatment_model"]],
    LL = thermo_models_list_label[["full_thermo_ll_label_treatment_model"]],
    GAP = thermo_models_list_label[["full_thermo_gap_label_treatment_model"]]
)

subgroups_label <- list(
    Overall = list(
        name = "Average Treatment Effect",
        interaction_terms = NULL
    ),
    LibDem = list(
        name = "Liberal Democrat Subgroup",
        interaction_terms = c(
            ML = "label_treatment:mostlikelyLiberal Democrats",
            LL = "label_treatment:mostlikelyLiberal Democrats",
            GAP = "label_treatment:mostlikelyLiberal Democrats"
        )
    ),
    London = list(
        name = "London Subgroup",
        interaction_terms = c(
            ML = "label_treatment:profile_GORLondon",
            LL = "label_treatment:profile_GORLondon",
            GAP = "label_treatment:profile_GORLondon"
        )
    ),
    FullTime = list(
        name = "Full Time Work",
        interaction_terms = c(
            ML = "label_treatment:profile_work_statWorking full time (30 hours or more a week)",
            LL = "label_treatment:profile_work_statWorking full time (30 hours or more a week)",
            GAP = "label_treatment:profile_work_statWorking full time (30 hours or more a week)"
        )
    )
)
