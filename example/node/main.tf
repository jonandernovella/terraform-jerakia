variable instance_count {}
variable prefix {}
variable image_name {}
variable flavor_name {}
variable region {}

variable location {}
variable random_location {}

variable keypair_name {}

variable network_name {}
variable security_group_name {}

variable private_key {}

variable assign_floating_ip {
  default = false
}

variable floating_ip_pool {}

resource "openstack_compute_floatingip_v2" "floating_ip" {
  count = "${var.assign_floating_ip ? var.instance_count : 0}"
  pool  = "${var.floating_ip_pool}"
}

resource "openstack_compute_floatingip_associate_v2" "floating_ip" {
  count       = "${var.assign_floating_ip ? var.instance_count : 0}"
  floating_ip = "${element(openstack_compute_floatingip_v2.floating_ip.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.instance.*.id, count.index)}"
}

resource "openstack_compute_instance_v2" "instance" {
  count           = "${var.instance_count}"
  name            = "${var.prefix}-${format("%03d", count.index)}"
  region          = "${var.region}"
  image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor_name}"
  key_pair        = "${var.keypair_name}"
  security_groups = ["${var.security_group_name}"]
 
  network {
    name = "${var.network_name}"
  }
}

resource "null_resource" "provision" {
  depends_on = ["openstack_compute_floatingip_associate_v2.floating_ip"]
  connection {
    type = "ssh"
    user = "centos"
    agent = "true"
    private_key = "${file(var.private_key)}"
    host = "${element(openstack_compute_floatingip_v2.floating_ip.*.address, count.index)}"
    timeout = "60s"
  }

provisioner "remote-exec" {
  inline = [
    "mkdir ~/${var.prefix}"
    ]
  }
}

data "template_file" "instance_template" {
    template = "$${name} public_ip=$${ip} location=$${location} randomlocation=$${random_location}"
    count = "${var.instance_count}"
    vars {
        name  = "${openstack_compute_instance_v2.instance.*.name[count.index]}"
        ip = "${openstack_compute_floatingip_v2.floating_ip.*.address[count.index]}"
        location = "${data.external.lookup.result.location}"
        random_location = "${data.external.lookup.result.randomlocation}"
    }
}

data "external" "lookup" {
  program = ["python", "../tf-jerakia/terraform_jerakia.py"]

  query = {
    # This is the query data your function will receive as an argument.
    location = "${var.location}"
    randomlocation = "${var.random_location}"
  }
}

data "template_file" "inventory" {
    template = "\n[instances]\n$${data}"
    vars {
        data = "${join("\n",data.template_file.instance_template.*.rendered)}"
    }
}

output "inventory" {
    value = "${data.template_file.inventory.rendered}"
}