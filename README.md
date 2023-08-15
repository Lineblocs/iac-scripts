# IAC scripts

> **IMPORTANT:** Please note that the majority of these examples, if not all, will not be free to try. For instance, EKS
> charges 0.10 $ / hour per cluster.

This repository contains IaC manifests that you will find useful to deploy Lineblocs charts. In every folder, you will
find a Terraform project, K8S files, ... that you can use to deploy your infrastructe. You can tweak some settings
like computing instances sizing, virtual private network CIDR and many more. Feel free to explore and use these
examples.

- [Getting Started](#getting-started)
- [Working with my team](#working-with-my-team)
- [Supported cloud providers](#supported-cloud-providers)
- [Contributing](#contributing)

## Getting Started

Each subfolder has a README, but here is a common "Getting started" section.

1. Navigate to the `aws`, `digitalocean`, `gcp`, `linode`, or `vultr` directory depending on the infrastructure you want
   to deploy.
2. Make sure you have Terraform
   [installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on your machine.
3. Run `terraform init` to initialize the Terraform environment.
4. Modify the `example.tfvars` file with your own values.
5. Run `terraform apply` to deploy the infrastructure.
6. Terraform will display the resources it will create. Proceed by typing `yes` to confirm.
7. Wait for the deployment to complete.

Feel free to explore each directory for more information. Each one contains a more precise README.

## Working with my team

State in Terraform is a key concept that represents the current state of deployed infrastructure. It includes the
configuration and metadata of resources managed by Terraform, such as the resource name, ID, properties, and
dependencies. The state file is typically stored locally or remotely and is used to plan and apply changes to
infrastructure, track drift, and enable collaboration among teams. It is crucial for Terraform to accurately manage
and reflect the actual state of the deployed resources.

Here are key points about Terraform state:

- **Resource Mapping**: State allows Terraform to know what AWS instance corresponds to a resource in the configuration
  file.
- **Metadata**: State keeps metadata on resource dependencies.
- **Performance Improvement**: For larger infrastructures, storing a mapping of resources can lead to performance
  benefits for certain operations.
- **Synchronization**: If working in a team, it's important to store state in a remote backend, so that Terraform can
  lock that state when it's being modified to prevent conflicts.

Here's how you might declare a backend in Terraform to store state remotely:

```hcl
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}
```

Keep in mind, state files can potentially include sensitive information, thus they should be stored securely and treated
as sensitive data.

## Supported cloud providers

| Name          | Path           | Supported yet |
|---------------|----------------|---------------|
| AWS EKS       | ./aws          | yes           |
| Azure AKS     | ./azure        | no            |
| Google GKE    | ./gcp          | no            |
| Digital Ocean | ./digitalocean | yes           |
| Linode        | ./linode       | no            |
| Vultr         | ./vultr        | no            |

## Contributing

To contribute to this project, please follow the following steps:

1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Test your changes.
5. Commit and push your changes.
6. Submit a pull request.
