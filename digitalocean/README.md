# Terraform Kubernetes on Digital Ocean

This repository contains the Terraform module for creating a Kubernetes Cluster on Digital Ocean.

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

You need a [Digital Ocean account](https://cloud.digitalocean.com/registrations/new)
and [doctl set up](https://docs.digitalocean.com/reference/doctl/).

For the project you want, you should create an API token in settings and run this command :

```bash
doctl auth init --context <name_of_the_new_context>
```

doctl will prompt you for the token. Then, everything is ready.

## Notes

* The resources will be created in your DO project
* You can tweak variables in the table below to customize cluster size to your need.
* You can run this command
  ```doctl kubernetes cluster kubeconfig save <cluster_name>``` to
  connect to the cluster.
  More info [here](https://docs.digitalocean.com/reference/doctl/reference/kubernetes/cluster/kubeconfig/)

## Defaults

See tables at the end for a comprehensive list of inputs and outputs.

* Default web node type: **s-2vcpu-4gb** _(2x vCPU, 8GB memory)_
* Default media node type: **s-2vcpu-4gb** _(2x vCPU, 8GB memory)_
* Default router node type: **s-2vcpu-4gb** _(2x vCPU, 8GB memory)_
* Default web pool size: **4**
* Default media pool size: **2**
* Default voip pool size: **2**
* Default region: **tor1**

## Runtime

Runtime `terraform apply`:

~8min

```bash
terraform apply  1,18s user 0,16s system 0% cpu 7:57,77 total
```

## Terraform Inputs

| Name                | Description                        | Type   | Default values |
|---------------------|------------------------------------|--------|----------------|
| cluster_name        | DO cluster name                    | string |                |
| project_id          | DO project ID                      | string |                |
| do_region           | DO resources region                | string |                |
| do_token            | DO access token                    | string |                |
| web_min_nodes       | DO k8s web minimum count of node   | number | 4              |
| web_max_nodes       | DO k8s web maximum count of node   | number | 4              |
| web_instance_type   | DO k8s web instance type           | string | s-2vcpu-4gb    |
| voip_min_nodes      | DO k8s voip minimum count of node  | number | 4              |
| voip_max_nodes      | DO k8s voip maximum count of node  | number | 4              |
| voip_instance_type  | DO k8s voip instance type          | string | s-2vcpu-4gb    |
| media_min_nodes     | DO k8s media minimum count of node | number | 4              |
| media_max_nodes     | DO k8s media maximum count of node | number | 4              |
| media_instance_type | DO k8s media instance type         | string | s-2vcpu-4gb    |
