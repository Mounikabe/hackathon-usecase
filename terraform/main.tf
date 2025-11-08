terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  credentials = file(var.gcp_sa_key_path)
  project     = "peppy-plateau-477609-c8"
  region      = "us-central1"
}

resource "google_compute_network" "main_vpc" {
  name                    = "demo-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet_a" {
  name          = "public-subnet-a"
  ip_cidr_range = "10.10.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.main_vpc.id
}

resource "google_compute_subnetwork" "public_subnet_b" {
  name          = "public-subnet-b"
  ip_cidr_range = "10.10.2.0/24"
  region        = "us-central1"
  network       = google_compute_network.main_vpc.id
}

resource "google_compute_subnetwork" "private_subnet_a" {
  name                     = "private-subnet-a"
  ip_cidr_range            = "10.10.3.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.main_vpc.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private_subnet_b" {
  name                     = "private-subnet-b"
  ip_cidr_range            = "10.10.4.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.main_vpc.id
  private_ip_google_access = true
}

# Storage bucket for Terraform state
resource "google_storage_bucket" "terraform_state" {
  name                        = "tfstate-demo-bucket-12345"
  location                    = "us-central1"
  force_destroy               = true
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }
}
