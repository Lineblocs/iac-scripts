# GKE cluster
data "google_container_engine_versions" "gke_version" {
  project        = var.project_id
  location       = try(var.zone, var.region)
  version_prefix = var.cluster_version_prefix
}

resource "google_container_cluster" "primary" {
  project  = var.project_id
  name     = var.cluster_name
  location = try(var.zone, var.region)

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

resource "google_container_node_pool" "web_nodes" {
  project  = var.project_id
  name     = "${google_container_cluster.primary.name}-web"
  location = try(var.zone, var.region)
  cluster  = google_container_cluster.primary.name

  version    = try(var.cluster_version, data.google_container_engine_versions.gke_version.release_channel_default_version["STABLE"])
  node_count = var.web_count

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    disk_type = var.web_disk_type

    machine_type = var.web_instance_type
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata     = {
      disable-legacy-endpoints = "true"
    }
  }
}

resource "google_container_node_pool" "voip_nodes" {
  project  = var.project_id
  name     = "${google_container_cluster.primary.name}-voip"
  location = try(var.zone, var.region)
  cluster  = google_container_cluster.primary.name

  version    = try(var.cluster_version, data.google_container_engine_versions.gke_version.release_channel_default_version["STABLE"])
  node_count = var.voip_count

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env      = var.project_id
      voipNode = true
    }

    disk_type = var.voip_disk_type

    machine_type = var.voip_instance_type
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata     = {
      disable-legacy-endpoints = "true"
    }
  }
}

resource "google_container_node_pool" "media_nodes" {
  project  = var.project_id
  name     = "${google_container_cluster.primary.name}-media"
  location = try(var.zone, var.region)
  cluster  = google_container_cluster.primary.name

  version    = try(var.cluster_version, data.google_container_engine_versions.gke_version.release_channel_default_version["STABLE"])
  node_count = var.media_count

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    disk_type = var.media_disk_type

    machine_type = var.media_instance_type
    metadata     = {
      disable-legacy-endpoints = "true"
    }
  }
}
