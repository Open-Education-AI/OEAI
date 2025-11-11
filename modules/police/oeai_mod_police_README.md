# Police module

The Police module integrates data from the UK Police open data API to enrich the OEAI data model with local context (such as crime statistics in areas relevant to the schools or students). It retrieves crime data based on student home postcodes and stores this information in the data lake for analysis.

## Requirements

- Cloud infrastructure meeting OEAI framework standards (Azure Data Lake and Spark environment)
- At least one OEAI MIS module (e.g. Wonde, Arbor, Bromcom) run beforehand – the Police module relies on existing student data (specifically student addresses/postcodes from the StudentExtended table produced by the MIS modules). Without student postcode data available, this module cannot fetch relevant police data.
- Azure Key Vault configured for secrets (see below)
- oeai_py.ipynb and oeai_logger.ipynb executed to provide necessary functions

## Module assets

- `oeai_mod_police_env_var.ipynb` – Environment variables notebook for Police. It sets up the storage path and any other configuration. (No sensitive API keys are required for the UK Police API, since it is open data, but the notebook still uses Key Vault for the common `storage-root` secret to determine where data is written.)
- `oeai_mod_police.ipynb` – A single notebook that handles the entire pipeline for police data. It loads the required input from existing student data, uses a geocoding step to convert postcodes to latitude/longitude, calls the UK Police API for each location to retrieve crime data, and then processes and stores the results. Specifically, this notebook:
    - Loads the *StudentExtended* dataset (from the Silver/Gold layer of the OEAI data model) to get a list of distinct student home postcodes.
    - Uses a geocoding library (pgeocode) to translate each postcode into latitude and longitude coordinates.
    - Defines and uses a fetch_data function with rate limiting to call the Police API’s crime endpoint for each location. This retrieves recent street-level crime records for the area around each postcode.
    - Aggregates or attaches the fetched crime data to the corresponding locations (postcodes) and writes the output to the data lake (Bronze/Silver layer). The final structured data (e.g., a fact table of crime incidents by area or a dimension of postcode with crime stats) is saved in the chosen format (Delta/Parquet) for use in analysis.

## Limitations

- The module assumes a Microsoft Azure or Fabric environment and uses Azure Data Lake for storage and Azure Key Vault for managing secrets. The secret you will require is:
    - `storage-root` – the base path in your data lake where the police data output will be stored (e.g., the root folder for OEAI Bronze/Silver/Gold layers).
- The Police data integration currently focuses on **street-level crime data by location**. It uses student home postcodes as the basis for location queries. This means the accuracy and relevance of the crime data depend on the quality of postcode information in the StudentExtended table.
- The module uses the public Police API which does not require authentication, so no API key secrets are needed. However, the API imposes rate limits. The notebook includes a rate-limited fetch to handle this, but very large numbers of postcodes could result in a slow run or hitting the rate limit. It’s recommended to run this module sparingly or filter the input postcodes if dealing with an extremely large dataset.
- **API endpoint currently supported**: The module utilizes the Police “crimes at location” endpoint (via latitude/longitude). It retrieves recent crime incidents in the vicinity of each provided location. (Additional endpoints like police “stop and search” data or others are not integrated at this time.)
- **Planned work**: Future iterations may refine how crime data is linked to school data (for example, aggregating by school catchment area or linking by neighborhood/ward instead of individual postcodes) and may include other related datasets if needed for analysis.