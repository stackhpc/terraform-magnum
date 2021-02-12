clusters = {
  "k8s-calico-coreos" = {
    template = "k8s-calico-coreos"
    label_overrides = {
    }
  }
  "k8s-calico-podman" = {
    template = "k8s-calico-atomic"

    label_overrides = {
      use_podman = "true"
      etcd_tag   = "v3.4.6"
    }
  }
  "k8s-calico-atomic" = {
    template = "k8s-calico-atomic"
    label_overrides = {
      kube_tag           = "v1.15.7" # https://hub.docker.com/r/openstackmagnum/kubernetes-apiserver/tags
      cloud_provider_tag = "v1.15.0" # https://hub.docker.com/r/k8scloudprovider/openstack-cloud-controller-manager/tags
      cinder_csi_enabled = "false"
    }
  }
}

kubeconfig = "k8s-calico-coreos"
