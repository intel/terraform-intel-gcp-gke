<p align="center">
  <img src="https://github.com/OTCShare2/terraform-intel-hashicorp/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Intel GCP GKE Simple Regional Example

This example illustrates how to create a simple regional cluster.  

## Usage 

The simple usage is as follows: 
```hcl
locals {
  cluster_type = "simple-regional"
  project_id = "intel-csa-resource-gcp"
  cluster_name_suffix = "-1"
  region = "us-east1"
  network = "default"
  subnetwork = "default"
  ip_range_pods = "k8s-pods"
  ip_range_services = "k8s-services"
  compute_engine_service_account = "551221341017-compute@developer.gserviceaccount.com"
  enable_binary_authorization = false
  skip_provisioners = false
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                      = "terraform-google-modules/kubernetes-engine/google"
  project_id                  = local.project_id
  name                        = "${local.cluster_type}-cluster${local.cluster_name_suffix}"
  regional                    = true
  region                      = local.region
  network                     = local.network
  subnetwork                  = local.subnetwork
  ip_range_pods               = local.ip_range_pods
  ip_range_services           = local.ip_range_services
  create_service_account      = false
  service_account             = local.compute_engine_service_account
  enable_cost_allocation      = true
  enable_binary_authorization = local.enable_binary_authorization
  skip_provisioners           = local.skip_provisioners

  node_pools = [
    {
      name = "my-pool"
      machine_type = "n2-standard-48"
    }
  ] 
}

```

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name\_suffix | A suffix to append to the default cluster name | `string` | `""` | no |
| compute\_engine\_service\_account | Service account to associate to the nodes in the cluster | `any` | n/a | yes |
| enable\_binary\_authorization | Enable BinAuthZ Admission controller | `bool` | `false` | no |
| ip\_range\_pods | The secondary ip range to use for pods | `any` | n/a | yes |
| ip\_range\_services | The secondary ip range to use for services | `any` | n/a | yes |
| network | The VPC network to host the cluster in | `any` | n/a | yes |
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region to host the cluster in | `any` | n/a | yes |
| skip\_provisioners | Flag to skip local-exec provisioners | `bool` | `false` | no |
| subnetwork | The subnetwork to host the cluster in | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | n/a |
| client\_token | n/a |
| cluster\_name | Cluster name |
| ip\_range\_pods | The secondary IP range used for pods |
| ip\_range\_services | The secondary IP range used for services |
| kubernetes\_endpoint | n/a |
| location | n/a |
| master\_kubernetes\_version | The master Kubernetes version |
| network | n/a |
| project\_id | n/a |
| region | n/a |
| service\_account | The default service account used for running nodes. |
| subnetwork | n/a |
| zones | List of zones in which the cluster resides |

## Considerations
Under the locals block, you will need to update the following inputs: 
- project_id: replace the project ID with your GCP project ID 
- ip_range_pods: replace "k8s-pods" with the secondary ip range you want to use for your pods 
- ip_range_services: replace "k8s-services" with the secondary ip range you want to use for your services
- network: currently set to default but you can replace it to the VPC network you want to host the cluster in 
- subnetwork: currently set to default but you can replace it to the subnetwork you want to host the cluster in 
- region: replace "us-east1" with the region you want to host the cluster in 
- computer_engine_service_account: replace the service account with your service account to associate to the nodes in the cluster