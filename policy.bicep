// policy.bicep
// Azure Policy: Require Customer-Managed Key (CMK) on Disk Encryption Sets

targetScope = 'subscription'

resource cmkDESPolicy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'require-cmk-disk-encryption-set'
  properties: {
    displayName: 'Require Customer-Managed Key on Disk Encryption Sets'
    description: 'Ensures all managed disks use a Disk Encryption Set backed by a Customer-Managed Key (CMK) stored in Azure Key Vault.'
    policyType: 'Custom'
    mode: 'Indexed'
    metadata: {
      category: 'Security'
      version: '1.0.0'
    }
    parameters: {
      effect: {
        type: 'String'
        metadata: {
          displayName: 'Effect'
          description: 'Deny, Audit, or Disabled'
        }
        allowedValues: [
          'Deny'
          'Audit'
          'Disabled'
        ]
        defaultValue: 'Deny'
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Compute/disks'
          }
          {
            field: 'Microsoft.Compute/disks/encryption.type'
            notEquals: 'EncryptionAtRestWithCustomerKey'
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}

output policyDefinitionId string = cmkDESPolicy.id
