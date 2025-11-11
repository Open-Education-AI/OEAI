# Bromcom module

The Bromcom module ingests school data from Bromcom MIS and processes it into the OEAI standard data model across Bronze, Silver, and Gold layers.

## Requirements

- Cloud infrastructure meeting OEAI framework standards
- Bromcom MIS access with one of the supported connection types (**SQL** or **OData**)
- Azure Key Vault configured (see below for required secrets)
- `oeai_py.ipynb` and `oeai_logger.ipynb` executed to provide necessary functions

## Module assets

- `oeai_mod_bromcom_env_var.ipynb` – Environment variables and configuration notebook for the Bromcom module. It retrieves required secret values from Key Vault (listed below), selects the connection type (`sql` or `odata`), and sets up the storage paths. Run this first so variables (paths, mappings, filters) are available to the other notebooks.
- `oeai_mod_bromcom_bronze_sql.ipynb` – Pulls data from Bromcom via **SQL** using configured JDBC details and writes raw, lightly-normalised outputs into the **Bronze** layer.
- `oeai_mod_bromcom_bronze_odata.ipynb` – Pulls data from Bromcom via **OData**. Supports bounded pulls using an academic-year-aware start date and per-entity date filtering. Writes the raw outputs into the **Bronze** layer.
- `oeai_mod_bromcom_silver.ipynb` – Transforms Bronze outputs into the OEAI standard **Silver** schema, creating standardised **dim/** and **fact/** Delta tables.
- `oeai_mod_bromcom_gold.ipynb` – Exports Silver Delta tables to **Parquet** in the **Gold** layer for analytics consumption (e.g., Power BI).

## Key Vault secrets

### Common
- `storage-root` – base path to the data lake where `reference/`, `oeai_bronze/`, `oeai_silver/`, and `oeai_gold/` are created.

### SQL connection
- `bromcom-sql-hostname`
- `bromcom-sql-port` (optional; defaults to `1433` if not set)
- `bromcom-sql-database`
- `bromcom-sql-username`
- `bromcom-sql-password`

### OData connection
- `bromcom-odata-username`
- `bromcom-odata-password`

## Bronze layer – entities and views

You can run either the SQL or OData Bronze notebook depending on your connection:

### If using **SQL**
The notebook ingests selected database **views**:
- `dbo_vwVisionSchools`
- `dbo_vwStudents`
- `Student_vwSessionAttendance`
- `Student_vwExclusions`
- `Student_vwBehaviourEvents`
- `dbo_vwStaff`
- `Staff_vwRoles`
- `Staff_vwAbsences`
- `Student_vwExamResults`
- `Student_vwCTFAssessments`

### If using **OData**
The notebook maps OData **entities** to the same target view-style names used by the SQL path, so the downstream processing is identical:
- `VisionSchools` → `dbo_vwVisionSchools`
- `Students` → `dbo_vwStudents`
- `SessionAttendance` → `Student_vwSessionAttendance`
- `Exclusions` → `Student_vwExclusions`
- `BehaviourEvents` → `Student_vwBehaviourEvents`
- `Staff` → `dbo_vwStaff`
- `StaffRoles` → `Staff_vwRoles`
- `StaffAbsences` → `Staff_vwAbsences`
- `ExamResults` → `Student_vwExamResults`
- `EbaccResults` → `Student_vwEbaccResults`

#### OData date windows
The OData Bronze flow supports bounded extracts using:
- `BOUND_START_DATE` – defaulted to the most recent **1 August** (start of academic year); can be overridden if needed.
- `FILTERED_ENTITIES` – per-entity date rules, e.g.:
  - `BehaviourEvents` using `EventDateTime` (weekly range)
  - `SessionAttendance` using `AttendanceDate` (weekly upper bound)
  - `CTFAssesments` using `ResultDate` (weekly range)

## Silver layer – standardised tables

Bronze outputs are transformed to the OEAI Silver schema (Delta) using the following mappings:
- `dbo_vwVisionSchools` → `dim_Organisation`
- `dbo_vwStudents` → `dim_Student`, `dim_StudentExtended`
- `Student_vwSessionAttendance` → `fact_AttendanceSession`
- `Student_vwExclusions` → `fact_Exclusion`, `dim_ExclusionReason`
- `Student_vwBehaviourEvents` → `fact_Behaviour`, `fact_Achievement`
- `dbo_vwStaff` → `dim_Staff`
- `Staff_vwRoles` → `dim_StaffRole`
- `Staff_vwAbsences` → `fact_StaffAbsence`
- (optional) `Student_vwExamResults` → `fact_ExamResult`

## Gold layer – analytics outputs

Silver Delta tables are published to **Parquet** in the Gold layer for efficient downstream consumption (e.g., Power BI semantic models).

## Academic year

The module uses an academic-year start date (default **1 August**). This is used by the OData Bronze notebook when constructing bounded date ranges.

## Limitations

- The module assumes a Microsoft Azure / Fabric environment with Azure Data Lake and Azure Key Vault.
- Feature coverage reflects the current set of Bromcom entities/views in the notebooks. Extend or adjust the lists if your tenancy exposes additional views/endpoints.

