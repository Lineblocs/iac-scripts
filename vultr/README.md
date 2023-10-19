# Terraform Kubernetes on Vultr

This repository contains the Terraform module for creating a Kubernetes Cluster on Vultr.

<p align="center">
<img alt="Vultr Logo" src="/https://www.google.com/url?sa=i&url=https%3A%2F%2Fseeklogo.com%2Fvector-logo%2F444861%2Fvultr&psig=AOvVaw20im7oJ0UECJpiFi1KPq4o&ust=1694960318172000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCOjso7Kpr4EDFQAAAAAdAAAAABAR" title="Vultr Logo">
</p>

- [Requirements](#Requirements)
- [Notes](#Notes)
- [Defaults](#Defaults)
- [Runtime](#Runtime)
- [Terraform Inputs](#Terraform-Inputs)

## Requirements

You need a [Vultr account](https://www.vultr.com/register/)
and [Vultr CLI set up](https://github.com/vultr/vultr-cli).

Vultr CLI uses an environment variable to log you in. It is named VULTR_API_KEY, and once given a value all of Vultr
CLI will be usable. Be aware that your shell is, in most cases, logging your commands. You can disable history with
the help of [this article](https://www.thegeekdiary.com/how-to-remove-disable-bash-shell-command-history-on-linux/).


## Notes

* The resources will be created in your Vultr account.
* You can tweak variables in the table below to customize cluster size to your need.
* You can run this command
  ```vultr-cli kubernetes config <cluster_id (not the name !)``` to connect to the cluster.

## Defaults

See tables at the end for a comprehensive list of inputs and outputs.

* Default web node type: **vc2-2c-4gb** _(2x vCPU, 4GB memory)_
* Default media node type: **vc2-2c-4gb** _(2x vCPU, 4GB memory)_
* Default router node type: **vc2-2c-4gb** _(2x vCPU, 4GB memory)_
* Default web pool size: **4**
* Default media pool size: **2**
* Default voip pool size: **2**
* Default region: **null**

## Runtime

Runtime `terraform apply`:

~4min

```bash
terraform apply  0,64s user 0,14s system 0% cpu 3:52,58 total
```

## Terraform Inputs

| Name                | Description                                               | Type   | Default values |
|---------------------|-----------------------------------------------------------|--------|----------------|
| cluster_name        |                                                           | string |                |
| cluster_version     | VKE cluster exact version, will overwrite prefix if set   | string | null           |
| default_node_count  | VKE default node pool desired count of node (cannot be 0) | number | 1              |
| media_count         | VKE media desired count of node                           | number | 2              |
| media_instance_type | VKE media instance type                                   | string | Standard_B2s   |
| voip_count          | VKE voip desired count of node                            | number | 2              |
| voip_instance_type  | VKE voip instance type                                    | string | Standard_B2s   |
| web_count           | VKE web desired count of node                             | number | 4              |
| web_instance_type   | VKE web instance type                                     | string | Standard_B2s   |
| region              | Vultr resources zone (uses region if not defined)         | string | null           |
