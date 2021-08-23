variable "clusters" {
  type = map(object({
    template            = optional(any)
    master_count        = optional(any)
    node_count          = optional(any)
    keypair             = optional(any)
    create_timeout      = optional(any)
    floating_ip_enabled = optional(any)
    flavor              = optional(any)
    master_flavor       = optional(any)
    fixed_network       = optional(any)
    fixed_subnet        = optional(any)
    labels              = optional(map(string))
  }))
  default = {}
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
  default = "15"
}

variable "kubeconfig" {
  type = string
}

data "local_file" "public_key" {
  filename = pathexpand(var.keypair_file)
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = var.keypair_name
  public_key = data.local_file.public_key.content
}

resource "openstack_containerinfra_cluster_v1" "clusters" {
  for_each            = var.clusters
  name                = each.key
  cluster_template_id = openstack_containerinfra_clustertemplate_v1.templates[each.value.template].id
  master_count        = lookup(each.value, "master_count") != null ? lookup(each.value, "master_count") : var.master_count
  node_count          = lookup(each.value, "node_count") != null ? lookup(each.value, "node_count") : var.node_count
  keypair             = lookup(each.value, "keypair") != null ? lookup(each.value, "keypair") : openstack_compute_keypair_v2.keypair.id
  create_timeout      = lookup(each.value, "create_timeout") != null ? lookup(each.value, "create_timeout") : var.create_timeout
  floating_ip_enabled = lookup(each.value, "floating_ip_enabled") != null ? lookup(each.value, "floating_ip_enabled") : var.floating_ip_enabled
  flavor              = lookup(each.value, "flavor") != null ? lookup(each.value, "flavor") : var.flavor
  master_flavor       = lookup(each.value, "master_flavor") != null ? lookup(each.value, "master_flavor") : var.master_flavor
  fixed_network       = lookup(each.value, "fixed_network") != null ? lookup(each.value, "fixed_network") : var.fixed_network
  fixed_subnet        = lookup(each.value, "fixed_subnet") != null ? lookup(each.value, "fixed_subnet") : var.fixed_subnet
  labels              = merge(openstack_containerinfra_clustertemplate_v1.templates[each.value.template].labels, var.cluster_labels, lookup(each.value, "labels", {}))
}

resource "local_file" "kubeconfigs" {
  for_each        = var.clusters
  content         = lookup(lookup(openstack_containerinfra_cluster_v1.clusters, each.key, {}), "kubeconfig", { raw_config : null }).raw_config
  filename        = pathexpand("~/.kube/${each.key}/config")
  file_permission = "0600"
  depends_on      = [openstack_containerinfra_cluster_v1.clusters]
}

resource "null_resource" "kubeconfig" {
  triggers = {
    kubeconfig = var.kubeconfig
  }

  provisioner "local-exec" {
    command = "ln -fs ~/.kube/${var.kubeconfig}/config ~/.kube/config; chmod 600 ~/.kube/config"
  }

  depends_on = [local_file.kubeconfigs]
}

output "clusters" {
  value = var.clusters
}
