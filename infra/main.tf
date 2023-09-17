resource "azurerm_resource_group" "resource_group" {
  name     = "python-rg"
  location = "West US"
}

resource "azurerm_container_registry" "container_registry" {
  name                = "pythonacr89"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  sku                 = "Premium"
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                = "python-aks"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

}

    # data "azurerm_container_registry" "acr_name" {
    #   name = "xxxxx"
    #   resource_group_name = "xxxxx"
    # }
    # resource "azurerm_role_assignment" "aks_to_acr_role" {
    #   scope                = data.azurerm_container_registry.acr_name.id
    #   role_definition_name = "AcrPull"
    #   principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
    #   skip_service_principal_aad_check = true
    # }

resource "azurerm_role_assignment" "role_assignment" {
  principal_id                     = azurerm_kubernetes_cluster.kubernetes_cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.container_registry.id
  skip_service_principal_aad_check = true
}