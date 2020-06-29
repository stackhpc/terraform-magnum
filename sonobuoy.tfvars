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
  kube_tag           = "v1.18.3" # https://github.com/kubernetes/kubernetes/releases
  cloud_provider_tag = "v1.18.0" # https://hub.docker.com/r/k8scloudprovider/openstack-cloud-controller-manager/tags
}
