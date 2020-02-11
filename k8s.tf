variable "cluster_template_flannel_name" {
  type = string
  default = "k8s_flannel"
}

variable "cluster_template_calico_name" {
  type = string
  default = "k8s_calico"
}

variable "cluster_flannel_name" {
  type = string
  default = "k8s_flannel"
}

variable "cluster_calico_name" {
  type = string
  default = "k8s_calico"
}

variable "external_network_id" {
  type = string
  default = "external-network-id"
}

variable "fixed_network_name" {
  type = string
  default = ""
}

variable "fixed_subnet_id" {
  type = string
  default = ""
}

variable "image_name" {
  type = string
  default = "Fedora-AtomicHost-29-20191126.0"
}

variable "public_key_file" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "keypair_name" {
  type = string
  default = "default"
}

variable "flavor_name" {
  type = string
  default = "ds4G"
}

variable "master_flavor_name" {
  type = string
  default = "ds2G"
}

variable "volume_driver" {
  type = string
  default = "cinder"
}

variable "master_count" {
  type = number
  default = 1
}

variable "node_count" {
  type = number
  default = 1
}

variable "max_node_count" {
  type = number
  default = 2
}

variable "cluster_calico_count" {
  type = number
  default = 1
}

variable "cluster_flannel_count" {
  type = number
  default = 0
}

variable "autoscaler_tag" {
  type = string
  default = "v1.15.2"
}

variable "kube_tag" {
  type = string
  default = "v1.17.2"
  # [coreos, podman]: https://github.com/kubernetes/kubernetes/releases
  # [atomic]: https://hub.docker.com/r/openstackmagnum/kubernetes-apiserver/tags
}

variable "cloud_provider_tag" {
  type = string
  default = "v1.17.0"
}

variable "tiller_tag" {
  type = string
  default = "v2.16.1"
}

variable "etcd_tag" {
  type = string
  default = "3.3.17"
}

variable "etcd_volume_size" {
  type = number
  default = 0
}

variable "use_podman" {
  type = string
  default = "true"
}

variable "ingress_controller" {
  type = string
  default = "nginx"
}

variable "monitoring_enabled" {
  type = string
  default = "true"
}

variable "auto_scaling_enabled" {
  type = string
  default = "true"
}

variable "auto_healing_enabled" {
  type = string
  default = "true"
}

variable "auto_healing_controller" {
  type = string
  default = "magnum-auto-healer"
}

variable "tiller_enabled" {
  type = string
  default = "true"
}

variable "master_fip_enabled" {
  type = string
  default = "true"
}

variable "fip_enabled" {
  type = string
  default = "true"
}

variable "hca_tag" {
  type = string
  default = "ussuri-dev"
}

variable "kubelet_options" {
  type = string
  default = ""
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = var.keypair_name
  public_key = file(var.public_key_file)
}

resource "openstack_containerinfra_clustertemplate_v1" "cluster_template_flannel" {
  name                  = "${var.cluster_template_flannel_name}"
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
  master_lb_enabled     = var.master_fip_enabled
  floating_ip_enabled   = var.fip_enabled

  lifecycle {
    create_before_destroy = true
  }
}

resource "openstack_containerinfra_cluster_v1" "cluster_flannel" {
  count                = var.cluster_flannel_count
  name                 = "${var.cluster_flannel_name}"
  cluster_template_id  = openstack_containerinfra_clustertemplate_v1.cluster_template_flannel.id
  master_count         = var.master_count
  node_count           = var.node_count
  keypair              = openstack_compute_keypair_v2.keypair.id

  provisioner "local-exec" {
    command = "mkdir -p ~/.kube/flannel; openstack coe cluster config ${var.cluster_flannel_name} --dir ~/.kube/flannel --force"
  }

  labels = {
    # toggles
    tiller_enabled                      = var.tiller_enabled
    monitoring_enabled                  = var.monitoring_enabled
    auto_scaling_enabled                = var.auto_scaling_enabled
    master_lb_floating_ip_enabled       = var.master_fip_enabled
    auto_healing_enabled                = var.auto_healing_enabled
    # tags
    kube_tag                            = var.kube_tag
    etcd_tag                            = var.etcd_tag
    etcd_volume_size                    = var.etcd_volume_size
    tiller_tag                          = var.tiller_tag
    autoscaler_tag                      = var.autoscaler_tag
    cloud_provider_tag                  = var.cloud_provider_tag
    heat_container_agent_tag            = var.hca_tag
    # misc
    auto_healing_controller             = var.auto_healing_controller
    ingress_controller                  = var.ingress_controller
    min_node_count                      = var.node_count
    max_node_count                      = var.max_node_count
    use_podman                          = var.use_podman
    kubelet_options			= var.kubelet_options
  }
}

resource "openstack_containerinfra_clustertemplate_v1" "cluster_template_calico" {
  name                  = "${var.cluster_template_calico_name}"
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
  master_lb_enabled     = var.master_fip_enabled
  floating_ip_enabled   = var.fip_enabled

  lifecycle {
    create_before_destroy = true
  }
}

resource "openstack_containerinfra_cluster_v1" "cluster_calico" {
  count                = var.cluster_calico_count
  name                 = "${var.cluster_calico_name}"
  cluster_template_id  = openstack_containerinfra_clustertemplate_v1.cluster_template_calico.id
  master_count         = var.master_count
  node_count           = var.node_count
  keypair              = openstack_compute_keypair_v2.keypair.id

  provisioner "local-exec" {
    command = "mkdir -p ~/.kube/calico; openstack coe cluster config ${var.cluster_calico_name} --dir ~/.kube/calico --force"
  }

  labels = {
    # toggles
    tiller_enabled                      = var.tiller_enabled
    monitoring_enabled                  = var.monitoring_enabled
    auto_scaling_enabled                = var.auto_scaling_enabled
    master_lb_floating_ip_enabled       = var.master_fip_enabled
    auto_healing_enabled                = var.auto_healing_enabled
    # tags
    kube_tag                            = var.kube_tag
    etcd_tag                            = var.etcd_tag
    etcd_volume_size                    = var.etcd_volume_size
    tiller_tag                          = var.tiller_tag
    autoscaler_tag                      = var.autoscaler_tag
    cloud_provider_tag                  = var.cloud_provider_tag
    heat_container_agent_tag            = var.hca_tag
    # misc
    auto_healing_controller             = var.auto_healing_controller
    ingress_controller                  = var.ingress_controller
    min_node_count                      = var.node_count
    max_node_count                      = var.max_node_count
    use_podman                          = var.use_podman
    kubelet_options			= var.kubelet_options
  }
}
