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
  master_count        = var.master_count
  node_count          = var.node_count
  keypair             = openstack_compute_keypair_v2.keypair.id
  create_timeout      = var.create_timeout
  floating_ip_enabled = openstack_containerinfra_clustertemplate_v1.templates[each.value.template].floating_ip_enabled # there is a terraform-openstack-provider bug which defaults floating ip enabled to False when it is unset so use value from the template
  flavor              = lookup(each.value, "flavor", var.flavor)
  master_flavor       = lookup(each.value, "master_flavor", var.master_flavor)
  labels              = merge(openstack_containerinfra_clustertemplate_v1.templates[each.value.template].labels, var.cluster_labels, lookup(each.value, "labels", {}))
}

resource "local_file" "kubeconfigs" {
  for_each   = var.clusters
  content    = lookup(lookup(openstack_containerinfra_cluster_v1.clusters, each.key, {}), "kubeconfig", { raw_config : null }).raw_config
  filename   = pathexpand("~/.kube/${each.key}/config")
  depends_on = [openstack_containerinfra_cluster_v1.clusters]
}

resource "null_resource" "kubeconfig" {
  triggers = {
    kubeconfig = var.kubeconfig
  }

  provisioner "local-exec" {
    command = "ln -fs ~/.kube/${var.kubeconfig}/config ~/.kube/config"
  }

  depends_on = [local_file.kubeconfigs]
}

output "clusters" {
  value = openstack_containerinfra_cluster_v1.clusters
}
