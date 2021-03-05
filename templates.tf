# kube_tag: https://github.com/rancher/hyperkube/tags
# cloud_provider_tag: https://github.com/kubernetes/cloud-provider-openstack/tags
variable "templates" {
  type = map(any)
  default = {
    "k8s-1.18.16" = {
      image = "fedora-coreos-33.20210217.3.0-openstack.x86_64"
      labels = {
        kube_tag           = "v1.18.16-rancher1"
        cloud_provider_tag = "v1.18.2"
      }
    }
    "k8s-1.19.8" = {
      image = "fedora-coreos-33.20210217.3.0-openstack.x86_64"
      labels = {
        kube_tag           = "v1.19.8-rancher1"
        cloud_provider_tag = "v1.19.2"
      }
    }
    "k8s-1.20.4" = {
      image = "fedora-coreos-33.20210217.3.0-openstack.x86_64"
      labels = {
        kube_tag           = "v1.20.4-rancher1"
        cloud_provider_tag = "v1.20.0"
      }
    }
  }
}

variable "extra_templates" {
  type    = map(any)
  default = {}
}

variable "template_labels" {
  type = map(any)
  default = {
    monitoring_enabled            = "true"
    auto_scaling_enabled          = "true"
    auto_healing_enabled          = "true"
    auto_healing_controller       = "magnum-auto-healer"
    magnum_auto_healer_tag        = "v1.20.0"
    ingress_controller            = "nginx"
    master_lb_floating_ip_enabled = "true"
    cinder_csi_enabled            = "true"
  }
}

variable "floating_ip_enabled" {
  type    = string
  default = "false"
}

variable "flavor" {
  type    = string
  default = "ds4G"
}

variable "master_flavor" {
  type    = string
  default = "ds4G"
}

variable "volume_driver" {
  type    = string
  default = "cinder"
}

variable "external_network" {
  type = string
}

variable "network_driver" {
  type    = string
  default = "calico"
}

variable "fixed_network" {
  type    = string
  default = ""
}

variable "fixed_subnet" {
  type    = string
  default = ""
}

variable "insecure_registry" {
  type    = string
  default = ""
}

variable "docker_volume_size" {
  type    = number
  default = "0"
}

variable "tls_disabled" {
  type    = string
  default = "false"
}

variable "master_lb_enabled" {
  type    = string
  default = "true"
}

resource "openstack_containerinfra_clustertemplate_v1" "templates" {
  for_each              = merge(var.templates, var.extra_templates)
  name                  = each.key
  coe                   = "kubernetes"
  docker_storage_driver = "overlay2"
  server_type           = "vm"
  tls_disabled          = var.tls_disabled
  image                 = each.value.image
  volume_driver         = var.volume_driver
  external_network_id   = var.external_network
  master_lb_enabled     = var.master_lb_enabled
  fixed_network         = var.fixed_network
  fixed_subnet          = var.fixed_subnet
  insecure_registry     = var.insecure_registry
  floating_ip_enabled   = var.floating_ip_enabled
  docker_volume_size    = var.docker_volume_size
  network_driver        = lookup(each.value, "network_driver", var.network_driver)
  flavor                = lookup(each.value, "flavor", var.flavor)
  master_flavor         = lookup(each.value, "master_flavor", var.master_flavor)
  labels                = merge(var.template_labels, lookup(each.value, "labels", {}))

  lifecycle {
    create_before_destroy = true
  }
}

output "templates" {
  value = openstack_containerinfra_clustertemplate_v1.templates
}

