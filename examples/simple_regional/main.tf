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
# Compute Optimized: c3-highcpu-4, c3-highcpu-8, c3-highcpu-22, c3-highcpu-44, c3-highcpu-88, c3-highcpu-176
#Memory Optimized:   m3-ultramem-32, m3-ultramem-64, m3-ultramem-128, m3-megamem-64, m3-megamem-128

locals {
  cluster_type = "simple-regional"

  # Update the project id that is specific to your own GCP environment
  project_id = "your_own_gcp_project_id"

  cluster_name_suffix = "-1"
  region              = "us-central1"
  node_locations      = ["us-central1-a", "us-central1-b", "us-central1-c"]
  network             = "default"
  subnetwork          = "default"

  # Machine type is selected as Intel 4th gen Xeon Scalable processor called Sapphire Rapids
  machine_type = "c3-highcpu-4"

  #Auto scaling configurations, min_node_count is the minimum node count per zone, max_node_count is the max node count per zone
  min_node_count = 1
  max_node_count = 3

  # For the selected network and subnetwork, there needs to exist secondary IP ranges for pods and a different secondary IP range for services. Make sure that these secondary
  # IP ranges are setup in your network and remember to use the associated names of these IP ranges for ip_range_pods and ip_range_services defined below. In our example,
  # we are caling these secondary ranges as k8s-pods and k8s-services
  ip_range_pods     = "k8s-pods"     # replace with your own ip_range_pods value
  ip_range_services = "k8s-services" # replace with your own ip_range_services value

  # Update the compute engine service account below with your own compute engine service account
  compute_engine_service_account = "123456789012-compute@developer.gserviceaccount.com"

  enable_binary_authorization = false
  skip_provisioners           = false
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source     = "terraform-google-modules/kubernetes-engine/google"
  project_id = local.project_id
  name       = "${local.cluster_type}-cluster${local.cluster_name_suffix}"
  regional   = true
  region     = local.region
  network    = local.network
  subnetwork = local.subnetwork

  ip_range_pods     = local.ip_range_pods
  ip_range_services = local.ip_range_services

  create_service_account = false
  service_account        = local.compute_engine_service_account

  enable_cost_allocation      = true
  enable_binary_authorization = local.enable_binary_authorization
  skip_provisioners           = local.skip_provisioners

  remove_default_node_pool = true


  node_pools = [
    # See recommended instance types for Intel Xeon 4th Generation Scalable processors (code-named Sapphire Rapids) above
    {
      name           = "my-pool"
      machine_type   = local.machine_type
      min_node_count = local.min_node_count
      max_node_count = local.max_node_count
    }
  ]
}