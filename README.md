# Azure Enterprise Hub-and-Spoke Network with Terraform

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/Microsoft_Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

**AZ-104 Certified** • **Terraform Associate (In Progress)** • **Cloud Portfolio Project**


## 🚀 Introduction

This project demonstrates my implementation of a production-ready **enterprise hub-and-spoke network architecture** on Microsoft Azure using Infrastructure as Code (Terraform). 

As part of my cloud engineering journey—having recently passed the **AZ-104 Azure Administrator certification** and currently preparing for the **HashiCorp Terraform Associate**—this project represents my hands-on application of core cloud networking concepts in a real-world scenario.

## 📋 Project Overview

**Objective:** Deploy a secure, scalable hub-and-spoke network topology following Azure best practices for enterprise environments.

**Key Features:**
- ✅ **Modular Terraform Design** – Reusable modules for VNets, subnets, NSGs, and peering
- ✅ **Security-First Architecture** – Network Security Groups for each application tier
- ✅ **Centralized Management** – Hub VNet with Azure Bastion for secure access
- ✅ **Proper Segmentation** – Three-tier application isolation (Web/App/DB)
- ✅ **Traffic Control** – Route tables for controlled egress traffic flow

## 🛠️ **Skills Demonstrated**

| **Azure Services** | **Terraform Concepts** | **Networking Principles** |
|:-------------------|:------------------------|:--------------------------|
| • Virtual Networks & Subnets | • Modular Code Structure | • Hub-and-Spoke Topology |
| • Network Security Groups | • Remote State Management | • CIDR Planning & IP Addressing |
| • VNet Peering | • Provider Configuration | • Subnet Segmentation |
| • Azure Bastion | • Variable Definitions | • Traffic Routing (UDRs) |
| • Route Tables | • Output Values | • Security Zones |

## 📋 Prerequisites

Before deploying this infrastructure, ensure you have:

- **Azure Account** with active subscription (free tier works)
- **Azure CLI** installed and configured (`az login`)
- **Terraform** v1.0+ installed locally
- Proper **permissions** to create resources in your Azure subscription
- **Git** for cloning the repository

## 🚀 Quick Start (Deploy in 10 Minutes)

| **Step** | **Command** | **Description** |
|:---|:---|:---|
| **1. Clone** | `git clone https://github.com/Rabaanee/azure-hub-spoke-terraform.git`<br>`cd azure-hub-spoke-terraform` | Get the code locally |
| **2. Authenticate** | `az login` | Connect to your Azure account |
| **3. Initialize** | `terraform init` | Set up Terraform backend & providers |
| **4. Plan** | `terraform plan` | Review what will be created |
| **5. Deploy** | `terraform apply -auto-approve` | Create all Azure resources |
| **6. Cleanup** | `terraform destroy -auto-approve` | Remove resources to avoid charges |

**Deployment Time:** ~15 minutes  
**Estimated Cost:** ~£110/month (mainly Azure Bastion)  
**Resources Created:** 15+ Azure resources across 2 resource groups
## 🏗️ Architecture Overview

The network implements:
- Hub and Spoke VNets with isolated address spaces
- Subnet-level Network Security Groups (NSGs)
- User-defined Route Tables (UDRs)
- Bidirectional VNet Peering
- Azure Bastion for secure administrative access
- Fully modularized Terraform code

<img width="800" alt="Hub and Spoke Network Diagram" src="https://github.com/user-attachments/assets/8cd98e1e-2071-43aa-ae6e-00d4a78efdeb" />



## 📁 Project Structure
```
azure-network-terraform/
├── providers.tf           # Azure provider configuration
├── variables.tf           # Input variables
├── main.tf               # Main orchestration
├── outputs.tf            # Output values
├── terraform.tfvars      # Variable values
└── modules/
    ├── vnet/             # Virtual Network module
    ├── subnet/           # Subnet module
    ├── nsg/              # Network Security Group module
    ├── route-table/      # Route Table module
    └── peering/          # VNet Peering module
```

---

## 🚀 Deployment Phases

### Pre-Phase: Terraform Setup
**Core Configuration Files:**

| providers.tf | variables.tf | terraform.tfvars |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/5d304981-39c3-422b-a60e-ddd06f391b11" width="280" alt="providers.tf" /> | <img src="https://github.com/user-attachments/assets/b39c1f25-ae03-477f-9828-152300e3188a" width="280" alt="variables.tf" /> | <img src="https://github.com/user-attachments/assets/a5590e46-73c9-4f3e-9d87-b6390bd5bff5" width="280" alt="terraform.tfvars" /> |

---

### Phase 1: Virtual Networks

**What I built:**
- Hub VNet (central network) and Spoke VNet (workload network)
- Separate address spaces to prevent IP conflicts
- Reusable Terraform VNet module

**VNet Module Files:**

| modules/vnet/main.tf | modules/vnet/variables.tf | modules/vnet/outputs.tf |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/cdcdafe3-2220-435a-bca8-5059904476a2" width="280" alt="vnet main.tf" /> | <img src="https://github.com/user-attachments/assets/a9f57f6a-7e03-4d08-8c51-2d6fba02c3ef" width="280" alt="vnet variables.tf" /> | <img src="https://github.com/user-attachments/assets/0c85f6d7-fa8e-49af-a44c-a364be10addb" width="280" alt="vnet outputs.tf" /> |

#### 🔧 Using the Module in main.tf
**After creating the module, I added this to my root main.tf:**
```hcl
# Create Hub VNet (central network for shared services)
module "hub_vnet" {
  source         = "./modules/vnet"
  name           = "vnet-hub"
  address_space  = ["10.0.0.0/16"]
  location       = var.location
  resource_group = var.hub_rg
}
# Create Spoke VNet (isolated workload network)
module "spoke_vnet" {
  source         = "./modules/vnet"
  name           = "vnet-spoke-prod"
  address_space  = ["10.1.0.0/16"]
  location       = var.location
  resource_group = var.spoke_rg
}
```

---

#### 📊 Resources Created in Azure

<img width="500"  alt="vnet-hub creation" src="https://github.com/user-attachments/assets/bb54d6be-c0d7-46b4-9e91-fc3241828379" />
<img width="500"  alt="spoke vnet creation" src="https://github.com/user-attachments/assets/ccc61573-b777-4005-8c04-488c74e2cbe1" />

**Why it matters:**  
The hub VNet serves as the central connectivity point for all workloads. Proper IP address planning at this stage is critical—overlapping CIDR ranges would prevent VNet peering in later phases.

---


### Phase 2: Subnets

**What I built:**
- Created a reusable Subnet Terraform module
- Deployed subnets in Hub VNet: `AzureBastionSubnet`, `SharedServicesSubnet`
- Deployed subnets in Spoke VNet: `WebSubnet`, `AppSubnet`, `DBSubnet`
- Planned address ranges within each VNet's address space

#### 📂 Subnet Module Files

| modules/subnet/main.tf | modules/subnet/variables.tf | modules/subnet/outputs.tf |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/cdcdafe3-2220-435a-bca8-5059904476a2" width="280" alt="subnet main.tf" /> | <img src="https://github.com/user-attachments/assets/a9f57f6a-7e03-4d08-8c51-2d6fba02c3ef" width="280" alt="subnet variables.tf" /> | <img src="https://github.com/user-attachments/assets/0c85f6d7-fa8e-49af-a44c-a364be10addb" width="280" alt="subnet outputs.tf" /> |

---

#### 🔧 Using the Module in main.tf

**After creating the subnet module, I added this to my root main.tf:**
```hcl
# Hub VNet Subnets
module "bastion_subnet" {
  source               = "./modules/subnet"
  name                 = "AzureBastionSubnet"  # Required name for Bastion
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.hub_vnet.name
  address_prefixes     = ["10.0.1.0/26"]      # Minimum /26 for Bastion
}

module "shared_services_subnet" {
  source               = "./modules/subnet"
  name                 = "SharedServicesSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.hub_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Spoke VNet Subnets (Three-tier architecture)
module "web_subnet" {
  source               = "./modules/subnet"
  name                 = "WebSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.spoke_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}

module "app_subnet" {
  source               = "./modules/subnet"
  name                 = "AppSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.spoke_vnet.name
  address_prefixes     = ["10.1.2.0/24"]
}

module "db_subnet" {
  source               = "./modules/subnet"
  name                 = "DBSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.spoke_vnet.name
  address_prefixes     = ["10.1.3.0/24"]
}
```

---

#### 📊 Resources Created in Azure

<img width="500"  alt="spoke subnets created" src="https://github.com/user-attachments/assets/84cbf0a0-971c-4326-b523-fd9bdb864566" />
<img width="500"  alt="hub subnets created" src="https://github.com/user-attachments/assets/4d7f9db7-8997-4436-8058-0f0cbd2c7d3f" />

**Why it matters:**  
Subnet segmentation enables granular security control through NSGs and route tables. The three-tier architecture (Web/App/DB) in the spoke follows enterprise best practices for application isolation. The Bastion subnet requires a minimum `/26` address space and must be named `AzureBastionSubnet`.

---


### Phase 3: Network Security Groups (NSGs)

**What I built:**
- Created a reusable NSG Terraform module
- Deployed separate NSGs for Web, App, and DB subnets
- Configured security rules (e.g., Allow HTTP/80 for Web tier, restrict DB access)
- Modularized NSG code for consistency and reusability

---

#### 📂 NSG Module Files

| modules/nsg/main.tf | modules/nsg/variables.tf | modules/nsg/outputs.tf |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/a557422b-1e01-4fef-8572-cfbe75446e7b" width="440" alt="nsg main.tf" /> | <img src="https://github.com/user-attachments/assets/73784135-c766-4c8e-8e0d-00f3594ca33e" /> | <img src="https://github.com/user-attachments/assets/f880bbb9-a0f7-40ff-802c-00b1774dd5a9" width="280" alt="nsg outputs.tf" /> |

---

#### 🔧 Using the Module in main.tf

**After creating the NSG module, I added this to my root main.tf:**
```hcl
# Create NSG for Web Subnet
module "web_nsg" {
  source         = "./modules/nsg"
  name           = "nsg-web"
  location       = var.location
  resource_group = var.spoke_rg
}

# Create NSG for App Subnet
module "app_nsg" {
  source         = "./modules/nsg"
  name           = "nsg-app"
  location       = var.location
  resource_group = var.spoke_rg
}

# Create NSG for DB Subnet
module "db_nsg" {
  source         = "./modules/nsg"
  name           = "nsg-db"
  location       = var.location
  resource_group = var.spoke_rg
}
```

---

#### 📊 Resources Created in Azure
<img width="1861" height="827" alt="nsg all" src="https://github.com/user-attachments/assets/b8ec65e8-e1c0-48e3-a2f5-daac546930ea" />

**Why it matters:**  
NSGs act as virtual firewalls at the subnet level, controlling inbound and outbound traffic. While this basic implementation allows HTTP traffic, NSGs can be enhanced with more granular rules to enforce least-privilege access between application tiers in production environments.

---

### Phase 4: NSG Associations

**What I built:**
- Associated Web NSG to Web subnet
- Associated App NSG to App subnet
- Associated DB NSG to DB subnet
- Verified NSG assignments in Azure Portal

---

#### 🔧 Implementation in main.tf

**After creating the NSGs, I linked them to their corresponding subnets:**
```hcl
# Associate Web NSG to Web Subnet
resource "azurerm_subnet_network_security_group_association" "web_assoc" {
  subnet_id                 = module.web_subnet.id
  network_security_group_id = module.web_nsg.id
}

# Associate App NSG to App Subnet
resource "azurerm_subnet_network_security_group_association" "app_assoc" {
  subnet_id                 = module.app_subnet.id
  network_security_group_id = module.app_nsg.id
}

# Associate DB NSG to DB Subnet
resource "azurerm_subnet_network_security_group_association" "db_assoc" {
  subnet_id                 = module.db_subnet.id
  network_security_group_id = module.db_nsg.id
}
```

---

#### 📊 Resources Verified in Azure

<img width="900" alt="NSG Associations" src="https://github.com/user-attachments/assets/00b4731e-8488-4294-b202-4b59857a41c9" />


**Why it matters:**  
NSG rules don't take effect until the NSG is associated with a subnet or network interface. This step activates the security policies, ensuring traffic filtering is enforced at the subnet level for all resources within each tier.

---
### Phase 5: Route Tables

**What I built:**
- Created a reusable Route Table Terraform module
- Deployed a route table for App and DB subnets with a default route to the internet
- Configured user-defined routes (UDRs) for traffic control
- Associated the route table with App and DB subnets

---

#### 📂 Route Table Module Files

| modules/route-table/main.tf | modules/route-table/variables.tf | modules/route-table/outputs.tf |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/b3666ecc-b22d-4cd4-af69-a6c44b3b9b67" width="440" alt="route-table main.tf" /> | <img src="https://github.com/user-attachments/assets/1b6e8b7f-9b92-401b-888e-c2d52b81182a" width="280" alt="route-table variables.tf" /> | <img src="https://github.com/user-attachments/assets/d813b6e3-a937-455d-a063-ae329100e5c9" width="280" alt="route-table outputs.tf" /> |



---

#### 🔧 Using the Module in main.tf

**After creating the route table module, I added this to my root main.tf:**
```hcl
# Create Route Table for App and DB subnets
module "spoke_route_table" {
  source         = "./modules/route-table"
  name           = "rt-spoke-app-db"
  location       = var.location
  resource_group = var.spoke_rg
}

# Associate Route Table with App Subnet
resource "azurerm_subnet_route_table_association" "app_rt_assoc" {
  subnet_id      = module.app_subnet.id
  route_table_id = module.spoke_route_table.id
}

# Associate Route Table with DB Subnet
resource "azurerm_subnet_route_table_association" "db_rt_assoc" {
  subnet_id      = module.db_subnet.id
  route_table_id = module.spoke_route_table.id
}
```

---

#### 📊 Resources Created in Azure

<img width="700" alt="Route Table and Associations" src="https://github.com/user-attachments/assets/ceb251df-0300-498c-8eb5-ba39d3f6cfb8" />



**Why it matters:**  
Route tables use user-defined routes (UDRs) to control traffic flow. Currently, the default route (0.0.0.0/0) sends all traffic to the internet, but this is a **placeholder for future Azure Firewall integration**. In production, this route would point to a firewall in the hub VNet, forcing all App and DB outbound traffic through centralized inspection and logging.

**Design decision:**  
The Web subnet has no route table, allowing direct internet access for public-facing traffic. The App and DB subnets share a route table, establishing a foundation where outbound traffic can later be routed through a Network Virtual Appliance (NVA) or Azure Firewall for security inspection.


---

### Phase 6: VNet Peering

**What I built:**
- Created a reusable VNet Peering Terraform module
- Established bidirectional peering between Hub and Spoke VNets
- Enabled traffic flow and forwarded traffic between networks
- Configured peering to allow virtual network access

---

#### 📂 VNet Peering Module Files

| modules/vnet-peering/main.tf | modules/vnet-peering/variables.tf | modules/vnet-peering/outputs.tf |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/91087d1e-e4b7-42cd-8a88-6e08ff23eb35" width="280" alt="peering main.tf" /> | <img src="https://github.com/user-attachments/assets/c9617d1a-839d-4ceb-8945-10293983f4c4" width="280" alt="peering variables.tf" /> | <img src="https://github.com/user-attachments/assets/30662a19-53a8-44c1-812b-6ffc81c5320a" width="280" alt="peering outputs.tf" /> |

---

#### 🔧 Using the Module in main.tf

**After creating the peering module, I added this to my root main.tf:**
```hcl
# Create peering from Hub to Spoke
module "hub_to_spoke" {
  source         = "./modules/vnet-peering"
  name           = "hub-to-spoke-peering"
  resource_group = var.hub_rg
  vnet_name      = module.hub_vnet.name
  remote_vnet_id = module.spoke_vnet.id
}

# Create peering from Spoke to Hub
module "spoke_to_hub" {
  source         = "./modules/vnet-peering"
  name           = "spoke-to-hub-peering"
  resource_group = var.spoke_rg
  vnet_name      = module.spoke_vnet.name
  remote_vnet_id = module.hub_vnet.id
}
```

---

#### 📊 Resources Created in Azure

<img width="1835" height="354" alt="vnet-spoke peering complete" src="https://github.com/user-attachments/assets/f32849ca-fe7b-4d4a-8446-2b738690b849" />
<img width="1858" height="357" alt="peering vnet-hub " src="https://github.com/user-attachments/assets/2f051ebc-dd13-491d-93f3-3bedd7f06388" />

**Why it matters:**  
VNet peering enables private, low-latency connectivity between virtual networks without routing traffic over the public internet or through a VPN gateway. Peering must be configured **bidirectionally**—each VNet needs its own peering connection to the other. This establishes the foundation of the hub-and-spoke architecture, allowing the hub to centralize shared services while spokes remain isolated from each other.

**Key configuration:**  
- `allow_forwarded_traffic = true` enables spoke-to-spoke communication through the hub
- `allow_virtual_network_access = true` permits resources in peered VNets to communicate
- Gateway transit settings are disabled as no VPN gateway is currently deployed

---

### Phase 7: Azure Bastion

**What I built:**
- Deployed Azure Bastion in Hub VNet for secure RDP/SSH access
- Created Standard Public IP (51.105.27.114) for Bastion connectivity
- Configured Bastion to use the AzureBastionSubnet (10.0.1.0/27)
- Established infrastructure for secure VM administration without public IPs

---

#### 🔧 Implementation in main.tf

**After creating all modules and infrastructure, I added Bastion to my root main.tf:**
```hcl
# Public IP for Bastion
resource "azurerm_public_ip" "bastion" {
  name                = "bastion-pip"
  location            = var.location
  resource_group_name = var.hub_rg
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Azure Bastion Host
resource "azurerm_bastion_host" "this" {
  name                = "hub-bastion"
  location            = var.location
  resource_group_name = var.hub_rg
  
  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = module.hub_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}
```

---

#### 📊 Resources Created in Azure


<img width="1418" height="43" alt="bastion ip" src="https://github.com/user-attachments/assets/8d6309ea-347c-40c2-9cdc-30b11ee453f4" />


<img width="1918" height="911" alt="bastion created" src="https://github.com/user-attachments/assets/f8f3e290-a534-49d9-a6c8-cf0276851a79" />


<img width="1921" height="920" alt="bastion in vnet-hub" src="https://github.com/user-attachments/assets/2b198fff-30e6-4da2-a604-32ccc8e74836" />

**Why it matters:**  
Azure Bastion provides secure RDP/SSH connectivity to virtual machines without exposing them to the public internet. All connections are made over SSL (port 443) through the Azure Portal, eliminating the need for public IPs on VMs and significantly reducing the attack surface.

**Key benefits:**
- Centralized access point for all VMs in hub and spoke networks
- No need to manage jump boxes or VPN connections
- Encrypted connections over SSL
- Integration with Azure AD for authentication

**Important limitation:**  
Azure Bastion must be deployed in the **same region** as the VMs it will access. Cross-region Bastion connectivity is not supported.

**Project note:**  
Due to regional subscription quota limitations, I was unable to deploy test VMs in the same region as Bastion for connectivity validation. However, the Bastion infrastructure is fully deployed and functional. In a production environment, this would provide centralized secure access to all VMs across the hub and spoke networks.

---

### Phase 8: Infrastructure Verification

**What I accomplished:**
- Successfully deployed complete hub-and-spoke network architecture using Terraform
- Verified all resources across Hub and Spoke resource groups
- Confirmed infrastructure state with `terraform show`
- Validated network topology with Azure Resource Visualizer

---

#### 📊 Azure Resource Visualizer - Complete Infrastructure

**Visual representation of deployed resources:**

<img width="900" alt="Azure Resource Visualizer" src="https://github.com/user-attachments/assets/279f4b92-6915-4ac0-aa5d-0f1165dd5b23" />

*The diagram shows the relationship between all components: VNets, Bastion, NSGs, Route Table, and their interconnections through peering.*

---

#### 📊 Hub Resource Group (rg-hub-network)

<img width="900" alt="Hub Resource Group" src="https://github.com/user-attachments/assets/bd0eba4e-16b6-490f-a61d-eff93305d691" />

**Hub Resources:**
- ✅ vnet-hub (10.0.0.0/16)
- ✅ bastion-pip (Public IP: 51.105.27.114)
- ✅ hub-bastion (Azure Bastion)

---

#### 📊 Spoke Resource Group (rg-spoke-prod-network)

<img width="900" alt="Spoke Resource Group" src="https://github.com/user-attachments/assets/f4885511-4086-49fd-b01f-6a4ac6c154e7" />

**Spoke Resources:**
- ✅ vnet-spoke-prod (10.1.0.0/16)
- ✅ nsg-web, nsg-app, nsg-db (Network Security Groups)
- ✅ rt-spoke-app-db (Route Table)

---

#### 🎯 Deployment Summary

**Infrastructure Components:**

| Category | Resource | Status |
|:---|:---|:---:|
| **Virtual Networks** | vnet-hub (10.0.0.0/16) | ✅ |
| | vnet-spoke-prod (10.1.0.0/16) | ✅ |
| **Subnets** | AzureBastionSubnet (10.0.1.0/27) | ✅ |
| | SharedServicesSubnet (10.0.2.0/24) | ✅ |
| | WebSubnet (10.1.1.0/24) | ✅ |
| | AppSubnet (10.1.2.0/24) | ✅ |
| | DBSubnet (10.1.3.0/24) | ✅ |
| **Security** | nsg-web, nsg-app, nsg-db | ✅ |
| | NSG Associations (3) | ✅ |
| **Routing** | rt-spoke-app-db | ✅ |
| | Route Table Associations (2) | ✅ |
| **Connectivity** | hub-to-spoke-peering | ✅ |
| | spoke-to-hub-peering | ✅ |
| **Bastion** | hub-bastion | ✅ |
| | bastion-pip (51.105.27.114) | ✅ |

---

#### ✅ Architecture Validation

**Verified Configurations:**
- Hub VNet successfully peers with Spoke VNet (bidirectional) ✅
- All subnets deployed with correct address spaces ✅
- NSGs associated with Web, App, and DB subnets ✅
- Route table applied to App and DB subnets for controlled traffic flow ✅
- Bastion deployed in Hub VNet with Standard Public IP ✅
- All resources deployed in correct resource groups (hub vs spoke) ✅
- Terraform state reflects all deployed infrastructure ✅

**Infrastructure managed entirely through Terraform with modular, reusable code.**

---

## 📊 Project Metrics & Cost Analysis

| **Metric** | **Value** | **Insight** |
|-----------|----------|-------------|
| **Terraform Modules** | 6 | Modular, reusable design |
| **Azure Resources** | 15+ | Production-scale deployment |
| **Deployment Time** | 15 min | Efficient infrastructure provisioning |
| **Monthly Cost** | ~£110 | Bastion is primary cost driver |
| **Lines of Code** | ~300 | Clean, maintainable IaC |
| **Security Zones** | 5 | Web/App/DB/Bastion/Shared |

## 🎯 What This Project Demonstrates to Employers:

1. **Technical Proficiency:** AZ-104 concepts applied in real infrastructure
2. **Infrastructure as Code:** Production-ready Terraform with modules
3. **Cloud Architecture:** Enterprise hub-and-spoke pattern implementation
4. **Security Awareness:** NSGs, segmentation, secure access (Bastion)
5. **Cost Consciousness:** Clear cleanup instructions to prevent waste
6. **Documentation Skills:** Comprehensive, recruiter-friendly README

---

## 🎯 Key Takeaways

- **Modular Terraform** makes infrastructure reusable and maintainable
- **Hub-and-spoke architecture** centralizes shared services and scales horizontally
- **NSGs + Route Tables** enforce security and traffic control at the subnet level
- **VNet peering** enables secure, private connectivity between networks
- **Azure Bastion** provides secure admin access without public IPs

---

## 🔮 Future Enhancements

- Deploy Azure Firewall in the hub for centralized traffic inspection
- Add Azure VPN Gateway for hybrid connectivity
- Implement Azure Monitor and Network Watcher for observability
- Deploy test VMs to validate connectivity
- Add CI/CD pipeline for Terraform deployment
- Implement least-privilege NSG rules (restrict App/DB access to specific subnets)


---
## 📫 Connect With Me

- **LinkedIn:** www.linkedin.com/in/Rabaanee-Ahmed
- **GitHub:** https://github.com/Rabaanee

*Open to cloud engineering roles and eager to contribute to infrastructure teams.*

