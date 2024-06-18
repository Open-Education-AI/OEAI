# Bromcom module

The Bromcom module uses the Bromcom API to extract school data.  It then processes this data into the OEAI standard data model in the data lake.  

Requirements:
* Cloud Infrastructure meeting OEAI framework standards
* Bromcom school installations, either as a Trust, or through OEAI (contact us)
* KeyVault configured (see below)
* [oeai_py.ipynb](oeai_py.ipynb) 

Module assets:
* oeai_mod_bromcom_bronze.ipynb: a notebook that loops through all schools and enpoints configured and stores the data in the data lake Bronze layer in json format.
* oeai_mod_bromcom_silver.ipynb: a notebook that loops through each school folder in Bronze, aggregates to a Trust level, transforms the data into the OEAI standard Silver Schema and upserts this data into the Silver layer in Delta Table format.
* oeai_mod_bromcom_gold.ipynb: a notebook that simply transforms the delta table format to parquet for easier consumption in data visualisation tools such as Power BI.

Limitations:
* Currently assumes Microsoft Azure / KeyVault.  If you are a Google (or AWS) Trust contact us so we can this vendor agnostic.  The secrets you will require are:
    * school_ids secret: a comma seperated value list of Bromcom school IDs
    * bromcom-bronze secret: the path to your Bronze storage location
    * bromcom-silver secret: the path to your Silver storage location
    * gold-path secret: the path to your Gold storage location
    * a secret per school_id with the Bromcom token called [school_id]
    * silver_ref_path secret: to store reference attendance codes
    * bromcom-appid secret
    * bromcom-appsecret
    * storage-account secret: the name of your Azure storage account
    * storage-accesskey secret: the storage access key for the storage account

* API endpoints currently supported:
    * Schools
    * Students
    * StudentFlatView
    * Attendances
    * AttendanceSessions
    * CalendarModels

Planned work:


Currently extending for the following endpoints:


As part of the planned MIS Insight Package we also have a Power BI report that consumes the last_run, audit and error log files that this module produces - thereby providing telemetry on every Module run.

References:
* https://docs.bromcom.com/article-tags/api/