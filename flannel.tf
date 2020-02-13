variable "cluster_template_flannel_name" {
  type = string
  default = "k8s-flannel-fedora-atomic"
}

variable "cluster_flannel_name" {
  type = string
  default = "k8s-flannel"
}

variable "cluster_flannel_enabled" {
  type = number
  default = 1
}

resource "null_resource" "cluster_flannel" {
  count = var.cluster_flannel_enabled
}

resource "openstack_containerinfra_clustertemplate_v1" "cluster_template_flannel" {
  name                  = var.cluster_template_flannel_name
  coe                   = "kubernetes"
  docker_storage_driver = "overlay2"
  server_type           = "vm"
  network_driver        = "flannel"
  image                 = var.image_name
  flavor                = var.flavor_name
  master_flavor         = var.master_flavor_name
  volume_driver         = var.volume_driver
  external_network_id   = var.external_network_id
  fixed_network         = var.fixed_network_name
  fixed_subnet          = var.fixed_subnet_id
  floating_ip_enabled   = var.fip_enabled
  labels                = var.template_labels
  master_lb_enabled     = local.labels.master_lb_floating_ip_enabled

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [null_resource.cluster_flannel]
}

resource "openstack_containerinfra_cluster_v1" "cluster_flannel" {
  name                  = var.cluster_flannel_name
  cluster_template_id   = openstack_containerinfra_clustertemplate_v1.cluster_template_flannel.id
  master_count          = var.master_count
  node_count            = var.node_count
  keypair               = var.keypair_name
  labels                = local.labels

  provisioner "local-exec" {
    command = "mkdir -p ~/.kube/flannel; openstack coe cluster config ${var.cluster_flannel_name} --dir ~/.kube/flannel --force; ln -s ~/.kube/flannel/config ~/.kube/config -f"
  }

  depends_on = [null_resource.cluster_flannel]
}
