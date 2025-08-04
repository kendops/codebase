# CKA Questions

 
### CKA Question 1  
Create a new pod called web-pod with image busy box
```
controlplane $  kubectl run web-pod --image=busybox --restart=Never --command -- sleep 3600
    or
controlplane $ k run web-pod --image=busybox
``` 
### CKA Question 2
Allow the pod to be able to set system_time
```    
controlplane $ kubectl run web-pod --image=busybox --restart=Never --command -- sleep 3600 
```

### CKA  Question 3
The container should sleep for 3200 seconds
```
controlplane $ kubectl run web-pod --image=busybox --restart=Never --command -- sleep 3600
```
### CKA  Question 4 (q2)
    
Q1: Create a new deployment called myproject, with image nginx:1.16
    and 1 replica. {the question want 1 image of nginx and 1 replica}

```
controlplane $ kubectl create deployment myproject --image=nginx:1.16 --replicas=1
controlplane $ kubectl get deployment.apps/myproject
```
   
Q2:Next upgrade the deployment to version 1.17 using rolling update
```
controlplane $ kubectl set image deployment.apps/myproject nginx=nginx:1.17 --record=true
controlplane $ k get deployment.apps/myproject
controlplane $ k describe deployment.apps/myproject
```
     
Q3:Make sure that the version upgrade is recorded in the resource annotation.
```    
controlplane $ kubectl set image deployment.apps/myproject nginx=nginx:1.17 --record=true
``` 
>   Explaination : set (--recored=true) for resource annotation
        Annotations: deployment.kubernetes.io/revision: 2  kubernetes.io/change-cause: kubectl set image deployment.apps/myproject nginx=nginx:1.17 --record=true
    
###  CKA  Question 5
    
Q1: Create a new deployment called my-deployment.
```
controlplane $ k create deployment my-deployment --image=nginx:1.16
controlplane $ k get deployment.apps/myproject2
```         
Q2: Scale the deployment to 3 replicas.
```    
controlplane $ kubectl scale --replicas=3 deployment.apps/my-deployment
```
> Explaination : - kubectl autoscale deployment foo --min=2 --max=10   
    If Deployment is not set replicas, the default replica will be 1.
    
Q3:Make sure desired number of pod always running.
```   
controlplane $  kubectl get pods
```
###  CKA  Question 6 (q4)
Deploy a web-nginx pod using the nginx:1.17 image with the
    labels set to tier=web-app.
```
controlplane $  kubectl run web-nginx --image=nginx:1.17 --labels="tier=web-app"
controlplane $  pod/web-nginx created 
```

###  CKA  Question 7 (q5)
Q1:Create a pod called pod-multi with two containers, Container 1 - name:container1, image:nginx

Q2:Container 2 - name:container2, image:busybox, command:sleep 4800
```
controlplane $  k run pod-multi --image:nginx
controlplane $  nano pod-multi.yaml
controlplane $  cat pod-multi.yaml
apiVersion: v1
kind: Pod
metadata:
    name: pod-multi 
spec:
containers:
- name: container1
    image: nginx  
- name: container2
  image: busybox
  command: ['sh', '-c', 'sleep 4800']

controlplane $ kubectl apply -f pod-multi.yaml
pod/pod-multi created 
controlplane $ kubectl describe pod/pod-multi
```
> To create a 2 containers use ymal file to add 2nd containers
 
###  CKA  Question 8 (q7)
Q: Create a pod called test-pod in "custom" namespace belonging to the test environment (env=test) and backend tier (tier=backend). image: nginx:1.17
```
controlplane $ kubectl get ns
controlplane $ k create namespace custom || k create ns custom
controlplane $ k run test-pod --image=nginx:1.17 --namespace=custom --labels=env=test,tier=backend
```
OR 
```
controlplane $ k get ns 
controlplane $ k create ns custom
controlplane $ k run test-pod --image=nginx:1.17 --namespace=custom --labels="env=test,tier=backend"
controlplane $ k get describe test-pod -n custom
controlplane $ k get pod test-pod -n custom
```
###  CKA  Question 9 (q8)
Get the node01 in JSON format and store it in a file at /node-info.json
```
controlplane $ kubectl get node node01 -o json > /node-info.json
controlplane $ cat /node-info.json
```
###  CKA  Question 10 (q9)
Use JSON PATH query to retrieve the osimages of all the nodes and store it in a file "allnodes-os-info.txt" at root location.
    Note: The osimage are under the nodeinfo section under status of each node.
```
controlplane $ kubectl get nodes -o jsonpath="{.items[*].status.nodeInfo.osImage}"
    Ubuntu 20.04.5 LTS Ubuntu 20.04.5 LTScontrolplane $ 
controlplane $ kubectl get nodes -o jsonpath="{.items[*].status.nodeInfo.osImage}" > /allnodes-os.info.txt
controlplane $ ls -l / 
controlplane $ cat /allnodes-os-info.txt
```
### CKA   Question 11 (q10)
Schedule a pod as follows:

∞ Name: nginx-kusc00401 co Image: nginx

∞ Node selector:
```
controlplane $ nano pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: ngincx-kusc00401
spec:
  containers:
    - name: nginx
      image: nginx
  nodeSelector:
    disk: ssd 
controlplane $ kubectl apply -f pod.ymal
controlplane $ kubectl get pods 
controlplane $ kubectl label node node01 disk=ssd //label node then pods will run
controlplane $ kubectl get pods //to get pods
controlplane $ kubectl get pods -o wide //display run on node01
controlplane $ k get nodes --show-labels

```

###  CKA  Question 12
Break the kube scheduler and scheduler a pod using NodeName. Fix the kube scheduler and schedule a pod using NodeSelector
```
controlplane $ nano /etc/kubernetes/manifests/kube-scheduler.yaml
----
spec:
  containers:
  - command:
    - kube-scheduler
    - --authentication-kubeconfig=/etc/kubernetes/scheduler.conf

    ///change to 

    - --authentication-kubeconfig=/etc/kubernetes/scheduler1.conf
----
```
```
apiVersion: v1
kind: Pod
metadata:
  name: manual-pod
  namespace: kube-system
spec:
  containers:
  - name: nginx
    image: nginx
  nodeName: <node-name>
```
```
controlplane $ k get pods --namespace kube-system
controlplane $ ls -l /etc/kubernetes/manifests //display to see 
//////missing breke the kube scheduler
controlplane $  nano 12.yaml

```
```
controlplane $ nano 12.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```
```
controlplane $ k apply -f 12.yaml
pod/nginx12 created
controlplane $ k get pods -o wide
NAME      READY   STATUS    RESTARTS   AGE   IP            NODE           NOMINATED NODE   READINESS GATES
nginx12   1/1     Running   0          18s   192.168.0.4   controlplane   <none>           <none>
controlplane $ cat 12.yaml

```
```
controlplane $ k get pods --namespace kube-system
NAME                                      READY   STATUS    RESTARTS      AGE
calico-kube-controllers-94fb6bc47-wr56s   1/1     Running   2 (52m ago)   11d
canal-cgrhr                               2/2     Running   2 (52m ago)   11d
canal-jb5rr                               2/2     Running   2 (52m ago)   11d
coredns-57888bfdc7-895dj                  1/1     Running   1 (52m ago)   11d
coredns-57888bfdc7-9rjt5                  1/1     Running   1 (52m ago)   11d
etcd-controlplane                         1/1     Running   2 (52m ago)   11d
kube-apiserver-controlplane               1/1     Running   2 (52m ago)   11d
kube-controller-manager-controlplane      1/1     Running   2 (52m ago)   11d
kube-proxy-5xtp7                          1/1     Running   1 (52m ago)   11d
kube-proxy-bt2pv                          1/1     Running   2 (52m ago)   11d
kube-scheduler-controlplane               1/1     Running   2 (52m ago)   11d
controlplane $ ls -l
total 8
-rw-r--r-- 1 root root  136 Dec 17 13:56 12.yaml
lrwxrwxrwx 1 root root    1 Dec  6 09:07 filesystem -> /
drwx------ 3 root root 4096 Dec  6 09:12 snap
controlplane $ nano 10.yaml
controlplane $ k apply -f 10.yaml
pod/nginx-12-1 created
controlplane $ k get pods
NAME         READY   STATUS    RESTARTS   AGE
nginx-12-1   0/1     Pending   0          13s
nginx12      1/1     Running   0          6m21s
controlplane $ k get node --show-labels
NAME           STATUS   ROLES           AGE   VERSION   LABELS
controlplane   Ready    control-plane   11d   v1.31.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=controlplane,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
node01         Ready    <none>          11d   v1.31.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=node01,kubernetes.io/os=linux
controlplane $ cat 10.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-12-1
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
    app: backend
controlplane $ 
```

###  CKA  Question 13
Create a NodePort service to expose the deployment named nginx-deployment on the port-80 with the NodePort range between 30000 and 32767
```
controlplane $ kubectl create deployment nginx-deployment --image=nginx --port=3000
controlplane $ kubectl get deployment nginx-deployment
controlplane $ kubectl expose deployment nginx-deployment --type=NodePort --port=80 --target-port=3000 --name=nginx-deploy-svc 
controlplane $ kubectl describe service/deployment-svc
controlplane $ kubectl get pods 
controlplane $ kubectl describe pod nginx-deployment
```
> this will shows the ipaddress and endpoints ip:80 port80



###  CKA  Question 14
Create a NodePort service to expose a pod named my-pod on
port 8080, with the NodePort set to 30080.
```
controlplane $ k run my-pod --image=nginx
pod/my-pod created
controlplane $ k get pod/my-pod
NAME     READY   STATUS    RESTARTS   AGE
my-pod   1/1     Running   0          19s
controlplane $ k describe  pod/my-pod | grep IP
                  cni.projectcalico.org/podIP: 192.168.1.5/32
                  cni.projectcalico.org/podIPs: 192.168.1.5/32
IP:               192.168.1.5
IPs:
  IP:  192.168.1.5
controlplane $ k expose pod/my-pod --type=NodePort --port=8080 --target-port=8000 --name=pod-svc --dry-run=client -o yaml > 14.yaml
controlplane $ nano 14.yaml
controlplane $ cat pod/my-pod
cat: pod/my-pod: No such file or directory
controlplane $ cat 14.yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    run: my-pod
  name: pod-svc
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8000
    nodePort: 30080
  selector:
    run: my-pod
  type: NodePort
status:
  loadBalancer: {}
controlplane $ k apply -f 14.yaml
service/pod-svc created
controlplane $ k describe service/pod-svc
Name:                     pod-svc
Namespace:                default
Labels:                   run=my-pod
Annotations:              <none>
Selector:                 run=my-pod
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.100.75.105
IPs:                      10.100.75.105
Port:                     <unset>  8080/TCP
TargetPort:               8000/TCP
NodePort:                 <unset>  30080/TCP
Endpoints:                192.168.1.5:8000
Session Affinity:         None
External Traffic Policy:  Cluster
Internal Traffic Policy:  Cluster
Events:                   <none>
controlplane $ k get pod/my-pod -o wide 
NAME     READY   STATUS    RESTARTS   AGE     IP            NODE     NOMINATED NODE   READINESS GATES
my-pod   1/1     Running   0          9m50s   192.168.1.5   node01   <none>           <none>
controlplane $ 
```


###  CKA  Question 15
Create a nginx pod called dns-resolver using image nginx expose it internally with a service called dns-resolver-service. Check if pod and service name are resolvable from within the cluster use the image:busybox:1.28 for nslookup save the result in /newroot/busy.svc
```
kubectl run dns-resolver --image=nginx --port=3000
kubectl get pods dns-resolver --show-labels
kubectl expose pod dns-resolver --port=80 --target-port=3000 --name=dns-resolver-service
kubectl get services dns-resolver-service
kubectl run busybox --image=busybox:1.28 --rm -i -t --restart=Never -- nslookup dns-resolver-service > /root/nginx.svc
controlplane $ ls -l
total 8
lrwxrwxrwx 1 root root    1 Dec  6 09:07 filesystem -> /
-rw-r--r-- 1 root root  209 Dec 26 14:22 nginx.svc
drwx------ 3 root root 4096 Dec  6 09:12 snap
controlplane $ cat nginx.svc
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      dns-resolver-service
Address 1: 10.111.51.79 dns-resolver-service.default.svc.cluster.local
pod "busybox" deleted
controlplane $ 

```

###  CKA  Question 16
Create a PersistantVolume with the given specification. Volume Name: pv-demo Storage:100Mi Access modes:ReadWriteMany HostPath:/pv/host-data

```
controlplane $ nano 16.yaml
controlplane $ cat 16.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-demo
  labels:
    app: pv-demo
spec:
  capacity:
    storage: 100Mi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  hostPath:
    path: /pv/host-data
controlplane $ kubectl apply -f 16.yaml
persistentvolume/pv-demo created
controlplane $ kubectl get persistentvolume/pv-demo
NAME      CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pv-demo   100Mi      RWX            Retain           Available                          <unset>                          95s
controlplane $ 
```


###  CKA   Question 17
Create a new PersistentVolume named safari-pv. It should have a capacity of 2Gi, accessMode ReadWriteOnce, hostPath /Volumes/Data and no storageClassName defined.

Next create a new PErsistentVolumeClaim in Namespace project-tiger named safari-pvc. It should request 2Gi storage, accessMode ReadWriteOnce and should not define a storageClassName. The PVC should bound to the PV correctly.

Finally create a new pod safari in Namespace project-tiger which mounts that volume at /tmp/safari-data. Image should be of image http:2.4.41-alpine

```
Create PersistentVolume
- Name safari-pv
- capacity of 2Gi
- accessMode ReadWriteOnce
- hostPath /Volumes/Data and 
- no storageClassName defined 


controlplane $ nano 17.yaml

controlplane $ cat 17.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: safari-pv
  labels: 
    app: safari-pv
spec:
  capacity:
    storage: 2Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /Volumes/Data
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: "" 

controlplane $ kubectl apply -f 17.yaml
Warning: spec.persistentVolumeReclaimPolicy: The Recycle reclaim policy is deprecated. Instead, the recommended approach is to use dynamic provisioning.
persistentvolume/safari-pv created

controlplane $ k get persistentvolume/safari-pv
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
safari-pv   2Gi        RWO            Recycle          Available                          <unset>                          32s
controlplane $

--------------------------------------------------------
Create a PersistentVolumeClaim
- Namespace project-tiger named safari-pvc
- 2Gi
- accessMode ReadWriteOnce
- not define a storageClassName


controlplane $ nano pvc.yaml
controlplane $ cat.pvc.yaml
cat.pvc.yaml: command not found
controlplane $ cat pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: safari-pvc
  namespace: project-tiger
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 2Gi
  storageClassName: ""
controlplane $ k get ns
NAME                 STATUS   AGE
default              Active   18d
kube-node-lease      Active   18d
kube-public          Active   18d
kube-system          Active   18d
local-path-storage   Active   18d
controlplane $ k create ns project-tiger
namespace/project-tiger created
controlplane $ k apply -f pvc.yaml
persistentvolumeclaim/safari-pvc created
controlplane $ k get persistentvolume/safari-pv
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                      STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
safari-pv   2Gi        RWO            Recycle          Bound    project-tiger/safari-pvc                  <unset>                          8m36s
controlplane $ k get persistentvolumeclaim/safari-pvc
Error from server (NotFound): persistentvolumeclaims "safari-pvc" not found
controlplane $ k get persistentvolumeclaim/safari-pvc -n project-tiger
NAME         STATUS   VOLUME      CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
safari-pvc   Bound    safari-pv   2Gi        RWO                           <unset>                 2m1s
controlplane $ k get pvc -ns project-tiger
Error from server (NotFound): namespaces "s" not found
controlplane $ k get pvc ns project-tiger
Error from server (NotFound): persistentvolumeclaims "ns" not found
Error from server (NotFound): persistentvolumeclaims "project-tiger" not found
controlplane $ k get persistentvolumeclaim/safari-pvc -n project-tiger
NAME         STATUS   VOLUME      CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
safari-pvc   Bound    safari-pv   2Gi        RWO                           <unset>                 12m
controlplane $ 

--------------------------------------------------------------
Finally create a new pod safari in Namespace project-tiger which mounts that volume at /tmp/safari-data. Image should be of image http:2.4.41-alpine
- volume /tmp/safari-data
- image http:2.4.41-alpine

controlplane $ nano pod.yaml
controlplane $ cat pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: safari
  namespace: project-tiger
spec:
  containers:
    - name: container1
      image: httpd:2.4.41-alpine
      volumeMounts:
      - mountPath: "/tmp/safari-data"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: safari-pvc
controlplane $ k apply -f pod.yaml              
pod/safari created
controlplane $ k get pod/safari -n project-tiger
NAME     READY   STATUS              RESTARTS   AGE
safari   0/1     ContainerCreating   0          3s
controlplane $ k describe pod/safari -n project-tiger
Name:             safari
Namespace:        project-tiger
Priority:         0
Service Account:  default
Node:             node01/172.30.2.2
Start Time:       Tue, 24 Dec 2024 13:44:04 +0000
Labels:           <none>
Annotations:      cni.projectcalico.org/containerID: c30fd15c159ef24b40569b3021a2fc64b01562a88eacb6cab579a205d25a920a
                  cni.projectcalico.org/podIP: 192.168.1.5/32
                  cni.projectcalico.org/podIPs: 192.168.1.5/32
Status:           Running
IP:               192.168.1.5
IPs:
  IP:  192.168.1.5
Containers:
  container1:
    Container ID:   containerd://31e1a2eeb4a4cf36a9f966e8fe740ba45916703a6e74f6c4a861408a16ff6ac4
    Image:          httpd:2.4.41-alpine
    Image ID:       docker.io/library/httpd@sha256:06ad90574c3a152ca91ba9417bb7a8f8b5757b44d232be12037d877e9f8f68ed
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Tue, 24 Dec 2024 13:44:13 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /tmp/safari-data from mypd (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-2bzbv (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  mypd:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  safari-pvc
    ReadOnly:   false
  kube-api-access-2bzbv:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  42s   default-scheduler  Successfully assigned project-tiger/safari to node01
  Normal  Pulling    42s   kubelet            Pulling image "httpd:2.4.41-alpine"
  Normal  Pulled     34s   kubelet            Successfully pulled image "httpd:2.4.41-alpine" in 8.619s (8.619s including waiting). Image size: 33292168 bytes.
  Normal  Created    34s   kubelet            Created container container1
  Normal  Started    34s   kubelet            Started container container1
controlplane $ 

```

### CKA Question 18

Create a new PersistentVolumeClaim:
- Name: pv-volume
- Class: csi-hostpath-sc
- Capacity: 10Mi

Create a new Pod which mounts the PersistentVolumeClaim as a volume:
- Name: web-server
- Image: nginx
- Mount path: /usr/share/nginx/html

Configure the new Pod to have ReadWriteOnce access on the volume
```

controlplane $ nano pvc.yaml

controlplane $ cat pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pv-volume
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 10Gi
  storageClassName: csi-hostpath-sc

controlplane $ k apply -f pvc.yaml
persistentvolumeclaim/pv-volume created


--------------------



controlplane $ nano pod.yaml

controlplane $ cat pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-server
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/usr/share/nginx/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim

controlplane $ k apply -f pod.yaml

----------------------

controlplane $ nano pv.yaml

controlplane $ cat pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-volume
  labels: 
    app: pv-volume
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /Volumes/Data
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: csi-hostpaht-sc 

controlplane $ 
```

### CKA Question 19

Upgrade the Cluster (Master node) to latest version. Make sure to first drain Node and make it available after upgrade.

Note: Kubernetes will then automatically reschedule the pods on the upgraded nodes, ensureing that the workloads are running on the latest version of Kubernetes.

check note kubeadm-upgrade
```
k get nodes ||check version

controlplane $ k drain controlplane --ignore-daemonsets || drain the controlplane and controlplane cordoned 
node/controlplane cordoned

k get nodes || shows the sheduling disabled

controlplane $ apt update

controlplane $ apt-cache madison kubeadm || its tell which version can be upgrade to 

controlplane $ apt-get install kubeadm=1.31.5-1.1 kubelet=1.31.5-1.1 kubectl=1.31.5-1.1  || use the latest version like stated on the question. 

controlplane $ kubeadm version || check kubeadm version

controlplane $ kubeadm upgrade plan ||check cluster if can be upgrade or not. 

kubeadm upgrade apply v1.31.5 ||upgrade this will take like up to 5mins to update until success || need to set command y = yes

controlplane $ systemctl daemon-reload

controlplane $ systemctl restart kubelet
k get nodes

controlplane $ k uncordon controlplane
node/controlplane uncordoned

controlplane $ k get nodes
```

### CKA Question 20

There is a pod running in node my-pod Take a backup of the pod ETCD database on /root/etcd-backup.db and then delete the pod and restore the backup pod /var/lib/etcdbackup and check the file etcd backup in /var/lib pod must be running.

```
controlplane $ k run my-pod --image=nginx

controlplane $ k get pods

controlplane $ cat /etc/kubernetes/manifests/etcd.yaml || use this file to get the trusted-ca-file, cert-file and key-file insert into the snapshot using etcdctl like code below

ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save /root/etcd-backup.db > backup.txt 2>&1 ||save the snapshot on etcd-backup.db 
 

ETCDCTL_API=3 etcdctl --write-out=table snapshot status /root/etcd-backup.db || use to verifying a snapshot.

kubectl delete pod/my-pod
 
ETCDCTL_API=3 etcdctl --data-dir /var/lib/etcdbackup snapshot restore /root/etcd-backup.db

nano /etc/kubernetes/manifests/etcd.yaml
k get pod/my-pod


```

### CKA Question 21

Create a  taint on node01 that not allowed any new pod schedule on node node01 is the name of the node you want to taint. key=value is the key-value pair for the taint. In this case use key=node-restriction and value=true. Run a pod pod1 with image=nginx that use the toleration. Make sure pod is running.

```
controlplane $ kubectl describe node node01 || just to show the taints in <none>

controlplane $ kubectl taint nodes node01 node-restriction=true:NoSchedule

controlplane $ kubectl describe node node01 || this shows Taints: node-restriction=true:NoSchedule

For toleration need to use declarative , no imparative can be use . means use yaml file

controlplane $ nano 21.yaml   

controlplane $ cat 21.yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod1
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  tolerations:
  - key: "node-restriction"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"

controlplane $ kubectl apply -f 21.yaml
pod/pod1 created

controlplane $ k get pod/pod1
NAME   READY   STATUS              RESTARTS   AGE
pod1   0/1     ContainerCreating   0          7s

controlplane $ k get pod/pod1
NAME   READY   STATUS    RESTARTS   AGE
pod1   1/1     Running   0          18s

controlplane $ k get pod/pod1 -o wide
NAME   READY   STATUS    RESTARTS   AGE   IP            NODE     NOMINATED NODE   READINESS GATES
pod1   1/1     Running   0          30s   192.168.1.4   node01   <none>           <none>
controlplane $ 


end solution for question 21
```

this is if using key on controlplane taints. If the node (controlplane) have been taints, it will use node node01 because controlplane has taints to NoSchedule
```
controlplane $ nano 2.yaml
controlplane $ kubectl apply -f 2.yaml
pod/pod2 created
controlplane $ cat 2.yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod2
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  tolerations:
  - key: "node-role.kubernetes.io/control-plane"
    operator: "Exists"
    effect: "NoSchedule"
controlplane $ k get pod/pod2
NAME   READY   STATUS    RESTARTS   AGE
pod2   1/1     Running   0          15s
controlplane $ k get pod/pod2 -o wide
NAME   READY   STATUS    RESTARTS   AGE   IP            NODE           NOMINATED NODE   READINESS GATES
pod2   1/1     Running   0          33s   192.168.0.4   controlplane   <none>           <none>
controlplane $ 
```

### CKA Question 22

Taint the worker node to be Unschedulable. Once done, create a pod called dev-redis, image redis:alpine to ensure workloads are not schedule to this worker node Finally , create a new pod called prod-redis and image redis:alpine with toleration to be scheduled on node01.

```
kubectl taint nodes node1 key1=value1:NoSchedule

controlplane $ kubectl taint nodes node01 key1=value1:NoSchedule
node/node01 tainted

controlplane $ kubectl run dev-redis --image=redis:alpine
pod/dev-redis created

controlplane $ k get pod/dev-redis
NAME        READY   STATUS    RESTARTS   AGE
dev-redis   0/1     Pending   0          9s

controlplane $ k get pod/dev-redis
NAME        READY   STATUS    RESTARTS   AGE
dev-redis   0/1     Pending   0          57s
controlplane $ 

controlplane $ nano 22.yaml

controlplane $ cat 22.yaml
apiVersion: v1
kind: Pod
metadata:
  name: prod-redis
  labels:
    env: test
spec:
  containers:
  - name: redis
    image: redis:alpine
    imagePullPolicy: IfNotPresent
  tolerations:
  - key: "key1"
    operator: "Equal"
    value: "value1"
    effect: "NoSchedule"
             
controlplane $ kubectl apply -f 22.yaml
pod/prod-redis created

controlplane $ k get pod/prod-redis -o wide
NAME         READY   STATUS    RESTARTS   AGE   IP            NODE     NOMINATED NODE   READINESS GATES
prod-redis   1/1     Running   0          14s   192.168.1.4   node01   <none>           <none>

controlplane $ 



```
### CKA Question 23

Create a pod name web-app in the default namespace with the following specifications:

1. The pod should have a single container using the nginx image.
2. Use Node Affinity to ensure that the pod is scheduled on a node labeled with disktype=ssd

### CKA Question 24

Create a pod named db-pod in the default namespace with the following specifications: The pod should have a single container using the nginx image.

Use Node Affinity to ensure the pod prefers to be scheduled on nodes labeled with storage=fast, but it can still run on other nodes if no nodes with this label are available

```

```

### CKA Question 25
You are tasked with creating a Pod named frontend-pod in the default namespace. The Pod should meet the following requirements:

The Pod should have a single container using the nginx image.
The Pod must only be scheduled on nodes labeled with environment=production (this is a hard requirement).

Additionally, the Pod should prefer to be scheduled on nodes labeled with
hardware-high-performance, but it can still run on other nodes if none are available with this label.

```
controlplane $ nano 25.yaml

controlplane $ cat 25.yaml
apiVersion: v1
kind: Pod
metadata:
  name: frontend-pod
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: environment
            operator: In
            values:
            - production
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 10
        preference:
          matchExpressions:
          - key: hardware
            operator: In
            values:
            - high-performance
  containers:
  - name: nginx
    image: nginx

controlplane $ kubectl apply -f 25.yaml
pod/frontend-pod created

controlplane $ k get pod/frontend-pod
NAME           READY   STATUS    RESTARTS   AGE
frontend-pod   0/1     Pending   0          10s

controlplane $ kubectl label nodes node01 environment=production   
node/node01 labeled

controlplane $ k get pod/frontend-pod
NAME           READY   STATUS    RESTARTS   AGE
frontend-pod   1/1     Running   0          2m42s

controlplane $ kubectl label nodes node01 hardware=high-performance
node/node01 labeled
controlplane $ 
```

### CKA Question 26

You are tasked with creating two Pods, high-priority-pod and low-priority-pod, in the default namespace. The Pods should meet the following requirements:

Both Pods must be scheduled on nodes labeled with zone=east (this is a hard requirement).
The high-priority-pod should have a higher preference for nodes labeled with performance=high, and the scheduler should give it priority when deciding where to place it.
The low-priority-pod should have a lower preference for nodes labeled with performance=high, meaning it will only be placed after the high-priority-pod, assuming both Pods target nodes with the same labels.

Both Pods should have a single container using the nginx

```
controlplane $ nano hp.yaml

controlplane $ cat hp.yaml
apiVersion: v1
kind: Pod
metadata:
  name: high-priority-pod
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: zone
            operator: In
            values:
            - east
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 90
        preference:
          matchExpressions:
          - key: performance
            operator: In
            values:
            - high
  containers:
  - name: nginx
    image: nginx

controlplane $ cp hp.yaml lp.yaml

controlplane $ nano lp.yaml

controlplane $ cat lp.yaml
apiVersion: v1
kind: Pod
metadata:
  name: low-priority-pod
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: zone
            operator: In
            values:
            - east
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 20
        preference:
          matchExpressions:
          - key: performance
            operator: In
            values:
            - high
  containers:
  - name: nginx
    image: nginx

controlplane $ k apply -f hp.yaml
pod/high-priority-pod created
controlplane $ k apply -f lp.yaml
pod/low-priority-pod created
controlplane $ kubectl get pods
NAME                READY   STATUS    RESTARTS   AGE 
high-priority-pod   0/1     Pending   0          27s
low-priority-pod    0/1     Pending   0          18s 
controlplane $ 

|| pending pod sb belum letak label, if letak label terus the status will be running , label do after just to shows the pending state

controlplane $ k label nodes node01 zone=east performance=high
node/node01 labeled

controlplane $ k get pods -o wide
NAME                READY   STATUS    RESTARTS   AGE    IP            NODE     NOMINATED NODE   READINESS GATES 
high-priority-pod   1/1     Running   0          118s   192.168.1.6   node01   <none>           <none>
low-priority-pod    1/1     Running   0          109s   192.168.1.7   node01   <none>           <none> 

controlplane $ k get nodes node01 --show-labels
NAME     STATUS   ROLES    AGE    VERSION   LABELS
node01   Ready    <none>   5d4h   v1.31.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,environment=production,hardware=high-performance,kubernetes.io/arch=amd64,kubernetes.io/hostname=node01,kubernetes.io/os=linux,performance=high,zone=east
controlplane $ 

//completed
```

### CKA Question 27
Create a CronJob named show-date that runs every minute and executes the shell command echo "Current date: $(date)" Watch the jobs as they are being scheduled Identify one of the Pods that ran the CronJob and render the logs Determine the number of successful executions the

Cronjob will keep in its history.

Delete the job

```
||use busybox for cronjob, because after the executions, pod will be die.

controlplane $ kubectl create cronjob show-date --image=busybox:1.28   --schedule="*/1 * * * *" -- /bin/sh -c  'echo "Current date: $(date)"'

controlplane $ kubectl get job.batch --watch ||watch the job that being scheduled

^Ccontrolplane $

controlplane $ kubectl get pods   
NAME                       READY   STATUS      RESTARTS   AGE
show-date-28939046-qvsxb   0/1     Completed   0          2m44s
show-date-28939047-j2f8h   0/1     Completed   0          104s
show-date-28939048-qhrrp   0/1     Completed   0          44s

controlplane $ kubectl logs show-date-28939048-qhrrp  || render the logs
Current date: Wed Jan  8 13:28:00 UTC 2025
controlplane $ 

controlplane $ kubectl get cronjobs.batch/show-date -o wide
NAME        SCHEDULE      TIMEZONE   SUSPEND   ACTIVE   LAST SCHEDULE   AGE   CONTAINERS   IMAGES         SELECTOR
show-date   */1 * * * *   <none>     False     0        45s             11m   show-date    busybox:1.28   <none>

kubectl get cronjob show-date -o yaml || to open the yaml file

controlplane $ k delete cronjobs.batch/show-date || delete the job


```

### CKA Question 28
You have access to multiple clusters from your main terminal through kubectl contexts. Write all those context names into /opt/course/1/contexts

Next write a command to display the current context into
/opt/newcourse/1/context_default_kubectl.sh, the command should use kubectl.

Finally write a second command doing the same thing into /opt/newcourse/2/context_default_no_kubectl.sh, but without the use of kubectl

```
new ans:

controlplane $ mkdir -p /opt/course/1/
controlplane $ k config get-contexts -o name > /opt/course/1/contexts
controlplane $ cat /opt/course/1/contexts
kubernetes-admin@kubernetes
controlplane $ mkdir -p /opt/course/1/contexts
mkdir: cannot create directory '/opt/course/1/contexts': File exists
controlplane $ mkdir -p /opt/course/2         
controlplane $ k config current-context > otp/course/2/context_default_kubectl.sh
bash: otp/course/2/context_default_kubectl.sh: No such file or directory
controlplane $ cat /opt/course/2/context_default_kubectl.sh
cat: /opt/course/2/context_default_kubectl.sh: No such file or directory
controlplane $ mkdir -p /opt/newcourse/2/
controlplane $ cat ~/.kube/config | grep current-context > /opt/newcourse/2/context_default_kubectl.sh
controlplane $ cat /opt/newcourse/2/context_default_kubectl.sh
current-context: kubernetes-admin@kubernetes
controlplane $ 

```


### CKA Question 29

Create a pod output-pod which write "You will passed CKA EXAM!" into a file "output-pod.txt" . The Pod output-pod should be deleted automatically after writing the text to the file. 

```
controlplane $ kubectl run output-pod --image=busybox --restart=Never --rm -it --command -- echo "You will pass the CKA Exam!" > output-pod.txt

or 

controlplane $ k run output-pod --image=busybox --restart=Never --attach --rm -- echo "You will pass the CKA Exam!" > output-pod.txt
```

### CKA Question 30

Create a new user "sam". Grant him access to the cluster.User "sam" should have permission to create, list, get, update, and delete pods. The private key exists at location:

sam.key and csr at sam.csr

[documents links](https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/)
```
new answer:

controlplane $ openssl genrsa -out sam.key 2048
controlplane $ openssl req -new -key sam.key -out sam.csr -subj "/CN=sam"
controlplane $ cat sam.csr | base64 | tr -d "\n"
controlplane $ nano sam.yaml  
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: myuser
spec:
  request: <copy paste cat sam.csr>
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth

controlplane $ k apply -f sam.yaml
controlplane $ k get csr
controlplane $ k certificate approve sam
certificatesigningrequest.certificates.k8s.io/sam approved

controlplane $ kubectl get csr sam -o jsonpath='{.status.certificate}'| base64 -d > sam.crt

controlplane $ kubectl create role developer --verb=create --verb=get --verb=list --verb=update --verb=delete --resource=pods

controlplane $ kubectl create rolebinding developer-binding-sam --role=developer --user=sam ||pair role and user

||add to kubeconfig
controlplane $ kubectl config set-credentials sam --client-key=sam.key --client-certificate=sam.crt --embed-certs=true
User "sam" set. ||But not ins the context yet

controlplane $ kubectl config get-contexts || sam is not there yet

controlplane $ kubectl config set-context sam --cluster=kubernetes --user=sam
Context "sam" created.

controlplane $ kubectl config use-context sam   
Switched to context "sam".
```


### CKA Config Maps
Config Maps is an API object used to store non-confidential data in key-value paiars. Pods can consume ConfigMaps as environment, variables, command-line arguments, or as configureation files in a volume, only store the raw data and not a sensitive data.

Pods refers to a ConfigMap must be in the same namespace

Create ConfigMaps from files
You can use kubectl create configmap to create a ConfigMap from an individual file, or from multiple files.

Create ConfigMaps from files or Generate ConfigMaps from literals

controlplane $ k delete cm 132-cmm
controlplane $ k get cm

### CKA Question 31
Create a config named redis-config.

Within the ConfigMap, use the key maxmemory with value 2mb and key maxmemory-policy with value allkeys-lru


```
||if you want to use key=value need to use --from-literal
kubectl create configmap redis-config --from-literal=maxmemory=2mb --from-literal=maxmemory-policy=allkeys-lru
kubectl get configmap/redis-config -o yaml
```


### CKA Question 32
Create a configmap named q32-cm (configmap or cm) that define the variable my=user=mypassword. 

Create a pod named q32pod that runs nginx, and uses the variable from step 1.
```
||using yaml file
controlplane $ nano 32cm.yaml
controlplane $ cat 32cm.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: q32-cm
  namespace: default
data:
  myuser: mypassword
controlplane $ 

||using command line
controlplane $ k get configmap/q32-cmm -o yaml
apiVersion: v1
data:
  myuser: mypassword
kind: ConfigMap
metadata:
  creationTimestamp: "2025-01-13T13:36:03Z"
  name: q32-cmm
  namespace: default
  resourceVersion: "4875"
  uid: 1ea90f68-c3dd-4fc1-b194-24d60c38ea4e
controlplane $ 

||create pod named q32pod

k get pod/q32pod
nano 31-pd.yaml
apiVersion: v1
kind: Pod
metadata:
  name: q32pod
spec:
  containers:
    - name: container-app
      image: nginx
      envFrom:
      - configMapRef:
          name: q32-cm
  restartPolicy: Never
k exec -it q32pod -- env
k get cm q32-cm -o yaml


|| create pod using dry run
kubectl run q32pod --image=nginx --dry-run=client -o yaml > q32.yaml
nano q32.yaml
cat q32.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: q32pod
  name: q32pod
spec:
  containers:
  - image: nginx
    name: q32pod
    resources: {}
    envForm:
    - configMapRef:
      name: q32-cm
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}


k apply -f q32.yaml
k get pod/q32pod
k exec -it q32pod --env

```

### CKA Question 33
create a Pod named mypod that uses a ConfigMap to provide configuratuon files mounted at /etc/data

```
||create configmap
nano sys.config
cat sys.config
OS=Window_NT
kubectl create configmap myconfig --from-file=sys.config
configmap/myconfig created
k get configmap/myconfig -o yaml
k describe cm myconfig

||create a pod mypods
||can use dry run like
kubectl run mypod --image=nginx --dry-run=client -o yaml > q33.yaml
nano q33.yaml

controlplane $ nano 1.yaml
controlplane $ cat 1.yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: test-container
      image: nginx
      volumeMounts:
      - name: config-volume
        mountPath: /etc/data
  volumes:
    - name: config-volume
      configMap:
        name: myconfig
  restartPolicy: Never
controlplane $ k apply -f 1.yaml
pod/mypod created
controlplane $ k describe pod/mypod

kubectl get pod/mypod
kubectl exec -it mypod --env || this yaml file for this pod is not declaring as a we declaring it as a volumemount

kubectl exec -it mypod -- ls /etc/data

```

### CKA Question 34

Create a Secret named my-secret with the following data:

username: admin
password: admin12345

Create a Pod named secret-pod that uses all the key-value pairs from the Secret my-secret as environment variables.

```
controlplane $ kubectl create secret generic my-secret --from-literal=username=admin
 --from-literal=password=admin12345 
secret/my-secret created

controlplane $ k describe secret/my-secret
Name:         my-secret
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
password:  10 bytes
username:  5 bytes

controlplane $ nano 34.yaml

controlplane $ cat 34.yaml
apiVersion: v1
kind: Pod 
metadata:
  name: secret-pod
spec:
  containers:
  - name: envars-test-container
    image: nginx
    envFrom:
    - secretRef:
        name: my-secret

controlplane $ k apply -f 34.yaml
pod/secret-pod created

controlplane $ k get pod/secret-pod
NAME         READY   STATUS    RESTARTS   AGE
secret-pod   1/1     Running   0          14s

controlplane $ k exec -it secret-pod -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=secret-pod
NGINX_VERSION=1.27.3
NJS_VERSION=0.8.7
NJS_RELEASE=1~bookworm
PKG_RELEASE=1~bookworm
DYNPKG_RELEASE=1~bookworm
username=admin
password=admin12345
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
TERM=xterm
HOME=/root
```

### CKA Question 35

Create a Secret named app-secret with the following data:

username: sam
password: sam123

Create a Pod named secret-volume-pod that mounts the app-secret as a volume at the path /etc/secret-data inside the container.

```
k create secret generic app-secret --from-literal=username=sam --from-literal=password=sam123

k describe secret/app-secret
Name:         app-secret
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
password:  6 bytes
username:  3 bytes

controlplane $ k get secret/app-secret -o yaml
apiVersion: v1
data:
  password: c2FtMTIz
  username: c2Ft
kind: Secret
metadata:
  creationTimestamp: "2025-01-14T13:43:20Z"
  name: app-secret
  namespace: default
  resourceVersion: "5830"
  uid: e8920ac0-8561-4dc3-99e3-664973b2efd9
type: Opaque

||Create pod
controlplane $ kubectl run secret-volume-pod --image=nginx --dry-run=client -o yaml > 35.yaml

controlplane $ nano 35.yaml 

controlplane $ cat 35.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: secret-volume-pod
  name: secret-volume-pod
spec:
  containers:
  - image: nginx
    name: secret-volume-pod
    resources: {}
    volumeMounts:
    - name: foo
      mountPath: "/etc/secret-data"
      readOnly: true
  volumes:
  - name: foo
    secret:
      secretName: app-secret
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

|| this to get insert the container 
controlplane $ kubectl exec --stdin --tty secret-volume-pod -- /bin/sh
# cd /etc/secret-data
# ls -l
lrwxrwxrwx 1 root root 15 Jan 14 14:03 password -> ..data/password
lrwxrwxrwx 1 root root 15 Jan 14 14:03 username -> ..data/username
# cat password
sam123# 
# cat username
sam#
```

### CKA Question 36

You have been tasked with setting up a new ServiceAccount in the dev namespace with specific permissions to manage Pods. Complete the following tasks to accomplish this:

First, create a ServiceAccount named pod-manager within the dev namespace. 

Next, create a Role called pod-access, also in the dev namespace, that has permissions to list, get, create, and delete Pods in the namespace.

Finally, create a Rolebinding named pod-access-binding to bind the pod-access Role to the pod-manager ServiceAccount. 

Ensure that all resources are created only within the dev namespace.

```
|| look at rbac documentation
controlplane $ k create namespace dev
namespace/dev created

controlplane $ k create serviceaccount pod-manager -n dev
serviceaccount/pod-manager created

controlplane $ kubectl create role pod-access  --verb=get --verb=list --verb=create --verb=d
elete --resource=pods -n dev
role.rbac.authorization.k8s.io/pod-access created

controlplane $ kubectl create rolebinding pod-access-binding  --role=pod=access --serviceacc
ount=dev:pod-manager -n dev
rolebinding.rbac.authorization.k8s.io/pod-access-binding created

controlplane $ k get role -n dev -o yaml

```

### CKA Question 37 

Create a new service account with the name pvviewer. Grant this Service account access to list all PersistentVolumes in the cluster by creating an appropriate cluster role called pvviewer-role and ClusterRoleBinding called pvviewer-role-binding.

```
controlplance $ k create sa pvviewer || controlplane $ k create serviceaccount pvviewer 
serviceaccount/pvviewer created

controlplane $ kubectl create clusterrole pvviewer-role --verb=list --resource=persistentvolume     
clusterrole.rbac.authorization.k8s.io/pvviewer-role created

controlplane $ k get clusterrole pvviewer-role -o yaml

controlplane $ kubectl create clusterrolebinding pvviewer-role-binding --clusterrole=pvviewer-role --
serviceaccount=default:pvviewer
clusterrolebinding.rbac.authorization.k8s.io/pvviewer-role-binding created

controlplane $ k get clusterrolebindings.rbac.authorization.k8s.io pvviewer-role-binding 
NAME                    ROLE                        AGE
pvviewer-role-binding   ClusterRole/pvviewer-role   109s

||validate the privilege rule set.
controlplane $ k auth can-i list persistentvolumes --as=system:serviceaccount:default:pvviewer
yes

controlplane $ k auth can-i create persistentvolumes --as=system:serviceaccount:default:pvviewer
no
```

### CKA Question 38 - service account role/rolebinding

Create a service account name seminar-sa 0n the namespace seminar. Create a new role named k8s-seminar in the namespace seminar which only allows create and update operations only on resources of types pods and deployments. Create a new rolebinding name k8s-serminarbind binding to the newly created role to the service account perviously named seminar-sa.

```
controlplane $ k create namespace seminar
namespace/seminar created

controlplane $ k create serviceaccount seminar-sa -n seminar
serviceaccount/seminar-sa created

controlplane $ k create role k8s-seminar --verb=create,update --resource=pod,deployments -n seminar
role.rbac.authorization.k8s.io/k8s-seminar created

controlplane $ k create rolebinding k8s-seminarbind --serviceaccount=seminar:seminar-sa -n seminar
error: exactly one of clusterrole or role must be specified

controlplane $ k create rolebinding k8s-seminarbind --serviceaccount=seminar:seminar-sa -n seminar --role=k8s-seminar
rolebinding.rbac.authorization.k8s.io/k8s-seminarbind created
controlplane $ 


```

### CKA Question 39

Create a new Service Account gitoups in Namespace project-1. Create a Role and RoleBinding, both named gitops-role and gitoups-rolebinding as well. These should allow the new SA to only create Secret and ConfigMaps in that Namespace.

```
controlplane $ kubectl create namespace project-1
namespace/project-1 created

controlplane $ kubectl create sa gitops -n project-1
serviceaccount/gitops created

controlplane $ kubectl create role gitops-role --verb=get --resource=secrets,configmaps -n project-1
role.rbac.authorization.k8s.io/gitops-role created

controlplane $ kubectl create rolebinding gitops-rolebinding --role=gitops-role --serviceaccount=project-1:gitops -n project-1
rolebinding.rbac.authorization.k8s.io/gitops-rolebinding created
 
```

### Question 40

There are various Pods in all namespaces. Write a command into /opt/course/5/ find_pods.sh which lists all Pods sorted by their AGE (metadata.creation Timestamp). Write a second command  into /opt/course/5/ find_pods_uid.sh which lists all Pods sorted by field metadata.uid. Use kubectl sorting for both commands 

```
Ans : Sir Rosnin

mkdir -p /opt/course/5/
echo "kubectl get pods -A --sort-by='.metadata.creationTimestamp'" > /opt/course/5/find_pods.sh
chmod +x /opt/course/5/find_pods.sh
echo "kubectl get pods -A --sort-by='.metadata.uid'" > /opt/course/5/find_pods_uid.sh
chmod +x /opt/course/5/find_pods_uid.sh
```

```
exp
#copy this from cheat sheet
# -A all pods
# List pods Sorted by Restart Count
kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'

#1st command 
kubectl get pod  -A --sort-by='.metadata.creationTimestamp

#check dir exist or not
ls /opt/course

#make dir
mkdir -p /opt/course/5

cd /opt/course/5
#present working dir
pwd

# inside the file need to use kubectl do not use alias k
echo "kubectl get pods -A --sort-by='.metadata.creationTimestamp'" > /opt/course/5/find_pods.sh

#check
cat find_pods.sh


#change the file to execution mode
chmod +x find_pods.sh

#listed
ls -l

#check sort by age
./find_pods.sh

#second command
echo "kubectl get pods -A --sort-by='.metadata.uid'" > /opt/course/5/find_pods_uid.sh

#change the file to execution mode
chmod +x /opt/course/5/find_pods_uid.sh

#check the execution mode
ls -l 

#check sorted by uid
./find_pods_uid.sh



```

### Question 41

Perform the command to list all API resources in your Kubernetes cluster. Save the output to a file 
named "resources.csv". 

```
Ans: Sir Rosnin

kubectl api-resources > resources.csv

```

### Question 42

List the services on your Linux operating system that are associated with Kubernetes. Save the  output to a file named services.csv. 

```
Ans: Sir Rosnin

systemctl list-unit-files --type service --all | grep kube > services.csv
```

### Question 43

Using the kubectl CLI tool, list all the services created in your Kubernetes cluster, across all  namespaces. Save the output of the command to a file named "all-k8sservices.txt". 

```
Ans: Sir Rosnin

k get services -A > all-k8sservices.txt

```

### Question 44

Generate a file (CKA007.txt) with details about the available size of all the node in a Kubernetes  cluster using a custom column, format as mentioned below: 
NAME AVAILABLE_MEMORY AVAILABLE_CPU 
node01  ...       ....
controlplane   ...   ....


```
Ans: Sir Rosnin

kubectl get node -o custom-columns='NODE_NAME:.metadata.name,AVAILABLE_MEMORY:.status.allocatable.memory,AVAILABLE_CPU:.status.allocatable.cpu' > CKA007.txt

```


### Question 45

Create a new namespace named ja. Create a new network policy named my-policy in the ja namespace
Requirements:
1. Network Policy should allow PODS within the ja to connect to each other only on port 80. No other ports should be allowed
2. No PODs from outside of the ja should be able to connect to any pods inside the ja

```
ans from Sir Rosnin
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: my-policy
  namespace: ja
spec:
  podSelector: {}  # apply to all pods in the ja namespace
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector: {}
      ports:
        - protocol: TCP
          port: 80
```

```
controlplane $ nano 45.yaml
controlplane $ k apply -f 45.yaml
namespace/ja created
networkpolicy.networking.k8s.io/my-policy created
controlplane $ k get networkpolicy my-policy -n ja
NAME        POD-SELECTOR   AGE
my-policy   <none>         42s
controlplane $ k run pod1 --image=nginx -n ja
pod/pod1 created
controlplane $ k run pod2 --image=nginx -n ja
pod/pod2 created
controlplane $ k get pods -o wide
No resources found in default namespace.
controlplane $ k get pods -o wide -n ja
NAME   READY   STATUS    RESTARTS   AGE   IP            NODE     NOMINATED NODE   READINESS GATES
pod1   1/1     Running   0          54s   192.168.1.4   node01   <none>           <none>
pod2   1/1     Running   0          38s   192.168.1.5   node01   <none>           <none>
controlplane $ k exec --stdin --tty pod1 -n ja -- /bin/sh
# curl http://192.168.1.5:80
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
# exit 
controlplane $ k exec --stdin --tty pod2 -n ja -- /bin/sh
# curl http://192.168.1.4:80                             
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
# exit
not completed
```

### CKA Question 46 (1)

Create a NetworkPolicy that denies all access to the payroll pod in the accounting ns.

> block with ingress because want to denies all access to the payroll

> policy need to created using ymal file

> [reference here](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
```
controlplane $ k create ns accounting
namespace/accounting created

controlplane $ k get ns

controlplane $ nano 46.yaml
controlplane $ cat 46.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
spec:
  podSelector: 
    matchLabels:
      run: payroll
  policyTypes:
  - Ingress

controlplane $ k run payroll --image=nginx -n accounting
pod/payroll created

controlplane $ k apply -f 46.yaml
networkpolicy.networking.k8s.io/default-deny-ingress created

controlplane $ k describe networkpolicy.networking.k8s.io/default-deny-ingress

//completed
```

### CKA Question 46 (2)

In the internal namespace of a company, you need to create a NetworkPolicy named web-egress-policy that allows egress traffic only from pods labeled app=web to the IP range 192.168.100.0/24. All other egress traffic from these app=web pods should be denied, without affecting other pods in the namespace. Write the YAML configuration for this NetworkPolicy.

> [reference here](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
```
controlplane $ k create ns internal
namespace/internal created

controlplane $ k get ns
sNAME                 STATUS   AGE 
internal             Active   18m

controlplane $ nano 46-2.yaml
controlplane $ cat 46-2.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: web-egress-policy
  namespace: internal
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
    - Egress
  egress:
    - to:
        - ipBlock:
            cidr: 192.168.100.0/24

controlplane $ k apply -f 46-2.yaml
networkpolicy.networking.k8s.io/web-egress-policy created

```

### CKA Question 47

Create a new NetworkPolicy names allow-port-from-namespace in the existing namespace fubar.

Further ensure that the new NetworkPolicy:
- does not allow access to Pods, which dont listen on port 9000
- does not allow access from Pods, which are not in namespace internal

```

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-port-from-namespace
  namespace: fubar
spec:
  podSelector: {} # network policy apply to all pods in namespace fubar
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: internal # allow incoming traffic from pods in namespace internal only
     ports:
    - protocol: TCP
      port: 9000 # allows traffic to port 9000 only for pods in namespace fubar

```
