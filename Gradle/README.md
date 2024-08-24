# Gradle

```
 _______  ______    _______  ______   ___      _______ 
|       ||    _ |  |   _   ||      | |   |    |       |
|    ___||   | ||  |  |_|  ||  _    ||   |    |    ___|
|   | __ |   |_||_ |       || | |   ||   |    |   |___ 
|   ||  ||    __  ||       || |_|   ||   |___ |    ___|
|   |_| ||   |  | ||   _   ||       ||       ||   |___ 
|_______||___|  |_||__| |__||______| |_______||_______|
```

# Table of Contents

# Theoretical
## Introduction
- Manually compiling java (using javac) is really hard, compiling tools exists to make compiling simple, error free and repeatable.
- Build tools make testing & packaging possible
- Gradle has **incremental build** which means you don't need to recompile app if nothing has changed from last build
- Gradle has a very advanced dependency management
- Gradl Project: highest-level construct representing the application you want to build, including the configuration of how to build it. So if you've got an application's source code sitting in a repository, an accompanying Gradle project also gets commited into the repository with all the information needed to build the application

## Components
- Projects: highest level, a container for all gradle things
- build scripts
- tasks: Individual gradle tasks that can be done using command line
- plugins: a series of defined tasks

## Maven VS Gradle
- Gradle use a code-based approach for build script rather than maven's XML-based approach
- gradle is faster than maven

## Gradle init
- for starting a gradle project, you are being asked these questions

1- Type of project:
- basic
- app
- library
- gradle plugin

2- build script DSL
- Groovy
- Kotlin

3- Project Name


## Files
- settings.gradle --> high-level setting for project, i.e. Project's name
- build.gradle --> build script configuration file
- gradlew --> wrapper for linux and mac enviornments, makes using gradle without installing it. When executed, it cache gradle locally.
- gradlew.bat --> wrapper for Windows enviornments, makes using gradle without installing it. When executed, it cache gradle locally.


## Groovy DSL
- runs on jvm
- script-based language

## Commands
- ``` $ gradlew tasks ``` --> a list of available tasks for this project 

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