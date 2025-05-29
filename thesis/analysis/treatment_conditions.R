# This R script creates a LaTeX table for the experiment design of AI-generated news articles, comparing control and treatment conditions.

# Set output path
output_file <- here("thesis", "outputs", "tables", "treatment_conditions_table.tex")

# Define the updated table data
table_data <- data.frame(
    ` ` = c("Control", "Treatment"),
    `No Labels` = c("Human-generated Article", "AI-generated Article"),
    `Labelled as AI` = c("Human-generated Article", "AI-generated Article"),
    check.names = FALSE
)

# Build the LaTeX table
latex_table <- kable(
    table_data,
    format = "latex",
    booktabs = TRUE,
    align = "lcc",
    escape = FALSE,
    caption = "Treatments and Control for AI-generated Content Exposure."
) %>%
    kable_styling(
        full_width = FALSE,
        position = "center"
    ) %>%
    add_header_above(c(" " = 1, "Article Labelling" = 2)) %>%
    row_spec(0, bold = TRUE)


# Save to file
cat(latex_table, file = output_file)
