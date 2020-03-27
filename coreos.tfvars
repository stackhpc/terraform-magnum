clusters = {
  "k8s-calico-coreos" = {
    network_driver = "calico"
    image          = "fedora-coreos-31.20200310.3.0-openstack.x86_64"
  }
  "k8s-flannel-coreos" = {
    network_driver = "flannel"
    image          = "fedora-coreos-31.20200310.3.0-openstack.x86_64"
  }
}

kubeconfig = "k8s-calico-coreos"

label_overrides = {
  kube_tag           = "v1.17.4" # https://github.com/kubernetes/kubernetes/releases
  cloud_provider_tag = "v1.17.0"
  etcd_tag           = "3.4.4"
}
