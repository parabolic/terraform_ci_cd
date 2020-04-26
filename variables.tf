variable "environment" {
  type = string
}

variable "instance_number" {
  default = 1
  type    = number
}

variable "machine_type" {
  default = "n1-standard-1"
  type    = string
}

variable "name" {
  default = "cloudlad"
  type    = string
}

variable "project_id" {
  type = string
}

variable "region" {
  default = "europe-west4"
  type    = string
}

variable "zone" {
  default = "europe-west4-c"
  type    = string
}

