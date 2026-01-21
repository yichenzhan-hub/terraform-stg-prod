terraform {
  required_providers {
    google = { source = "hashicorp/google", version = ">= 5.0" }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

# 1. Get the Network info from GCP (created in Layer 1)
data "google_compute_network" "vpc" {
  name = var.network_name
}

data "google_compute_subnetwork" "subnet" {
  name   = var.subnetwork_name
  region = var.region
}

# 2. Create the GKE Autopilot Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region # Autopilot is regional

  # CRITICAL: Enable Autopilot
  enable_autopilot = true

  network    = data.google_compute_network.vpc.id
  subnetwork = data.google_compute_subnetwork.subnet.id

  # Private clusters are more secure (Nodes have no public IP)
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false # You can still access master from public internet (easier for Terraform)
  }

  # Allow other services to access the master if needed
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "Allow Everywhere" # For Sandbox simplicity. In Prod, restrict this!
    }
  }

  # Deletion protection prevents accidental "terraform destroy"
  deletion_protection = false # Set to true for Production
}