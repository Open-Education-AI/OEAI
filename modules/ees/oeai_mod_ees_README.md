# EES module

The EES module processes the Department for Education (DfE) national attendance data and transforms it into the OEAI standard data model in the data lake. This allows benchmarking of a Trust’s attendance against national figures.

## Requirements

- Cloud infrastructure meeting OEAI framework standards (Azure Data Lake and Spark environment)
- Access to DfE national attendance data – historic attendance datasets should be available. (The module expects certain CSV files with past attendance data to be present or accessible as referenced in the notebook.)
- The module’s historic CSV files (e.g. for academic years 2022/23 and 2023/24) should be placed in the designated reference data folder before running the module.
- Azure Key Vault configured for secrets (see below)
- oeai_py.ipynb and oeai_logger.ipynb executed to provide necessary functions

## Module assets

- `oeai_mod_ees_env_var.ipynb` – Environment variables notebook for EES. It fetches configuration such as storage paths from Key Vault and defines any paths for reference files (e.g., where the historic CSVs reside).
- `oeai_mod_ees_bronze.ipynb` – Ingests the national attendance data. It sets up a dictionary of data sources (some are local CSV files for historic data, others are fetched from the DfE GitHub repository for the latest data). This notebook downloads or reads the CSV files (e.g. daily attendance figures) for the specified academic years and stores the raw data in the Bronze layer.
- `oeai_mod_ees_silver.ipynb` – Transforms and combines the raw attendance data into standardized Silver layer tables. It consolidates data across years, computing daily, weekly, and year-to-date attendance metrics. The notebook creates structured DataFrames such as:
    - *ees_daily_22_23*, *ees_daily_23_24* – daily attendance records for 2022/23 and 2023/24 academic years, respectively (read from the Bronze CSV data).
    - *ees_daily* – a combined or updated daily attendance dataset.
    - *ees_weekly*, *ees_ytd* – aggregated attendance data (weekly and year-to-date) derived from daily figures.  
    It then writes the cleaned and structured attendance metrics to the Silver layer (as Delta tables).
- `oeai_mod_ees_gold.ipynb` – Reads the Silver layer attendance data and outputs it to the Gold layer in a Parquet format. This makes the national attendance tables easy to consume in analytics tools (e.g., as fact_ees_daily in Power BI).

## Limitations

- The module currently assumes a Microsoft Azure or Fabric environment with Azure Data Lake storage and Key Vault for secret management. The secret you will require is:
    - `storage-root` – the base path to your data lake where the EES module’s output will be stored (this should point to the root container/folder for Bronze/Silver/Gold).
- This module is designed around publicly available DfE attendance data. It currently includes data for the 2022–23 and 2023–24 academic years. Updates for subsequent years or changes in the DfE data format may require modifications to the notebooks or additional data input.
- **Data coverage**: The EES data ingested provides national-level aggregate attendance figures (e.g., percentage sessions attended, etc.) on a daily and weekly basis. School or Trust-level breakdowns are not part of this dataset (it is intended for benchmarking Trust data against national trends). Ensure that the reference CSV files (or URLs) are kept up to date if you wish to include the latest attendance data as DfE releases it.