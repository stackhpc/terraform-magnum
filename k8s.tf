variable "cluster_template_name" {
  type = string
  default = "k8s"
}

variable "cluster_name" {
  type = string
  default = "k8s"
}

variable "external_network_id" {
  type = string
  default = "external-network-id"
}

variable "fixed_network_name" {
  type = string
  default = "fixed-network-name"
}

variable "fixed_subnet_id" {
  type = string
  default = "fixed-subnet-id"
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

variable "master_flavor_name" {
  type = string
  default = "general.v1.tiny"
}

variable "network_driver" {
  type = string
  default = "flannel"
}

variable "master_count" {
  type = number
  default = 1
}

variable "node_count" {
  type = number
  default = 2
}

variable "ingress_controller" {
  type = string
  default = "nginx"
}

variable "master_fip_enabled" {
  type = string
  default = "false"
}

variable "fip_enabled" {
  type = string
  default = "true"
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = "default"
  public_key = "${file("${var.public_key_file}")}"
}

resource "openstack_containerinfra_clustertemplate_v1" "cluster_template" {
  name                  = "${var.cluster_template_name}"
  image                 = "${var.image_name}"
  coe                   = "kubernetes"
  flavor                = "${var.flavor_name}"
  master_flavor         = "${var.master_flavor_name}"
  docker_storage_driver = "overlay2"
  volume_driver         = "cinder"
  network_driver        = "${var.network_driver}"
  server_type           = "vm"
  external_network_id   = "${var.external_network_id}"
  fixed_network         = "${var.fixed_network_name}"
  fixed_subnet          = "${var.fixed_subnet_id}"
  master_lb_enabled     = "${var.master_fip_enabled}"
  floating_ip_enabled   = "${var.fip_enabled}"
  labels = {
    master_lb_floating_ip_enabled="${var.master_fip_enabled}"
    ingress_controller="${var.ingress_controller}"
    tiller_enabled="true"
    tiller_tag="v2.14.3"
    monitoring_enabled="true"
    auto_scaling_enabled="true"
    autoscaler_tag="v1.0"
    min_node_count="1"
    max_node_count="5"
    kube_tag="v1.14.6"
    cloud_provider_tag="v1.14.0"
    heat_container_agent_tag="train-stable"
  }
}

resource "openstack_containerinfra_cluster_v1" "cluster" {
  name                 = "${var.cluster_name}"
  cluster_template_id  = "${openstack_containerinfra_clustertemplate_v1.cluster_template.id}"
  master_count         = "${var.master_count}"
  node_count           = "${var.node_count}"
  keypair              = "${openstack_compute_keypair_v2.keypair.id}"

  provisioner "local-exec" {
    command = "openstack coe cluster config ${var.cluster_name} --dir ~/.kube/ --force"
  }
}
