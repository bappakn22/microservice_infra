# Configuration
$RESOURCE_GROUP_NAME = "rg-terraform-state"
$LOCATION = "eastus"
$STORAGE_ACCOUNT_NAME = "stterraformstate" + (Get-Random -Minimum 10000 -Maximum 99999)
$CONTAINER_NAME = "tfstate"

Write-Host "Creating Resource Group: $RESOURCE_GROUP_NAME..." -ForegroundColor Cyan
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

Write-Host "Creating Storage Account: $STORAGE_ACCOUNT_NAME..." -ForegroundColor Cyan
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --location $LOCATION --sku Standard_LRS --encryption-services blob

Write-Host "Creating Blob Container: $CONTAINER_NAME..." -ForegroundColor Cyan
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

Write-Host "`nBackend Infrastructure Created Successfully!" -ForegroundColor Green
Write-Host "Please update 'environments/dev/backend.tf' with the following:" -ForegroundColor Yellow
Write-Host "storage_account_name = `"$STORAGE_ACCOUNT_NAME`"" -ForegroundColor White
