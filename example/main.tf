# Provider
provider "openstack" {
  auth_url  = "${var.auth_url}"
}

# Network
module "network" {
  source                = "./network"
  network_name          = "${var.network_name}"
  external_network_uuid = "${var.external_network_uuid}"
  prefix                = "${var.cluster_prefix}"
}

# Security group
module "security_group" {
  source              = "./security_group"
  security_group_name = "${var.security_group_name}"
  prefix              = "${var.cluster_prefix}"
}

# Keypair
module "keypair" {
  source      = "./keypair"
  public_key  = "${var.public_key}"
  prefix      = "${var.cluster_prefix}"
}

# etcd node
module "etcd_node" {
  source          = "./node"
  instance_count  = "${var.etcd_count}"
  prefix          = "${var.region}-${var.image_name}-etcd"
  region          = "${var.region}"
  flavor_name     = "${var.etcd_node_flavor}"
  image_name      = "${var.image_name}"
  location        = "${var.node_location}"
  random_location = "${var.random_location}"

  keypair_name = "${module.keypair.keypair_name}"
  private_key  = "${var.private_key}"

  network_name        = "${module.network.network_name}"
  security_group_name = "${module.security_group.security_group_name}"
  assign_floating_ip  = "${var.assign_floating_ip}"
  floating_ip_pool    = "${var.floating_ip_pool}"
}
