function Configure-OEAI {
    param (
        [string]$WorkspaceId,
        [string]$CapacityName,
	[string]$subscriptionName,
	[string]$resourceGroupName,
	[string]$powerbiEmbeddedEntraId
    )
	
	Write-Host "Please check if you are administrator of fabric capacity, go to capacity in azure and click on Capacity Administrators"
	
	# Check if Az.Accounts module is installed
    $azAccountsModule = Get-Module -Name Az.Accounts -ListAvailable

    if (-not $azAccountsModule) {
		Install-Module Az.Accounts -Scope CurrentUser
	}
	
	# Check if Fabtools module is installed
    $fabtoolsModule = Get-Module -Name Fabtools -ListAvailable

    if (-not $fabtoolsModule) {
		Install-Module Fabtools -Scope CurrentUser
	}
	

#Create key vault
az account set --subscription $subscriptionName

az keyvault create --name 'kv-oea-oeai' --resource-group $resourceGroupName --location "uksouth"

# Get the Application (client) ID of the Power BI App
appId=$powerbiEmbeddedEntraId
# Set Key Vault access policy for secrets
az keyvault set-policy --name 'kv-oea-oeai' --resource-group $resourceGroupName --object-id $appId --secret-permissions get list

# Clone the repository
git clone https://github.com/Jojobit/fabtools.git

# Import the module
Import-Module ./Fabtools/Fabtools.psm1

Set-FabricAuthToken -reset
#Connect-AzAccount
$accessToken = Get-FabricAuthToken
 $accessToken = "Bearer ${accessToken}"
$headers = @{
    "Content-Type" = "application/json"
    "Authorization" = $accessToken
}


$response = Invoke-RestMethod -Uri "https://api.fabric.microsoft.com/v1/capacities" -Method GET -Headers $headers


$response.value | Format-Table

$capacity = $response.value | Where-Object { $_.displayName -eq $CapacityName }


Register-FabricWorkspaceToCapacity -WorkspaceId $WorkspaceId -CapacityId $capacity.Id

$fabricCreateUrl = "https://api.fabric.microsoft.com/v1/workspaces/$($WorkspaceId)/items"
#list existing items# Make the API request
$listResponse = Invoke-RestMethod -Uri $fabricCreateUrl -Method Get -Headers $headers
$existingItems = {}

# Display data in a table
$existingItems = $listResponse.Value



Write-Host $existingItems| Format-Table -AutoSize

#create lakehouse

$lakeHouseInstance = $existingItems | Where-Object { $_.DisplayName -eq 'oealkhouse' }
Write-Host "value of $($lakeHouseInstance)"
if($lakeHouseInstance) { Write-Host "oealkhouse is already present $($lakeHouseInstance)" }
else{
	$body = @{
	  "displayName"= "oealkhouse"
	  "type"= "Lakehouse"
	}| ConvertTo-Json

	$response = Invoke-RestMethod -Uri $fabricCreateUrl -Method Post -Body $body -Headers $headers
	write-Host "Lakehouse is created"
}
#upload notebook files

# Set the path to the folder containing IPython Notebook files
$notebooksFolder = "."

# Get all .ipynb files in the folder
$notebookFiles = Get-ChildItem -Path $notebooksFolder -Filter *.ipynb

# Loop through each notebook file
foreach ($notebookFile in $notebookFiles) {
    # Read the content of the notebook file
    $notebookContent = Get-Content -Path $notebookFile.FullName -Raw

    # Convert the content to Base64
    $base64Content = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($notebookContent))


    # Display the inline Base64 string or perform any other actions as needed
    Write-Output "Notebook $($notebookFile.Name) converted to inline Base64 string:"
    
	$notebookName = $notebookFile.Name

	# Find the position of the first dot
	$dotPosition = $notebookName.IndexOf('.')

	# Check if a dot was found
	if ($dotPosition -ge 0) {
		# Trim the string up to the first dot
		$notebookName = $notebookName.Substring(0, $dotPosition)
		
		# Display the trimmed string
		Write-Output "Trimmed String: $trimmedString"
	}
	
	Write-Output $notebookName
	$notebookInstance = $existingItems | Where-Object { $_.DisplayName -eq $notebookName }
	
	if($notebookInstance){Write-Host "oealkhouse is already present $($notebookInstance)"}
	else{
		# Construct the JSON string using double-quoted string to expand $name
		$jsonBody = @"
		{
			"displayName": "$notebookName",
			"type": "Notebook",
			"definition": {
				"format": "ipynb",
				"parts": [
					{
						"path": "artifact.content.ipynb",
						"payload": "$base64Content",
						"payloadType": "InlineBase64"
					}
				]
			}
		}
"@


		$response = Invoke-RestMethod -Uri $fabricCreateUrl -Method Post -Body $jsonBody -Headers $headers

		Write-Host "$($notebookFile.Name) is created"
	}

}



}
