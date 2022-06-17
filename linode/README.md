# Lineblocs IaC scripts

This repository contains the scripts and Terraform modules for deploying Lineblocs on Digital Ocean.

It uses the latest available Digital Ocean Kubernetes slug version available and creates a kubeconfig file at completion.

## Requirements / Dependencies

```
Digitalocean account
Registered domain name
kubectl >= 1
helm >= 3
terraform >= 1.0.11
```

## Download pre-requisites

### Kubectl

Links to download kubectl can be found here: (kubectl tools)[https://kubernetes.io/docs/tasks/tools/]

### Helm

To download latest version of Helm, please follow the instructions in the link below:

(Helm | Installing Helm)[https://helm.sh/docs/intro/install/]

> note: please make sure to download version v3 or later

### Terraform

(Download Terraform - Terraform by HashiCorp)[https://www.terraform.io/downloads.html]

## Installing Lineblocs

Once you have setup all the dependencies, you can get started with the installation. This process consists of 2 steps:

1. Creation of IaC resources
2. K8s Deployment

In the repository, there are helper scripts for K8s. These scripts can be used to deploy all of the Kubernetes services. For reference, the scripts can be found in the **k8s** directory.


### Installation

To get started with the installation, please refer to the following instructions:

1. Setup terraform

to setup the solution, please run:
```
terrform init
```

2. make copy of example variables file
```
cp vars.tfvars.example vars.tfvars
```

3. edit vars.tfvars
    a) set do_region to a valid region. to view list of regions, please refer to [Regional Availability Matrix :: DigitalOcean Documentation](https://docs.digitalocean.com/products/platform/availability-matrix/)
    b) do_token should be set to your DigitalOcean API token
    c) (optional) changing the kube_version is optional. But if decide to change it, please be advised of potential issues. For example, some features may not be supported in older versions of Kubernetes.

4. deploy infrastructure

To deploy the solution, please run:
```
terraform apply
```

> note: when you run this command, Terraform will automatically create the kubernetes config for you. The config will be saved in the same directory as the scripts.

5. configure K8s

Once the Terraform scripts finish running, you can configure K8s.

To setup the config, please run:
```
export KUBECONFIG=$(pwd)/kubeconfig_do
```

5. install K8s services

Next, to setup the Kubernetes cluster, please run:

```
./setup_k8s.sh -d {YOUR_DOMAIN_NAME}
```

> Note: this may take a few minutes. However you will be notified of any updates

Once the installation has completed, you will receive a link to the admin portal where you can setup the service. To complete the configuration, please open this link using a browser.

## Configuring Lineblocs

In the configuration, there are a few settings to keep in mind. For example, you can choose which TTS provider to use, or pick where you want to store your media files. But it is optional to change the config, and in most cases the default settings are fine.

To finish the setup process, please go over all of the setup screens and fill in any required fields. 

Then on the final screen, click "Save configuration".

## Completing setup - logging in

If you havent noticed any errors yet then Lineblocs is now ready for usage - you can login to the admin dashboard or create accounts in the user portal.

## Next steps

For more helpful guides, be sure to review the following articles:

[Lineblocs - Setup SIP providers](https://docs.digitalocean.com/products/platform/availability-matrix/)
[Lineblocs - Upload call rates](https://docs.digitalocean.com/products/platform/availability-matrix/)
[Lineblocs - Debuging media servers](https://docs.digitalocean.com/products/platform/availability-matrix/)
[Lineblocs - Deploying new SIP router](https://docs.digitalocean.com/products/platform/availability-matrix/)