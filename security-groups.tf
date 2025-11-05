#--------------------Sg-bastion----------------------------------------
resource "yandex_vpc_security_group" "sg-bastion" {
  name        = "sg-bastion"
  network_id     = yandex_vpc_network.netology.id
  
  ingress {
    protocol       = "TCP"
    description    = "allow-ssh-from-internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    description    = "Zabbix agent from Zabbix server"
    protocol       = "TCP"
    port           = 10050
    v4_cidr_blocks = ["10.0.1.0/24"]
  } 

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#--------------------Sg-web----------------------------------------
resource "yandex_vpc_security_group" "sg-web" {
    name           = "sg-web" 
    network_id     = yandex_vpc_network.netology.id

  ingress {
    protocol       = "TCP"
    description    = "allows remote access only through Bastion"
    security_group_id  = yandex_vpc_security_group.sg-bastion.id
    port           = 22
  }

  ingress {
    protocol       = "ICMP"
    description    = "allows ping only from bastion"
    security_group_id  = yandex_vpc_security_group.sg-bastion.id
  }

  ingress {
    protocol       = "TCP"
    description    = "allows remote access alb"
    port           = 80
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]    
  }

  ingress {
    description    = "Zabbix agent from Zabbix server"
    protocol       = "TCP"
    port           = 10050
    v4_cidr_blocks = ["10.0.1.0/24"]
  } 

egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
} 

#--------------------Sg-elastic----------------------------------------
resource "yandex_vpc_security_group" "sg-elastic" {
  name        = "sg-elk"
  network_id     = yandex_vpc_network.netology.id

  ingress {
    protocol       = "TCP"
    description    = "allows remote access only through Bastion"
    security_group_id  = yandex_vpc_security_group.sg-bastion.id
    port           = 22
  }

  ingress {
    protocol       = "ICMP"
    description    = "allows ping only from bastion"
    security_group_id  = yandex_vpc_security_group.sg-bastion.id
  }

  ingress {
    protocol       = "TCP"
    description    = "allows access kibana"
    v4_cidr_blocks = ["10.0.1.0/24"]    
    port           = 9200
  }

  ingress {
    description    = "Filebeat from web servers"
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["10.0.1.0/28", "10.0.2.0/28"]
  }

  ingress {
    description    = "Zabbix agent from Zabbix server"
    protocol       = "TCP"
    port           = 10050
    v4_cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  } 
}    

#--------------------Sg-monitoring----------------------------------------
resource "yandex_vpc_security_group" "sg-monitoring" {
  name        = "sg-monitoring"
  network_id     = yandex_vpc_network.netology.id

  ingress {
    description    = "Zabbix Web UI from internet"
    protocol       = "TCP"
    port           = 8080
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "allows remote access only through Bastion"
    security_group_id  = yandex_vpc_security_group.sg-bastion.id
    port           = 22
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#--------------------Sg-kibana----------------------------------------
resource "yandex_vpc_security_group" "sg-kibana" {
  name             = "sg-kibana"
  network_id       = yandex_vpc_network.netology.id
 
  ingress {
    description    = "Kibana UI from internet"
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "ICMP"
    description    = "allows ping only from bastion"
    security_group_id  = yandex_vpc_security_group.sg-bastion.id
  }

  ingress {
    protocol       = "TCP"
    description    = "allows remote access only through Bastion"
    security_group_id  = yandex_vpc_security_group.sg-bastion.id
    port           = 22
  }  

  ingress {
    description    = "Zabbix agent from Zabbix server"
    protocol       = "TCP"
    port           = 10050
    v4_cidr_blocks = ["10.0.1.0/24"]
  }  

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
