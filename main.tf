terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">=1.31.0"
    }
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

data "local_file" "public_key" {
  filename = pathexpand(var.keypair_file)
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = var.keypair_name
  public_key = data.local_file.public_key.content
}

resource "openstack_containerinfra_clustertemplate_v1" "templates" {
  for_each              = merge(var.templates, var.extra_templates)
  name                  = each.key
  coe                   = "kubernetes"
  docker_storage_driver = "overlay2"
  server_type           = "vm"
  tls_disabled          = var.tls_disabled
  image                 = each.value.image
  volume_driver         = var.volume_driver
  external_network_id   = var.external_network
  master_lb_enabled     = var.master_lb_enabled
  fixed_network         = var.fixed_network
  fixed_subnet          = var.fixed_subnet
  insecure_registry     = var.insecure_registry
  floating_ip_enabled   = var.floating_ip_enabled
  docker_volume_size    = var.docker_volume_size
  network_driver        = lookup(each.value, "network_driver", var.network_driver)
  flavor                = lookup(each.value, "flavor", var.flavor)
  master_flavor         = lookup(each.value, "master_flavor", var.master_flavor)
  labels                = merge(var.template_labels, lookup(each.value, "labels", {}))

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
  keypair             = openstack_compute_keypair_v2.keypair.id
  create_timeout      = var.create_timeout
  floating_ip_enabled = openstack_containerinfra_clustertemplate_v1.templates[each.value.template].floating_ip_enabled # there is a terraform-openstack-provider bug which defaults floating ip enabled to False when it is unset so use value from the template
  flavor              = lookup(each.value, "flavor", var.flavor)
  master_flavor       = lookup(each.value, "master_flavor", var.master_flavor)
  labels              = merge(var.template_labels, var.cluster_labels, lookup(each.value, "labels", {}))
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
