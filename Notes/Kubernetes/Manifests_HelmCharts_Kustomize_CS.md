# Manifests, Helm Charts and Kustomize

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
