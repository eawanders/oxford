# Thesis Project Workflow: Affective Polarisation (YouGov UniOM)

## Overview

This repository contains all scripts and files necessary to reproduce the
analysis and manuscript for the research thesis using YouGov UniOM survey data.
The workflow is designed to ensure full reproducibility, modularity, and clarity
from raw data processing to final PDF output.

## Folder Structure

```
thesis/
├── analysis/           # All R scripts for data prep, analysis, tables, and figures
│   ├── balance_analysis.R
│   ├── codebook.R
│   ├── data.R
│   ├── data_cleaning.R
│   ├── descriptive_analysis.R
│   ├── functions.R
│   ├── ordinal_models.R
│   ├── ordinal_models_plots.R
│   ├── packages.R
│   ├── survey_design.R
│   ├── thermo_models.R
│   ├── thermo_models_plots.R
│   └── yougov_survey_analysis.r
├── data/yougov/        # Place raw and cleaned survey data files here
├── outputs/
│   ├── figures/        # All generated plots (PDF/PNG etc)
│   ├── models/         # Saved model objects (.rds) for reproducibility
│   └── tables/         # Generated tables for manuscript inclusion (.tex)
├── writing/
│   ├── header.tex      # LaTeX header for formatting
│   └── research_design.rmd  # Main RMarkdown manuscript
│   └── research_design.pdf  # Compiled output (built after knitting)
```

## How to Reproduce the Analysis

1. **Install required R packages**
   - Run `analysis/packages.R` to install/load all dependencies.
2. **Prepare data**
   - Place the relevant data files in `data/yougov/`.
   - Run `analysis/data_cleaning.R` as needed.
3. **Set up survey design**
   - Run `analysis/survey_design.R` to define `yougov_design` (must be sourced
     before running analysis scripts).
4. **Run analysis scripts**
   - All scripts in `analysis/` are modular and can be sourced independently.
   - Key scripts:
     - `thermo_models.R` and `ordinal_models.R` fit and save model objects to
       `outputs/models/`.
     - `thermo_models_plots.R` and `ordinal_models_plots.R` generate and save
       plots to `outputs/figures/`.
     - `balance_analysis.R`, `codebook.R`, etc., generate tables to
       `outputs/tables/`.
5. **Produce tables and figures**
   - All output tables and figures are saved in `outputs/` and referenced in the
     manuscript via LaTeX (e.g., with `\input{}` or `\includegraphics{}`).
   - Tables and figures are **not** created live in the `.rmd` file; instead,
     the `.rmd` simply calls the saved outputs.

## Workflow Notes

- **Reproducibility:** If you change data or script logic, rerun the relevant
  analysis script(s) and then re-knit the manuscript.
- **Modularity:** Models, tables, and figures are saved to `outputs/` so they
  can be reused and included without re-running full analyses.
- **Extending analysis:** To run new models (e.g., for new treatments), edit or
  duplicate analysis scripts and adjust `writing/research_design.rmd` to
  reference new outputs.

## Troubleshooting

- Always ensure `survey_design.R` is sourced **before** any script that fits
  survey models.
- If an object (e.g., `yougov_design`) is not found, check that the relevant
  script has been run or sourced in the session.
- Ensure all necessary directories exist (e.g., `outputs/models/`), or create
  them before running scripts that save files.

## Data

- Raw data files are not included in the repository. Place them in
  `data/yougov/` before running scripts.

## Contact

For questions about this project or reproducibility, contact Edward Anders.
