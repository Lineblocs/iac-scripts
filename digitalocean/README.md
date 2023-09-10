# Terraform Kubernetes on Digital Ocean

This repository contains the Terraform module for creating a Kubernetes Cluster on Google GKE.

<p align="center">
<img alt="DO Logo" src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/DigitalOcean_logo.svg/240px-DigitalOcean_logo.svg.png" title="DO Logo">
</p>

- [Terraform Kubernetes on Digital Ocean](#Terraform-Kubernetes-on-Digital-Ocean)
- [Requirements](#Requirements)
- [Notes](#Notes)
- [Defaults](#Defaults)
- [Runtime](#Runtime)
- [Terraform Inputs](#Terraform-Inputs)
- [Outputs](#Outputs)

## Requirements

You need a [GCP account](https://console.cloud.google.com)
and [gcloud CLI set up](https://cloud.google.com/sdk/docs/install?hl=fr).

Run `gcloud init` to initialize your CLI. You can create a brand-new project for this test. Please note that it cannot
run without a billing account attached to the project.

When you have everything set up, note your project ID. You will use it as the value of `project_id` variable.

## Notes

* The resources will be created in your GCP project
* You can tweak variables in the table below to customize cluster size to your need.
* You can run this command
  ```gcloud container clusters get-credentials <cluster_name> --location <region-code or zone-code>``` to
  connect to the cluster.
  More info [here](https://cloud.google.com/sdk/gcloud/reference/container/clusters/get-credentials)
* You will probably need to install gke-gcloud-auth-plugin, refer
  to [this link](https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke).

## Defaults

See tables at the end for a comprehensive list of inputs and outputs.

* Default vpc cidr: **10.123.0.0/16**
* Default web node type: **e2-standard-2** _(2x vCPU, 8GB memory)_
* Default web disk type: **pd-standard** _(HDD)_
* Default media node type: **e2-standard-2** _(2x vCPU, 8GB memory)_
* Default media disk type: **pd-standard** _(HDD)_
* Default router node type: **e2-standard-2** _(2x vCPU, 8GB memory)_
* Default router disk type: **pd-standard** _(HDD)_
* Default web pool size: **4**
* Default media pool size: **2**
* Default voip pool size: **2**
* Default zone: **null**

## Runtime

Runtime `terraform apply`:

~12min

```bash
terraform apply  19,52s user 1,60s system 2% cpu 14:17,06 total
```

## Terraform Inputs

| Name                   | Description                                             | Type   | Default values |
|------------------------|---------------------------------------------------------|--------|----------------|
| cluster_name           |                                                         | string |                |
| cluster_version        | GKE cluster exact version, will overwrite prefix if set | string | null           |
| cluster_version_prefix | GKE cluster version prefix                              | string | 1.27           |
| media_count            | GKE media desired count of node                         | number | 2              |
| media_disk_type        | GKE media nodes disk type                               | string | pd-standard    |
| media_instance_type    | GKE media instance type                                 | string | e2-standard-2  |
| project_id             | GCP project ID                                          | string |                |
| region                 | GCP resources region                                    | string |                |
| voip_count             | GKE voip desired count of node                          | number | 2              |
| voip_disk_type         | GKE voip nodes disk type                                | string | pd-standard    |
| voip_instance_type     | GKE voip instance type                                  | string | e2-standard-2  |
| vpc_main_subnet        | VPC Classless Inter-Domain Routing                      | string | 10.123.0.0/24  |
| web_count              | GKE web desired count of node                           | number | 4              |
| web_disk_type          | GKE web nodes disk type                                 | string | pd-standard    |
| web_instance_type      | GKE web instance type                                   | string | e2-standard-2  |
| zone                   | GCP resources zone (uses region if not defined)         | string | null           |
