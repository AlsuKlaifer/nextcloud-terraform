resource "null_resource" "update_ssh_known_hosts" {
  depends_on = [
    yandex_compute_instance.instance,
  ]

  provisioner "local-exec" {
    command = "../known-hosts.sh ${yandex_compute_instance.instance.network_interface[0].nat_ip_address}"
  }
}

resource "local_file" "create_ansible_inventory" {
    depends_on = [ 
        yandex_compute_instance.instance,
    ]
    content = "server ansible_host=${yandex_compute_instance.instance.network_interface[0].nat_ip_address} ansible_ssh_private_key_file=${var.private_ssh_key} ansible_user=${var.ansible_username} ansible_connection=${var.connection_type}"
    filename = "../ansible/inventory"
}

resource "null_resource" "execute_ansible_playbook" {
  depends_on = [
    yandex_compute_instance.instance,
    local_file.create_ansible_inventory,
    null_resource.update_ssh_known_hosts,
  ]

  provisioner "local-exec" {
    command = "ansible-playbook --become --become-user root --become-method sudo -i ../ansible/inventory ../ansible/deploy.yml"
  }
}

resource "yandex_vpc_network" "network" {
  name = var.network_id
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.subnet_id
  zone           = var.yc_zone
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = yandex_vpc_network.network.id
}

data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

resource "yandex_compute_disk" "disk" {
  name     = var.disk_name
  type     = "network-ssd"
  image_id = data.yandex_compute_image.ubuntu.id
  size     = 10
}

resource "yandex_compute_instance" "instance" {
  name        = var.instance_name
  platform_id = "standard-v3"
  hostname    = "instance"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 1
  }

  boot_disk {
    disk_id = yandex_compute_disk.disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_ssh_key)}"
  }
}
