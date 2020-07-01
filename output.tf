output "templates" {
  value = openstack_containerinfra_clustertemplate_v1.templates
}

output "clusters" {
  value = openstack_containerinfra_cluster_v1.clusters
}
