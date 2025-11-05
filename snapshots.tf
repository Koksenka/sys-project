resource "yandex_compute_snapshot_schedule" "snapshot-vm" {
  name = "snapshot-vm"
  description = "daily"

  schedule_policy {
    expression = "0 0 */1 * *"
  }
  
  snapshot_count = "7"
  
  disk_ids = concat(
    [for instance in yandex_compute_instance.web-servers : instance.boot_disk[0].disk_id],
    [
      yandex_compute_instance.bastion.boot_disk[0].disk_id,
      yandex_compute_instance.zabbix.boot_disk[0].disk_id,
      yandex_compute_instance.elasticsearch.boot_disk[0].disk_id,
      yandex_compute_instance.kibana.boot_disk[0].disk_id
    ]
  )
}

resource "yandex_compute_snapshot" "initial-web_servers_backup" {
  for_each = { for idx, instance in yandex_compute_instance.web-servers : idx => instance.boot_disk[0].disk_id }
  
  name           = "initial-web-${each.key}-${formatdate("DD-MM-YY", timestamp())}"
  description    = "Первоначальный снепшот"
  source_disk_id = each.value
}


resource "yandex_compute_snapshot" "initial_backup" {
  for_each = {
    bastion       = yandex_compute_instance.bastion.boot_disk[0].disk_id
    zabbix        = yandex_compute_instance.zabbix.boot_disk[0].disk_id
    elasticsearch = yandex_compute_instance.elasticsearch.boot_disk[0].disk_id
    kibana        = yandex_compute_instance.kibana.boot_disk[0].disk_id
  }
  
  name           = "initial-${each.key}-${formatdate("DD-MM-YY", timestamp())}"
  description    = "Первоначальный снепшот"
  source_disk_id = each.value
}