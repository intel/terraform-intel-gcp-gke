<p align="center">
  <img src="https://github.com/intel/terraform-intel-gcp-gke/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## GCP GKE Module

This code base implements the GCP GKE Terraform Module available on Terraform registry (https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest)

This example illustrates how to create a simple regional kubernetes cluster within GCP. The cluster is created on Intel 3rd gen Xeon Scalable processor called Icelake. At the time of publication of this example, Intel's 4th gen Xeon Scalable processor is not globally available in GCP. It is available in public preview. Hence this example uses Icelake based GCE instances to create the cluster. Once Saphhire Rapids is globally available in GCP, the GKE cluster can be created based on Sapphire Rapids based GCE instances.


## Usage

**See the 'examples' folder for more details**

```hcl
#########################################################
# Local variables, modify for your needs                #
#########################################################

# See policies.md for recommended instances
# General Purpose:  n2-standard-2, n2-standard-4, n2-standard-8, n2-standard-16, n2-standard-32, n2-standard-48, n2-standard-64,
#                   n2-standard-80, n2-standard-96, n2-standard-128
# General Purpose:  n2-highmem-2, n2-highmem-4, n2-highmem-8, n2-highmem-16, n2-highmem-32, n2-highmem-48, n2-highmem-64,
#                   n2-highmem-80, n2-highmem-96, n2-highmem-128
# General Purpose:  n2-highcpu-2, n2-highcpu-4, n2-highcpu-8, n2-highcpu-16, n2-highcpu-32, n2-highcpu-48, n2-highcpu-64,
#                   n2-highcpu-80, n2-highcpu-96
# Compute Optimized: c2-standard-4, c2-standard-8, c2-standard-16, c2-standard-30, c2-standard-60, c3-highcpu-4, c3-highcpu-8,
#                    c3-highcpu-22, c3-highcpu-44, c3-highcpu-88, c3-highcpu-176
#Memory Optimized:   m3-ultramem-32, m3-ultramem-64, m3-ultramem-128, m3-megamem-64, m3-megamem-128

locals {
  cluster_type                   = "simple-regional"
  project_id                     = "intel-csa-resource-gcp"
  cluster_name_suffix            = "-1"
  region                         = "us-east1"
  network                        = "default"
  subnetwork                     = "default"
  ip_range_pods                  = "k8s-pods"
  ip_range_services              = "k8s-services"
  compute_engine_service_account = "551221341017-compute@developer.gserviceaccount.com"
  enable_binary_authorization    = false
  skip_provisioners              = false
  machine_type                   = "n2-standard-4"
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
  remove_default_node_pool    = true


  node_pools = [
    # See recommended instance types for Intel Xeon 4th Generation Scalable processors (code-named Sapphire Rapids) above
    {
      name         = "my-pool"
      machine_type = local.machine_type
    }
  ]
}
```

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure


## Considerations  

Under the locals block, you will need to update the following inputs: 
- project_id: replace the project ID with your GCP project ID 
- ip_range_pods: replace "k8s-pods" with the secondary ip range you want to use for your pods 
- ip_range_services: replace "k8s-services" with the secondary ip range you want to use for your services
- network: currently set to default but you can replace it to the VPC network you want to host the cluster in 
- subnetwork: currently set to default but you can replace it to the subnetwork you want to host the cluster in 
- region: replace "us-east1" with the region you want to host the cluster in 
- computer_engine_service_account: replace the service account with your service account to associate to the nodes in the cluster