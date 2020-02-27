clusters = {
  "k8s-coreos-calico" = "k8s-fedora-coreos-calico"
}

label_overrides = {
  kube_tag                              = "v1.17.3" # https://github.com/kubernetes/kubernetes/releases
  cloud_provider_tag                    = "v1.17.0"
  etcd_tag                              = "3.4.3"
}
