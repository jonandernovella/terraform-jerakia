variable prefix {}
variable security_group_name {}

resource "openstack_compute_secgroup_v2" "security_group" {
  count       = "${var.security_group_name == "" ? 1 : 0}"
  name        = "${var.prefix}-security_group"
  description = "this is a security group"

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "udp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    self        = "true"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "udp"
    self        = "true"
  }
}

output "security_group_name" {
  value = "${ var.security_group_name == "" ? join(" ", openstack_compute_secgroup_v2.security_group.*.name) : var.security_group_name }"
}