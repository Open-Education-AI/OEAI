# Renaissance module

The Renaissance module uses the Renaisance SFTP to extract Accelerated Reader data.  It then processes this data into the OEAI standard data model in the data lake.

Requirements:
* Cloud Infrastructure meeting OEAI framework standards
* Wonde school installations, either as a Trust, or through OEAI (contact us)
* Use of Microsoft infrastrucute and reading progress program
* KeyVault configured (see below)
* [oeai_py.ipynb](oeai_py.ipynb) 

Module assets:
* oeai_mod_renaisance_bronze.ipynb: a notebook that downloads data using SFTP and extracts data to csv files per school
* oeai_mod_renaisance_silver.ipynb: a notebook that loops through each school in Bronze, transforms the data into the OEAI standard Silver Schema and upserts this data into the Silver layer in Delta Table format.
* oeai_mod_renaisance_gold.ipynb: a notebook that simply transforms the delta table format to parquet for easier consumption in data visualisation tools such as Power BI.

Limitations:
* Currently assumes Microsoft Azure / KeyVault.  If you are a Google (or AWS) Trust contact us so we can this vendor agnostic.  The secrets you will require are:
    * renaissance-bronze: the path to your Bronze storage location
    * renaissance-silver: the path to your Silver storage location
    * renaissance-school-ids
    * gold-path secret: the path to your Gold storage location
    * storage-account secret: the name of your Azure storage account
    * storage-accesskey secret: the storage access key for the storage account

Planned Work
* 