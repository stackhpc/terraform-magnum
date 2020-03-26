# OpenStack Magnum and Terraform to deploy Kubernetes cluster

## Autoscaling

Prerequisites:

- OpenStack Queens, Magnum Stein 8.1.0 minimum
- Terraform v0.12.10, provider.openstack v1.23.0
- Kubernetes client (to be able to run `kubectl`)

Deployment:

- Initialise terraform

        terraform init --upgrade

- Copy sample variable file:

        cp terraform.tfvars{.sample,}

- Edit `terraform.tfvars` and fill in details like `external_network_id` and `keypair_name`.

- Source your OpenStack cloud environment variables:

        source openrc.sh

- To upload the latest Fedora CoreOS image:

        ./upload-coreos.sh # requires Magnum Train 9.1.0 minimum and Heat Train.
        ./upload-atomic.sh # if using older Magnum releases

- To deploy the cluster (replace with `atomic.tfvars` or `podman.tfvars` if using Magnum release older than Train 9.1.0):

        ./cluster.sh coreos.tfvars # requires Magnum Train (9.1.0) and Heat Train minimum.
        ./cluster.sh podman.tfvars # requires Magnum Train (9.1.0) and Heat Queens minimum.
        ./cluster.sh atomic.tfvars # requires Magnum Stein (8.1.0) and Heat Queens minimum.

- Optionally attach floating ip to the master node:

        openstack server add floating ip \`openstack server list -f value -c Name | grep master-0\` 128.232.224.88

- SSH into the master node:

        kubectl create deployment test-autoscale --image=nginx
        kubectl scale deployment test-autoscale --replicas=100

- Sample output of `kubectl logs deploy/cluster-autoscaler -n kube-system`:

        I1017 13:26:11.617165       1 leaderelection.go:217] attempting to acquire leader lease  kube-system/cluster-autoscaler...
        I1017 13:26:11.626499       1 leaderelection.go:227] successfully acquired lease kube-system/cluster-autoscaler
        I1017 13:26:13.804795       1 magnum_manager_heat.go:293] For stack ID 3e981ac7-4a6e-47a7-9d16-7874f5e108a0, stack name is k8s-sb7k6mtqieim
        I1017 13:26:13.974239       1 magnum_manager_heat.go:310] Found nested kube_minions stack: name k8s-sb7k6mtqieim-kube_minions-33izbolw5kvp, ID 2f7b5dff-9960-4ae2-8572-abed511d0801
        I1017 13:32:25.461803       1 scale_up.go:689] Scale-up: setting group default-worker size to 3
        I1017 13:32:28.400053       1 magnum_nodegroup.go:101] Increasing size by 1, 2->3
        I1017 13:33:02.387803       1 magnum_nodegroup.go:67] Waited for cluster UPDATE_IN_PROGRESS status
        I1017 13:36:11.528032       1 magnum_nodegroup.go:67] Waited for cluster UPDATE_COMPLETE status
        I1017 13:36:21.550679       1 scale_up.go:689] Scale-up: setting group default-worker size to 5
        I1017 13:36:24.157717       1 magnum_nodegroup.go:101] Increasing size by 2, 3->5
        I1017 13:36:58.062981       1 magnum_nodegroup.go:67] Waited for cluster UPDATE_IN_PROGRESS status
        I1017 13:40:07.134681       1 magnum_nodegroup.go:67] Waited for cluster UPDATE_COMPLETE status
        W1017 13:50:14.668777       1 reflector.go:289] k8s.io/autoscaler/cluster-autoscaler/utils/kubernetes/listers.go:190: watch of *v1.Pod ended with: too old resource version: 15787 (16414)
        I1017 14:00:17.891270       1 scale_down.go:882] Scale-down: removing empty node k8s-sb7k6mtqieim-minion-2
        I1017 14:00:17.891315       1 scale_down.go:882] Scale-down: removing empty node k8s-sb7k6mtqieim-minion-3
        I1017 14:00:17.891323       1 scale_down.go:882] Scale-down: removing empty node k8s-sb7k6mtqieim-minion-4
        I1017 14:00:23.255551       1 magnum_manager_heat.go:344] Resolved node k8s-sb7k6mtqieim-minion-2 to stack index 2
        I1017 14:00:23.255579       1 magnum_manager_heat.go:344] Resolved node k8s-sb7k6mtqieim-minion-4 to stack index 4
        I1017 14:00:23.255584       1 magnum_manager_heat.go:344] Resolved node k8s-sb7k6mtqieim-minion-3 to stack index 3
        I1017 14:00:24.283658       1 magnum_manager_heat.go:280] Waited for stack UPDATE_IN_PROGRESS status
        I1017 14:01:25.030818       1 magnum_manager_heat.go:280] Waited for stack UPDATE_COMPLETE status
        I1017 14:01:58.970490       1 magnum_nodegroup.go:67] Waited for cluster UPDATE_IN_PROGRESS status

## Cinder Volumes

In order to ensure support for cinder volumes, ensure that `volume_driver = "cinder"` in `terraform.tfvars`.

To attach cinder volumes:

    openstack volume create nginx-volume --size 100

    cat <<END | kubectl apply -f -
    apiVersion: v1
    kind: Pod
    metadata:
      name: cinder-web
    spec:
      containers:
        - name: web
          image: nginx
          volumeMounts:
            - name: html-volume
              mountPath: "/usr/share/nginx/html"
      volumes:
        - name: html-volume
          cinder:
            # Enter the volume ID below
            volumeID: `openstack volume show nginx-volume -f value -c id`
            fsType: ext4
    END

To use Cinder as the default storage class `kubectl apply -f https://raw.githubusercontent.com/stackhpc/magnum-terraform/master/manifests/sc-in-tree-cinder.yaml`:

    kind: StorageClass
    apiVersion: storage.k8s.io/v1
    metadata:
      name: cinder
      annotations:
        storageclass.kubernetes.io/is-default-class: "true"
    provisioner: kubernetes.io/cinder
    END

You can then proceed to spawn a PVC `kubectl apply -f https://raw.githubusercontent.com/stackhpc/magnum-terraform/master/manifests/nginx-in-tree-cinder.yaml`:

    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
      name: nginx
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi # pass here the size of the volume
    ---
    apiVersion: v1
    kind: Pod
    metadata:
      name: web
    spec:
      containers:
        - name: web
          image: nginx
          ports:
            - name: web
              containerPort: 80
              hostPort: 8081
              protocol: TCP
          volumeMounts:
            - mountPath: "/usr/share/nginx/html"
              name: mypd
      volumes:
        - name: mypd
          persistentVolumeClaim:
            claimName: nginx

## Helm

To use helm with tiller installed on the cluster, first of all, install `helm`:

    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

Now source `magnum-tiller.sh` to use tiller installed in the `magnum-tiller` namespace.

    source magnum-tiller.sh
    helm version

If there is a mismatch between the intalled version of helm client and tiller installed on the server, upgrade tiller.

    helm init --upgrade

NOTE: magnum currently uses Helm 2, and tiller has been deprecated in Helm 3.

## Ingress

It is then necessary to label your node of choice as an ingress node, we are going to label the one that is not a master node:

    kubectl label `kubectl get nodes -o NAME | grep -v master-0 | head -n1` role=ingress

As an example, you can now proceed to map an Ingress to a service in the same Kubernetes namespace as follows:
    
    cat <<END | kubectl apply -f -
    apiVersion: extensions/v1beta1
    kind: Ingress
    metadata:
      name: grafana-ingress
      namespace: monitoring
      annotations:
        kubernetes.io/ingress.class: "nginx"
    spec:
        rules:
          - host: "grafana.`kubectl get nodes -l role=ingress -o jsonpath={.items[*].status.addresses[?\(@.type==\"ExternalIP\"\)].address}`.nip.io"
            http:
              paths:
                - backend:
                      serviceName: prometheus-operator-grafana
                      servicePort: 80
                  path: "/"
    END

You will also need to ensure that the security group rules allow access to HTTP endpoints.

    for name in `openstack security group list -c Name -f value | grep minion`; do openstack security group rule create --ingress $name --dst-port 80 --protocol tcp; done
