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
        Write-Output "Notebook $($notebookFile.Name) converted to inline Base64 string:"
        
        $notebookName = $notebookFile.BaseName
        Write-Output $notebookName
        $notebookInstance = $ExistingItems | Where-Object { $_.DisplayName -eq $notebookName }
        
        if ($notebookInstance) {
            Write-Host "Notebook $notebookName is already present $($notebookInstance)"
        }
        else {
            $jsonBody = @{
                displayName = $notebookName
                type = "Notebook"
                definition = @{
                    format = "ipynb"
                    parts = @(
                        @{
                            path = "artifact.content.ipynb"
                            payload = $base64Content
                            payloadType = "InlineBase64"
                        }
                    )
                }
            } | ConvertTo-Json

            $response = Invoke-RestMethod -Uri $FabricCreateUrl -Method Post -Body $jsonBody -Headers $Headers
            Write-Host "$($notebookFile.Name) is created"
        }
    }
}

function Configure-OEAI {
    param (
        [string]$WorkspaceId,
        [string]$CapacityName,
        [string]$subscriptionName,
        [string]$resourceGroupName,
        [string]$powerbiEmbeddedEntraId
    )

    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    Write-Host "Please check if you are administrator of fabric capacity, go to capacity in azure and click on Capacity Administrators"

    $azAccountsModule = Get-Module -Name Az.Accounts -ListAvailable

    if (-not $azAccountsModule) {
        Install-Module Az.Accounts -Scope CurrentUser
    }

    $fabtoolsModule = Get-Module -Name Fabtools -ListAvailable

    if (-not $fabtoolsModule) {
        Install-Module Fabtools -Scope CurrentUser
    }

    az account set --subscription $subscriptionName

    az keyvault create --name 'kv-oea-oeai' --resource-group $resourceGroupName --location "uksouth"

    $appId = $powerbiEmbeddedEntraId

    az keyvault set-policy --name 'kv-oea-oeai' --resource-group $resourceGroupName --object-id $appId --secret-permissions get list

    git clone https://github.com/Jojobit/fabtools.git

    Import-Module ./Fabtools/Fabtools.psm1

    Set-FabricAuthToken -reset

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
    $listResponse = Invoke-RestMethod -Uri $fabricCreateUrl -Method Get -Headers $headers
    $existingItems = $listResponse.Value

    Write-Host $existingItems | Format-Table -AutoSize

    $lakeHouseInstance = $existingItems | Where-Object { $_.DisplayName -eq 'oealkhouse' }
    Write-Host "value of $($lakeHouseInstance)"
    if ($lakeHouseInstance) {
        Write-Host "oealkhouse is already present $($lakeHouseInstance)"
    }
    else {
        $body = @{
            displayName = "oealkhouse"
            type = "Lakehouse"
        } | ConvertTo-Json

        $response = Invoke-RestMethod -Uri $fabricCreateUrl -Method Post -Body $body -Headers $headers
        write-Host "Lakehouse is created"
    }

    $notebooksFolder = "."
    $notebookFiles = Get-ChildItem -Path $notebooksFolder -Filter *.ipynb
    Upload-NotebookFiles -NotebookFiles $notebookFiles -ExistingItems $existingItems -FabricCreateUrl $fabricCreateUrl -Headers $headers

    #for oeai_py in root folder
    $notebooksFolder = "..\..\."
    $notebookFiles = Get-ChildItem -Path $notebooksFolder -Filter *.ipynb
    Upload-NotebookFiles -NotebookFiles $notebookFiles -ExistingItems $existingItems -FabricCreateUrl $fabricCreateUrl -Headers $headers

}
