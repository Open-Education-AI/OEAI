# MVP report

The MVP is a Power BI report (and semantic data model) that brings together the outputs of the OEAI modules into a unified schema for analysis. This report includes a Power BI dataset (Semantic Model) defining all the tables, relationships, and measures, as well as a sample report visualization. Use this as a starting point to explore the data gathered by the various OEAI modules.

## Parameters

The dataset uses two parameters to locate the data in your data lake. These must be configured to point to your environment’s data sources:

`Path_DataModel` – This parameter should be set to the root folder or path where your Gold layer data resides. The dataset will append specific file names or sub-folders to this path to find the fact and dimension tables. For example, if your Gold data is in an Azure Data Lake Gen2 container or OneLake, Path_DataModel might look like: `https://<storage_account>.dfs.core.windows.net/<container>/oeai_gold` (for Azure) or the equivalent OneLake URL for Fabric. All fact and dimension tables produced by the modules (e.g., `dim_Student.parquet`, `fact_AttendanceSession.parquet`) are expected to be found under this path.

`Path_Reference` – This parameter should be set to the folder or location of your reference data (static lookup tables). These are typically small CSV files that contain standard reference information (for example, date dimension, code mappings, standard enumerations). For instance, you might store reference CSVs in a path like `https://<storage_account>.dfs.core.windows.net/<container>/reference`. The dataset will use Path_Reference to locate files such as `dim_Date.csv`, `dim_NCYearGroup.csv`, etc.

Make sure to update these parameter values in Power BI to match your actual storage locations before refreshing the dataset. In the Power BI Desktop or Fabric workspace settings, you can find these parameters (Path_DataModel and Path_Reference) and edit their values. They must point to the exact folder paths where the expected files are stored; otherwise, the data model will not load.

## Required tables 

The MVP semantic model expects the following tables to be present in the data lake (under the paths defined by the parameters above). These tables are produced by the corresponding OEAI modules:

### Tables from Path_DataModel

- `dim_Student` – Master list of students, with unique IDs and attributes, consolidated from the MIS module data (e.g., from Wonde/Arbor).
- `dim_Organisation` – Information on the organization units, such as Trust and schools. For a multi-academy trust, this includes the Trust itself and each school (usually populated by the MIS module).
- `dim_Group` – Definitions of groups (such as classes, year groups, or other groupings of students as defined in the MIS).
- `dim_GroupMembership` – A mapping table linking students to groups (each record shows a student’s membership in a given group, class, or cohort).
- `dim_StudentAcademicYearGroup` – A mapping of students to academic year group (this typically denotes which academic year (grade) the student is in for each year, often derived from MIS data).
- `dim_StudentCalculated` – A table of derived student attributes or flags (e.g., persistent calculated indicators about students, as produced by the data processing in Silver layer).
- `dim_StudentExtended` – Extended student information, which can include additional details like addresses, contact info, etc., consolidated for each student. (This is used, for example, by the Police module to get student postcodes.)
- `dim_ExclusionReason` – The list of exclusion reasons recorded in the Trust’s data (as encountered in the MIS data). This dimension enumerates the actual exclusion reason values used in fact_Exclusion.
- `fact_AttendanceSession` – Attendance records at the session level (e.g. AM/PM or lesson-level attendance marks for students). Populated by MIS modules, this fact table contains one row per student-session with attendance code (present, absent, etc.).
- `fact_AttendanceSummary` – Summary of attendance over a period (e.g., daily or weekly summaries per student). The MIS modules produce this to aggregate session data into useful metrics (such as total present/absent sessions in a day for each student).
- `fact_Behaviour` – Behavioral incident records. Each row represents a behavior event (like a conduct incident) involving a student, as recorded in the MIS.
- `fact_Achievement` – Achievement or reward records. Each row might represent an instance of a student receiving an achievement/award or points (from the MIS data).
- `fact_Exclusion` – Exclusion records. Each row is an instance of a student exclusion (temporary or permanent), including references to reason codes, dates, and durations.

### Tables from Path_Reference (static reference data)

- `dim_Date` – A complete Date dimension table (covering the calendar and academic dates needed for reporting). This is a standard date lookup (usually provided as a CSV in the reference data folder).
- `dim_NCYearGroup` – A reference table mapping educational year group codes to standardized descriptions (National Curriculum Year Groups mapping). For example, mapping year group identifiers to a consistent label or order.
- `dim_std_ExclusionReason` – A standard reference list of exclusion reasons as defined nationally (for example, DfE standard exclusion reason codes). This allows mapping the Trust’s exclusion reasons (dim_ExclusionReason) to standardized categories if needed.

### Measures and other tables

The model also includes calculation groups or measure tables (denoted by names like “% Measures” or “# Measures” in the project). These do not correspond to physical data files but are defined within the Power BI model for analytic calculations (for example, predefined DAX measures for attendance rates, exclusion counts, etc., possibly organized in a measures table). Additionally, there are helper tables such as Achievement Bands and Incident Bands which classify numeric outcomes (achievement points, incident counts) into categories for reporting; these may be defined by DAX queries or calculated tables within the model. You do not need to supply external data for measure tables or calculated tables – they are created by the model itself as part of the dataset definition.

Before using the report, ensure all the above-required fact and dimension tables are populated in your data lake by running the corresponding modules. If any table is missing or empty, the Power BI dataset refresh may fail or produce incomplete results.

## Usage

- **Open the Power BI Project** - Load the `.pbip` project file in Power BI Desktop.
- **Set Parameters** - Update `Path_DataModel` and `Path_Reference` to match your environment.
- **Configure Access** - Provide appropriate authentication (Microsoft account or service principal) with access to the data lake or OneLake paths.
- **Refresh the Dataset** - Perform a full refresh to load all required tables. Use the included report pages to confirm data integrity and explore KPIs.
- **Extend or Customize** - The MVP report is intentionally minimal; it can be expanded with custom visuals, additional facts, or more detailed measures once validated.

## Limitations

- This semantic model and report were developed and tested in a Microsoft Fabric (Power BI) environment connecting to Azure Data Lake Storage. The AzureStorage.DataLake connector is used for retrieving data via the parameter paths. If you are using a different environment or data storage configuration, you may need to adjust the data source connection. For instance, ensure the Path_DataModel and Path_Reference URLs are accessible from Power BI (the storage account firewall should allow Power BI access, or use an on-premises gateway if necessary).
- The model assumes the standardized structure provided by the OEAI modules. If you have not used the OEAI notebooks or have a different data schema, the report will not automatically work. It’s tailored to the table and column names of the OEAI framework.
- When pointing the parameters to a new data source, you might encounter privacy level prompts or errors in Power BI Desktop. It’s recommended to set the privacy level for these data source connections to “Organizational” or disable privacy levels for development, as the data is all within your tenant’s lake.
- The included measures and report visuals are for demonstration and may need customization to fit specific analysis needs. They are provided as a starting point (for example, attendance percentage measures assume certain definitions that you might tweak).
- Finally, note that this model currently performs a full load of all data (“all” data is loaded on refresh). There is no incremental refresh configured out-of-the-box. If your fact tables become very large, consider implementing Power BI incremental refresh policies or aggregations as needed.