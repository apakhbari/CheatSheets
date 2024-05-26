# OpenShift-Pipeline
```
 _______  _______  _______  __    _  _______  __   __  ___   _______  _______         _______  ___   _______  _______  ___      ___   __    _  _______ 
|       ||       ||       ||  |  | ||       ||  | |  ||   | |       ||       |       |       ||   | |       ||       ||   |    |   | |  |  | ||       |
|   _   ||    _  ||    ___||   |_| ||  _____||  |_|  ||   | |    ___||_     _| ____  |    _  ||   | |    _  ||    ___||   |    |   | |   |_| ||    ___|
|  | |  ||   |_| ||   |___ |       || |_____ |       ||   | |   |___   |   |  |____| |   |_| ||   | |   |_| ||   |___ |   |    |   | |       ||   |___ 
|  |_|  ||    ___||    ___||  _    ||_____  ||       ||   | |    ___|  |   |         |    ___||   | |    ___||    ___||   |___ |   | |  _    ||    ___|
|       ||   |    |   |___ | | |   | _____| ||   _   ||   | |   |      |   |         |   |    |   | |   |    |   |___ |       ||   | | | |   ||   |___ 
|_______||___|    |_______||_|  |__||_______||__| |__||___| |___|      |___|         |___|    |___| |___|    |_______||_______||___| |_|  |__||_______|
```
---
Table of contents:

Section1: Quick Overview

- Overview

- working Environment (Which Domain, Port)

- Road map 🚧

Section 2: theoretical

- About

- vs other tools

- Core Components

- Role Base Access Control Details

- minimum resource requirements

- directories structure

- Important Routes (API Calls - method: PUT, GET, POST)

- tips and tricks

Section 3: Implementation

- first time setup

- configuration

- commands

- syntax of config files (Example of config files)

- Automation

- common rules

- storage

- log and monitoring

- plugins

- Cases (Trouble Shooting + related to the services that are working with this)

Section 4 : Acknowledgment
- Contributors

- Links

---

## Section1: Quick Overview

### Pipeline Tasks
- Fetch Git Repo
- Build
- Test (UAT + SIT)
- Code Analysis
- Create Image Builder
- Build Image
- Deploy

## Section 2: theoretical
### About

To create a full-fledged, self-serving CI/CD pipeline for an application, perform the following tasks:

- Create custom tasks, or install existing reusable tasks.

- Create and define the delivery pipeline for your application.

- Provide a storage volume or filesystem that is attached to a workspace for the pipeline execution, using one of the following approaches:

    - Specify a volume claim template that creates a persistent volume claim

    - Specify a persistent volume claim

- Create a PipelineRun object to instantiate and invoke the pipeline.

- Add triggers to capture events in the source repository.

## Section 3: Implementation


### Assembling a pipeline: 

> 	The Red Hat OpenShift Pipelines Operator installs the Buildah cluster task and creates the pipeline service account with sufficient permission to build and push an image. The Buildah cluster task can fail when associated with a different service account with insufficient permissions.

1. First we need to create two different Openshift Namespace

```
$ oc new-project <Project>-pipeline
$ oc new-project <Project>-deploy
```

2. Create PVC

lets start with creating a new PVC for storing our build artifacts. This PVC is going to be needed betweek Task, and we’ll store those artifact under a different folder based on Pipeline’s uid variable to prevent overlapping one and another.

3. Creating Git secret

inside /config/gitlab-access-basic-auth

```
$ oc apply --filename secret.yaml,serviceaccount.yaml,pipeline-run.yaml
```

https://docs.openshift.com/container-platform/4.8/cicd/pipelines/authenticating-pipelines-using-git-secret.html


### Running a pipeline: 

# Section 4 : Acknowledgment
## Contributors

APA 🖖🏻

## Links

- jKube [Build and Deploy java applications on Kubernetes] --> https://github.com/eclipse/jkube?tab=readme-ov-file

- Using Private Repositories and Registries:  https://redhat-scholars.github.io/tekton-tutorial/tekton-tutorial/private_reg_repos.html


- Understanding OpenShift Pipelines: https://docs.openshift.com/container-platform/4.8/cicd/pipelines/understanding-openshift-pipelines.html#:~:text=using%20git%20secret-,Workspaces,receive%20input%20or%20provide%20output.

- Creating CI/CD solutions for applications using OpenShift Pipelines: https://docs.openshift.com/container-platform/4.9/cicd/pipelines/creating-applications-with-cicd-pipelines.html

- Openshift pipelines tutorial: https://github.com/openshift/pipelines-tutorial

- Guide to OpenShift Pipelines Part 2 - Using Source 2 Image build in Tekton (How it actually works): https://www.redhat.com/en/blog/guide-to-openshift-pipelines-part-2-using-source-2-image-build-in-tekton
- https://github.com/marrober/pipelineBuildExample

- https://spring.io/guides/topicals/spring-boot-docker/

- https://medium.com/hybrid-cloud-engineering/integrating-code-inspection-in-your-openshift-pipelines-using-sonarqube-a5371ca49369

- https://jenkins-x.io/v3/admin/platforms/openshift/

- https://github.com/osa-ora/simple_java_maven
- 

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
