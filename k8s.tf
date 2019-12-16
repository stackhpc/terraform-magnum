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
  default = ""
}

variable "fixed_subnet_id" {
  type = string
  default = ""
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

variable "volume_driver" {
  type = string
  default = ""
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

variable "max_node_count" {
  type = number
  default = 4
}

variable "kube_tag" {
  type = string
  default = "v1.16.3"
}

variable "cloud_provider_tag" {
  type = string
  default = "v1.16.0"
}

variable "etcd_tag" {
  type = string
  default = ""
}

variable "use_podman" {
  type = string
  default = "true"
}

variable "ingress_controller" {
  type = string
  default = ""
}

variable "master_fip_enabled" {
  type = string
  default = "false"
}

variable "fip_enabled" {
  type = string
  default = "true"
}

variable "hca_tag" {
  type = string
  default = "train-stable"
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = "default"
  public_key = file(var.public_key_file)
}

resource "openstack_containerinfra_clustertemplate_v1" "cluster_template" {
  name                  = var.cluster_template_name
  image                 = var.image_name
  coe                   = "kubernetes"
  flavor                = var.flavor_name
  master_flavor         = var.master_flavor_name
  docker_storage_driver = "overlay2"
  volume_driver         = var.volume_driver
  network_driver        = var.network_driver
  server_type           = "vm"
  external_network_id   = var.external_network_id
  fixed_network         = var.fixed_network_name
  fixed_subnet          = var.fixed_subnet_id
  master_lb_enabled     = var.master_fip_enabled
  floating_ip_enabled   = var.fip_enabled

  lifecycle {
    create_before_destroy = true
  }
}

resource "openstack_containerinfra_cluster_v1" "cluster" {
  name                 = var.cluster_name
  cluster_template_id  = openstack_containerinfra_clustertemplate_v1.cluster_template.id
  master_count         = var.master_count
  node_count           = var.node_count
  keypair              = openstack_compute_keypair_v2.keypair.id

  provisioner "local-exec" {
    command = "openstack coe cluster config ${var.cluster_name} --dir ~/.kube/ --force"
  }

  labels = {
    master_lb_floating_ip_enabled       = var.master_fip_enabled
    ingress_controller                  = var.ingress_controller
    nginx_ingress_controller_tag        = "0.26.1"
    nginx_ingress_controller_chart_tag = "1.24.7"
    tiller_enabled                      = "true"
    tiller_tag                          = "v2.16.0"
    monitoring_enabled                  = "true"
    prometheus_operator_chart_tag       = "8.2.2"
    auto_scaling_enabled                = "true"
    autoscaler_tag                      = "v1.0"
    min_node_count                      = var.node_count
    max_node_count                      = var.max_node_count
    use_podman                          = var.use_podman
    kube_tag                            = var.kube_tag
    etcd_tag                            = var.etcd_tag
    cloud_provider_tag                  = var.cloud_provider_tag
    heat_container_agent_tag            = var.hca_tag
  }
}
