 # GitLab-CI
```
   _____ _ _   _           _            _____ _____ 
  / ____(_) | | |         | |          / ____|_   _|
 | |  __ _| |_| |     __ _| |__ ______| |      | |  
 | | |_ | | __| |    / _` | '_ \______| |      | |  
 | |__| | | |_| |___| (_| | |_) |     | |____ _| |_ 
  \_____|_|\__|______\__,_|_.__/       \_____|_____|
```

``` $ tree | grep .mp4 | sed -r 's/^.{4}//' | rev |  cut -c5- | rev | sort -n | ts "##" ```


**Course: https://www.udemy.com/course/gitlab-cicd-course/**

## Table of Contents:


**1. Crash Course on CICD concept**
**2. Getting Started with GitLab**
**3. Create First Pipeline**
**4. Artifacts with Nodejs Application**
**5. GitLab Runners and Installation**
**6. Run Pipelines using Local Runners**
**7. Variables in GitLab CICD**
**8. Project - Requirements & Setup (Python Application)**
**9. Project - Create GitLab CI Pipeline**
**10. Project - Create GitLab CD Pipeline (Deployment to Heroku)**
**11. Static Environments in GitLab CICD**
**12. Dynamic Environments in GitLab CICD**
**13. Stop Dynamic Environments**
**14. Miscellaneous**
**15. Additional Learnings**



# 1. Crash Course on CICD concept
## What is CICD
- CI/CD is a method to frequently deliver apps to customers by introducing automation into the stages of software development
- We try to automate every possible stage of a software development cycle to minimize human intervention, thus, minimize the risk of errors
- Ci/CD makes the building and deploying of software easier, even a developer can make a code change live in prod
- CI/CD is a practice, set of operating principles that needs to be adopted in work culture

## CICD terms Unwrapped
- CI: Countinous Integration
   - Start: Adopting countinous integration practice is the first move towards delivering a high-quality software
   - Requires: requires developers to integrate their code into a central shared code repo, such as git, multiple times a day
   - Automation: Each check-in in the main code is verified by automated builds and tests that runs on some CI server
   - Goal:
      - Find and address bugs quickly
      - Improve software quality
      - Reduce the time it takes to validate and release new software updates

- CD: Countinous Delivery
 - Goal: A deployment-ready build software that hass passed through a standardized test process
 - Automated Releases: Artifacts produced by CI server are deployed to the test or staging server with just a singe click
 - Fast Deliveries: Build, Test and Release software with greater speed and frequency
 - Visibility: Makes it possible to continuosly adapt software in line with user feedback

- CD: Countinous Deployment
   - Final: Final stage of automating software development process
   - Automated Deployment: Softwares are deployed frequently in the end market through automated deployment systems
 
- Countinous Delivery vs Countinous Deployment: in Countinous Delivery although software holds potential to get release, but doing so would require approval and intervention of human

## 3.Software Development Lifecycle (SDLC)
- SDLC: a systematic process used by software industry for building the high-quality software

- Planning --> Defining --> Designing --> Building --> Testing --> Deployment 


## 4. Conventional SDLC approach (without CICD)
## 5. Drawbacks of Conventional SDLC approach
## 6. Adapting CICD work culture
- Test --> Build --> Deliver --> Release

# 2. Getting Started with GitLab

## 1. What is GitLab
- a web-based complete DevOps platform, that spans the entire software development lidecycle and helps teams to accelerate DevOps adoption
- Enables professionals to perform all tasks in a project - project planning, source code management, monitoring and security
- Gitlab is not a monolithic application; it believes a software module should do only one particular thing, and do it well.
- Provides a Git-repository manager for issue-tracking, CI & CD
- Supports both public and private development branches with gree and paid options
- Is updated every 22-nd day of month

## 2. Create first Project
## 3. GitLab UI Tour
## 4. Virtual Machine Installation


# 3. Create First Pipeline

## 1. Setting up Git Branches - Part 1
- ``` $ git branch ``` --> shows branches. green one is currenytly checked in
- ``` $ git branch <BRANCH_NAME> ``` --> create new branch, not check in to new branch
- ``` $ git checkout <BRANCH_NAME> ``` --> navigate to another branch

## 2. Setting up Git Branches - Part 2
- ``` $ git status ``` --> show status
- ``` $ git add <FILE_NAME> ``` --> add file to staging area, to include in next commit
- ``` $ git commit -m "COMMIT_MESSAGE" ``` --> commit locally
- ``` $ git push ``` --> push changes

## 3. What is Pipeline
- Pipelines are the top-level component of countinous integration, delivery and deployment
- Pipeline comprises of two things: Jobs & Stages
   - Job: defines what to do. EX: A job to test the code
   - Stage: Collection of jobs, It defines the order of jobs 
- If all jobs in a stage succeed, the pipelinemoves on the next stage.
- If any job in a stage fails, the next stage is not (usually) executed and the pipeline ends early
- Pipelines are executed automatically and requires no intervention once created.
- GitLab also allows you to manually interact with a pipeline
- Four usual stages of CI/CD pipeline:
1. Test
2. Build
3. Stage
4. Prod

- Multi types of pipeline can be build:
1. Basic Pipeline
2. DAG Pipeline
3. Parent-Child Pipeline
4. Multi-project Pipeline
5. etc

## 4. Write First Pipeline
Prerequisits:
1. App Code must be in a repo
2. Define .gitlab-ci.yml file in root of repo

File: 3- Simple Pipeline > .gitlab-ci.yml
## 5. Pipeline Execution Logs Explained

# 4. Artifacts with Nodejs Application

## 1. Creating Nodejs Application

## 2. Writing GitLab Pipeline
- If You write a series a jobs, they will start parallelly by default . Order of jobs does not matter

## 3. Stage & Stages in a Pipeline
- Stage vs Stages are very different things:
   - stage: keyword is used in a job to define which stage that job is part of.
   - stages: define the order of execution of jobs or group of jobs. Is global in all pipeline
- If a job does not specify a stage, the job is assigned the *test* stage.
- Jobs in the same stage run in parallel.
- Jobs in the next stage run after the jobs from the previous stage complete successfully
- Gitlab has 5 default stages, which execute in the below order, so you don't need to assign them to a stages section in order to run after each other:
1. .pre
2. build
3. test
4. deploy
5. .post

- You can not change order of pre / post jobs.

## 4. Writing GitLab Pipeline Continued
- Artifacrs: Job Artifacts are a list of files and directories created by a job once it finishes
- Artifacts expiry date is by default 30 days.

## 5. Running Jobs in Background
- Default execution time before returning an error is 1 hour.
- In servers, deploy job will never finishes since its nature is to listen on a certain port. After 1 hour it is going to be finished as failed.
- add ```  > /dev/null 2>&1 & ``` to end of a script line in order to send it to background

## 6. Optimizing the Pipeline
- Gitlab by default runs a ruby image.
- assign right docker  image to each job.

# 5. GitLab Runners and Installation

## 1. Introduction to GitLab Runners
- An Application that works with Gitlab CI/CD to pick and execute CI/CD jobs.
- Open-Source and written in Go language.
- You can add or remove runners into your GitLab architecture.
- GitLab offers several shared runners available to every project in a GitLab instance.
- Gitlab runner application can be installed on infrastructure that you own or manage.

## 2. Shared GitLab Runners
- Each share runner has sets of tags assigned to it, so its work is pre-determind.
- Pending job means all runners with related tags are in use, so you have to wait so that those runners are being finished and can pick up your new job.
- It is possible to assign a job to a specific runner via [tag: ] 

## 3. Installing GitLab Runner (Things to keep in mind)
- Should install GitLab Runner on a machine seperate from the one that hosts GitLab instance.
- Runner can be installed on an os that can compile a Go library.
- Runners are created by an administrator and are visible in the GitLab UI.
- Gitlab Runner should be of the same version as Gitlab.
- After Application installation, register individual runners.
- When you register a runnerm, you must choose an executer.

## 4. Install GitLab Runner in Local Machine

# 6. Run Pipelines using Local Runners

## 1. Create Python App & Dockerfile
## 2. Write GitLab Pipeline
## 3. Run the Pipeline locally
- add gitlab-runner to docker group ```$ sudo usermod -aG docker gitlab-runner ```

## 4. Improvising the Pipeline

# 7. Variables in GitLab CICD

## 1. What are GitLab CICD Variables
- Variables store information
- For security & reusability
- Variables help to maintain consistency of the code
- CI/CD variables are a useful way to customize pipelines based on their environment.
- Two ways to use variables:
   - Predifined set of CI/CD variables
   - Create your own custom variables

## 2. Predefined GitLab Variables
https://docs.gitlab.com/ee/ci/variables/predefined_variables.html

## 3. Create Custom Variables
- Variables section is globally, you can override a variable inside a specific job

## 4. Secret Variables in GitLab
- General > CI/CD > Variables > Add Variable [maintainer users only can do this]

## 5. Pipeline Continued

# 8. Project - Requirements & Setup (Python Application)

## 1. Project Requirements
## 2. Designing Project Workflow
## 3. How to add SSH keys in GitLab
## 4. Create Model for Python App
## 5. Create Front-end for Python App
## 6. Writing the Application Logic

# 9. Project - Create GitLab CI Pipeline

## 1. Lint Tests with Flake8
- Lint Test: a technique of automated checking for any programmatic and stylistic errors. Like importing a library that's not used in code

## 2. Add Lint Tests in Pipeline
- In order for our test job to keep artifact by the time test is not passed, we use ``` when: always ``` in artifact section

## 3. Write Smoke Tests using pytest
## 4. Write Unit Tests using pytest 
## 6. Add Testing Stage in Pipeline
## 8. Writing Dockerfile to Build Project Image
## 9. Adding Build Stage in Pipeline
## 10. Push Docker Image to GitLab Container Registry
- Gitlab Container Registry:
 - Introduced in GitLab c 8.8
 - Open-Source
 - Secure and private registry for storing Docker images
 - Requires no additional installation
 - Free to use
- To push image to GitLab Registry: <Registry URL>/<namespace (=Username)>/<project>/<image>
 - Best practice: $CI_REGISTRY_IMAGE/project-image:$CI_COMMIT_REF_SLUG
 - registry.gitlab.com/username/project:mytag
 - registry.gitlab.com/username/project/myimage:mytag
 - registry.gitlab.com/username/project/my/image:mytag

- For authentication of registry: Create Token with scope of read_registry + write_registry

- Docekr images are two kinds: 1-Docekr stable client 2-Dind (docker in docker) --> Docekr stable client has everything thats needed to connect to a docekr daemon. If you want to have more daemon side work, you need to use dind (docker in docker) service.
- For Build / Push Docker images inside CI/CD jobs you need to use Dind (docker in docker)

# 10. Project - Create GitLab CD Pipeline (Deployment to Heroku)

## 1. Different Deployment Options
## 2. Getting Started with Heroku
## 3. Deploy to Staging Environment
## 4. Deploy to Staging Environment Continued
## 5. Automated Testing in Pipeline
## 6. Assignment
## 8. Deploy to Production Environment
## 9. Controlling the Production Deployments
- With use of only condition, you can specify when a job is going to be done.For example to only execute in main branche:
- only: - main
## 10. Running the Final CICD Pipeline

# 11. Static Environments in GitLab CICD

## 1. Enhancing the Pipeline Workflow
## 2. What are Environments & Deployments in GitLab
- Environmets describe where the code is deployed.
- Each time Gitlab CI/CD deploys a version of code to an environmet, a deployment is created.
- You can control the CD of your software all within Gitlab by defining yhem in projects .gitlab-ci.yml
- Deployments are created when jobs deploy versions of code to environments, so every environment can have one or more deployments
- With adding environments, you can always know what is currently being deployed on your servers
- Gitlab provides a full history of deployments per every environment.
- Create environments from:
1. Gitlab UI
2. IN project

## 3. Adding Static Environments in Pipeline
## 4. Rollback Deployments

# 12. Dynamic Environments in GitLab CICD
# 13. Stop Dynamic Environments

# 14. Miscellaneous
## 1. CI Lint Tool in GitLab
- In top right of pipeline, for checking syntax errors of pipeline itself

## 2. How to Schedule Pipelines
- CI/CD > Schedules
- can run a pipeline on cuncurrent based jobs
- min interval on 2 pipelines is 60 minutes

## 3. Timeout in GitLab
- The maximum amount of time in that a job is able to run
- Types:
 - Job-level
 - Runner-specific
 - Project-level

- If both job level and project level timeout is specified; the jobs for which job level timeout is sesified will come under the job level timeout and the rest one will follow the projcet level timeout.
- THe job-level timeout can exceed the project-level timeout but can't exceed the Runner-specific timeout.
- If the job surpasses the threshold time, it is marked as failed.
- Default timeout is set to 1 hour by Gitlab.
- Project-level --> For In UI: Settings > CI/CD > General Pipelines > Timeout
- Job-level --> specify in gitlab-ci.yml
 
# 15. Additional Learnings
 
# acknowledgment
## Contributors

APA 🖖🏻

## Links


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
