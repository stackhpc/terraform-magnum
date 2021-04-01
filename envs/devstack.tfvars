external_network    = "public"
keypair_name        = "devstack"
floating_ip_enabled = "true"
cluster_labels = {
  container_infra_prefix = "harbor.cumulus.openstack.hpc.cam.ac.uk/magnum/"
}

clusters = {
  "k8s-1.20" = {
    template = "k8s-1.20.4"
    labels = {
    }
  }
}

kubeconfig = "k8s-1.20"
