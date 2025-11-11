# Arbor module

The Arbor module uses an Arbor MIS data source (via a database connection) to extract school data and process it into the OEAI standard data model in the data lake.

## Requirements

- Cloud infrastructure meeting OEAI framework standards (Azure Data Lake and Spark environment)
- Arbor MIS data access (e.g. via Snowflake database or API) for your schools, either provided by your Trust or through OEAI (contact us for details)
- Azure Key Vault configured for secrets (see list below)
- oeai_py.ipynb and oeai_logger.ipynb executed to provide necessary functions

## Module assets

- `oeai_mod_arbor_env_var.ipynb` – Environment variables notebook for the Arbor module. It pulls required secrets from Key Vault (see below) and sets paths and configuration used by the above notebooks.
- `oeai_mod_arbor_bronze.ipynb` – Connects to the Arbor data source and extracts raw data (students, staff, attendance, behavior incidents, exclusions, assessments, etc.), storing it in the Bronze layer (e.g. as JSON or raw tables).
- `oeai_mod_arbor_silver.ipynb` – Aggregates and transforms the raw Bronze data into the OEAI standard Silver schema. This includes combining school-level data to Trust level, and structuring data into standardized dimension and fact tables (e.g. dim_Student, dim_Staff, fact_Attendance, fact_Behaviour, etc.) in Delta format.
- `oeai_mod_arbor_gold.ipynb` – Converts the Silver layer tables into the Gold layer (curated Parquet files) for efficient consumption by analytics tools (such as Power BI).

## Limitations

- The module currently assumes a Microsoft Azure or Fabric environment with Azure Data Lake storage and Key Vault. (If you are using an alternative cloud setup, please contact us to discuss modifications.) The secrets you will require are:
    - `storage-root` - the base path URL to your data lake container where OEAI data will be stored (e.g. the root path for Bronze/Silver/Gold folders).
    - `arbor-db-schema` – the database schema name for the Arbor data (e.g. in Snowflake).
    - `arbor-db-database` – the database name where Arbor data is stored.
    - `arbor-db-warehouse` – the data warehouse name or compute resource (if using Snowflake) for querying Arbor data.
    - `arbor-db-account` – the account identifier/URL for the Arbor database (if using Snowflake, the account name).
    - `arbor-db-user` – username credential for accessing the Arbor database.
    - `arbor-db-password` – password for the above database user.
- **API endpoints currently supported**: The Arbor module currently ingests the following data areas from Arbor:
    - Schools (basic organization information for each school in the Trust)
    - Students (core student data and demographics)
    - Staff (staff data)
    - Groups and Group Memberships (classes, year groups, and student membership in those groups)
    - Attendance (session-level attendance records and daily attendance summaries)
    - Behaviour Incidents (behavioral events/infractions)
    - Achievements (rewards/achievement points earned by students)
    - Exclusions (student exclusions data)
    - Assessments (student assessment results, including EYFS/KS1/KS2 teacher assessments and KS4/KS5 exam results)
    - Academic Calendar (term dates or related calendar info used in processing attendance)
- **Planned work**: Additional Arbor data integrations or refinements will be considered as needed. (At this time, the module covers most core data needed for analytics. If you require an Arbor data type not listed above, please reach out.)