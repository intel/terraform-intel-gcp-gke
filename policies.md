<p align="center">
  <img src="https://github.com/intel/terraform-intel-gcp-gke/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform  

© Copyright 2022, Intel Corporation

## HashiCorp Sentinel Policies

This file documents the HashiCorp Sentinel policies that apply to this module

## GKE Policy 1

Description: The configured "machine_type" should be an Intel Xeon 3rd Generation(code-named Ice Lake) Scalable processors or an Intel Xeon 4th Generation(code-named Sapphire Rapids) Scalable processors. For c2-standard-* machine types, we have made an exception to include Intel Xeon 2nd Generation (code-named Cascade Lake),since they are not available on Ice Lake. 

Resource type: google_container_cluster

Parameter:  machine_type

Allowed Types 

- **General Purpose:**  n2-standard-2, n2-standard-4, n2-standard-8, n2-standard-16, n2-standard-32, n2-standard-48, n2-standard-64, n2-standard-80, n2-standard-96, n2-standard-128
- **General Purpose:** n2-highmem-2, n2-highmem-4, n2-highmem-8, n2-highmem-16, n2-highmem-32, n2-highmem-48, n2-highmem-64, n2-highmem-80, n2-highmem-96, n2-highmem-128
- **General Purpoose:** n2-highcpu-2, n2-highcpu-4, n2-highcpu-8, n2-highcpu-16, n2-highcpu-32, n2-highcpu-48, n2-highcpu-64, n2-highcpu-80, n2-highcpu-96
- **Compute Optimized:** c2-standard-4, c2-standard-8, c2-standard-16, c2-standard-30, c2-standard-60, c3-highcpu-4, c3-highcpu-8, c3-highcpu-22, c3-highcpu-44, c3-highcpu-88, c3-highcpu-176
- **Memory Optimized:** m3-ultramem-32, m3-ultramem-64, m3-ultramem-128, m3-megamem-64, m3-megamem-128

## GKE Policy 2

Description: The configured "machine_type" should be an Intel Xeon 3rd Generation(code-named Ice Lake) Scalable processors or an Intel Xeon 4th Generation(code-named Sapphire Rapids) Scalable processors. For c2-standard-* machine types, we have made an exception to include Intel Xeon 2nd Generation (code-named Cascade Lake),since they are not available on Ice Lake. 

Resource type: google_container_node_pool

Parameter:  machine_type

Allowed Types 

- **General Purpose:**  n2-standard-2, n2-standard-4, n2-standard-8, n2-standard-16, n2-standard-32, n2-standard-48, n2-standard-64, n2-standard-80, n2-standard-96, n2-standard-128
- **General Purpose:** n2-highmem-2, n2-highmem-4, n2-highmem-8, n2-highmem-16, n2-highmem-32, n2-highmem-48, n2-highmem-64, n2-highmem-80, n2-highmem-96, n2-highmem-128
- **General Purpoose:** n2-highcpu-2, n2-highcpu-4, n2-highcpu-8, n2-highcpu-16, n2-highcpu-32, n2-highcpu-48, n2-highcpu-64, n2-highcpu-80, n2-highcpu-96
- **Compute Optimized:** c2-standard-4, c2-standard-8, c2-standard-16, c2-standard-30, c2-standard-60, c3-highcpu-4, c3-highcpu-8, c3-highcpu-22, c3-highcpu-44, c3-highcpu-88, c3-highcpu-176
- **Memory Optimized:** m3-ultramem-32, m3-ultramem-64, m3-ultramem-128, m3-megamem-64, m3-megamem-128

## GKE Policy 3

Description: This policy will be based on the google_container_cluster resource type and the minimum cpu platform (min_cpu_platform) parameter. This policy will allow "Intel Ice Lake", "Intel Sapphire Rapids" CPU platforms.  

Resource type: google_container_cluster

Parameter: min_cpu_platform

Allowed Types
- Intel Cascade Lake, Intel Ice Lake, Intel Sapphire Rapids

## Links
https://cloud.google.com/compute/docs/cpu-platforms