# Creating a cloud network
resource "yandex_vpc_network" "netology" {
   name = var.vpc_name
 }


# Creating a subnet
resource "yandex_vpc_subnet" "subnet1" {
  name           = var.subnet1_name
  zone           = var.zone1
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.default_cidr1
  route_table_id = yandex_vpc_route_table.rt.id 
}

resource "yandex_vpc_subnet" "subnet2" {
  name           = var.subnet2_name
  zone           = var.zone2
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.default_cidr2
  route_table_id = yandex_vpc_route_table.rt.id 
}

# Creating a NAT Gateway 
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}  
}

resource "yandex_vpc_route_table" "rt" {
  name       = "route-table"
  network_id = yandex_vpc_network.netology.id
  static_route {
    destination_prefix = "0.0.0.0/0"  
    gateway_id         = yandex_vpc_gateway.nat_gateway.id  
  }
}

