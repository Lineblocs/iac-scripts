# Terraform Kubernetes on Amazon EKS

This repository contains the Terraform module for creating a Kubernetes Cluster on Amazon EKS.

<p align="center">
<img alt="AWS Logo" src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Amazon_Web_Services_Logo.svg/320px-Amazon_Web_Services_Logo.svg.png" title="AWS Logo">
</p>

- [Terraform Kubernetes on Amazon EKS](#Terraform-Kubernetes-on-Amazon-EKS)
- [Requirements](#Requirements)
- [Notes](#Notes)
- [Defaults](#Defaults)
- [Runtime](#Runtime)
- [Terraform Inputs](#Terraform-Inputs)
- [Outputs](#Outputs)

## Requirements

You need an [AWS account](https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-creating.html)
and [AWS CLI set up](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).

## Notes

* The resources will be created in your AWS account
* You can tweak variables in the table below to customize cluster size to your need.
* You can run this command ```aws eks update-kubeconfig --region <region-code> --name <my-cluster>``` to connect to the
  cluster. More info [here](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)

## Defaults

See tables at the end for a comprehensive list of inputs and outputs.

* Default intra subnet: **["10.123.5.0/24", "10.123.6.0/24"]**
* Default private subnet: **["10.123.3.0/24", "10.123.4.0/24"]**
* Default public subnet: **["10.123.1.0/24", "10.123.2.0/24"]**
* Default vpc cidr: **10.123.0.0/16**
* Default web node type: **m5.large** _(2x vCPU, 8GB memory)_
* Default media node type: **m5.large** _(2x vCPU, 8GB memory)_
* Default router node type: **m5.large** _(2x vCPU, 8GB memory)_
* Default web pool size: **4**
* Default media pool size: **2**
* Default voip pool size: **2**

## Runtime

Runtime `terraform apply`:

~12min

```bash
terraform apply  19,52s user 1,60s system 2% cpu 14:17,06 total
```

## Terraform Inputs

> NOTE: See the
> [difference](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest#private-versus-intra-subnets)
> between intra and private subnets

| Name                | Description                                           |     Type     |              Default               | Required |
|---------------------|-------------------------------------------------------|:------------:|:----------------------------------:|:--------:|
| cluster_name        | EKS cluster name                                      |    string    |                                    |   yes    |
| intra_subnets       | VPC intra subnets                                     | list(string) | ["10.123.5.0/24", "10.123.6.0/24"] |   yes    |
| web_instance_type   | EKS web node type                                     | list(string) |            ["m5.large"]            |   yes    |
| web_desired_size    | EKS web desired count of node                         |    number    |                 4                  |   yes    |
| web_max_size        | EKS web maximum count of node                         |    number    |                 4                  |   yes    |
| web_min_size        | EKS web minimum count of node                         |    number    |                 4                  |   yes    |
| private_subnets     | VPC private subnets                                   | list(string) | ["10.123.3.0/24", "10.123.4.0/24"] |   yes    |
| public_subnets      | VPC public subnets                                    | list(string) | ["10.123.1.0/24", "10.123.2.0/24"] |   yes    |
| region              | Resources region                                      |    string    |                                    |   yes    |
| media_instance_type | EKS media node type                                   | list(string) |            ["m5.large"]            |   yes    |
| media_desired_size  | EKS media desired count of node                       |    number    |                 2                  |   yes    |
| media_max_size      | EKS media maximum count of node                       |    number    |                 2                  |   yes    |
| media_min_size      | EKS media minimum count of node                       |    number    |                 2                  |   yes    |
| voip_instance_type  | EKS voip node type                                    | list(string) |            ["m5.large"]            |   yes    |
| voip_desired_size   | EKS voip desired count of node                        |    number    |                 2                  |   yes    |
| voip_max_size       | EKS voip maximum count of node                        |    number    |                 2                  |   yes    |
| voip_min_size       | EKS voip minimum count of node                        |    number    |                 2                  |   yes    |
| users               | Users list to be authorized (list of arn and username | list(object) |                                    |   yes    |
| vpc_cidr            | VPC Classless Inter-Domain Routing                    |    string    |           10.123.0.0/16            |   yes    |
