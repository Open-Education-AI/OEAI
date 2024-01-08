# Wonde module

The Wonde module uses the Wonde API to extract school data.  It then processes this data into the OEAI standard data model in the data lake.  

Requirements:
* Cloud Infrastructure meeting OEAI framework standards
* Wonde school installations, either as a Trust, or through OEAI (contact us)
* KeyVault configured (see below)
* [oeai_py.ipynb](oeai_py.ipynb) 

Module assets:
* oeai_mod_wonde_bronze.ipynb: a notebook that loops through all schools and enpoints configured and stores the data in the data lake Bronze layer in json format.
* oeai_mod_wonde_silver.ipynb: a notebook that loops through each school folder in Bronze, aggregates to a Trust level, transforms the data into the OEAI standard Silver Schema and upserts this data into the Silver layer in Delta Table format.
* oeai_mod_wonde_gold.ipynb: a notebook that simply transforms the delta table format to parquet for easier consumption in data visualisation tools such as Power BI.

Limitations:
* Currently assumes Microsoft Azure / KeyVault.  If you are a Google (or AWS) Trust contact us so we can this vendor agnostic.  The secrets you will require are:
    * school_ids secret: a comma seperated value list of Wonde school IDs
    * wonde-bronze secret: the path to your Bronze storage location
    * wonde-silver secret: the path to your Silver storage location
    * gold-path secret: the path to your Gold storage location
    * a secret per school_id with the Wonde token called wonde-[school_id]
    * storage-account secret: the name of your Azure storage account
    * storage-accesskey secret: the storage access key for the storage account
* API endpoints currently supported:
    * schools
    * students
    * students_education
    * students_extended
    * attendance-summaries

Planned work:

Currently extending for the following endpoints:
* groups
* classes
* behaviour
* achievements
* exclusions
* assessment (aspects, results, templates, marksheets, resultsets)
* subjects
* periods
* employees
* detentions
* photos
* detention-types
* attendance/detention

Error logging: we are in the process of converting all Prints to the error log function (Bronze completed, Silver and Gold to do)

As part of the planned MIS Insight Package we also have a Power BI report that consumes the last_run, audit and error log files that this module produces - thereby providing telemetry on every Module run.

References:
* https://docs.wonde.com/docs/api/sync/