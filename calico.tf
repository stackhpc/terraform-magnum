variable "cluster_template_calico_name" {
  type = string
  default = "k8s-calico-fedora-atomic"
}

variable "cluster_calico_name" {
  type = string
  default = "k8s-calico"
}

variable "cluster_calico_enabled" {
  type = number
  default = 1
}

resource "null_resource" "cluster_calico" {
  count = var.cluster_calico_enabled
}

resource "openstack_containerinfra_clustertemplate_v1" "cluster_template_calico" {
  name                  = var.cluster_template_calico_name
  coe                   = "kubernetes"
  docker_storage_driver = "overlay2"
  server_type           = "vm"
  network_driver        = "calico"
  image                 = var.image_name
  flavor                = var.flavor_name
  master_flavor         = var.master_flavor_name
  volume_driver         = var.volume_driver
  external_network_id   = var.external_network_id
  fixed_network         = var.fixed_network_name
  fixed_subnet          = var.fixed_subnet_id
  floating_ip_enabled   = var.floating_ip_enabled
  master_lb_enabled     = var.master_lb_enabled
  labels                = var.template_labels

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [null_resource.cluster_calico]
}

resource "openstack_containerinfra_cluster_v1" "cluster_calico" {
  name                  = var.cluster_calico_name
  cluster_template_id   = openstack_containerinfra_clustertemplate_v1.cluster_template_calico.id
  master_count          = var.master_count
  node_count            = var.node_count
  keypair               = var.keypair_name
  labels                = var.labels

  provisioner "local-exec" {
    command = "mkdir -p ~/.kube/calico; openstack coe cluster config ${var.cluster_calico_name} --dir ~/.kube/calico --force; ln -s ~/.kube/calico/config ~/.kube/config -f"
  }

  depends_on = [null_resource.cluster_calico]
}
