# Kubernetes

## Commands:

- `-c` flag —> address a running container in a pod

## Configs:

- `kubectl apply -f [config file name]` —> feed a config file to k8s. needs to be written for each file. create a deployment out of a config file
- `kubectl delete -f [config file name]` —> remove an object
- `kubectl set image [object type] / [object name] [container name] = [new image to use]` —> imperative command to update image

## Print status:

- `kubectl get pods` —> print out information about all of the running pods
- `kubectl get services` —> print out information about all of the running services
- `kubectl get deployments` —> list all the running deployments
- `kubectl get pv` —> list all the persistent volumes
- `kubectl get pvc` —> list all the persistent volume claims
- `kubectl get secrets` —> get all of secrets
- `kubectl get namespaces` —> get all namespaces inside of our cluster

## LOG:

- `kubectl logs [pod_name]` —> print out logs from the given pod
- `kubectl describe [object type] [object name / can be none to get all of objects]` —> print out details about a specific object
- `kubectl describe pod [pod_name]` —> print out some information about the running pod

## Deployment Commands:

- `kubectl delete deployment [depl_name]` —> delete a deployment
- `kubectl rollout restart deployment [depl_name]` —> for updating new built container
- `skaffold dev` —> start

## Minikube:

- `minikube ip` —> show IP address of node to access on local machine
- `kubectl exec -it [pod_name] [cmd].` —> execute the given command in a running pod
- `kubectl delete pod [pod_name]` —> deletes the given pod
- `kubectl create secret generic jwt-secret --from-literal=JWT_KEY=asdf` —> create a secret environment variable of `JWT_KEY=asdf`
- `kubectl get services -n <NAMESPACE>` —> get all services that are inside of a namespace
- `kubectl config view` —> show all things that are running, different contexts and namespaces
- `kubectl config use-context <namespace>` —> change context

## Don't know:
- restart statefulset --> `$ kubectl --kubeconfig ./kubeconfig rollout restart statefulset <shopping-stage-back-pgha1-mbrq>`
- change namespace --> `$ kubectl config set-context --current --namespace=my-namespace`

---

## Programs:

- **minikube** (just for development, local only) —> use for managing the VM itself. creates k8s node.
- **kubectl** —> use for managing containers in the node
- **ingress-nginx** —> [github.com/kubernetes/ingress-nginx](http://github.com/kubernetes/ingress-nginx) and not kubernetes-ingress by nginx [github.com/nginxc/kubernetes-ingress](http://github.com/nginxc/kubernetes-ingress)

---
