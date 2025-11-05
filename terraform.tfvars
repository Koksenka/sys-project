# Servers vars ===============================
vms_resources = {
    web-server = {
      cores  = 2
      memory = 2
      disk   = 10
      core_fraction = 5       
     },
    bastion = {
      cores  = 2
      memory = 2
      disk   = 10
      core_fraction = 5     
    },
    zabbix = {
      cores  = 2
      memory = 2
      disk   = 15
      core_fraction = 5     
    },
    elasticsearch = {
      cores  = 2
      memory = 2
      disk   = 15
      core_fraction = 5           
    },
    kibana = {
      cores  = 2
      memory = 2
      disk   = 15
      core_fraction = 5     
    }
   }

ssh_public_key   = "~/.ssh/id_ed25519.pub"
username         = "dic72"