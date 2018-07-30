variable prefix {}
variable public_key {}

resource "random_id" "rid" {
  byte_length = 12
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.prefix}-keypair-${random_id.rid.hex}"
  public_key = "${file(var.public_key)}"
}

output "keypair_name" {
  value = "${openstack_compute_keypair_v2.keypair.name}"
}