external_network    = "ilab"
keypair_name        = "sriov"
master_count        = 1
node_count          = 1
fixed_network       = "p3-bdn-gw"
fixed_subnet        = "p3-bdn-gw"
master_flavor       = "general.v1.tiny"
flavor              = "general.v1.tiny"
floating_ip_enabled = true
master_lb_enabled   = false
volume_driver       = ""
insecure_registry   = "10.60.253.37"
create_timeout      = 60

template_labels = {
  container_infra_prefix  = "10.60.253.37/magnum/"
  monitoring_enabled      = "true"
  auto_scaling_enabled    = "true"
  auto_healing_enabled    = "true"
  auto_healing_controller = "magnum-auto-healer"
  magnum_auto_healer_tag  = "v1.20.0"
  ingress_controller      = "nginx"
  vnic_type               = "direct"
}

clusters = {
  "k8s-sriov" = {
    template = "k8s-sriov-1.18.16"
    labels = {
    }
  }
}
kubeconfig = "k8s-sriov"

templates = {
  "k8s-sriov-1.18.16" = {
    network_driver = "calico"
    image          = "fedora-coreos-32.20201018.3.0-openstack.x86_64"
    labels = {
      kube_tag           = "v1.18.16-rancher1" # https://github.com/kubernetes/kubernetes/releases
      cloud_provider_tag = "v1.18.0"           # https://hub.docker.com/r/k8scloudprovider/openstack-cloud-controller-manager/tags
      vnic_type          = "direct"
    }
  }
  "k8s-sriov-1.19.8" = {
    network_driver = "calico"
    image          = "fedora-coreos-32.20201018.3.0-openstack.x86_64"
    labels = {
      kube_tag           = "v1.19.8-rancher1" # https://github.com/kubernetes/kubernetes/releases
      cloud_provider_tag = "v1.19.0"          # https://hub.docker.com/r/k8scloudprovider/openstack-cloud-controller-manager/tags
      vnic_type          = "direct"
    }
  }
  "k8s-sriov-1.20.3" = {
    network_driver = "calico"
    image          = "fedora-coreos-32.20201018.3.0-openstack.x86_64"
    labels = {
      kube_tag           = "v1.20.3-rancher1" # https://github.com/kubernetes/kubernetes/releases
      cloud_provider_tag = "v1.20.0"          # https://hub.docker.com/r/k8scloudprovider/openstack-cloud-controller-manager/tags
      vnic_type          = "direct"
    }
  }
}
