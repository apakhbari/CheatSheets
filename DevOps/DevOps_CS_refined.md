# **DevOps**

**——————————————————**

## Objectives:

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
