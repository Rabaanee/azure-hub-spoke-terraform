module "hub_vnet" {
  source         = "./modules/vnet"
  name           = "vnet-hub"
  address_space  = ["10.0.0.0/16"]
  location       = var.location
  resource_group = var.hub_rg
}

module "spoke_vnet" {
  source         = "./modules/vnet"
  name           = "vnet-spoke-prod"
  address_space  = ["10.1.0.0/16"]
  location       = var.location
  resource_group = var.spoke_rg
}
module "hub_bastion_subnet" {
  source          = "./modules/subnet"
  name            = "AzureBastionSubnet"
  address_prefix  = "10.0.1.0/27"
  resource_group  = var.hub_rg
  vnet_name       = module.hub_vnet.name
}
module "shared_services_subnet" {
  source          = "./modules/subnet"
  name            = "SharedServicesSubnett"
  address_prefix  = "10.0.2.0/24"
  resource_group  = var.hub_rg
  vnet_name       = module.hub_vnet.name
}
module "spoke_web_subnet" {
  source          = "./modules/subnet"
  name            = "WebSubnet"
  address_prefix  = "10.1.1.0/24"
  resource_group  = var.spoke_rg
  vnet_name       = module.spoke_vnet.name
}
module "app_subnet" {
  source          = "./modules/subnet"
  name            = "AppSubnet"
  address_prefix  = "10.1.2.0/24"
  resource_group  = var.spoke_rg
  vnet_name       = module.spoke_vnet.name
}
module "db_subnet" {
  source          = "./modules/subnet"
  name            = "DBSubnet"
  address_prefix  = "10.1.3.0/24"
  resource_group  = var.spoke_rg
  vnet_name       = module.spoke_vnet.name
}
module "web_nsg" {
  source         = "./modules/nsg"
  name           = "nsg-web"
  location       = var.location
  resource_group = var.spoke_rg
}

module "app_nsg" {
  source         = "./modules/nsg"
  name           = "nsg-app"
  location       = var.location
  resource_group = var.spoke_rg
}

module "db_nsg" {
  source         = "./modules/nsg"
  name           = "nsg-db"
  location       = var.location
  resource_group = var.spoke_rg
}
resource "azurerm_subnet_network_security_group_association" "web_assoc" {
  subnet_id                 = module.spoke_web_subnet.id
  network_security_group_id = module.web_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "app_assoc" {
  subnet_id                 = module.app_subnet.id
  network_security_group_id = module.app_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "db_assoc" {
  subnet_id                 = module.db_subnet.id
  network_security_group_id = module.db_nsg.id
}
module "spoke_route_table" {
  source         = "./modules/route-table"
  name           = "rt-spoke-app-db"
  location       = var.location
  resource_group = var.spoke_rg
}
resource "azurerm_subnet_route_table_association" "app_rt_assoc" {
  subnet_id      = module.app_subnet.id
  route_table_id = module.spoke_route_table.id
}

resource "azurerm_subnet_route_table_association" "db_rt_assoc" {
  subnet_id      = module.db_subnet.id
  route_table_id = module.spoke_route_table.id
}
# Hub → Spoke
module "hub_to_spoke" {
  source         = "./modules/vnet-peering"
  name           = "hub-to-spoke-peering"
  resource_group = var.hub_rg
  vnet_name      = module.hub_vnet.name
  remote_vnet_id = module.spoke_vnet.id
}

# Spoke → Hub
module "spoke_to_hub" {
  source         = "./modules/vnet-peering"
  name           = "spoke-to-hub-peering"
  resource_group = var.spoke_rg
  vnet_name      = module.spoke_vnet.name
  remote_vnet_id = module.hub_vnet.id
}
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
resource "azurerm_public_ip" "bastion" {
  name                = "bastion-pip"
  location            = var.location
  resource_group_name = var.hub_rg
  allocation_method   = "Static"
  sku                 = "Standard"
}