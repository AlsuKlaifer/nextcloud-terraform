terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id                 = local.cloud_id
  folder_id                = local.folder_id
  service_account_key_file = local.service_key_path
  zone                     = local.zone
}

locals {
  cloud_id         = var.yc_cloud_id
  folder_id        = var.yc_folder_id
  service_key_path = var.yc_service_key_path
  zone             = var.yc_zone
}

variable "yc_cloud_id" {
  type = string
}

variable "yc_folder_id" {
  type = string
}

variable "yc_service_key_path" {
  type = string
}

variable "yc_zone" {
  type    = string
  default = "ru-central1-d"
}