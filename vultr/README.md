# Terraform Kubernetes on Azure AKS

This repository contains the Terraform module for creating a Kubernetes Cluster on Azure AKS.

<p align="center">
<img alt="Azure Logo" src="https://upload.wikimedia.org/wikipedia/fr/thumb/b/b6/Microsoft-Azure.png/240px-Microsoft-Azure.png" title="Azure Logo">
</p>

- [Requirements](#Requirements)
- [Notes](#Notes)
- [Defaults](#Defaults)
- [Runtime](#Runtime)
- [Terraform Inputs](#Terraform-Inputs)

## Requirements

You need a [Azure account](https://azure.microsoft.com/en-us/free)
and [Azure CLI set up](https://learn.microsoft.com/fr-fr/cli/azure/install-azure-cli).

Run `az login` to initialize your CLI. Please note that it cannot run without a credit card attached to the account.
Having your billing information in Azure increases resource quotas and will let you run one node of each pool. For more,
see [increase quotas](https://learn.microsoft.com/en-us/azure/quotas/quickstart-increase-quota-portal).


## Notes

* The resources will be created in your Azure base domain
* You can tweak variables in the table below to customize cluster size to your need.
* You can run this command
  ```az aks get-credentials --resource-group <rg_name> --name <cluster_name>``` to
  connect to the cluster.

## Defaults

See tables at the end for a comprehensive list of inputs and outputs.

* Default web node type: **Standard_B2s** _(2x vCPU, 8GB memory)_
* Default media node type: **Standard_B2s** _(2x vCPU, 8GB memory)_
* Default router node type: **Standard_B2s** _(2x vCPU, 8GB memory)_
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

| Name                | Description                                               | Type   | Default values |
|---------------------|-----------------------------------------------------------|--------|----------------|
| cluster_name        |                                                           | string |                |
| cluster_version     | AKS cluster exact version, will overwrite prefix if set   | string | null           |
| default_node_count  | AKS default node pool desired count of node (cannot be 0) | number | 1              |
| media_count         | AKS media desired count of node                           | number | 2              |
| media_instance_type | AKS media instance type                                   | string | Standard_B2s   |
| location            | Azure resources region                                    | string |                |
| voip_count          | AKS voip desired count of node                            | number | 2              |
| voip_instance_type  | AKS voip instance type                                    | string | Standard_B2s   |
| web_count           | AKS web desired count of node                             | number | 4              |
| web_instance_type   | AKS web instance type                                     | string | Standard_B2s   |
| zone                | GCP resources zone (uses region if not defined)           | string | null           |
