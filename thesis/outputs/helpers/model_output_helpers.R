#' Extract predicted probability for a subgroup-treatment combination
#'
#' @param predictions A dataframe returned by `generate_plot_for_outcome(...)$data`
#' @param group A string for the moderator group (e.g. "Low Education")
#' @param treatment_level Either "Control" or "Treatment"
#' @param outcome Optional string, if your predictions contain multiple outcomes
#'
#' @return A numeric predicted probability, or NA if not found
get_predicted_prob <- function(predictions, group, treatment_level = c("Control", "Treatment"), outcome = NULL) {
    treatment_level <- match.arg(treatment_level)

    result <- predictions %>%
        dplyr::filter(mod_group == group, treatment == treatment_level)

    if (!is.null(outcome)) {
        result <- result %>% dplyr::filter(Outcome == outcome)
    }

    if (nrow(result) != 1) {
        warning("Expected exactly one match for group and treatment; returning NA.")
        return(NA)
    }

    return(result$predicted)
}

#' Collect and store key model outputs for inline referencing
#'
#' @param models A named list of model objects
#' @param predicted_probs A named list of prediction data.frames (from generate_plot_for_outcome(...))
#' @param save_path Path to save the .rds file
#'
#' @return Invisibly returns the list of extracted values
save_inline_results <- function(models, predicted_probs, save_path = "outputs/inline_results.rds") {
    results <- list()

    # Extract coefficients from models
    for (name in names(models)) {
        model <- models[[name]]
        coefs <- coef(summary(model))
        if (is.matrix(coefs)) {
            for (term in rownames(coefs)) {
                message("Trying to extract: ", term, " from model: ", name)
                if (term %in% rownames(coefs) && "Estimate" %in% colnames(coefs)) {
                    results[[paste0(name, "_", term, "_est")]] <- unname(coefs[term, "Estimate"])
                    results[[paste0(name, "_", term, "_se")]] <- unname(coefs[term, "Std. Error"])
                } else {
                    message("⚠️ Skipping term: ", term, " from model: ", name, " due to missing estimate or column.")
                }
            }
        }
    }

    # Extract predicted probabilities
    for (name in names(predicted_probs)) {
        pred <- predicted_probs[[name]]
        if ("mod_group" %in% names(pred)) {
            for (group in unique(pred$mod_group)) {
                for (trt in unique(pred$treatment)) {
                    prob <- get_predicted_prob(pred, group, trt)
                    key <- paste0(name, "_", group, "_", trt)
                    results[[key]] <- prob
                }
            }
        }
    }

    saveRDS(results, save_path)
    invisible(results)
}