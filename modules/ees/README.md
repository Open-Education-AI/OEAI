# EES module

The EES module uses the DfE national attendance.  It then processes this data into the OEAI standard data model in the data lake.  

Requirements:
* Cloud Infrastructure meeting OEAI framework standards
* OEAI school installations, either as a Trust, or through OEAI (contact us)
* Modules deployed with historic csv files in reference folder 
* [oeai_py.ipynb](oeai_py.ipynb) 

Module assets

* ees_env_var: 

Notebook to hold environment variables for bronze, silver and gold aswell as where reference files are located. These are aquired from secrets in your key vault which must be configured in advance.

* oeai_mod_ees_bronze: 

Sets up a dictionary (urls) that contains references to various CSV files related to attendance data.
Some of these files are stored locally, while others are retrieved from a GitHub repository (dfe-analytical-services/attendance-data-dashboard).
The script then iterates through the URLs and prints the dataset name.
If the data source is a GitHub URL, it downloads the CSV file using the requests library.

* oeai_mod_ees_silver: 

Defines a Dictionary (dfs) for DataFrames:
ees_daily_22_23
ees_daily_23_24
ees_daily
ees_weekly
ees_ytd

Checks for Existing Data:

Defines a function check_path_exists_databricks(path_to_check), which:
Uses dbutils.fs.ls to list files in Databricks storage.
Returns True if the path exists, otherwise False.

Data Processing and Transformation:

The notebook  processes attendance data to clean, structure, and optimize it for further use. Some  transformations include:

Schema Enforcement:
Defines explicit data types for consistency.
Ensures dates are properly formatted using to_date().
Data Cleaning & Standardization:
Handles missing or inconsistent data.
Uses functions like col() to rename or manipulate columns.
Adds metadata columns using lit() (e.g., inserting timestamps or source identifiers).


Output & Integration
The processed data is stored in the lakehouse for processing in Gold Layer

* oeai_mod_ees_gold: 
Processes data to parquet
