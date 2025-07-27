
#' @title Personal Finance Cleaner
#' @description This R script imports, cleans, and merges transaction data from multiple bank accounts
#' (Halifax, American Express, and Revolut). It standardises the column structure and formats across
#' each dataset, handles missing files gracefully, and outputs a unified CSV ready to import into Notion.
#'
#' @details
#' Steps:
#' 1. Checks if each account CSV file (halifax.csv, amex.csv, revolut.csv) exists on the Desktop.
#' 2. Cleans and standardises the transactions:
#'    - Converts dates to Date format
#'    - Infers "Income" or "Expense" from Amount
#'    - Adds a source label ("Payment Account")
#' 3. Combines all available datasets.
#' 4. Saves the result as 'combined_finance_data.csv' on the Desktop.
#'
#' @output combined_finance_data.csv
#' @author Edward Anders

# Script setup
# Install Packages using Pacmans
if (!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr, tidyr, readr)

# Helper: Safely load CSVs if they exist
load_data_if_exists <- function(path, loader) {
  if (file.exists(path)) loader(path) else NULL
}

# 1. Load Halifax if available
halifax_data <- load_data_if_exists("/Users/edwardanders/Desktop/halifax.csv", function(p) {
  read.csv(p) %>%
    dplyr::select(-Transaction.Type, -Sort.Code, -Account.Number, -Balance) %>%
    mutate(across(c(Debit.Amount, Credit.Amount), ~ ifelse(. %in% c("Invalid Number", NA), 0, .))) %>%
    mutate(across(c(Debit.Amount, Credit.Amount), as.numeric)) %>%
    mutate(
      Amount = abs(Credit.Amount) - abs(Debit.Amount),
      Transaction = Transaction.Description,
      `Payment Account` = "Halifax",
      `Income/Expense` = ifelse(Amount > 0, "Income", "Expense"),
      Transaction.Date = as.Date(Transaction.Date, format = "%d/%m/%Y")
    ) %>%
    dplyr::select(Transaction.Date, Transaction, Amount, `Payment Account`, `Income/Expense`)
})

# 2. Load Amex if available
amex_data <- load_data_if_exists("/Users/edwardanders/Desktop/amex.csv", function(p) {
  read.csv(p) %>%
    rename(Transaction.Date = Date, Transaction = Description) %>%
    mutate(
      Amount = ifelse(Amount > 0, -Amount, Amount),
      Amount = as.numeric(ifelse(Amount %in% c("Invalid Number", NA), 0, Amount)),
      `Payment Account` = "American Express",
      `Income/Expense` = ifelse(Amount > 0, "Income", "Expense"),
      Transaction.Date = as.Date(Transaction.Date, format = "%d/%m/%Y")
    ) %>%
    dplyr::select(Transaction.Date, Transaction, Amount, `Payment Account`, `Income/Expense`)
})

# 3. Load Revolut if available
revolut_data <- load_data_if_exists("/Users/edwardanders/Desktop/revolut.csv", function(p) {
  read.csv(p) %>%
    mutate(Completed.Date = as.Date(Completed.Date)) %>%
    rename(Transaction.Date = Completed.Date, Transaction = Description) %>%
    mutate(
      Amount = as.numeric(Amount),
      `Payment Account` = "Revolut",
      `Income/Expense` = ifelse(Amount > 0, "Income", "Expense")
    ) %>%
    dplyr::select(Transaction.Date, Transaction, Amount, `Payment Account`, `Income/Expense`)
})

# 4. Combine all non-null datasets
combined_data <- bind_rows(na.omit(list(halifax_data, amex_data, revolut_data)))

# 5. Clean combined data
combined_data <- combined_data %>%
  rename(`Transaction Date` = Transaction.Date) %>%
  mutate(`Transaction Date` = as.Date(`Transaction Date`))

# 6 Write combined data to CSV
write_csv(combined_data, "/Users/edwardanders/Desktop/combined_finance_data.csv")
