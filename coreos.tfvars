cluster_template_flannel_name = "k8s-flannel-fedora-coreos"
cluster_template_calico_name = "k8s-calico-fedora-coreos"
cluster_flannel_name = "k8s-flannel-coreos"
cluster_calico_name = "k8s-calico-coreos"
image_name = "fedora-coreos-31.20200127.3.0-openstack.x86_64"
labels = {
  kube_tag                      = "v1.17.3" # https://github.com/kubernetes/kubernetes/releases
  cloud_provider_tag            = "v1.17.0"
  etcd_tag                      = "3.4.3"
}
