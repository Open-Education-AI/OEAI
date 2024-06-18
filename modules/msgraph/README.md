# MSGraph module

The MSGraph module uses the Graph API to extract reading progress data.  It then processes this data into the OEAI standard data model in the data lake.  

Requirements:
* Cloud Infrastructure meeting OEAI framework standards
* Use of Renaissance Accelerated Reader program
* KeyVault configured (see below)
* [oeai_py.ipynb](oeai_py.ipynb) 

Module assets:
* oeai_mod_msgraph_la_bronze.ipynb: a notebook that loops through all schools and endpoints configured and stores the data in the data lake Bronze layer in json format.
* oeai_mod_msgraph_la_silver.ipynb: a notebook that loops through each school folder in Bronze, transforms the data into the OEAI standard Silver Schema and upserts this data into the Silver layer in Delta Table format.
* oeai_mod_msgraph_la_gold.ipynb: a notebook that simply transforms the delta table format to parquet for easier consumption in data visualisation tools such as Power BI.

Limitations:
* Currently assumes Microsoft Azure / KeyVault.  If you are a Google (or AWS) Trust contact us so we can this vendor agnostic.  The secrets you will require are:
    * msgraph-rp-bronze: the path to your Bronze storage location
    * msgraph-silver: the path to your Silver storage location
    * wonde-silver: the path to your Wonde Silver location
    * msgraph-tenantid
    * msgraph-clientid
    * msgraph-secret
    * storage-account secret: the name of your Azure storage account
    * storage-accesskey secret: the storage access key for the storage account

* API endpoints currently supported:
    * assignments
    * schools
    * users
    * classes

Planned work:

Currently extending for the following endpoints:
    * reflect
