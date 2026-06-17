// assignment.bicep
// Assigns the CMK DES policy to the POLICY-RG resource group

targetScope = 'resourceGroup'

param policyDefinitionId string
param effect string = 'Deny'

resource cmkPolicyAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'assign-cmk-disk-encryption-set'
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Enforce CMK on Disk Encryption Sets - POLICY-RG'
    description: 'Denies creation of managed disks not using a Customer-Managed Key.'
    policyDefinitionId: policyDefinitionId
    parameters: {
      effect: {
        value: effect
      }
    }
    enforcementMode: 'Default'
  }
}

output assignmentId string = cmkPolicyAssignment.id
output principalId string = cmkPolicyAssignment.identity.principalId
