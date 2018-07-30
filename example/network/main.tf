variable prefix {}

variable network_name {}

variable subnet_cidr {
  default = "192.168.199.0/24"
}

variable external_network_uuid {}

resource "openstack_networking_network_v2" "network" {
  count          = "${var.network_name == "" ? 1 : 0}"
  name           = "${var.prefix}-network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  count      = "${var.network_name == "" ? 1 : 0}"
  name       = "${var.prefix}-subnet"
  network_id = "${openstack_networking_network_v2.network.id}"
  cidr       = "${var.subnet_cidr}"
  ip_version = 4
}

resource "openstack_networking_router_v2" "router" {
  count            = "${var.network_name == "" ? 1 : 0}"
  name             = "${var.prefix}-router"
  external_gateway = "${var.external_network_uuid}"
}

resource "openstack_networking_router_interface_v2" "interface" {
  count     = "${var.network_name == "" ? 1 : 0}"
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet.id}"
}

output "network_name" {
  value = "${ var.network_name == "" ? join(" ", openstack_networking_network_v2.network.*.name) : var.network_name }"
}
