// keyvault-des.bicep
targetScope = 'resourceGroup'

param location string = 'centralindia'
param keyVaultName string = 'kv-cmk-policylab'
param keyName string = 'cmk-disk-key'
param desName string = 'des-azureuser'
param adminObjectId string

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: { family: 'A', name: 'standard' }
    tenantId: subscription().tenantId
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enablePurgeProtection: true
    enabledForDiskEncryption: true
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: adminObjectId
        permissions: { keys: [ 'get', 'create', 'delete', 'list', 'unwrapKey', 'wrapKey', 'verify', 'sign', 'update' ] }
      }
    ]
  }
}

resource cmkKey 'Microsoft.KeyVault/vaults/keys@2023-02-01' = {
  parent: keyVault
  name: keyName
  properties: {
    kty: 'RSA'
    keySize: 4096
    keyOps: [ 'unwrapKey', 'wrapKey' ]
    attributes: { enabled: true }
  }
}

resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2023-04-02' = {
  name: desName
  location: location
  identity: { type: 'SystemAssigned' }
  properties: {
    encryptionType: 'EncryptionAtRestWithCustomerKey'
    activeKey: {
      sourceVault: { id: keyVault.id }
      keyUrl: cmkKey.properties.keyUriWithVersion
    }
  }
}

resource desKeyVaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2023-02-01' = {
  parent: keyVault
  name: 'add'
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: diskEncryptionSet.identity.principalId
        permissions: { keys: [ 'get', 'unwrapKey', 'wrapKey' ] }
      }
    ]
  }
}

output keyVaultId string = keyVault.id
output desId string = diskEncryptionSet.id
output desPrincipalId string = diskEncryptionSet.identity.principalId
