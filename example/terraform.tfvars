# Deployment configuration
auth_url = "https://keystone.api.cloud.ipnett.no/v3"
cluster_prefix = "cluster"
region = "no-south-1"
image_name = "CentOS-7-x86_64-GenericCloud-1711"
assign_floating_ip = "true"
floating_ip_pool = "public-v4"
external_network_uuid = "cbcbe027-9391-4ddc-98ec-5bfa96a9332e"
public_key = "~/.ssh/newkey.pub"
private_key = "~/.ssh/newkey"

# Example Jerakia lookup
node_location = "common/test"
random_location = "common/random"

# etcd node
etcd_count = "1"
etcd_node_flavor = "m.small"


