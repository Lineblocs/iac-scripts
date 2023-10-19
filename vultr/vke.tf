resource "vultr_kubernetes" "lineblocs" {
  label   = var.cluster_name
  region  = var.region
  version = var.cluster_version

  node_pools {
    label         = "web"
    node_quantity = var.web_count
    plan          = var.web_instance_type
  }
}

resource "vultr_kubernetes_node_pools" "voip" {
  cluster_id    = vultr_kubernetes.lineblocs.id
  label         = "voip"
  node_quantity = var.voip_count
  plan          = var.voip_instance_type
  tag           = "routerNode"
}

resource "vultr_kubernetes_node_pools" "media" {
  cluster_id    = vultr_kubernetes.lineblocs.id
  label         = "media"
  node_quantity = var.media_count
  plan          = var.media_instance_type
}