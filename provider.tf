variable "cloud" {
  type = string
  default = "openstack"
}

provider "openstack" {
  cloud = "${var.cloud}"
  version = "1.23.0"
}
