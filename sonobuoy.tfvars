clusters = {
  "k8s-calico-sonobuoy" = {
    network_driver = "calico"
    image          = "fedora-coreos-32.20200601.3.0-openstack.x86_64"
  }
  "k8s-flannel-sonobuoy" = {
    network_driver = "flannel"
    image          = "fedora-coreos-32.20200601.3.0-openstack.x86_64"
  }
}

node_count = 2
kubeconfig = "k8s-calico-sonobuoy"

label_overrides = {
}
