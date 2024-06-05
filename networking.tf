data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_network_profile" "acg_network_profile" {
  name                = "acg-profile"
  location            = data.azurerm_virtual_network.vnet.location
  resource_group_name = var.resource_group_name

  container_network_interface {
    name = "acg-nic"

    ip_configuration {
      name      = "aci-ts-ipconfig"
      subnet_id = data.azurerm_subnet.subnet.id
    }
  }
} 

# resource "azurerm_subnet_delegation" "delegation" {
#   name                 = "aci-delegation"
#   subnet_id            = data.azurerm_subnet.subnet.id

#   service_delegation {
#     name = "Microsoft.ContainerInstance/containerGroups"
#     actions = [
#       "Microsoft.Network/virtualNetworks/subnets/join/action",
#       "Microsoft.Network/virtualNetworks/subnets/joinViaServiceEndpoint/action",
#     ]
#   }
# }