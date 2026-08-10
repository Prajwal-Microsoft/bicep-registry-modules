// ============================================================================
// Module: Azure Container Registry (AVM)
// AVM Module: avm/res/container-registry/registry:0.12.1
// ============================================================================

@description('Required. Name of the container registry.')
param name string

@description('Required. Azure region for deployment.')
param location string

@description('Optional. Resource tags.')
param tags object = {}

@description('Optional. SKU for the container registry.')
@allowed(['Basic', 'Standard', 'Premium'])
param acrSku string = 'Standard'

@description('Optional. Enable/Disable usage telemetry for the module.')
param enableTelemetry bool = true

@description('Optional. Enable the ACR admin user (username/password).')
param acrAdminUserEnabled bool = false

@description('Optional. Whether to allow trusted Azure services to bypass the ACR network rules.')
param networkRuleBypassOptions string = 'AzureServices'

@description('Optional. Default action for the network rule set. Use Allow when no private endpoint is in place; Deny for private-only.')
@allowed(['Allow', 'Deny'])
param networkRuleSetDefaultAction string = 'Allow'

@description('Optional. Public network access setting.')
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Enabled'

@description('Optional. Whether zone redundancy is enabled for the registry (Premium SKU only).')
@allowed(['Enabled', 'Disabled'])
param zoneRedundancy string = 'Disabled'

// Must be 'enabled' for App Service managed-identity image pulls (acrUseManagedIdentityCreds); the
// underlying AVM module defaults it to 'disabled', which causes ACR token retrieval to fail
// (ACRTokenRetrievalFailure) during container startup.
@description('Optional. ARM-audience AAD token policy status. Keep "enabled" for App Service managed-identity ACR pulls.')
@allowed(['enabled', 'disabled'])
param azureADAuthenticationAsArmPolicyStatus string = 'enabled'

@description('Optional. Role assignments to apply to the registry (e.g. AcrPull for consuming identities).')
param roleAssignments array = []

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings array?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

// ============================================================================
// Container Registry (AVM)
// ============================================================================
module containerRegistry 'br/public:avm/res/container-registry/registry:0.12.1' = {
  name: take('avm.res.container-registry.registry.${name}', 64)
  params: {
    name: name
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    acrSku: acrSku
    acrAdminUserEnabled: acrAdminUserEnabled
    networkRuleBypassOptions: networkRuleBypassOptions
    // Note: networkRuleSetDefaultAction must be 'Allow' (not the module's 'Deny' default) when public access is enabled,
    // otherwise the underlying module configures a networkRuleSet, which is only supported on Premium SKU.
    networkRuleSetDefaultAction: networkRuleSetDefaultAction
    publicNetworkAccess: publicNetworkAccess
    zoneRedundancy: zoneRedundancy
    azureADAuthenticationAsArmPolicyStatus: azureADAuthenticationAsArmPolicyStatus
    roleAssignments: roleAssignments
    diagnosticSettings: diagnosticSettings
    privateEndpoints: privateEndpoints
  }
}

// ============================================================================
// Outputs
// ============================================================================
@description('The name of the container registry.')
output name string = containerRegistry.outputs.name

@description('The login server URL of the container registry.')
output loginServer string = containerRegistry.outputs.loginServer

@description('The resource ID of the container registry.')
output resourceId string = containerRegistry.outputs.resourceId
