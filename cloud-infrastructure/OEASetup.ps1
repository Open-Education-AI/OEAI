
function Grant-KeyVaultPermission {
    param(
        [string]$KeyVaultName,
        [string]$UserEmail,
        [string[]]$Permissions
    )

    # Connect to Azure account
    Connect-AzAccount

    # Get the Key Vault object
    $keyVault = Get-AzKeyVault -VaultName $KeyVaultName

    # Get the Object ID of the user
    $userId = (Get-AzADUser -UserPrincipalName $UserEmail).Id

    # Grant access policy based on permission
    # Grant access policy based on permissions array
    $accessPermissions = @()
    foreach ($permission in $Permissions) {
        switch ($permission) {
            "get" {
                $accessPermissions += "get"
            }
            "set" {
                $accessPermissions += "set"
            }
            "list" {
                $accessPermissions += "list"
            }
            default {
                Write-Host "Invalid permission: $permission"
            }
        }
    }

    # Assign access policy
   az keyvault set-policy --name $KeyVaultName --object-id $userId --secret-permissions $accessPermissions
}


function Print-Hashtableparam(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]$myHashtable){
    foreach ($key in $myHashtable.Keys) 
    {
        Write-Host "$key : $($myHashtable[$key])"
    }
}

function Print-ObjectProperties {
    param(
        [Parameter(Mandatory = $true)]
        [object]$Object,
        
        [string]$Prefix = ""
    )

    $Object | Get-Member -MemberType Property | ForEach-Object {
        $propertyName = $_.Name
        $propertyValue = $Object.$propertyName
        
        Write-Host "$Prefix$propertyName : $propertyValue"
        
        # Recursively print nested properties if the property value is an object
        if ($propertyValue -is [System.Object]) {
            Print-ObjectProperties -Object $propertyValue -Prefix ("    $Prefix")
        }
    }
}

function Upload-NotebookFiles {
    param (
        [System.IO.FileInfo[]]$NotebookFiles,
        [System.Collections.ArrayList]$ExistingItems,
        [string]$FabricCreateUrl,
        [System.Collections.Hashtable]$Headers
    )

    foreach ($notebookFile in $NotebookFiles) {
        $notebookContent = Get-Content -Path $notebookFile.FullName -Raw
        $base64Content = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($notebookContent))
        Write-Output "Notebook $($notebookFile.Name) - $($FabricCreateUrl) converted to inline Base64 string"
        
        $notebookName = $notebookFile.BaseName
        Write-Output $notebookName
        $notebookInstance = $ExistingItems | Where-Object { $_.DisplayName -eq $notebookName }
        
        if ($notebookInstance) {
            Write-Host "Notebook $notebookName is already present $($notebookInstance)"
        }
        else {
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

            try {
            $response = Invoke-RestMethod -Uri $FabricCreateUrl -Method Post -Body $jsonBody -Headers $Headers
            $response.ErrorDetails
            }
            catch {
                # Print the entire exception
                $_.ErrorDetails | Format-List * -Force
                Write-Host "Exception Message: $($_.Exception.Message)"
                Write-Host "Exception StackTrace: $($_.Exception.StackTrace)"
                Write-Host "Exception InnerException: $($_.Exception.InnerException)"
                Write-Host "Exception ErrorDetails: $($_.Exception.ErrorDetails.Message)"
            }
        }
    }
}

function Configure-OEAI {
    param (
        [string]$WorkspaceId,
        [string]$CapacityName,
        [string]$subscriptionName,
        [string]$resourceGroupName,
        [string]$powerbiEmbeddedEntraId,
        [string]$prefix = "oeai"
    )

    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    Write-Host "Please check if you are administrator of fabric capacity, go to capacity in azure and click on Capacity Administrators"
    $storageAccountName = "${prefix}stoacc"
    $containerName = "data-model"
    $azAccountsModule = Get-Module -Name Az.Accounts -ListAvailable

    if (-not $azAccountsModule) {
        Install-Module Az.Accounts -Scope CurrentUser
    }

    $azureADModule = Get-Module -Name AzureAD -ListAvailable
    if (-not $azureADModule) {
        Install-Module AzureAD -Scope CurrentUser -Force -AllowClobber
    }
    Import-Module -Name AzureAD

    $azureStorageModule = Get-Module -Name Az.Storage -ListAvailable
    if (-not $azureStorageModule) {
        Install-Module Az.Storage -Scope CurrentUser -Force -AllowClobber
    }
    Import-Module -Name Az.Storage

    $powerBIModule = Get-Module -Name MicrosoftPowerBIMgmt -ListAvailable
    if (-not $powerBIModule) {
        Install-Module MicrosoftPowerBIMgmt -Scope CurrentUser -Force -AllowClobber
    }

    Import-Module MicrosoftPowerBIMgmt

    $fabtoolsModule = Get-Module -Name Fabtools -ListAvailable

    if (-not $fabtoolsModule) {
        Install-Module Fabtools -Scope CurrentUser
    }

    az account set --subscription $subscriptionName
    Set-AzContext -subscription $subscriptionName
    $resourceGroupName = "${prefix}${resourceGroupName}"
    New-AzResourceGroup -Name $resourceGroupName -Location "uksouth"

    #create new user
    $userContext = Get-AzContext
    $username = $userContext.Account.Id
    $usernameParts = $username -split "@"
    $domain = $usernameParts[1]

    $newUser = "oeai@${domain}" 

    $password = ConvertTo-SecureString "1qaz@WSX3edc" -AsPlainText -Force

    New-AzADUser -DisplayName "Open Education Analytics" -Password $password -AccountEnabled $true -MailNickname "OEAISys" -UserPrincipalName $newUser
    New-AzRoleAssignment -SignInName $newUser -RoleDefinitionName "Contributor" -ResourceGroupName $resourceGroupName


    az keyvault create --name 'kv-oea-oeai' --resource-group $resourceGroupName --location "uksouth"

    $appId = $powerbiEmbeddedEntraId

    az keyvault set-policy --name 'kv-oea-oeai' --resource-group $resourceGroupName --object-id $appId --secret-permissions get list

    $user = Get-AzAccessToken
     Grant-KeyVaultPermission -KeyVaultName "kv-oea-oeai" -UserEmail $user.UserId -Permission @("get","set","list")

    git clone https://github.com/Jojobit/fabtools.git

    Import-Module ./Fabtools/Fabtools.psm1

    Set-FabricAuthToken -reset

    $accessToken = Get-FabricAuthToken
    $accessToken = "Bearer ${accessToken}"
    $headers = @{
        "Content-Type" = "application/json"
        "Authorization" = $accessToken
    }

    if ($WorkspaceId -eq '' -or -not $WorkspaceId) {
        Connect-PowerBIServiceAccount

        # Step 4: Create a workspace
        $workspaceName = "Open Education AI"
        $workspace = New-PowerBIWorkspace -Name $workspaceName
        $WorkspaceId = $workspace.Id

        Add-PowerBIWorkspaceUser -Scope Organization -Id $WorkspaceId -UserEmailAddress $newUser -AccessRight Contributor
    }

    $response = Invoke-RestMethod -Uri "https://api.fabric.microsoft.com/v1/capacities" -Method GET -Headers $headers

    $response.value | Format-Table

    $capacity = $response.value | Where-Object { $_.displayName -eq $CapacityName }

    Register-FabricWorkspaceToCapacity -WorkspaceId $WorkspaceId -CapacityId $capacity.Id

    $fabricCreateUrl = "https://api.fabric.microsoft.com/v1/workspaces/$($WorkspaceId)/items"
    $listResponse = Invoke-RestMethod -Uri $fabricCreateUrl -Method Get -Headers $headers
    $existingItems = $listResponse.Value

    Write-Host $existingItems | Format-Table -AutoSize

    $lakeHouseInstance = $existingItems | Where-Object { $_.DisplayName -eq "${prefix}oealkhouse" -and $_.Type -eq 'Lakehouse' }
    if ($lakeHouseInstance) {
        Write-Host "oealkhouse is already present $($lakeHouseInstance.Id)"
        #Print-ObjectProperties $lakeHouseInstance
    }
    else {
        $body = @{
            displayName = "${prefix}oealkhouse"
            type = "Lakehouse"
        } | ConvertTo-Json

        $response = Invoke-RestMethod -Uri $fabricCreateUrl -Method Post -Body $body -Headers $headers
        write-Host "Lakehouse is created"
        $lakeHouseInstance = $existingItems | Where-Object { $_.DisplayName -eq "${prefix}oealkhouse" -and $_.Type -eq 'Lakehouse' }
    }

    #GET https://api.fabric.microsoft.com/v1/workspaces/{workspaceId}/lakehouses/{lakehouseId}
    $fabricGetUrl = "https://api.fabric.microsoft.com/v1/workspaces/$($WorkspaceId)/lakehouses/$($lakeHouseInstance.Id)";
    $response = Invoke-RestMethod -Uri $fabricGetUrl -Method Get -Headers $headers
    $filePath= $response.properties.oneLakeFilesPath
    $bronzePath = "${filePath}/Files/Bronze"
    $silverPath = "${filePath}/Files/Silver"
    $goldPath = "${filePath}/Files/Gold"
    $secretValue = ConvertTo-SecureString -String $bronzePath -AsPlainText -Force
    $keyVaultSecretName = "wonde-bronze"
    Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $keyVaultSecretName -SecretValue $secretValue

    $secretValue = ConvertTo-SecureString -String $silverPath -AsPlainText -Force
    $keyVaultSecretName = "wonde-silver"
    Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $keyVaultSecretName -SecretValue $secretValue

     $secretValue = ConvertTo-SecureString -String $goldPath -AsPlainText -Force
    $keyVaultSecretName = "wonde-gold"
    Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $keyVaultSecretName -SecretValue $secretValue


    $notebooksFolder = "..\modules\wonde\."
    $notebookFiles = Get-ChildItem -Path $notebooksFolder -Filter *.ipynb
    Upload-NotebookFiles -NotebookFiles $notebookFiles -ExistingItems $existingItems -FabricCreateUrl $fabricCreateUrl -Headers $headers

    #for oeai_py in root folder
    $notebooksFolder = "..\."
    $notebookFiles = Get-ChildItem -Path $notebooksFolder -Filter *.ipynb
    Upload-NotebookFiles -NotebookFiles $notebookFiles -ExistingItems $existingItems -FabricCreateUrl $fabricCreateUrl -Headers $headers

    
# Create storage account
New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -SkuName Standard_LRS -Kind StorageV2 -Location "UK South"

# Get storage account connection string
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $storageAccountName).Value[0]
$storageConnectionString = "DefaultEndpointsProtocol=https;AccountName=$storageAccountName;AccountKey=$storageAccountKey;EndpointSuffix=core.windows.net"

# Add connection string to key vault
$secretValue = ConvertTo-SecureString -String $storageAccountKey -AsPlainText -Force
$keyVaultSecretName = "storage-accesskey"
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $keyVaultSecretName -SecretValue $secretValue

$keyVaultSecretName = "storage-account"
$secretValue = ConvertTo-SecureString -String $storageAccountName -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $keyVaultSecretName -SecretValue $secretValue

# Create container
$ctx = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
New-AzStorageContainer -Name $containerName -Context $ctx




$upgradeTask = Invoke-AzStorageAccountHierarchicalNamespaceUpgrade `
    -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName `
    -RequestType Upgrade `
    -Force `
    -AsJob

$upgradeTask | Wait-Job

$status =(Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroupName ).EnableHierarchicalNamespace
}
