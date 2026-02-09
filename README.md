# Azure-enterprise-ops-platform
This project demonstrates the deployment of an enterprise-style hub-and-spoke network in Azure using Terraform.
The network includes:

- Hub and Spoke VNets across multiple subnets
- Subnet-level Network Security Groups
- Route Tables with user-defined routes
- VNet Peering
- Azure Bastion for secure admin access
- Full Terraform modularization for reusability
  

## Project Phases
### Pre-Phase: Setup Terraform
<div style="display: flex; gap: 10px; align-items: flex-start; flex-wrap: nowrap;">
  <div style="text-align: center;">
    <b>providers.tf</b><br>
    <img src="https://github.com/user-attachments/assets/5d304981-39c3-422b-a60e-ddd06f391b11" width="320" alt="providers terraform" />
  </div>
  <div style="text-align: center;">
    <b>variables.tf</b><br>
    <img src="https://github.com/user-attachments/assets/b39c1f25-ae03-477f-9828-152300e3188a" width="320" alt="main variables" />
  </div>
  <div style="text-align: center;">
    <b>terraform.tfvars</b><br>
    <img src="https://github.com/user-attachments/assets/a5590e46-73c9-4f3e-9d87-b6390bd5bff5" width="320" alt="terraform tfvars main" />
  </div>
</div>

### Phase 1: Virtual Networks

- Created Hub and Spoke VNets with separate address spaces
- Used Terraform modules for reusability

  Terraform Files :
 <div style="display: flex; gap: 10px; align-items: flex-start; flex-wrap: nowrap;">
  <div style="text-align: center;">
    <b>modules/vnet/main.tf</b><br>
    <img src="https://github.com/user-attachments/assets/cdcdafe3-2220-435a-bca8-5059904476a2" width="350" alt="modules vnet main" />
  </div>
  <div style="text-align: center;">
    <b>modules/vnet/variables.tf</b><br>
    <img src="https://github.com/user-attachments/assets/a9f57f6a-7e03-4d08-8c51-2d6fba02c3ef" width="350" alt="modules vnet variables" />
  </div>
  <div style="text-align: center;">
    <b>modules/vnet/outputs.tf</b><br>
    <img src="https://github.com/user-attachments/assets/0c85f6d7-fa8e-49af-a44c-a364be10addb" width="350" alt="modules vnet outputs" />
  </div>
</div>


Resources created:

<img width="500"  alt="vnet-hub creation" src="https://github.com/user-attachments/assets/bb54d6be-c0d7-46b4-9e91-fc3241828379" />
<img width="500"  alt="spoke vnet creation" src="https://github.com/user-attachments/assets/ccc61573-b777-4005-8c04-488c74e2cbe1" />




Phase 2: Subnets
- Created subnets for Web, App, DB, Bastion, and Shared Services
- Each subnet assigned proper address ranges
- Screenshot: phase2-subnets.png

Phase 3: Network Security Groups (NSGs)

Created separate NSGs for Web, App, and DB subnets

Minimal inbound rule: Allow HTTP (TCP/80)

Modularized for reusability

Screenshot: phase3-nsgs.png

Phase 4: NSG Associations

Associated each NSG to its corresponding subnet

Verified NSG assignment in Azure Portal
  
Screenshot: phase4-nsg-association.png

Phase 5: Route Tables

Created a user-defined route table for App and DB subnets

Configured default route to Internet (placeholder for future firewall)

Associated route tables with subnets

Screenshot: phase5-route-tables.png

Phase 6: VNet Peering

Peered Hub VNet ↔ Spoke VNet bidirectionally

Allowed traffic between hub and spoke subnets

Screenshot: phase6-vnet-peering.png

Phase 7: Bastion & Shared Services

Created Azure Bastion in Hub VNet for secure RDP/SSH

Assigned static Standard Public IP

Created Shared Services subnet in hub (for future utilities)

Screenshots:

Bastion Subnet: phase7-bastion-subnet.png

Public IP: phase8-bastion-pip.png

Bastion Host: phase9-bastion-host.png

Note: Bastion and VM demo connectivity not shown due to region constraints. Bastion is valid and fully deployed.

Phase 8: Resource Overview

Verified infrastructure using Azure subscription visualizer

Screenshot: subscription-visualizer.png

Key Takeaways

Modular Terraform code makes infrastructure reusable and maintainable

NSGs + route tables enforce security and traffic flow at subnet level

Hub-and-spoke architecture provides centralized control and secure admin access

Documenting infrastructure with screenshots ensures auditability and clarity
