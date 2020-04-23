clusters = {
  "k8s-calico-atomic" = {
    network_driver = "calico"
    image          = "Fedora-AtomicHost-29-20191126.0.x86_64"
  }
  "k8s-flannel-atomic" = {
    network_driver = "flannel"
    image          = "Fedora-AtomicHost-29-20191126.0.x86_64"
  }
}

kubeconfig = "k8s-calico-atomic"

label_overrides = {
  kube_tag           = "v1.15.7" # https://hub.docker.com/r/openstackmagnum/kubernetes-apiserver/tags
  cloud_provider_tag = "v1.15.0" # https://hub.docker.com/r/k8scloudprovider/openstack-cloud-controller-manager/tags
}
