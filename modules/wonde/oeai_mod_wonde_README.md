# Wonde module

The Wonde module uses the Wonde API to extract school data and then processes this data into the OEAI standard data model in the data lake.

## Requirements

- Cloud infrastructure meeting OEAI framework standards
- Wonde MIS access for your schools (either via your Trust’s Wonde integration or through OEAI – contact us if you need assistance obtaining access)
- Azure Key Vault configured (see below for required secrets)
- oeai_py.ipynb and oeai_logger.ipynb executed to provide necessary functions

## Module assets

- `oeai_mod_wonde_env_var.ipynb` – Environment variables and configuration notebook for the Wonde module. It retrieves required secret values from Key Vault (listed below) such as the list of school IDs and API tokens, and sets up the storage paths. This notebook should be run before the Bronze/Silver/Gold notebooks to ensure all needed variables (like schools_list and paths) are configured.
- `oeai_mod_wonde_bronze.ipynb` – A notebook that loops through all configured schools and their available API endpoints, pulling raw data from Wonde. It stores the raw JSON data in the Bronze layer of the data lake (organized by school). This includes data such as students, staff, attendance, behavior, groups, etc., fetched via Wonde’s API for each school in scope.
- `oeai_mod_wonde_silver.ipynb` – A notebook that processes the Bronze data into the OEAI standard Silver schema. It combines data across all schools (for Trust-level analysis), transforming the raw JSON into structured Delta tables. The transformation includes creating standardized dimension tables (Students, Staff, etc.) and fact tables (Attendance, Behaviour incidents, Achievements, Exclusions, etc.), aligning the data to the common OEAI model and upserting records into the Silver layer.
- `oeai_mod_wonde_gold.ipynb` – A notebook that takes the Silver layer Delta tables and outputs them in Parquet format in the Gold layer. This step optimizes the data for consumption in visualization tools like Power BI (for example, ensuring fact and dimension tables are in a convenient Parquet form for the semantic model).

## Limitations

- The module currently assumes a Microsoft Azure / Fabric environment with Azure Data Lake and Azure Key Vault. (For other environments like GCP/AWS, please contact us to discuss adaptation.) The secrets you will require are:
    - `wonde-school-ids` – a comma-separated list of the Wonde School IDs that you want to ingest data for. These IDs identify the schools in the Wonde API.
    - `wonde-{school-id}` per school ID – each school in the above list requires a secret in Key Vault containing the Wonde API token for that school. Each secret should be named in the format wonde-{school_id} (where {school_id} is the actual ID string from Wonde). For example, if one of the school IDs is `A12345`, you should have a secret named `wonde-A12345` containing that school’s API access token.
    - `storage-root` – the base path to your data lake storage container where the module’s output will be written (the root folder for Bronze/Silver/Gold data).
- **API endpoints currently supported**: The Wonde module currently pulls data from the following endpoints in the Wonde API:
    - Schools – basic information about the school(s)
    - Students – student demographic and enrollment data
    - Students (Education) – education details per student (e.g., year groups, enrollment status)
    - Students (Extended) – extended student information (may include contacts, addresses, etc.)
    - Attendance Summaries – attendance data (e.g., present/absent counts, typically by session     or day)
    - Groups – class or cohort groups defined in the school MIS
    - Behaviour – behavior incidents or records
    - Achievements – achievement or merits data
    - Exclusions – exclusions data
    - Assessment – including assessment aspects, results, and resultsets (i.e., assessment definitions and scores)
- **Planned work**: Additional Wonde endpoints or data (such as Classes, detailed assessment templates, mark sheets, etc.) are planned for future integration. We are continuously extending support for more data as needed – if you require data that is not yet covered, please get in touch so we can prioritize it.