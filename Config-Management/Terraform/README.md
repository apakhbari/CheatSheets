# Teraform

```
 _______  _______  ______    ______    _______  _______  _______  ______    __   __ 
|       ||       ||    _ |  |    _ |  |   _   ||       ||       ||    _ |  |  |_|  |
|_     _||    ___||   | ||  |   | ||  |  |_|  ||    ___||   _   ||   | ||  |       |
  |   |  |   |___ |   |_||_ |   |_||_ |       ||   |___ |  | |  ||   |_||_ |       |
  |   |  |    ___||    __  ||    __  ||       ||    ___||  |_|  ||    __  ||       |
  |   |  |   |___ |   |  | ||   |  | ||   _   ||   |    |       ||   |  | || ||_|| |
  |___|  |_______||___|  |_||___|  |_||__| |__||___|    |_______||___|  |_||_|   |_|
```

**Course: [complete-terraform-course-beginner-to-advanced](https://www.udemy.com/course/complete-terraform-course-beginner-to-advanced/)**
**Course: [Complete Terraform Course - From BEGINNER to PRO! (Learn Infrastructure as Code)](https://www.youtube.com/watch?v=7xngnjfIlK4))**

## Part 1: Evolution of Cloud + Infrastructure as Code
- Three form of Provisioning cloud Resources:
  - GUI
  - API/CLI
  - IaC
- What is Infra as code?
  - Categories of IaC tools:
    1. Ad hoc scripts: a shell svript that is being run in a machine to do a job
    2. Configuration management tools: manage software that is running, more on prem setups since you need to manage what software is installed and how does it configured
    3. Server templating tools: building out a template for what we are going to manage in a server. All VMs are being created from a template, so we can spin several instances of the sae server over & over again
    4. Orchestration Tools: k8s, how to define app deployment
    5. Provisioning Tools
   
## Part 2: Terraform Overview + Setup
- A tool for building, changing, and versioning infra safely and efficiently
- Enables app software best practices to infra
- Compatible with many clouds and services
- It is cloud agnostic, which means it is compatible with many clouds and services , as long as there is an api gateway

Common Patterns
- Provisioning (Terraform) + Config Management (Ansible)
- Provisioning (Terraform) + Server Templating (Packer)
- Provisioning (Terraform) + Orchestration (k8s)

Arcitecture
- Terraform Core
- Terraform State: refrences to all of infra that we provisioned 
- Terraform Config
- Terraform Provider: a middleware between infra and Terraform Core. For every different infra, its provider is also different. For example: Docker, AWS, GKE, Azure, K8s, ...

``` $ teraform init ``` --> initialize within directory where your code is stored
``` $ teraform  plan``` --> query the provider API and compare what is currently deployed vs what is going to be deployed after apply
``` $ teraform  apply``` 
``` $ teraform  destroy``` --> destroy deployment

## Part 3: Basic Terraform Usage
Baic Usage Sequence:
### ``` $ terrafrom init ```
  - Create a .terraform/providers/registry.terraform.io directory which are provider-specific and have data related to how it should be connected
  - Download and store all of terraform modules
### ``` $ terrafrom plan ```
### ``` $ terrafrom apply ```
### ``` $ terrafrom destroy ```

State File:
- Terraform's representation of the world
- JSON file containing information about every resource and data object
- Contains Sensitive Info (e.g. DB password)
- Can be stored locally or remote

Local Backend:
- Pro: Simple to get start
- Con: Sensitive values in plain text - Uncollaborative - Manual

Remote Backend:
- Terraform state File is somewhere else
- Pro: Sensitive values encrypted - collaborative - Automation possible
- Con: Increased Complexity
- There are 2 primary options for Remote BackEnd:
  - Terrafrom cloud: free up to 5 users
    ```
    terraform {
    backend "remote" {
    organization = "devops-directive"
    workspace { name = "terraform-demo"
     }
    }
    }
    ```
  - self hosting
 
## Part 4: Variables and Outputs
Variable Types:
- Input Variable: var.\<name\>
```
variable "instance_type" {
 description = "ec2 instance type"
type = strig
dafault = "t2.micro"
}
```
- Local Variables: local.\<name\>
  - temporary variables within the scope of function
```
locals {
 service_name = "My Service"
owner = "Devops Directive"
}
```
- Output Variables
  - Dynamic Data that is output of another part of configuration
```
output "instance_ip_addr" {
 value = aws_instance.instance.public_ip
}
```

Setting Input Variables: (In order of precedence // lowest --> highest)
- Manual entry during plan/apply
- Default value in declaration block
- TF_VAR_\<name\> environment variable
- terraform.tfvars file (for non-sensitive files)
- *.auto.tfvars file
- Command line -var or -var-file

- If we have more than 1 default tfvars file (terraform.tfvars), by the time we use apply we should use such ``` $ terraform apply -var-file=aditional-file.tfvars ```

Types & Validation:
- Primitive Types:
  - String
  - Number
  - Bool

- Complex Types:
  - list(\<TYPE\>)
  - set(\<TYPE\>)
  - map(\<TYPE\>)
  - object({\<ATTR NAME\> = \<TYPE\>, ...}) 
  - tuple([\<TYPE\>,...])

Validation
- Type checking happens automatically
- Custom conditions can also be enforces

Sensitive Data
- Mark variables as sensitive:
  - Sensitive = true
- Pass to terraform apply with:
  - TV_VAR_variable
  - -var (retrieved from secret manager at runtime)
- Can also use external secret store
  - For example, AWS Secrets Manager 

## Part 5: Additional Language Features (see official docs)
Expressions
- Template Strings
- Operators (!, -, *, /, %, >, ==, etc)
- Conditionals (cond ? true : false)
- For ([for o in var.list : o.id])
- splat (var.list[*].id)
- Dynamic Blocks
- Constraints (Tyeps & Version)

Functions
- Numeric
- String
- Collection
- Encoding
- Filesystem
- Date & Time
- Hash & Crypto
- IP Network
- Type COnversion

Meta-Arguments
- depends_on
  - Terraform automatically generates dependency graph based on references
  - If two resources depend on each other (but not each others data), depends_on specifies that dependency to enforce ordering
  - For example, if software on the instance needs access to S3, trying to create the aws_instance would fail if attempting to create it before the aws_iam_role_policy
- count
  - Allows for creation of multiple resources/modules from a single block
  - Useful when the multiple necessary resources are nearly identical
- For_each
  -  Allows for creation of multiple resources/modules from a single block
  -  Allows more control to customize each resources than count
- Lifecycle
  - A set of meta arguments to control terraform behavior for specific resources
  - create_before_destroy can help with zero downtime deployments
  - ignore_changes prevents Terraform from trying to revert metadate being set elsewhere
  - prevent_destroy causes Terraform to reject any plan which would destroy this resource
 
Provisioners
- Perform action on local or remote machine
  - file
  - local-exec
  - remote-exec
  - vendor
    - chef
    - puppet  

## Part 6: Project Organization + Modules
What is a Module?
- Modules are containers for multiple resources that are used together. A module consists of a collection of .tf and/or .tf.json files kept together in a directory.
- Modules are the main way to package and reuse resource configurations with Terraform.

Types of Modules
- Root Module: Default module containing all .tf files in main working directory
- Child Module: A seperate external module referred to from a .tf file

Module sources
- Local path
```
module "web-app" {
 source = "../web-app"
}
```
- Terraform Registry
```
module "consul" {
 source = "hashicorp/consul/aws"
 version = "0.1.0"
}
```
- Git
```
# HTTPS
module "example" {
 source = "github.com/hashicorp/example?ref=v1.2.0"
}

# SSH
module "example" {
 source = "git@github.com:hashicorp/example.git"
}

# Generic Git Repo
module "example" {
 source = "git::ssh://username@example.com/storage.git "
}
```

Inputs + Meta-arguments
- Input variables are passed in via module block
```
module "web_app"{
  source = "../web-app-module"

# INPUT VARIABLES
bucket_name = "devops-directive-web-app-data"
domain = "mysuperawesomesite.com"
db_name = "mydb"
db_user = "foo"
db_pass = var.db_pass
```

What makes a Good Module?
- Raises the abstraction level from base resource types
- Groups resources in a logical fashion
- Exposes input variable to allow necessary customization + composition
- Provides useful defaults
- Returns outputs to make further integrations possible
  
## Part 7: Managing Multiple Environments
Two Main Approaches
- Workspaces
  - Multiple named sections witin a single backend 
- File Structure (having sub-directories)
  - Directory layout provides separation, modules provide reuse

Terraform worksapces
- Pros
  - Easy to get started
  - Convenient terrafrom.workspace expression
  - Minimizes Code Duplication
- Cons
  - Prone to human error
  - State stored within same backend
  - Codebase doesn't unambiguoslyshow deployment configurations
 
File Structure
- Pros
  - Isolation of backends
    - Improved security
    - Decreased potential for human error
  - Codebase fully represents deployed state
- Cons
  - Multiple terraform apply required to provision environments
  - More code duplication, but can be minimized with modules
 
- Further seperation (at logical component groups) useful for larger projects
  - Isolate things that changefrequently from those which don't
- Referencing resources across configuration is possible using terraform_remote_state

Terragrunt
- Tool by gruntwork.io that provides utilities to make certain Terraform use cases easier
- Keeping Terraform cod DRY
- Executing commands across multiple RF configs
- Working with multiple cloud accounts


## Part 8: Testing Terraform Code
Code Rot
- Out of band changes
- Unpinned versions
- Deprecated dependencies
- Unapplied changs

Static checks
- Built in
  - $ terraform fmt
  - $ terraform validate
  - $ terraform plan
  - custom validation rules
- External
  - tflint
  - checkov, tfsec, terrascan, terraform-compliance, synk
  - Terraform sentinal (enterprise only)
 
- Automated Testing with Terratest
- Periodically excute $ terraform plan , and monitor its output

## Part 9: Developer Workflows and Automation
- gruntwork-io/cloud-nuke --> a tool to easy cleanupof cloud resources



# acknowledgment
## Contributors

APA 🖖🏻

## Links
https://github.com/sidpalas/devops-directive-terraform-course
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
