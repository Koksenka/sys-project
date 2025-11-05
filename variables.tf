# Cloud vars ===========================================================================
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"  
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"  
}

# Availability zone vars ================================================================
variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b"]
}

variable "zone1" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone2" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

# Network vars
variable "vpc_name" {
  type        = string
  default     = "netology"
  description = "VPC network&subnet name"
}

variable "subnet1_name" {
  type        = string
  default     = "prd1"
  description = "VPC network&subnet name"
}

variable "subnet2_name" {
  type        = string
  default     = "prd2"
  description = "VPC network&subnet name"
}

variable "default_cidr1" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "default_cidr2" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

# Servers vars =========================================================================
variable "image_family" {
   type        = string
   default     = "ubuntu-2204-lts"
   description = "OS image for virtual machine"
 }

 variable "platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Yandex Compute Cloud provides platform "
}

variable "vms_resources" {
  type        = map(map(number))
  description = "All resources for virtual machine"
}

variable username {
  type = string
}

variable ssh_public_key {
  type        = string
  description = "Location of SSH public key."
}