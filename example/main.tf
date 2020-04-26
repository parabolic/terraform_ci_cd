provider "google" {
  project = var.project_id
  region  = var.region
}

# provider "google-beta" {
#   project = var.project_id
#   region  = var.region
# }

module "cloudlad" {
  source = "../"

  environment     = var.environment
  instance_number = var.instance_number
  name            = var.name
  project_id      = var.project_id
  region          = var.region
  zone            = var.zone
}
