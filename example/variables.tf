variable "auth_url" {}
variable "etcd_count" {
  default = "1"
}
variable "cluster_prefix" {}
variable "region" {
  default = ""
}
variable "image_name" {
  default = "CentOS-7-x86_64-GenericCloud-1711"
}
variable "node_location" {
  default = ""
}
variable "random_location" {
  default = ""
}
variable "etcd_node_flavor" {
  default = "m.small"
}
variable "security_group_name" {
  default = ""
}
variable "assign_floating_ip" {
  default = "true"
}
variable "floating_ip_pool" {}
variable "external_network_uuid" {}
variable "network_name" {
	default = ""
}
variable "public_key" {
	default = ""
}
variable "private_key" {
	default = ""
}

