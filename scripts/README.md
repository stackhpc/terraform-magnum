# Scripts

## upload-coreos.sh

Upload the latest stable Fedora Coreos image to glance.

## upload-atomic.sh [deprecated]

Upload the last ever Fedora Atomic image to Glance.

## pull-retag-push.py

Pull retag and push list of images to a local container registry.

Usage:

    ./pull-retag-push.py -r localhost:5000 -i images.txt

    Pulling images in scripts/master.txt
    kubernetesui/dashboard:v2.0.0                               | exists locally
    openstackmagnum/cluster-autoscaler:v1.18.1                  | exists locally
    kubernetesui/metrics-scraper:v1.0.4                         | exists locally
    quay.io/coreos/etcd:v3.4.6                                  | exists locally
    rancher/hyperkube:v1.19.1-rancher1                          | exists locally
    k8scloudprovider/openstack-cloud-controller-manager:v1.18.0 | exists locally
    k8scloudprovider/k8s-keystone-auth:v1.18.0                  | exists locally
    k8s.gcr.io/hyperkube:v1.18.8                                | exists locally
    docker.io/openstackmagnum/heat-container-agent:victoria-dev | exists locally
    quay.io/calico/cni:v3.13.1                                  | exists locally
    k8scloudprovider/magnum-auto-healer:latest                  | exists locally
    coredns/coredns:1.6.6                                       | exists locally
    quay.io/calico/kube-controllers:v3.13.1                     | exists locally
    quay.io/calico/node:v3.13.1                                 | exists locally
    quay.io/prometheus/node-exporter:v0.18.1                    | exists locally
    quay.io/calico/pod2daemon-flexvol:v3.13.1                   | exists locally
    gcr.io/google_containers/pause:3.1                          | exists locally
    ---
    Pushing images in scripts/master.txt
    localhost:5000/heat-container-agent:victoria-dev            | pushed
    localhost:5000/hyperkube:v1.19.1-rancher1                   | pushed
    localhost:5000/etcd:v3.4.6                                  | pushed
    localhost:5000/cluster-autoscaler:v1.18.1                   | pushed
    localhost:5000/cni:v3.13.1                                  | pushed
    localhost:5000/dashboard:v2.0.0                             | pushed
    localhost:5000/metrics-scraper:v1.0.4                       | pushed
    localhost:5000/magnum-auto-healer:latest                    | pushed
    localhost:5000/hyperkube:v1.18.8                            | pushed
    localhost:5000/k8s-keystone-auth:v1.18.0                    | pushed
    localhost:5000/coredns:1.6.6                                | pushed
    localhost:5000/pause:3.1                                    | pushed
    localhost:5000/node-exporter:v0.18.1                        | pushed
    localhost:5000/kube-controllers:v3.13.1                     | pushed
    localhost:5000/node:v3.13.1                                 | pushed
    localhost:5000/openstack-cloud-controller-manager:v1.18.0   | pushed
    localhost:5000/pod2daemon-flexvol:v3.13.1                   | pushed
    ---
    Pulling images in scripts/worker.txt
    rancher/hyperkube:v1.19.1-rancher1                                   | exists locally
    k8s.gcr.io/hyperkube:v1.18.8                                         | exists locally
    k8scloudprovider/cinder-csi-plugin:v1.18.0                           | exists locally
    quay.io/calico/node:v3.13.1                                          | exists locally
    quay.io/calico/pod2daemon-flexvol:v3.13.1                            | exists locally
    quay.io/coreos/prometheus-operator:v0.37.0                           | exists locally
    quay.io/calico/cni:v3.13.1                                           | exists locally
    docker.io/openstackmagnum/heat-container-agent:victoria-dev          | exists locally
    quay.io/coreos/prometheus-config-reloader:v0.37.0                    | exists locally
    kiwigrid/k8s-sidecar:0.1.99                                          | exists locally
    grafana/grafana:6.6.2                                                | exists locally
    quay.io/coreos/kube-state-metrics:v1.9.4                             | exists locally
    quay.io/prometheus/prometheus:v2.15.2                                | exists locally
    quay.io/k8scsi/csi-resizer:v0.3.0                                    | exists locally
    quay.io/k8scsi/csi-provisioner:v1.4.0                                | exists locally
    quay.io/prometheus/alertmanager:v0.20.0                              | exists locally
    quay.io/k8scsi/csi-attacher:v2.0.0                                   | exists locally
    quay.io/k8scsi/csi-snapshotter:v1.2.2                                | exists locally
    squareup/ghostunnel:v1.5.2                                           | exists locally
    gcr.io/google_containers/metrics-server-amd64:v0.3.5                 | exists locally
    jettech/kube-webhook-certgen:v1.0.0                                  | exists locally
    directxman12/k8s-prometheus-adapter-amd64:v0.5.0                     | exists locally
    k8s.gcr.io/node-problem-detector:v0.6.2                              | exists locally
    quay.io/k8scsi/csi-node-driver-registrar:v1.1.0                      | exists locally
    quay.io/prometheus/node-exporter:v0.18.1                             | exists locally
    gcr.io/google_containers/pause:3.1                                   | exists locally
    k8s.gcr.io/defaultbackend:1.4                                        | exists locally
    gcr.io/google_containers/cluster-proportional-autoscaler-amd64:1.1.2 | exists locally
    quay.io/coreos/configmap-reload:v0.0.1                               | exists locally
    ---
    Pushing images in scripts/worker.txt
    localhost:5000/hyperkube:v1.19.1-rancher1                            | pushed
    localhost:5000/hyperkube:v1.18.8                                     | pushed
    localhost:5000/cinder-csi-plugin:v1.18.0                             | pushed
    localhost:5000/prometheus-config-reloader:v0.37.0                    | pushed
    localhost:5000/heat-container-agent:victoria-dev                     | pushed
    localhost:5000/prometheus-operator:v0.37.0                           | pushed
    localhost:5000/cni:v3.13.1                                           | pushed
    localhost:5000/node:v3.13.1                                          | pushed
    localhost:5000/pod2daemon-flexvol:v3.13.1                            | pushed
    localhost:5000/grafana:6.6.2                                         | pushed
    localhost:5000/kube-state-metrics:v1.9.4                             | pushed
    localhost:5000/ghostunnel:v1.5.2                                     | pushed
    localhost:5000/alertmanager:v0.20.0                                  | pushed
    localhost:5000/prometheus:v2.15.2                                    | pushed
    localhost:5000/csi-snapshotter:v1.2.2                                | pushed
    localhost:5000/csi-resizer:v0.3.0                                    | pushed
    localhost:5000/k8s-sidecar:0.1.99                                    | pushed
    localhost:5000/csi-provisioner:v1.4.0                                | pushed
    localhost:5000/csi-attacher:v2.0.0                                   | pushed
    localhost:5000/metrics-server-amd64:v0.3.5                           | pushed
    localhost:5000/k8s-prometheus-adapter-amd64:v0.5.0                   | pushed
    localhost:5000/kube-webhook-certgen:v1.0.0                           | pushed
    localhost:5000/pause:3.1                                             | pushed
    localhost:5000/cluster-proportional-autoscaler-amd64:1.1.2           | pushed
    localhost:5000/configmap-reload:v0.0.1                               | pushed
    localhost:5000/node-exporter:v0.18.1                                 | pushed
    localhost:5000/defaultbackend:1.4                                    | pushed
    localhost:5000/csi-node-driver-registrar:v1.1.0                      | pushed
    localhost:5000/node-problem-detector:v0.6.2                          | pushed
    ---
