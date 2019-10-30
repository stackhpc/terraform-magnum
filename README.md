# Autoscaling in OpenStack Magnum deployed Kubernetes

Prerequisites:
- OpenStack Queens, Magnum Stein 8.1.0 minimum
- Terraform v0.12.10, provider.openstack v1.23.0

To deploy:
- `cp terraform.tfvars{.sample,}`
- Edit `terraform.tfvars` and fit your OpenStack environment.
- Source your openstack environment variables, e.g. `source openrc.sh`
- `terraform init && terraform apply`
- Optionally attach floating ip to the master node:

    openstack server add floating ip \`openstack server list -f value -c Name | grep master-0\` 128.232.224.88

- SSH into the master node and `kubectl apply -f test-autoscale.yaml`

Sample output of `kubectl logs deploy/cluster-autoscaler -n kube-system`:

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

To attach cinder volumes:

    openstack volume create nginx-volume --size 100

    cat > nginx-cinder.yaml << END
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

    kubectl apply -f nginx-cinder.yaml

