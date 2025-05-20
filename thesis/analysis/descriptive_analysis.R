# This script contains functions to perform descriptive analysis on the data.

# Plotting
create_thermo_gap_plot <- function(data, treatment_var = c("ai_treatment", "label_treatment")) {
    treatment_var <- match.arg(treatment_var)

    # Reshape data to long format
    thermo_data <- data %>%
        dplyr::select(thermo_gap, all_of(treatment_var)) %>%
        tidyr::pivot_longer(
            cols = all_of(treatment_var),
            names_to = "treatment_type",
            values_to = "treated"
        ) %>%
        dplyr::filter(!is.na(treated), !is.na(thermo_gap)) %>%
        dplyr::mutate(
            treatment_type = dplyr::recode(treatment_type,
                "ai_treatment" = "AI Treatment",
                "label_treatment" = "Label Treatment"
            ),
            treated = factor(treated, levels = c(0, 1), labels = c("Control", "Treatment"))
        )

    # Calculate group means
    summary_stats <- thermo_data %>%
        dplyr::group_by(treatment_type, treated) %>%
        dplyr::summarise(
            mean_gap = mean(thermo_gap, na.rm = TRUE),
            .groups = "drop"
        )

    # Build the plot
    ggplot2::ggplot(summary_stats, ggplot2::aes(x = treatment_type, y = mean_gap, fill = treated)) +
        ggplot2::geom_col(position = ggplot2::position_dodge(width = 0.7), width = 0.6) +
        ggplot2::labs(
            x = NULL,
            y = "Average Thermometer Gap",
            fill = "Group"
        ) +
        ggplot2::scale_fill_manual(
            labels = c("Control", "Treatment"),
            values = c("#bdbdbd", "#4b4b4b")
        ) +
        ggplot2::ylim(0, NA) +
        ggplot2::theme_classic(base_family = "serif") +
        ggplot2::theme(
            axis.title.x = ggplot2::element_text(size = 10, margin = ggplot2::margin(t = 10)),
            axis.title.y = ggplot2::element_text(size = 10, margin = ggplot2::margin(r = 10)),
            axis.text = ggplot2::element_text(size = 9),
            legend.title = ggplot2::element_text(size = 9),
            legend.text = ggplot2::element_text(size = 9)
        )
}

# Save the plot output
save_thermo_gap_plot <- function(data, treatment_var, file = "../outputs/figures/thermo_gap_plot.pdf", width = 5, height = 3) {
    plot <- create_thermo_gap_plot(data, treatment_var = treatment_var)
    ggplot2::ggsave(
        filename = file,
        plot = plot,
        width = width,
        height = height,
        units = "in"
    )
    invisible(file)
}


# Bind the two subsets into one dataframe
combined_thermo_data <- dplyr::bind_rows(
    yougov_data_ai %>% dplyr::mutate(treatment_type = "AI Treatment", treated = ai_treatment),
    yougov_data_label %>% dplyr::mutate(treatment_type = "Label Treatment", treated = label_treatment)
)

# Create a single plot showing both treatment effects
create_combined_thermo_gap_plot <- function(data) {
    summary_stats <- data %>%
        dplyr::filter(!is.na(treated), !is.na(thermo_gap)) %>%
        dplyr::group_by(treatment_type, treated) %>%
        dplyr::summarise(
            mean_gap = mean(thermo_gap, na.rm = TRUE),
            .groups = "drop"
        ) %>%
        dplyr::mutate(treated = factor(treated, levels = c(0, 1), labels = c("Control", "Treatment")))

    ggplot2::ggplot(summary_stats, ggplot2::aes(x = treatment_type, y = mean_gap, fill = treated)) +
        ggplot2::geom_col(position = ggplot2::position_dodge(width = 0.7), width = 0.6) +
        ggplot2::labs(
            x = NULL,
            y = "Average Thermometer Gap",
            fill = "Group"
        ) +
        ggplot2::scale_fill_manual(
            labels = c("Control", "Treatment"),
            values = c("#bdbdbd", "#4b4b4b")
        ) +
        ggplot2::ylim(0, NA) +
        ggplot2::theme_classic(base_family = "serif") +
        ggplot2::theme(
            axis.title.x = ggplot2::element_text(size = 10, margin = ggplot2::margin(t = 10)),
            axis.title.y = ggplot2::element_text(size = 10, margin = ggplot2::margin(r = 10)),
            axis.text = ggplot2::element_text(size = 9),
            legend.title = ggplot2::element_text(size = 9),
            legend.text = ggplot2::element_text(size = 9)
        )
}

# Save the combined plot
combined_plot <- create_combined_thermo_gap_plot(combined_thermo_data)
ggplot2::ggsave("../outputs/figures/thermo_gap_plot_combined.pdf", combined_plot, width = 5, height = 3)
