resource "digitalocean_kubernetes_cluster" "k8s" {
  name    = var.cluster_name
  region  = var.do_region
  version = var.kube_version

  node_pool {
    name       = "web"
    size       = var.web_type
    min_nodes  = var.web_min_nodes
    max_nodes  = var.web_max_nodes
    auto_scale = true
  }
}

resource "digitalocean_kubernetes_node_pool" "k8s_voip_nodes" {
  cluster_id = digitalocean_kubernetes_cluster.k8s.id

  name       = "voip"
  size       = var.voip_type
  min_nodes  = var.voip_min_nodes
  max_nodes  = var.voip_max_nodes
  auto_scale = true
  labels     = {
    routerNode = "true"
  }
}

resource "digitalocean_kubernetes_node_pool" "k8s_media_nodes" {
  cluster_id = digitalocean_kubernetes_cluster.k8s.id

  name       = "media"
  size       = var.media_type
  min_nodes  = var.media_min_nodes
  max_nodes  = var.media_max_nodes
  auto_scale = true
}

resource "digitalocean_firewall" "cluster_firewall" {
  name = "lineblocs-cluster-firewall-${digitalocean_kubernetes_cluster.k8s.id}"

  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "1-65535"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  tags       = ["k8s:${digitalocean_kubernetes_cluster.k8s.id}"]
  depends_on = [
    digitalocean_kubernetes_cluster.k8s
  ]
}
