provider "openstack" {
}

variable "clusters" {
  type = map
  default = {
  }
}

variable "kubeconfig" {
  type = string
}

variable "external_network_id" {
  type = string
}

variable "fixed_network_name" {
  type    = string
  default = ""
}

variable "fixed_subnet_id" {
  type    = string
  default = ""
}

variable "keypair_name" {
  type = string
}

variable "flavor_name" {
  type    = string
  default = "ds4G"
}

variable "master_flavor_name" {
  type    = string
  default = "ds4G"
}

variable "volume_driver" {
  type    = string
  default = "cinder"
}

variable "master_count" {
  type    = number
  default = 1
}

variable "node_count" {
  type    = number
  default = 1
}

variable "create_timeout" {
  type    = number
  default = 20
}

variable "floating_ip_enabled" {
  type    = string
  default = "false"
}

variable "master_lb_enabled" {
  type    = string
  default = "true"
}

variable "labels" {
  type = map
  default = {
    heat_container_agent_tag      = "ussuri-dev"
    tiller_enabled                = "true"
    tiller_tag                    = "v2.16.3"
    monitoring_enabled            = "true"
    auto_scaling_enabled          = "true"
    autoscaler_tag                = "v1.15.2"
    auto_healing_enabled          = "true"
    auto_healing_controller       = "magnum-auto-healer"
    ingress_controller            = "octavia"
    master_lb_floating_ip_enabled = "true"
    cinder_csi_enabled            = "true"
  }
}

variable "label_overrides" {
  type = map
  default = {
  }
}

locals {
  labels = merge(var.labels, var.label_overrides)
  templates = {
    for item in distinct(values(var.clusters)) : format("k8s-%s-%s", item.network_driver, item.image) => item
  }
  clusters = {
    for name, item in var.clusters : name => openstack_containerinfra_clustertemplate_v1.templates[format("k8s-%s-%s", item.network_driver, item.image)].id
  }
}

resource "openstack_containerinfra_clustertemplate_v1" "templates" {
  for_each              = local.templates
  name                  = each.key
  coe                   = "kubernetes"
  docker_storage_driver = "overlay2"
  server_type           = "vm"
  network_driver        = each.value.network_driver
  image                 = each.value.image
  flavor                = var.flavor_name
  master_flavor         = var.master_flavor_name
  volume_driver         = var.volume_driver
  external_network_id   = var.external_network_id
  fixed_network         = var.fixed_network_name
  fixed_subnet          = var.fixed_subnet_id
  floating_ip_enabled   = var.floating_ip_enabled
  master_lb_enabled     = var.master_lb_enabled

  lifecycle {
    create_before_destroy = true
  }
}

resource "openstack_containerinfra_cluster_v1" "clusters" {
  for_each            = local.clusters
  name                = each.key
  cluster_template_id = each.value
  master_count        = var.master_count
  node_count          = var.node_count
  keypair             = var.keypair_name
  create_timeout      = var.create_timeout
  labels              = local.labels

  provisioner "local-exec" {
    command = "mkdir -p ~/.kube/${each.key}; openstack coe cluster config ${each.key} --dir ~/.kube/${each.key} --force"
  }

}

resource "null_resource" "kubeconfig" {
  triggers = {
    kubeconfig = var.kubeconfig
  }

  provisioner "local-exec" {
    command = "ln -fs ~/.kube/${var.kubeconfig}/config ~/.kube/config"
  }

  depends_on = [openstack_containerinfra_cluster_v1.clusters]
}

output "templates" {
  value = local.templates
}

output "clusters" {
  value = local.clusters
}
