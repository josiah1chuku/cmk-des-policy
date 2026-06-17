// attach-des-to-vm.bicep
targetScope = 'resourceGroup'

param location string = 'centralindia'
param vmName string = 'azureuser'
param desId string

resource osDiskUpdate 'Microsoft.Compute/disks@2023-04-02' = {
  name: '${vmName}_osdisk_1_44ba6e3dd8dc4f43ae2c05af81c97704'
  location: location
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    encryption: {
      type: 'EncryptionAtRestWithCustomerKey'
      diskEncryptionSetId: desId
    }
  }
}

output diskName string = osDiskUpdate.name
output encryptionType string = osDiskUpdate.properties.encryption.type
