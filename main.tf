provider "openstack" {
  version = "1.29.0"
}

resource "openstack_containerinfra_clustertemplate_v1" "templates" {
  for_each              = var.templates
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
  master_lb_enabled     = var.master_lb_enabled
  fixed_network         = var.fixed_network
  fixed_subnet          = var.fixed_subnet
  floating_ip_enabled   = var.floating_ip_enabled

  lifecycle {
    create_before_destroy = true
  }
}

resource "openstack_containerinfra_cluster_v1" "clusters" {
  for_each            = var.clusters
  name                = each.key
  cluster_template_id = openstack_containerinfra_clustertemplate_v1.templates[each.value.template].id
  master_count        = var.master_count
  node_count          = var.node_count
  keypair             = var.keypair_name
  create_timeout      = var.create_timeout
  labels              = merge(var.labels, var.label_overrides, lookup(each.value, "label_overrides", {}))
  docker_volume_size  = var.docker_volume_size
}

resource "local_file" "kubeconfigs" {
  for_each = var.clusters
  content  = lookup(lookup(openstack_containerinfra_cluster_v1.clusters, each.key, {}), "kubeconfig", { raw_config : null }).raw_config
  filename = pathexpand("~/.kube/${each.key}/config")
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
