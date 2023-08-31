resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.cluster_name
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "dns-${var.cluster_name}"

  kubernetes_version = var.cluster_version

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = var.default_instance_type
    node_count = var.default_node_count
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "web" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  name                  = "web"
  vm_size               = var.web_instance_type
  node_count            = var.web_count
  enable_node_public_ip = true
}

resource "azurerm_kubernetes_cluster_node_pool" "voip" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  name                  = "voip"
  vm_size               = var.voip_instance_type
  node_count            = var.voip_count
  enable_node_public_ip = true
}

resource "azurerm_kubernetes_cluster_node_pool" "media" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  name                  = "media"
  vm_size               = var.media_instance_type
  node_count            = var.media_count
  enable_node_public_ip = true
}