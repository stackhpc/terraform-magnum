# kube_tag: https://github.com/rancher/hyperkube/tags
# cloud_provider_tag: https://github.com/kubernetes/cloud-provider-openstack/tags
variable "templates" {
  type = map(any)
  default = {
    "k8s-1.18.16" = {
      image = "fedora-coreos-33.20210217.3.0-openstack.x86_64"
      labels = {
        kube_tag           = "v1.18.16-rancher1"
        cloud_provider_tag = "v1.18.0"
      }
    }
    "k8s-1.19.8" = {
      image = "fedora-coreos-33.20210217.3.0-openstack.x86_64"
      labels = {
        kube_tag           = "v1.19.8-rancher1"
        cloud_provider_tag = "v1.19.0"
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

