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

variable "master_lb_enabled" {
  type    = string
  default = "true"
}

variable "labels" {
  type = map
  default = {
    heat_container_agent_tag      = "ussuri-dev"
    tiller_enabled                = "true"
    monitoring_enabled            = "true"
    auto_scaling_enabled          = "true"
    auto_healing_enabled          = "true"
    auto_healing_controller       = "magnum-auto-healer"
    ingress_controller            = "nginx"
    master_lb_floating_ip_enabled = "true"
    cinder_csi_enabled            = "true"
  }
}

variable "label_overrides" {
  type = map
  default = {
  }
}

variable "cluster_label_overrides" {
  type = map(map(string))
  default = {
  }
}
