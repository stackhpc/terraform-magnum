clusters = {
  "k8s-calico-podman" = {
    network_driver = "calico"
    image          = "Fedora-AtomicHost-29-20191126.0.x86_64"
  }
  "k8s-flannel-podman" = {
    network_driver = "flannel"
    image          = "Fedora-AtomicHost-29-20191126.0.x86_64"
  }
}

kubeconfig = "k8s-calico-coreos"

label_overrides = {
  use_podman         = "true"
  kube_tag           = "v1.17.4" # https://github.com/kubernetes/kubernetes/releases
  cloud_provider_tag = "v1.17.0" # https://hub.docker.com/r/k8scloudprovider/openstack-cloud-controller-manager/tags
  etcd_tag           = "v3.4.6"
}
