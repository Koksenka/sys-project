data "yandex_compute_image" "ubuntu" {  
  family = var.image_family
}

data "template_file" "cloudinit-web" {
  template = file("./cloud-init-web.yaml")
  vars = {
    username       = var.username
    ssh_public_key = file(var.ssh_public_key)   
  }
}

#--------------------Web-server----------------------------------------
resource "yandex_compute_instance" "web-servers" {
  count = 2  
  name        = "web-server-${count.index + 1}"
  hostname    = "web-server-${count.index + 1}"
  platform_id = var.platform_id
  allow_stopping_for_update = true
  zone        = var.zones[count.index]
  
  resources {
    cores         = var.vms_resources["web-server"]["cores"]
    memory        = var.vms_resources["web-server"]["memory"]
    core_fraction = var.vms_resources["web-server"]["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["web-server"]["disk"]
    }
  }
  
  # scheduling_policy {
  #   preemptible = true
  # }
  
  network_interface {
    subnet_id = count.index == 0 ? yandex_vpc_subnet.subnet1.id : yandex_vpc_subnet.subnet2.id
    # nat       = true
    security_group_ids = [yandex_vpc_security_group.sg-web.id] 
  }

  metadata = {
    user-data          = data.template_file.cloudinit-web.rendered
    serial-port-enable = 1
  }
}

#--------------------Bastion-server----------------------------------------
resource "yandex_compute_instance" "bastion" {    
  name        = "bastion"
  hostname    = "bastion"
  platform_id = var.platform_id
  allow_stopping_for_update = true
  zone        = var.zones[0]
  
  resources {
    cores         = var.vms_resources["bastion"]["cores"]
    memory        = var.vms_resources["bastion"]["memory"]
    core_fraction = var.vms_resources["bastion"]["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["bastion"]["disk"]
    }
  }
  
  # scheduling_policy {
  #   preemptible = true
  # }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg-bastion.id] 
  }

  metadata = {
    user-data = templatefile("./cloud-init.yaml", {
        username       = var.username
        ssh_public_key = file(var.ssh_public_key)   
      })
    serial-port-enable = 1
  }
}

#--------------------Zabbix-server----------------------------------------
resource "yandex_compute_instance" "zabbix" {    
  name        = "zabbix"
  hostname    = "zabbix"
  platform_id = var.platform_id
  allow_stopping_for_update = true
  zone        = var.zones[0]
  
  resources {
    cores         = var.vms_resources["zabbix"]["cores"]
    memory        = var.vms_resources["zabbix"]["memory"]
    core_fraction = var.vms_resources["zabbix"]["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["zabbix"]["disk"]
    }
  }
  
  # scheduling_policy {
  #   preemptible = true
  # }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg-monitoring.id]  
  }

  metadata = {
    user-data = templatefile("./cloud-init.yaml", {
        username       = var.username
        ssh_public_key = file(var.ssh_public_key)   
      })
    serial-port-enable = 1
  }
}

#--------------------Elasticsearch-server---------------------------------
resource "yandex_compute_instance" "elasticsearch" {    
  name        = "elasticsearch"
  hostname    = "elasticsearch"
  platform_id = var.platform_id
  allow_stopping_for_update = true
  zone        = var.zones[0]
  
  resources {
    cores         = var.vms_resources["elasticsearch"]["cores"]
    memory        = var.vms_resources["elasticsearch"]["memory"]
    core_fraction = var.vms_resources["elasticsearch"]["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["elasticsearch"]["disk"]
    }
  }
  
  # scheduling_policy {
  #   preemptible = true
  # }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    # nat                = true
    security_group_ids = [yandex_vpc_security_group.sg-elastic.id] 
  }

  metadata = {
    user-data = templatefile("./cloud-init.yaml", {
        username       = var.username
        ssh_public_key = file(var.ssh_public_key)   
      })
    serial-port-enable = 1
  }
}

#--------------------Kibana-server----------------------------------------
resource "yandex_compute_instance" "kibana" {    
  name        = "kibana"
  hostname    = "kibana"
  platform_id = var.platform_id
  allow_stopping_for_update = true
  zone        = var.zones[0]
  
  resources {
    cores         = var.vms_resources["kibana"]["cores"]
    memory        = var.vms_resources["kibana"]["memory"]
    core_fraction = var.vms_resources["kibana"]["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["kibana"]["disk"]
    }
  }
  
  # scheduling_policy {
  #   preemptible = true
  # }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg-kibana.id]  
  }

  metadata = {
    user-data = templatefile("./cloud-init.yaml", {
        username       = var.username
        ssh_public_key = file(var.ssh_public_key)   
      })
    serial-port-enable = 1
  }
}