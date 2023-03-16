<p align="center">
  <img src="https://github.com/intel/terraform-intel-azure-aks/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## GCP GKE Module

This code base implements the GCP GKE Terraform Module available on Terraform registry (https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest)

The code selects **GCP machine types based on the Intel Xeon 3rd Generation Scalable processors** (code-named Ice Lake) for optimal cost/performance. 

The code will create a simple regional GKE cluster. Please replace inputs as appropriate to be able to run the module. 


## Usage

**See the 'examples' folder for more details**

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
      machine_type = "n2-standard-8"
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

Note that this code base will create resources. Run `terraform destroy` when you don't need these resources anymore to minimize costs.  