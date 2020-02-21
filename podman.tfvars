cluster_flannel_name = "k8s-flannel-podman"
cluster_calico_name = "k8s-calico-podman"
labels = {
  use_podman         = "true"
  kube_tag           = "v1.17.3" # https://github.com/kubernetes/kubernetes/releases
  cloud_provider_tag = "v1.17.0"
  etcd_tag           = "3.4.3"
}
