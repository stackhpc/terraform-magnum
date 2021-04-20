external_network    = "public"
keypair_name        = "devstack"
floating_ip_enabled = "true"
cluster_labels = {
  container_infra_prefix = "harbor.cumulus.openstack.hpc.cam.ac.uk/magnum/"
}

clusters = {
  "k8s-devstack" = {
    template = "k8s-1.21.0"
    labels = {
    }
  }
}

kubeconfig = "k8s-devstack"
