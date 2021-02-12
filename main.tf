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
  filename = pathexpand("~/.ssh/id_rsa.pub")
}


resource "openstack_compute_keypair_v2" "keypair" {
  name       = var.keypair_name
  public_key = data.local_file.public_key.content
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
  insecure_registry     = var.insecure_registry
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
  labels              = merge(var.template_labels, var.cluster_labels, lookup(each.value, "labels", {}))
  docker_volume_size  = var.docker_volume_size
  floating_ip_enabled = var.floating_ip_enabled
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
