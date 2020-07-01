provider "openstack" {
  version = ">= 1.29.0"
}

locals {
  templates = {
    for item in distinct(values(var.clusters)) : format("k8s-%s-%s", item.network_driver, item.image) => item
  }
  clusters = {
    for name, item in var.clusters : name => {
      template_id = lookup(lookup(openstack_containerinfra_clustertemplate_v1.templates, format("k8s-%s-%s", item.network_driver, item.image), {}), "id", null)
      labels      = merge(var.labels, var.label_overrides, lookup(var.cluster_label_overrides, name, {}))
    }
  }
}

resource "openstack_containerinfra_clustertemplate_v1" "templates" {
  for_each              = local.templates
  name                  = each.key
  coe                   = "kubernetes"
  docker_storage_driver = "overlay2"
  server_type           = "vm"
  tls_disabled          = var.tls_disabled
  network_driver        = each.value.network_driver
  image                 = each.value.image
  flavor                = var.flavor_name
  master_flavor         = var.master_flavor_name
  volume_driver         = var.volume_driver
  external_network_id   = var.external_network
  fixed_network         = var.fixed_network
  fixed_subnet          = var.fixed_subnet
  floating_ip_enabled   = var.floating_ip_enabled
  master_lb_enabled     = var.master_lb_enabled

  lifecycle {
    create_before_destroy = true
  }
}

resource "openstack_containerinfra_cluster_v1" "clusters" {
  for_each            = local.clusters
  name                = each.key
  cluster_template_id = each.value.template_id
  master_count        = var.master_count
  node_count          = var.node_count
  keypair             = var.keypair_name
  create_timeout      = var.create_timeout
  labels              = each.value.labels
  docker_volume_size  = var.docker_volume_size
}

resource "local_file" "kubeconfigs" {
  for_each = local.clusters
  content  = openstack_containerinfra_cluster_v1.clusters[each.key].kubeconfig.raw_config
  filename = pathexpand("~/.kube/${each.key}/config")
}

resource "local_file" "kubeconfig" {
  for_each = local.clusters
  content  = openstack_containerinfra_cluster_v1.clusters[var.kubeconfig].kubeconfig.raw_config
  filename = pathexpand("~/.kube/config")
}
