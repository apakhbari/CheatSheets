# GitLab-CI
```
   _____ _ _   _           _            _____ _____ 
  / ____(_) | | |         | |          / ____|_   _|
 | |  __ _| |_| |     __ _| |__ ______| |      | |  
 | | |_ | | __| |    / _` | '_ \______| |      | |  
 | |__| | | |_| |___| (_| | |_) |     | |____ _| |_ 
  \_____|_|\__|______\__,_|_.__/       \_____|_____|
```

```$ tree | grep .mp4 | sed -r 's/^.{4}//' | rev |  cut -c5- | rev | ts "##"```
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
06:59



# 4. Artifacts with Nodejs Application
# 5. GitLab Runners and Installation
# 6. Run Pipelines using Local Runners
# 7. Variables in GitLab CICD
# 8. Project - Requirements & Setup (Python Application)
# 9. Project - Create GitLab CI Pipeline
# 10. Project - Create GitLab CD Pipeline (Deployment to Heroku)
# 11. Static Environments in GitLab CICD
# 12. Dynamic Environments in GitLab CICD
# 13. Stop Dynamic Environments
# 14. Miscellaneous
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
