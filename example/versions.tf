terraform {
  required_version = "~> 0.12.24"

  required_providers {
    google      = "~> 3.16.0"
    google-beta = "~> 3.16.0"
  }

  # Enable for production workloads
  # backend "gcs" {
  #   bucket = "terraform-state"
  #   prefix = "workspaces"
  # }
}


