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

variable "ansible_username" {
  type        = string
  default     = "ubuntu"
}

variable "connection_type" {
  type        = string
  default     = "ssh"
}

variable "network_id" {
  type    = string
  default = "my-network"
}

variable "subnet_id" {
  type    = string
  default = "my-subnet"
}

variable "image_family" {
  type    = string
  default = "ubuntu-2404-lts-oslogin"
}

variable "disk_name" {
  type    = string
  default = "my-boot-disk"
}

variable "instance_name" {
  type    = string
  default = "my-instance"
}

variable "public_ssh_key" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_ssh_key" {
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "dns_zone" {
  type    = string
  default = "vvot36.itiscl.ru."
}
variable "dns_zone_name" {
  type    = string
  default = "ru-itiscl-vvot36"
}

variable "dns_name" {
  type    = string
  default = "project"
}

output "web_url" {
  value = "http://${yandex_compute_instance.instance.network_interface[0].nat_ip_address}/nextcloud/index.php"
}

output "dns" {
  value = "http://${yandex_dns_recordset.recordset.name}.${yandex_dns_zone.zone.zone}/nextcloud/index.php"
}
