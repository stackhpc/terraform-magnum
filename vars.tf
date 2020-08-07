variable "templates" {
  type = map
  default = {
    "k8s-calico-atomic" = {
      network_driver = "calico"
      image          = "Fedora-AtomicHost-29-20191126.0.x86_64"
    }
    "k8s-flannel-atomic" = {
      network_driver = "flannel"
      image          = "Fedora-AtomicHost-29-20191126.0.x86_64"
    }
    "k8s-calico-coreos" = {
      network_driver = "calico"
      image          = "fedora-coreos-32.20200629.3.0-openstack.x86_64"
    }
    "k8s-flannel-coreos" = {
      network_driver = "flannel"
      image          = "fedora-coreos-32.20200629.3.0-openstack.x86_64"
    }
  }
}

variable "clusters" {
  type = map
  default = {
  }
}

variable "kubeconfig" {
  type = string
}

variable "external_network" {
  type = string
}

variable "fixed_network" {
  type    = string
  default = ""
}

variable "fixed_subnet" {
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

variable "docker_volume_size" {
  type    = number
  default = "0"
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

variable "tls_disabled" {
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
    monitoring_enabled            = "true"
    auto_scaling_enabled          = "true"
    auto_healing_enabled          = "true"
    auto_healing_controller       = "magnum-auto-healer"
    magnum_auto_healer_tag        = "latest"
    ingress_controller            = "nginx"
    master_lb_floating_ip_enabled = "true"
    cinder_csi_enabled            = "true"
    kube_tag                      = "v1.18.3" # https://github.com/kubernetes/kubernetes/releases
    cloud_provider_tag            = "v1.18.0" # https://hub.docker.com/r/k8scloudprovider/openstack-cloud-controller-manager/tags
  }
}

variable "label_overrides" {
  type = map
  default = {
  }
}
