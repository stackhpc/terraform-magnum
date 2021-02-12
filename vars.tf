variable "templates" {
  type = map(any)
  default = {
    "k8s-1.18.15" = {
      network_driver = "calico"
      image          = "fedora-coreos-33.20210117.3.2-openstack.x86_64"
      labels = {
        kube_tag           = "v1.18.15-rancher1" # https://github.com/kubernetes/kubernetes/releases
        cloud_provider_tag = "v1.18.0"           # https://hub.docker.com/r/k8scloudprovider/openstack-cloud-controller-manager/tags
      }
    }
    "k8s-1.19.7" = {
      network_driver = "calico"
      image          = "fedora-coreos-33.20210117.3.2-openstack.x86_64"
      labels = {
        kube_tag           = "v1.19.7-rancher1"  # https://github.com/kubernetes/kubernetes/releases
        cloud_provider_tag = "v1.19.0"           # https://hub.docker.com/r/k8scloudprovider/openstack-cloud-controller-manager/tags
      }
    }
    "k8s-1.20.2" = {
      network_driver = "calico"
      image          = "fedora-coreos-33.20210117.3.2-openstack.x86_64"
      labels = {
        kube_tag           = "v1.20.2-rancher1"  # https://github.com/kubernetes/kubernetes/releases
        cloud_provider_tag = "v1.20.0"           # https://hub.docker.com/r/k8scloudprovider/openstack-cloud-controller-manager/tags
      }
    }
  }
}

variable "clusters" {
  type = map(any)
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
  default = "1"
}

variable "node_count" {
  type    = number
  default = "1"
}

variable "create_timeout" {
  type    = number
  default = "10"
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

variable "insecure_registry" {
  type    = string
  default = ""
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

variable "cluster_labels" {
  type = map(any)
  default = {
  }
}
