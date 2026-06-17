# CMK Disk Encryption Policy-as-Code (Azure Bicep)

A policy-as-code project that enforces Customer-Managed Key (CMK) encryption on all managed disks in an Azure resource group, deployed using Bicep and Azure CLI.

## Project Structure

- `policy.bicep` — Custom Azure Policy definition (Deny disks without CMK)
- `assignment.bicep` — Policy assignment scoped to POLICY-RG
- `parameters.json` — Deployment parameters
- `keyvault-des.bicep` — Key Vault + CMK key + Disk Encryption Set
- `attach-des-to-vm.bicep` — Attaches DES to existing VM OS disk

## Tech Stack
- Azure Bicep
- Azure Policy
- Azure Key Vault
- Azure Disk Encryption Sets
- Azure CLI
- VS Code
