variable "external_network_id" {
  type = string
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
  default = "Fedora-AtomicHost-29-20191126.0.x86_64"
}

variable "keypair_name" {
  type = string
}

variable "flavor_name" {
  type = string
  default = "ds4G"
}

variable "master_flavor_name" {
  type = string
  default = "ds2G"
}

variable "volume_driver" {
  type = string
  default = "cinder"
}

variable "master_count" {
  type = number
  default = 1
}

variable "node_count" {
  type = number
  default = 1
}

variable "floating_ip_enabled" {
  type = string
  default = "true"
}

variable "master_lb_enabled" {
  type = string
  default = "true"
}

variable "template_labels" {
  type = map
  default = {
    kube_tag                            = "v1.15.7" # https://hub.docker.com/r/openstackmagnum/kubernetes-apiserver/tags
    cloud_provider_tag                  = "v1.15.0"
    heat_container_agent_tag            = "ussuri-dev"
    tiller_enabled                      = "true"
    tiller_tag                          = "v2.16.1"
    monitoring_enabled                  = "true"
    auto_scaling_enabled                = "true"
    autoscaler_tag                      = "v1.15.2"
    auto_healing_enabled                = "true"
    auto_healing_controller             = "magnum-auto-healer"
    ingress_controller                  = "nginx"
    master_lb_floating_ip_enabled       = "true"
  }
}

variable "labels" {
  type = map
  default = {
  }
}

locals {
  labels = merge(var.template_labels, var.labels)
}
