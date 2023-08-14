# Terraform Kubernetes on Amazon EKS

This repository contains the Terraform module for creating a Kubernetes Cluster on Amazon EKS.

It uses the latest available EKS slug version available.


<p align="center">
<img alt="Digital Ocean Logo" src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/DigitalOcean_logo.svg/240px-DigitalOcean_logo.svg.png">
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
* Default media node type: **m5.large** _(2x vCPU, 8GB memory)_
* Default router node type: **m5.large** _(2x vCPU, 8GB memory)_
* Default media pool size: **4**
* Default router pool size: **2**

## Runtime

Runtime `terraform apply`:

~12min

## Terraform Inputs

> NOTE: ([See the difference between intra and private subnets](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest#private-versus-intra-subnets)

| Name                 | Description                                           |     Type     |              Default               | Required |
|----------------------|-------------------------------------------------------|:------------:|:----------------------------------:|:--------:|
| cluster_name         | EKS cluster name                                      |    string    |                                    |   yes    |
| intra_subnets        | VPC intra subnets                                     | list(string) | ["10.123.5.0/24", "10.123.6.0/24"] |   yes    |
| media_desired_size   | EKS media desired count of node                       |    number    |                 4                  |   yes    |
| media_instance_type  | EKS media node type                                   | list(string) |            ["m5.large"]            |   yes    |
| media_max_size       | EKS media maximum count of node                       |    number    |                 4                  |   yes    |
| media_min_size       | EKS media minimum count of node                       |    number    |                 4                  |   yes    |
| private_subnets      | VPC private subnets                                   | list(string) | ["10.123.3.0/24", "10.123.4.0/24"] |   yes    |
| public_subnets       | VPC public subnets                                    | list(string) | ["10.123.1.0/24", "10.123.2.0/24"] |   yes    |
| region               | Resources regien                                      |    string    |                                    |   yes    |
| router_desired_size  | EKS router desired count of node                      |    number    |                 2                  |   yes    |
| router_instance_type | EKS router node type                                  | list(string) |            ["m5.large"]            |   yes    |
| router_max_size      | EKS router maximum count of node                      |    number    |                 2                  |   yes    |
| router_min_size      | EKS router minimum count of node                      |    number    |                 2                  |   yes    |
| users                | Users list to be authorized (list of arn and username | list(object) |                                    |   yes    |
| vpc_cidr             | VPC Classless Inter-Domain Routing                    |    string    |           10.123.0.0/16            |   yes    |
