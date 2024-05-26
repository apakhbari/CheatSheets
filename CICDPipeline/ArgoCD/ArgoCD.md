# argocd

```
 _______  ______    _______  _______    _______  ______  
|   _   ||    _ |  |       ||       |  |       ||      | 
|  |_|  ||   | ||  |    ___||   _   |  |       ||  _    |
|       ||   |_||_ |   | __ |  | |  |  |       || | |   |
|       ||    __  ||   ||  ||  |_|  |  |      _|| |_|   |
|   _   ||   |  | ||   |_| ||       |  |     |_ |       |
|__| |__||___|  |_||_______||_______|  |_______||______| 
```


## Tips & Tricks
- ArgoCD is a declarative GitOPS tool which is based on k8s.
- It is pull base (noy push based, like jenkins or gitlab) which means there is an agent on cluster which is going to monitor git repo for changes constantly in order to check whether state we have right now is desired state or not.
- Git is source of truth, You define your configs in a git repo then argo CD syncs it in k8s cluster
- in GitOps it is best practice to have two different repos: 1-app repo 2- config repo
- Inside confg repo we have: 1- k8s manifests 2- helm charts 3- kustomize files
- Argo CD has disaster Recovery
- Argo CD can control multiple Clusters
- default username: admin - password : get secret
- It is best practice to sync automatically for dev env & manula for prod. so you really know when pulling changes to prod cluster
- IMPORTANT: check prune inside sync policy, so old configs are being removed.
- ArgoCD sync repo every 3 mins by default
---

**Course: https://www.udemy.com/course/mastering-gitops-with-argo-cd/**

## Table of Contents:
1. **Introduction to GitOps and Argo CD**
2. **GitOps Workflow and Best Practices**
3. **Argo CD Deep Dive**
4. **Advanced Argo CD Features and Integrations**

## 1. Introduction to GitOps and Argo CD

GitOps: Set of practices that leverages Git as the single source of truth for declarative infra and app configuration. Enables teams to streamline their app delivery process, automate deployment, and improve collaboration.

Core Principles of GitOps:
- Declarative Configuraion
- Version Control
- Automated Synchronization
- Continous Feedback

Benefits of GitOps:
- Increased Productivity
- Improved Collaboration
- Enhanced Security
- Faster Recovery

What is ArgoCD:
- A declarative, GitOps continous delivery tool for Kubernetes
- Using Git as the single source of truth
- Can manage multiple Kubernetes environments

Key Features of ArgoCD:
- Declaraive and versiones
- Multi-cluster support
- Automated Sync and Rollbacks
- Pluggable Deployment Strategies
- Extensibility


Advanteges of ArgoCD:
- Streamlined Deployments
- Enhanced Collaboration
- Improved Security
- Faster Incident Response
- Scalability

The Need For GitOps: Traditional deploymetn methods often lack the necessary automation, consistenct, and reliability needed in modern environments. GitOps relies on GIt as a singlel source of truth for declarative infrastructure and provides a clear, version-controlled history of changes.

Why Choose ArgoCD: 
- Kubernets-native
- Provides automated deployments
- Supports various configuration management tools
- Enhances security and compliance
- Facilitates collaboration and transparency

## 2. GitOps Workflow and Best Practices

### Git Repositoy structure for GitOps

Why Git repo structuer matters:
- Version Control your configuration
- Roll back changes if necessary
- Review & approve changes before they are applied
- Collaborate with your team 

Git repo structure best practices
- Use a single repo per app or environment
- Use branches to manage different stages of the development and deploymet process
- Store configuration data in a seperate directory from application code
- Use descriptive names for directories and files
- Use Git submodules to manage shared configuration data

Branching Strategies
- Trunk-based development: All development happens in main branch and feature branches are short-lived
  - Used by small teams / fast iteration 
- GitFlow: Development happens in develop bracnh and features developed in feature branches
- GitHub Flow: All development happens in main branch and feature branches are used for pull requests

### Manifests, Helm Charts and Kustomize

Manifests
- Pros:
  - simple & easy to understand
  - Provide a clear and complete picture of the desired state of a kubernetes object.
 - Can be customized to meet specific requirements
- Cons:
  - Can become cumbersome to manage
  - Require manual updates when changes are made
  - Difficult to reuse across different environments
  - Managing secrets in manifests can be a security risk

Helm Charts
- A package manager for kubernetes
- Pros
  - They provide a way to package, distribute, and manage kubernetes applications as a single unit
  - Allow for parametrization, so you can reuse a chart with different values based on your environment
- Cons:
  - They can be complex to create and manage
  - They can introduce risk to your deployment pipeleine
- Example chart directory structure:
  - mycahrt/chart.yaml  -->  A YAML file with information about the chart
  - mycahrt/values.yaml  -->  A YAML file with default values for the chart
  - charts/  -->  A directory containing the chart dependencies
  - templates/  -->  A directory of templates that generate Kubernets manifestscontaining the chart

Kustomize
- Provides a way to customize Kubernetes objects without modifying the original YAML files
- Pro:
  - Allows you to customie your Kubernetes objects without modifying the orgignal YAML files.
  - Provides a way to manage complex configuration in a predictable and repeatable manner.
- Cons:
  - It can be complex to create and manage, especially for complex configurations
  - Requires an understanding of YAML and Kubernetes resources, as well as a familiarity with Kustoize configuration files and patches.
- Example of a Kustomizayion directory structure:
  - mykustomizeation/kustomization.yaml  -->  A file with the configuration for the Kustomization
  - bases/  -->  A directory containing the base resources
  - overlays/  -->  A directory containing the customization patches
 
Comparing Manifests, Helm Charts and Kustomize
- Manifests are simple and easy to understand, but they can be cumbersome.
- Helm charts simplify the management of kubernetes objects. However they can be complex to create and manage, and can introduce risk to the deployment pipeline
- Kustomize allows us to customize Kubernetes objects without modifying the original YAML files, but it can be complex to create and manage for complex configuration.

Choosing the right tools
- Considewr the complexity of your configuration, the number of objects you need to manage, and your team's experience and expertise.
- Manifests are a good choice for small ro medium-sized deployments with a limited number of objects and simple configurations.
- Helm Charts are a good choice for managing complex applications with multiple objects and configurations.
- Kustomize is a good choice for customizing exisiting YAML files or generating new ones based on a set of rules and patches.

GitOpes Best Practices
- Use Version Control for all your infrastructure code
- Follow a Pull-based model for deployments
- Ensure that all changes are auditable and traceable
- Automate as much as possible
- Ensure that all configurations are tested and validate before deployment
- Implement security best practices

## 3. Argo CD Deep Dive

ArgoCD architecture:
- ArgoCD API Server
  - Central Component of the architecture
  - Processes API requests from users
  - Interacts with the Kubernetes API
  - Monitors the state of the cluster
  - Built on top of the Kubernets API server
  - Uses Kubernets RBAC for authentication adn authorization
- Repository Server
  - Manges the Git repositories that contain the configuration and deploment instructions
  - Interact with Git to pull the configuration and deployment data
  - Stores the data in a local cache for faster retrieval
- Application Controller
  - Updates the Kubernets objects based on data retrieved from Git
  - Uses Kubernetes controllers (Deployments, StatefulSets, etc.) to manage the cluster state
- ArgoCD CLI
- Redis
  - In-memory data structuer store
  - Stores metadata about the applications and resources in the cluster. For example: the status of the application deployments, the cluster resources state, and the history of changes
- Prometheus [Not Built-in to ArgoCD]
  - an Open-source monitoring and alerting system
  - Monitors the health and performance of the Kubernets cluster
  - Collects the health and performance of the Kubernets cluster
  - Collects metrics from ArgoCD and Kubernetes
  - Provides a UI for querying the performance data
- Grafana [Not Built-in to ArgoCD]
  -  an Open-Source data visualization tool
  -  Used to display metrics collected by Prometheus in dashboards
 
ArgoCD best practices
1. Use git as the source of truth for the configuration and deployment
2. Use a version control system for the Git repository. such as GitHub or Gitlab
3. Use Kubernets namespaces to organize and manage thi resources in the cluster
4. Use Kubernetes RBAC to control access to the resources in the cluster
5. Use Helm charts or Kustomize to manage the deployment of complex applications

### Deploying a simple app to Argo CD
1. Create an Argo CD User in git
2. Create an Access Token in Git with api scope
3. Create a Kubernetes Secret for Access TOke
3. or Using ArgoCD CLI / UI:

``` $ argocd repo add "http://gitlab.com/repo.git --username "USER_NAME" --password "ACCESS_TOKEN"" ```

4. Create an app inside argo
5. For applying changes to deployment, we have to manually Use ``` $ kubectl apply -f <RESOURCE> ``` for changes to take effect.
- ArgoCD syncs repo every 3 mins by default, for manually syncing use:
``` $ argocd app sync <NAME_OF_APP> ```

### Deploying Helm charts to Argo CD

ArgoCD supports helm:
1. Using ready-made charts stored in remote registries
2. Using local charts stored in the git repository

#### Implementation of Using ready-made charts stored in remote registries:
- When you don't need to modify the chart contents. Just use the values file to customize the installation
- When the Helm chart is stored and maintained in a different repo by a different team or organization
1. Let's create an app which links argocd with app manifests 
- ``` $kubectl apply -f ./argo-app/argocd.yaml```
2. use this helm cahrt fot testing purposes https://matheufsm.dev/cahrts/
3. add httpbin-app/httpbin-v1.yaml to git
4. sync changes in argo
5. DONE!

for changing deployment to NodePort instead of ClusterIP:
1. using helm CLI it is ``` $ helm upgrade httpbin --set service.type=NodePort matheusfm/httpbin``` but since we deployed using argo, not helm, ``` $ helm list ``` won't recognize our deployment.
2. edit httpbin-app/httpbin-v1.yaml to httpbin-app/httpbin-v2.yaml in git
3. sync changes in argo
4. DONE!

- Using GitOps instead of helm CLI, now we know When, Why & Who changed our deployment.

#### Implementation of Using local charts stored in the git repository:
- When the chart is developed locally as part of rhe application
- When you need to have control over the chart contents and not just the values file
1. ``` $ helm create httpd ```
2. ``` $ cd httpd ```
3. ``` $ vim values.yaml ```
  - change -->  image/repository: httpd
    - change -->  image/tag: latest
4. ``` $ vim Chart.yaml ``` --> version of chart by default is 0.1.0 , can be changed here
5. ``` $ helm package . ``` --> will make a compressed package with .tgz format. now save this package inside a repository. We are using gitlabe here
6. Go to gitlab > <Desired Project> > Settings > General > Copy Project ID
7. Send Package to gitlab ```curl --request POST --form 'chart=@httpd-0.1.0.tgz' --user "<USERNAME>:<TOKEN>" https://gitlab.com/api/v4/projects/[your project
id]/packages/helm/api/stable/charts```
8. Add Git credentials, to access helm pacakge ``` $argocd repocreds add https://gitlab.com/api/v4/projects/[your project
id]/packages/helm/stable --username [your username] --password [your personal
token] ```  
9. add httpd/httpd.yaml to git

### Deploying Kustomize to Argo CD

### Managing Secrets in GitOps

#### Importance of secret Management
- A Crucial aspect of any modern application development process
- Should be managed securely and seperately from app code
- We need to ensure that secrets are:
  - Encrypted: to protect against unauthorized access
  - Versioned: to maintain an audit trail and rollback capabilities
  - Automated: to reduce manual intervention and human error

#### Storing Secrets in Git Repo
- We need to store secrets in Git
- This presents a security risk
- We can use HashiCorp's Vault or Sealed Secrets to mitigate this risk
- we'll use Sealed Secrets

Sealed Secrets
- An open-source project by bitnami
- Can securly store,version and manage secrets in a GitOps workflow using ArgoCD
- Consists oF:
  - SealedSecret CRD: A k8s custom resource which stores encrypted secrets
  - KubeSeal: Comman-line utility for creating secret objects
  - Sealed Secrets Controller: a k8s controller that watches for sealed secret objects and decrypt them into k8s secrets

### Synchronization and Rollbacks
- Synchronization is a fundamental concept in GitOps
- It involves maintaining consistency between the desired state of your application or infrastructure as defined in your Git repository, and the actual state in your kubernetes cluster
- In a GitOps workflow, synchronization is performed automatically and countinuoslt ro ensure that your environment stays up-to-date with the latest changes

ArgoCD Sync
- Argo CD is a powerful tool that enables countinous synchroniztion of your application reources in kubernetes with the desired state defined in your Git repo
- When you create or update an application in ArgoCD, it compares the actual state in the cluster with the desired state from the repo
- If there are any differences, ArgoCD will automatically apply the necessary changes to synchronize the states. This process is called an ArgoCD Sync

Rollbacks in GitOps
- In software development, rollbacks are essential for quickly reverting an application to a previous stable state in case of errors or issues.
- In GitOps, rollbacks involve reverting the changes in the Git repo to a previous commit, and then synchronizing the cluster to that commit
- This allows you to quickly recover from any issues and restore the desired state of your app or infra

ArgoCD Rollbacks
- ArgoCD provides an easy way to perform rollbacks by using the "rollback" feature
- With ArgoCD, you can select a specific commit or version of your app, and it will automatically synchronize the cluster to that version, effectively rolling back your application to that state
- This is a powerful feature that enables you to quickly recover from issues without the need for manual intervention

- IMPORTANT: For rollback you need to disbale auto sync, so remove syncPolicy section inside argo.yaml 

Rollback in CommandLine:
- ``` $ argocd app history <APP_NAME> ```
- ``` $ git log --one-line ``` --> get complete description of commits
- ``` $ argocd app rollback <APP_NAME> <COMMIT_HASH>```
- ``` $ git revert <COMMIT_HASH>..HEAD``` --> change git head to a desired commit

## 4. Advanced Argo CD Features and Integrations

### MultiCluster Deployment with Argo CD

Why have multiple clusters?
- Production and staging
- Blue/Green deployment
- Development and QA
- Multi-region deployment
- Cluster segmentation
- Isolated workloads
- Different environments for different teams

### Introducing Argo CD ApplictionSets
- ApplicationSet: A k8s CRD which is being interpreted by ArgoCD Controller, It allows us to use a template file which will be parsed by ArgoCD and will be converted to regular app

### Implementing BlueGreen Deployments
- Two identical enviroments both of which serve production
- Only one of them is active at any given time. for example, Blue
- The green enviornment is prepared for the next release:
  - unit tests
  - Integration tests
  - sSystem tests
  - Performance tests
  - Security tests
  - Usability tests
  - Regression tests
- Once the tests pass, the green enviornment serves production while the blue one is prepared for the next release.

### Implementing Canary Deployments
- A software release management strategy that involves deploying a new version of an application alongside the existing one, but only exposing a small subset of users to the new version.
- Rolling out the feature to 5% of users, gradually increase the canary percentage while monitoring and collecting user feedback

## Section 4 : Acknowledgment
## Contributors

APA 🖖🏻

## Links
- Deploying a Spring Boot application with Argo CD: <https://docs.openshift.com/container-platform/4.8/cicd/gitops/deploying-a-spring-boot-application-with-argo-cd.html>

- Getting Started with OpenShift GitOps: https://github.com/redhat-developer/openshift-gitops-getting-started


```                                                                                                       
  aaaaaaaaaaaaa  ppppp   ppppppppp     aaaaaaaaaaaaa   
  a::::::::::::a p::::ppp:::::::::p    a::::::::::::a  
  aaaaaaaaa:::::ap:::::::::::::::::p   aaaaaaaaa:::::a 
           a::::app::::::ppppp::::::p           a::::a 
    aaaaaaa:::::a p:::::p     p:::::p    aaaaaaa:::::a 
  aa::::::::::::a p:::::p     p:::::p  aa::::::::::::a 
 a::::aaaa::::::a p:::::p     p:::::p a::::aaaa::::::a 
a::::a    a:::::a p:::::p    p::::::pa::::a    a:::::a 
a::::a    a:::::a p:::::ppppp:::::::pa::::a    a:::::a 
a:::::aaaa::::::a p::::::::::::::::p a:::::aaaa::::::a 
 a::::::::::aa:::ap::::::::::::::pp   a::::::::::aa:::a
  aaaaaaaaaa  aaaap::::::pppppppp      aaaaaaaaaa  aaaa
                  p:::::p                              
                  p:::::p                              
                 p:::::::p                             
                 p:::::::p                             
                 p:::::::p                             
                 ppppppppp                             
                                                       
```
