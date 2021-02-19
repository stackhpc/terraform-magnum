variable "clusters" {
  type = map(any)
  default = {
  }
}

variable "cluster_labels" {
  type = map(any)
  default = {
  }
}

variable "keypair_file" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "keypair_name" {
  type = string
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

variable "kubeconfig" {
  type = string
}

