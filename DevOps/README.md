# **DevOps**
```
 ______   _______  __   __  _______  _______  _______ 
|      | |       ||  | |  ||       ||       ||       |
|  _    ||    ___||  |_|  ||   _   ||    _  ||  _____|
| | |   ||   |___ |       ||  | |  ||   |_| || |_____ 
| |_|   ||    ___||       ||  |_|  ||    ___||_____  |
|       ||   |___  |     | |       ||   |     _____| |
|______| |_______|  |___|  |_______||___|    |_______|
```

## Table of contents:

0. DevOps workflow

1. Git
2. Maven
3. JFrog Artifact
4. Jenkins
5. SonarQube
6. Docker
7. Kubernetes
8. Prometheus

**——————————————————**

## 0. DevOps workflow

Git → Jenkins → JFrog Artifactory → Ansible → Tomcat

CI: git clone - build - docker image - push to artifactory

**——————————————————**

## 1. Git

### Files & Directories

/.git/config → info about origin branch

### Commands

#### Introducing yourself to git

- `$ git config --global user.name "APA"`
- `$ git config --global user.email "APA@gmail.com"`
- `$ git config --global user.name` → see user.name
- `$ git config --global user.email` → see user.email

#### Creating Git Repo

- `$ git init .`
- `$ git add <file>` → add file to staging area. add files to staging area. use . flag or --all flag for adding all files in dir. note that `$ git add .` only add things in current directory so for several changes in different directories you should change pwd several times
- `$ git commit -m "first commit"` → add changes to local VCS

#### Connecting local repo to origin

- `$ git remote add origin git@github.com:ravdy/demorepo.git` → connect local repo to origin

#### Download repo from origin repo

- `$ git clone <repo name>`
- `$ git push origin master`

#### Checking status

- `$ git status` → where is status of files in wd, which one is un-tracked and which is on staging or committed
- `$ git log` → show commits

#### Checking differences

- `$ git diff` → check differences between WD and staging area
- `$ git diff --staged` → check differences between staging area and local repository
- `$ git diff --staged HEAD` → same as above
- `$ git diff HEAD` → check differences between WD and local repository
- `$ git diff <first 6 digits of commit> <first 6 digits of commit>` → compare two commits together
- Tip: it is possible to use `$ git diff HEAD HEAD~2` (HEAD-2), this way you can compare with 2 previous commits

### Branches

- `$ git branch` → show how many branches you have. the one with * is the active one
- `$ git branch <branch name>` → create test branch
- `$ git checkout <branch name>` → change to another branch. Technically HEAD is going to change
- `$ git checkout -b <branch name>` → create another branch and also change to it
- `$ git merge <branch name>` → merging with the current active branch

### Go back to a previous commit

- `$ git checkout <commit ID>` → Technically HEAD is going to change
- `$ git switch -` → go back to the commit before checkout

### Get information about a specific commit

- `$ git show <commit ID>`

### Get information about who changed a file, line by line

- `$ git annotate <file name>`

### Tagging

- `$ git tag` → show current tag
- `$ git tag v1.0` → tag commit
- `$ git push origin v1.0`
- `$ git tag -a v1.1 <Commit ID> -m "description"` → add a tag to a specific commit

### Restoring changes

#### Revert changes from working directory

- `$ git restore <file name>`
- or
- `$ git checkout -- <file name>`

#### Revert changes from staging area

- `$ git restore --staged <file name>` → revert from staging area to working directory
- `$ git restore <file name>` → revert changes from working dir

#### Revert changes from local repository

- `$ git restore HEAD^1` → revert from local repo to working directory, 1 commit back
- `$ git restore <file name>` → revert changes from working dir

### Git Rebase

- `$ git rebase -i HEAD~4` → squish latest 5 commits into 1 commit

**Descriptions**

- Git is a distributed Version Control, means there is a centralized VC Repository and each collaborator has a VC Repository on his system
- Git Stages:
    1. Working Directory. use `$ git add`, for next stage
    2. Staging Area. use `$ git commit`, for next stage
    3. Repository
- origin is remote
- HEAD is latest commit in repo. you can always use HEAD instead of <commit ID>
- Best practice to have these branches:
    - Test
    - QA → it is after test branch and is used to check quality of things. after that it is going to prod branch
    - Prod → release branch
- It is best practice to get code to local system before merge
- Fork is like clone, difference is instead of getting file to your local system, you are putting it directly to your github account
- Git Rebase: squish multiple commits into one commit
- instead of `$ git add .`, `$ git commit -m "something"` can use `$ git commit -a -m "something"`, but it is just for modified files, not newly added files
- Git fetch vs Git pull: pull is doing 2 things, first it fetches Remote Repo into Local Repo, then merge changes into working dir

## Repository setup in real-world

- Create a private repo
- Create 3 branches, Prod, UAT and Dev
- Add team as collaborators to repo
- Enable SSH based authentication
- Protect Prod and UAT branches
- 1 approval needed to check-in code on UAT and 2 for Prod
- Build and Deploy should be successful before chick-in the code onto UAT as well as Prod

---

```bash
$ git revert <COMMIT_HASH>..HEAD
```

--> change git head to a desired commit

---

### Best Practice for starting a repo:

```bash
$ mkdir myapp
$ cd myapp
$ git init
$ git branch -m main --> change master branch name to main (best practice)
$ touch app.yaml
$ git add app.yaml
$ git commit -m "Initial commit"
$ git checkout -b develop --> create and switch to a new branch
$ git checkout -b feature/my-new-feature  --> short lived branch to add my new feature
$ vim app.yaml
$ git add app.yaml
$ git commit -m "Added my new feature"
$ git checkout develop
$ git merge --no-ff my-new-feature (name of feature branch) --> no-fastforward
$ git checkout -n release/my-new-feature
$ vim app.yaml
$ git commit -m "releasing my new feature"
$ git merge --no-ff release/my-new-feature
$ git checkout main
$ git merge -no-ff release/my-new-feature
$ git push

$ git remote add origin git@<GIT_URL/repo.git>
$ git add -A
$ git commit -m "message"
$ git push --set-upstream origin main --> set-upstream is assigned to origin remote
```

For Excluding a file from git changes:

```bash
$ git add -- . ':!node_modules'
```

**——————————————————**

## 2. Maven

# **Files & Directories**

- src/main/java → main app
- src/test/java → where test cases are
- pom.xml → project object model. config file of project for building project
- /target → where output and compiled thing exist
- ${maven.home}/conf/settings.xml or ${user.home}/.m2/settings.xml → settings that are not project specific, for example local repo locations, alternate remote repo servers, authentication info
- user/.m2/ → local repo, where packages are being downloaded from Maven central repo and get installed in your system. big companies have something called Enterprise Repo which is an internal repo that exists because of security reasons, so developers download packages from it instead of Maven central repo

## Commands

- `$ mvn test-compile` → do maven goals
- `$ mvn archetype:generate` → get list of available archetypes. Then using integrated terminal choose which archetype and which version you want then specify coordinates

## Descriptions

- Archetypes are project templating toolkit
- Maven coordinates are:

  - groupID: org.apache.maven (same for all apps in a company)
  - artifactId: project_name (must be unique)
  - version
  - packaging → groupID:artifactId:version

- Java compilation process: main.java → main.class → main.jar or main.war . notice that you should first see tests cases success
- Maven Goals (take note that if you execute verify for example, all previous goals are being executed too. you can specify more than one goal, for example: clean install)
  - clean: remove all files generated by the previous build
  - validate: validate the project is correct and all necessary information is available
  - compile: compile the source code of the project
  - test-compile: compile the test source code into the test destination directory
  - test: run tests using a suitable unit testing framework
  - package: take the compiled code and package it in its distributable format, such as a JAR
  - verify: run any checks to verify the package is valid and meets quality criteria
  - install: install the package into the local repo, for use as a dependency in other projects locally
  - deploy: copies the final package to the remote repo for sharing with other projects

- Plugins are where goals are written
- Maven lifecycle:
  - default: all of above goals
  - clean: just clean goal
  - site: just for creating documentation

## How to deploy on tomcat server using maven

**Pre-requisites**
1. Maven Server
2. Tomcat Server

### Procedure

1. download archetype maven-archetype-webapp
   ```sh
   mvn archetype:generate -DgroupId=com.valaxy.webapp -DartifactId=helloworld-project -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false
   ```

2. Update `pom.xml` code to add maven plugin to copy artifacts onto tomcat. This should be under `<plugins>`
   ```xml
   <plugins>
     <plugin>
       <groupId>org.apache.tomcat.maven</groupId>
       <artifactId>tomcat7-maven-plugin</artifactId>
       <version>2.2</version>
       <configuration>
         <url>http://localhost:8080/manager/text</url>
         <server>TomcatServer</server>
         <path>/helloworld-webapp</path>
       </configuration>
     </plugin>
   </plugins>
   ```

3. Create `settings.xml` for credentials
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <settings ...>
     <servers>
       <server>
         <id>TomcatServer</id>
         <username>admin</username>
         <password>password</password>
       </server>
     </servers>
   </settings>
   ```

4. Build and deploy the project on tomcat
   ```sh
   mvn tomcat7:deploy
   ```

**——————————————————**

## 3. JFrog Artifact
# **Description**

- artifact is outcome of source code, for example main.jar or main.war or main.ear is outcome of main.java
- JFrog artifactory is on port 8081
- we don’t use git as an artifact repo
- artifact repo
  - a source for artifacts needed for build
  - stores artifacts generated in the build process
- we use artifact repo for maintaining different versions of things so rollback is easy
- There are 3 kind of artifactory we can use:
  - local
  - remote
  - virtual
- Local repo with maven are these two:
  - libs-release-local
  - libs-snapshot-local
- for integration with Maven, first create a new maven user with admin privileges then for providing credentials in maven server create /.m2/settings.xml and add credentials from Set Me Up of JFrog Artifactory then should add `<distrbutionManagement>` tag to pom.xml, from Set Me Up of JFrog Artifactory could find related info. after that we should `$ mvn deploy`
- take note that snapshot version is for test purpose and release version is for prod. you should config both of them in JFrog and Maven
- for making JFrog central repo for dependencies, remove /.m2/repositories dir entirely, so now dependencies would be downloaded to JFrog and systems get dependencies directly from there

**——————————————————**

# **4.Jenkins**

- Jenkins: Leading open-source automation server, which provides hundreds of plugins to support building, deploying and automating any project. Jenkins is an application that manages and monitors executions of repeated jobs.
- Jenkins developed with Java

### Why Jenkins?

- Open-source
- Easy to install
- Easy GUI
- Distributed Builds
- Track & Revert Changes
- Jenkins server have to has Git & Maven installed on it, since it is where build happens
- It is possible to pass parameters to Jenkins
- All of build outcomes are stored in workspace tab in console or /var/lib/jenkins/workspace

### Manage Jenkins Tab

- Configure System: if you want to connect to maven, artifactory and …
- Global Tool Configuration: set up tools, such as Git

### Integrating Git

- install git on server
- tell Jenkins where git is installed: `$ which git`, then configure Manage Jenkins Tab > Global Tool Configuration

### Integrating Maven

- install maven integration plugin + Maven invoker plugin on Jenkins console
- install maven on server
- Manage Jenkins Tab > Global Tool Configuration & tell Jenkins where maven is installed: `$ which mvn`

### Master & Slave Configuration

- Manage Jenkins Tab > Manage Nodes and Clouds

### Build Triggers

- difference between Schedule and Poll SCM is schedule is dumb, but Poll SCM only build on automation when there are changes
- GitHub hook trigger for GITScm polling

### Integrating GitHub Webhooks

- go to github repo settings, in Webhooks tab, Add webhook, Add jenkins server as follow [http://<Jenkins_URL](http://jenkins_url)>:8080/github-webhook/

### DSL Jobs

- create another job(s)/pipeline(s)/etc. must install its plugin. Its goal is to convert the pipeline into script. When cloning from Git, you should approve the script from Manage Jenkins Tab > In-process Script Approval
- Jenkins Pipeline
  - instead of using GUI, you’d write a file or script to create a job
  - It is possible to change the default flow of Jenkins
  - Must install pipeline plugin
  - Create a Jenkinsfile in git repo

### Integrating JFrog Artifactory

- install artifactory plugin
- Add new user for jenkins in JFrog
- Manage Jenkins Tab > Configure System —> enter artifactory credentials
- Check Maven3-Artifactory Integration in build environment
- Check Resolve Artifacts from artifactory to get packages from artifactory

### UpStream & DownStream

- whenever you build a job, another job gets built
  - DownStream: via Post-build Actions, choose Build other projects
  - UpStream: via Build Triggers, Check Build after other projects are built

**——————————————————**

# **5.SonarQube**

- SonarQube is a Static Code Analysis tool. It’s a Quality Management Tool
- SonarQube components:
  - Rules
  - Database: stores reports in it
  - Web Interface
  - SonarScanner

- Integration with Jenkins

**——————————————————**

# **6.Ansible**
- Configuration management is a process for maintaining computer systems, servers and software in a desired, consistent state. It’s a way to make sure that a system performs as it’s expected to as changes are made over time
- How ansible works
- Control Node: main machine that Controls Other nodes. Any machine with Ansible installed
- Managed Nodes: network devices you manage with Ansible
- Inventory: A list of managed nodes. An inventory file is also sometimes called a ”hostfile”
- Modules: units of code Ansible executes. Each module has a particular functionality
- Tasks: units of action in Ansible
- Playbooks: ordered list of tasks written in YAML
- Ad-hoc commands: command that we are doing repeatedly
- flag -b ( -s in older versions for sudo) stands for become, which means do this as root user
- ping: $ ansible all -m ping —> for all hosts, use ping module
- command : $ ansible -m command -a “uptime” —> a stands for attribute
- $ ansible -m command -a “ls -l” —> on ansible user home dir
- stat: $ ansible all -m stat -a “/home/ansadmin/testfile” —> to check a file exist or not
- yum: $ ansible all -m yum -a “name=git”
- user: $ ansible all -m user -a “name=sysadmin” -b —> create a user
- setup: $ ansible all -m setup —> gather all info of nodes
- file module : create/delete file and dir and change ownership
- Ansible Inventory can be defined as following
- Default location: /etc/ansible/hosts
- use -i option for overriding location: ansible -i my_hosts
- defined in ansible.cfg file
- ansible.cfg hierarchy of use
- ANSIBLE_CONFIG (as environment variable)
- ansible.cfg (in current dir)
- .ansible.cfg (in home dir)
- /etc/ansible/ansible.cfg
- ansible by default uses setup module, so even if we are doing any playbook, setup is also being executed
- $ ansible-playbook test.yml
- $ ansible-playbook test.yml —check —> for just checking, not executing
- playbook conditions are:
  - When
  - With_items: for looping purposes
  - Notify & handlers: only when task is done, notify other task to do something

httpd_package.yml
---

- name: installing and starting packages
  hosts: all
  become: true
  gather_facts: yes
  tasks:
    - name: installing packages on RedHat
      yum:
        name: ”{{ item }}”
        state: installed
      with_items:
        - httpd
        - git
        - tree
      when: ansible_os_family == “Redhat”
      notify: start httpd services

    - name: installing other packages
      yum:
        name: [‘telnet’ , ‘make’]
        state: installed
      when: ansible_os_family == “Redhat”

    - name: installing httpd on ubuntu
      apt:
        name: apache2
        state: started
      when: ansible_os_family == “Debian”

    - name: copying index.html to nodes
      copy:
        src: home/ansadmin/playbooks/index.html
        dest: /var/www/html

    - name: starting httpd service on ubuntu
      service:
        name: httpd
        state: present
      when: ansible_os_family == “Debian”

  handlers:
    - name: start httpd services
      service:
        name: httpd
        state: started
      when: ansible_os_family == “Redhat”

packages_loop.yml
---

- name: installing and starting packages
  hosts: all
  become: true
  gather_facts: no
  tasks:
    - name: installing/uninstalling packages
      yum:
        name: ”{{ item.pkg }}”
        state: ”{{ item.setup }}”
      loop:
        - { pkg: ‘git’, setup: ‘installed’ }
        - { pkg: ‘wget’, setup: ‘latest’ }
        - { pkg: ‘tree’, setup: ‘removed’ }
        - { pkg: ‘mak’, setup: ‘absent’ }

- ansible variables
  - Define in playbook
  - vars: user_name: asghar
- passing from external files
  - user.yml —> user_name: asghar —> vars_files: - /home/ansible/user.yml
- passing from host inventory
- passing while running playbook
  - —extra-vars “user_name=asghar” —> it is highest priority
- using group_vars or hosts_vars and so on

create_user.yml
---

- name: installing and starting packages
  hosts: all
  become: true
  gather_facts: no
  vars:
    user_name: asghar
  tasks:
    - name: creating user {{ user_name }}
      user:
        name: “{{ user_name }}”

    - name: creating dir
      file:
        path: /opt/{{user_name}}_temp_dir
        owner: “{{user_name}}”
        group: “{{user_name}}”
        mode: 0755

- specify nohup in your command if you want that command to execute when things finish. because by default ansible kills processes when exiting and by specifying nohup you tell it not to
- Ansible vault is a feature of ansible that allows you to keep sensitive data such as passwords or keys in encrypted files, rather than as plaintext in playbooks or roles
- $ ansible-vault create
- $ ansible-vault view
- $ ansible-vault edit
- $ ansible-vault encrypt
- $ ansible-vault decrypt
- — ask-vault-pass: to provide password while running playbook
- — vault-password-file: to pass a vault password through a file

- Ansible roles is being used for re-using a playbook, it is going to divide a playbook to different files for re-usability and more readability purposes
- $ ansible-galaxy init tomcat_setup —> create a tomcat role
- $ ansible-galaxy install <role_name> —> will download role from ansible galaxy to ~/.ansible/roles
- /hosts

[webservers]

172.31.38.215

172.31.38.13

**——————————————————**

**7.Docker**
- network Drivers
- bridge: The default network driver. If you don’t specify a driver, this is the type of network you are creating. Bridge networks are commonly used when your application runs in a container that needs to communicate with other containers on the same host. —> IPs will be private
- host: Remove network isolation between the container and the Docker host, and use the host’s networking directly. —> Ips will be in range of host, within available subnet
- overlay: Overlay networks connect multiple Docker daemons together and enable Swarm services and containers to communicate across nodes. This strategy removes the need to do OS-level routing.
- ipvlan: IPvlan networks give users total control over both IPv4 and IPv6 addressing. The VLAN driver builds on top of that in giving operators complete control of layer 2 VLAN tagging and even IPvlan L3 routing for users interested in underlay network integration.
- macvlan: Macvlan networks allow you to assign a MAC address to a container, making it appear as a physical device on your network. The Docker daemon routes traffic to containers by their MAC addresses. Using the macvlan driver is sometimes the best choice when dealing with legacy applications that expect to be directly connected to the physical network, rather than routed through the Docker host’s network stack
- none: Completely isolate a container from the host and other containers. none is not available for Swarm services.
- [Network plugins](https://docs.docker.com/engine/extend/plugins_services/): You can install and use third-party network plugins with Docker.
- for creating network:
  - `$ docker network create —driver=bridge —subnet=192.168.0.0/16 —ip-range=172.28.5.0/24 —gateway=172.28.5.254 172network<name of network>`
- containers will be in this dir, their files are here too: /var/lib/docker/overlay2/containerid
- `$ docker volume ls —> see all volumes`
- `$ docker run -it —name nginx1 -v fisrt_container_vol:/data4 nginx bash —> create volume`
- `$ docker volume create sec_container_vol —> create volume`
- for bind mounting : `$ docker run -it —name nginx1 -v /root/data4/:/data4 nginx bash`
- in Dockerfile
  - difference between add & copy is that add is like wget, it adds stuff from web to our image
  - difference between CMD & ENTRYPOINT is that entrypoint cannot be overwritten

**——————————————————**

**8.Kubernetes**
- k8s supports two kind of containers
  - docker
  - rocketd
- components
  - Master node
    - API server: gate keeper recieve calls, create or delete or modify components
    - kube controller
      - replication controller
      - node controller
      - end point controller
      - service account controller
    - scheduler: decide which pod deploys on which node
    - etcd: all cluster data is stored here
  - worker node
    - kubelet: make sure that pods are working fine in nodes. If things are not going good it informs kube controller and then scheduler will start a new pod
    - kubeproxy: pods use this to communicate within cluster
    - pod: a scheduling unit
    - containers
      - It is possible to have two containers in a pod. for example for log purposes it happens. we have sidecar container / init container which is same
- Kubernetes objects
  - creating yml file for k8s object we want to create
    - apiVersion: version number of k8s API
    - kind: what kind of object want to create
    - metadata: data to help uniquely identify object
    - spec: desired state for the object
- `$ kubectl scale rc (replication controller) nginx —replica=5 —> for scale up / down`
- `kubectl edit rc (replication controller) nginx —> another way to scale up / down`
- RabbitMQ and ElasticSearch use StatefulSet instead of deployment
- DaemonSet deployment is for when fluentd is being deployed as a part of EFK (elastic fluentd kibana)
- in deployment, these deploying methods are available
  - ReCreate: delete old ones & create new ones
  - RollingUpdate: delete old one, create a new one, delete old one, create a new one, … (one at a time)
  - Blue/Green: route traffic to new ones, then delete old ones
  - Canary
- `$ kubectl rollout status deployment nginx-deployment`
- ClusterIP service is used for inside cluster cases, you can access them via there names
- NodePort service is used for external access. range is 30000 to 32767. not being used in prod env
- LoadBalancer service is the default when you want access from outside and you are using cloud. downside is each service gets an ip so its gonna be expensive. LB is accessible by outside via its port
- NameSpaces
  - Default: all NameSpaces that don’t belong public/system
  - kube-public: publicly available/readable by all
  - kube-system: objects/resources created by k8s systems
- ConfigMap: an API object used to store non-confidential data in key-value pairs
- helm (v2.0)
  - has a client side component called helm + a cluster side component called tiller
  - `$ helm create`
- Dir
  - `/charts: dependencies`
  - `chart.yaml: metadata of charts`
  - `templates`
  - `deployment.yaml:`
  - `values.yaml: values of template and out project in general`

**——————————————————**

**8.Prometheus**
- Components
  - server
  - alert manager
  - exporter


# acknowledgment
## Contributors

APA 🖖🏻

## Links


## APA, Live long & prosper
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