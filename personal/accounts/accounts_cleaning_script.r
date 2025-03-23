# Objective: R Script to clean finance data from Halifax and American Express

# Script setup
# Install Packages using Pacmans
if (!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr, tidyr, readr)

# Steps Required:
# Export Halifax data from online banking and rename the file to 'halifax.csv'
# Export American Express data from online banking and rename the file to 'amex.csv'
# 1. Load Halifax data

halifax_data <- read.csv("/Users/edwardanders/Desktop/halifax.csv")

# 1.1 Clean Halifax data
# 1.1.1 Remove Transaction Type, Sort Code, Account Number, Balance
halifax_data <- halifax_data %>%
    dplyr::select(
        -Transaction.Type,
        -Sort.Code,
        -Account.Number,
        -Balance
    )

# 1.1.2 Create a new column 'Amount' which is the absolute value of 'Debit' and 'Credit'
# 1.1.2.1 Clean 'Debit.Amount' and 'Credit.Amount' columns to convert 'Invalid Number' and 'NA' to 0
halifax_data <- halifax_data %>%
    mutate(across(c(Debit.Amount, Credit.Amount), ~ ifelse(. %in% c("Invalid Number", NA), 0, .))) %>%
    mutate(across(c(Debit.Amount, Credit.Amount), as.numeric))

halifax_data <- halifax_data %>%
    mutate(
        Amount = abs(Credit.Amount) - abs(Debit.Amount)
    )

# 1.1.3 Remove 'Debit.Amount' and 'Credit.Amount' columns
halifax_data <- halifax_data %>%
    dplyr::select(
        -Debit.Amount,
        -Credit.Amount
    )

# 1.1.4 Rename columns
halifax_data <- halifax_data %>%
    rename(Transaction = Transaction.Description)

# View(halifax_data)

# 1.2 Add 'Payment Account' column to Halifax data
halifax_data <- halifax_data %>%
    mutate(
        `Payment Account` = "Halifax"
    )

# 1.3 Add 'Income/Expense' column to Halifax data
halifax_data <- halifax_data %>%
    mutate(
        `Income/Expense` = ifelse(Amount > 0, "Income", "Expense")
    )

# 2. Load American Express data

amex_data <- read.csv("/Users/edwardanders/Desktop/amex.csv")

# 2.1 Clean American Express data
# 2.1.1 Rename columns
amex_data <- amex_data %>%
    rename(
        Transaction.Date = Date,
        Transaction = Description
    )

# 2.1.2 Modify 'Amount' column to be negative for 'Debit' and positive for 'Credit'

amex_data <- amex_data %>%
    mutate(
        Amount = ifelse(Amount > 0, -Amount, Amount)
    )

# 2.1.3 Ensure 'Amount' column is numeric
amex_data <- amex_data %>%
    mutate(across(Amount, ~ ifelse(. %in% c("Invalid Number", NA), 0, .))) %>%
    mutate(across(Amount, as.numeric))

# View(amex_data)

# 2.2 Add 'Payment Account' column to American Express data
amex_data <- amex_data %>%
    mutate(
        `Payment Account` = "American Express"
    )

# Add 'Income/Expense' column to American Express data
amex_data <- amex_data %>%
    mutate(
        `Income/Expense` = ifelse(Amount > 0, "Income", "Expense")
    )

# 3. Combine both datasets

combined_data <- rbind(halifax_data, amex_data)

# 3.1 Clean combined data
# 3.1.1 Rename 'Transaction.Date' column
combined_data <- combined_data %>%
    rename(
        `Transaction Date` = Transaction.Date
    )

# 3.1.2 Mutate the 'Transaction Date' column to be in the format 'YYYY-MM-DD'
combined_data <- combined_data %>%
    mutate(
        `Transaction Date` = as.Date(`Transaction Date`, "%d/%m/%Y")
    )

# 4 Write combined data to CSV
write_csv(combined_data, "/Users/edwardanders/Desktop/combined_finance_data.csv")
