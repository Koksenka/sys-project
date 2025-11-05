resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/inventory.tftpl",

  { web-servers = yandex_compute_instance.web-servers
   zabbix = yandex_compute_instance.zabbix 
   bastion = yandex_compute_instance.bastion
   elasticsearch = yandex_compute_instance.elasticsearch
   kibana = yandex_compute_instance.kibana
    username = var.username     
   } )

  filename = "${abspath(path.module)}/ansible/inventory/inventory.ini"
}