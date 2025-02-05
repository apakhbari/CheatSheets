# Tekton
```
 _______  _______  ___   _  _______  _______  __    _ 
|       ||       ||   | | ||       ||       ||  |  | |
|_     _||    ___||   |_| ||_     _||   _   ||   |_| |
  |   |  |   |___ |      _|  |   |  |  | |  ||       |
  |   |  |    ___||     |_   |   |  |  |_|  ||  _    |
  |   |  |   |___ |    _  |  |   |  |       || | |   |
  |___|  |_______||___| |_|  |___|  |_______||_|  |__|
```

## About Tekton
- Tekton pipelines are built from separate containers that are sequenced via internal Kubernetes events on the K8 API server. They are an example of the event-driven choreography sequencing type. There is no single process manager to lock up, get restarted, hog resources or otherwise fail. Tekton will allow each pod to instantiate when it is needed in order to perform whatever stage of pipeline process that it’s responsible for. When it finishes, it will shut down, freeing up the resources it used for something else
- Tekton integrates from the ground up with the Kubernetes API and security model and strongly encourages loose coupling/reuse. It is event-driven, following the choreography model, so it’s good for controlling the long-running testing-type process. The pipeline artifacts are just additional Kubernetes resources—pod definitions, service accounts, secrets, etc.—that can easily lend themselves to the world of everything-as-code, aligned with the rest of the k8-type ecosystem.
- Tekton is declarative in its nature

## Tips
- Tekton allows you to run CI/CD processes on same cluster as your apps.
- It has two main components: 1- Tasks 2- Pipelines
- Step = smallest building block of Tekton, steps are where you can specify your commands and arguments and images to process.
- A Task consisted of 1 or more steps. Each Task runs in a Pod. Tasks are reusable in whole projects, just bey mentioning its name
- A pipeline is for further organizing of Tasks, by controlling the execution of tasks
- Inputs & Outputs are pipeline resources. You can define them.
- A pipelineRun run triggers on pipeline and you can declare it in triggertemplate. Triggers let you detect and extract information from events that have happened
- Each component is a yaml file
- Tekton is object oriented, modular, very easy to reuse
- Service accounts handle secrets, authentication and autorization
- Tekton runs credential on each pod, so your process is very secure

## Jenkins VS Tekton
- Jenkins is good on VMs, while Tecton is cloud native and easily scalable
- Jenkins is Java based, so you need plugins for other use cases
- Jenkins use a big large configuration jenkins file, Tecton organizes its each component into a single file so its easy to organize it
- Jenkins functions could be more complex, you can have functions to export
- Jenkins use a Jenkins Home directory, while Tecton uses PVC --&gt; Tecton could be very portable in cloud

---


# acknowledgment
## Contributors

APA 🖖🏻

## Links
- <https://www.redhat.com/en/blog/tekton-vs-jenkins-whats-better-cicd-pipelines-red-hat-openshift>


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