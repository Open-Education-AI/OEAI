# Weather module

The Weather module uses the OpenWeatherMap API to extract reading progress data.  It then processes this data into the OEAI standard data model in the data lake.  

Requirements:
* Cloud Infrastructure meeting OEAI framework standards
* Wonde school installations, either as a Trust, or through OEAI (contact us)
* OpenWeatherMap account and API key
* KeyVault configured (see below)
* [oeai_py.ipynb](oeai_py.ipynb) 

Module assets:
* oeai_mod_weather_bronze.ipynb: a notebook that (when complete) loops through all schools and enpoints configured and stores the data in the data lake Bronze layer in json format.
* oeai_mod_weather_silver.ipynb: a notebook that loops through each school folder in Bronze, transforms the data into the OEAI standard Silver Schema and upserts this data into the Silver layer in Delta Table format.

Limitations:
* Currently assumes Microsoft Azure / KeyVault.  If you are a Google (or AWS) Trust contact us so we can this vendor agnostic.  The secrets you will require are:
    * school_ids secret: a comma seperated value list of Wonde school IDs
    * wonde-bronze secret: the path to your Bronze storage location
    * wonde-silver secret: the path to your Silver storage location
    * a secret per school_id with the Wonde token called wonde-[school_id]
    * storage-account secret: the name of your Azure storage account
    * storage-accesskey secret: the storage access key for the storage account
    * weather-apikey secret: key provided by OpenWeatherMap to access weather data

Planned work:
    * Fully implement loop through school ids with aquisition of lat and lon. Currently uses option of hardcoded values.

Reference: https://openweathermap.org/api 