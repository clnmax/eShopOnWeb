param webAppName string // = uniqueString(resourceGroup().id) // unique String gets created from az cli instructions
param sku string = 'S1' // The SKU of App Service Plan
param location string = resourceGroup().LOCATION

var appServicePlanName = toLower('AppServicePlan-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: LOCATION
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
}
resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  kind: 'app'
  location: LOCATION
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Dev'
        }
        {
          name: 'UseOnlyInMemoryDatabase'
          value: 'true'
        }
      ]
    }
  }
}
