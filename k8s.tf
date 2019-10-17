variable "cluster_name" {
  type = string
  default = "k8s"
}

variable "external_network_name" {
  type = string
  default = "provision-net"
}

variable "fixed_network_name" {
  type = string
  default = "provision-net"
}

variable "fixed_subnet_name" {
  type = string
  default = "provision-net"
}

variable "keypair_name" {
  type = string
  default = "default"
}

variable "image_name" {
  type = string
  default = "FedoraAtomic29-20190820"
}

variable "public_key_file" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "flavor_name" {
  type = string
  default = "general.v1.tiny"
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = "default"
  public_key = "${file("${var.public_key_file}")}"
}

resource "openstack_containerinfra_clustertemplate_v1" "cluster_template" {
  name                  = "k8s"
  image                 = "${var.image_name}"
  coe                   = "kubernetes"
  flavor                = "${var.flavor_name}"
  master_flavor         = "${var.flavor_name}"
  docker_storage_driver = "overlay2"
  network_driver        = "flannel"
  server_type           = "vm"
  external_network_id   = "${var.external_network_name}"
  fixed_network         = "${var.fixed_network_name}"
  fixed_subnet          = "${var.fixed_subnet_name}"
  master_lb_enabled     = false
  floating_ip_enabled   = false
  labels = {
    cgroup_driver="cgroupfs"
    ingress_controller="traefik"
    tiller_enabled="true"
    tiller_tag="v2.14.3"
    monitoring_enabled="true"
    auto_scaling_enabled="true"
    autoscaler_tag="v1.0"
    min_node_count="1"
    max_node_count="5"
    kube_tag="v1.14.6"
    cloud_provider_tag="v1.14.0"
    heat_container_agent_tag="train-dev"
  }
}

resource "openstack_containerinfra_cluster_v1" "cluster" {
  name                 = "${var.cluster_name}"
  cluster_template_id  = "${openstack_containerinfra_clustertemplate_v1.cluster_template.id}"
  master_count         = 1
  node_count           = 2
  keypair              = "${openstack_compute_keypair_v2.keypair.id}"
}
