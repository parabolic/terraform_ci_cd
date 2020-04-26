locals {
  lower_tags = {
    for key, value in module.label.tags :
    lower(key) => value
  }
}

module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  environment = var.environment
  name        = var.name
  delimiter   = "-"
  label_order = ["name", "environment"]
}

resource "google_storage_bucket" "cloudlad" {
  name          = module.label.id
  force_destroy = var.environment == "production" ? false : true
}

data "google_compute_image" "debian_image" {
  family  = "debian-9"
  project = "debian-cloud"
}

resource "google_compute_instance_group" "cloudlad" {
  name = module.label.id

  description = "Terraform instance group - ${module.label.id}"

  zone    = var.zone
  network = google_compute_network.cloudlad.self_link

  instances = google_compute_instance.cloudlad[*].self_link
}

resource "google_compute_instance" "cloudlad" {
  count = var.instance_number

  name         = "${module.label.id}-${count.index}"
  machine_type = "n1-standard-1"

  zone = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  network_interface {
    network = google_compute_network.cloudlad.self_link
  }

  tags = module.label.attributes
}

resource "google_compute_network" "cloudlad" {
  # provider = google-beta

  name = module.label.id
}
