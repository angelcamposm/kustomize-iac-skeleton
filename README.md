# kustomize-iac-skeleton

[Kustomization](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/) Skeleton Repository

This repository provides a foundational structure for Kubernetes deployments, serving as a starting point for rapid application deployment. It includes a pre-configured Kustomization overlay with essential resources like Deployments, Services, ConfigMaps, and Secrets, providing a solid base for building complex applications.

Think of this as a "skeleton" of your [Kubernetes](https://kubernetes.io) infrastructure, ready to be fleshed out with your specific application requirements. Customize and extend the provided resources to match your application needs without starting from scratch.

By leveraging this repository, you can significantly accelerate your deployment cycles while maintaining consistency and best practices.

Key Features:

- Pre-configured Kustomization overlay
- Essential Kubernetes resource templates
- Flexible and customizable structure
- Clear documentation and examples
- Promotes best practices for Kubernetes deployments

## Benefits of using Kustomize

1. **Reusability**  
Kustomize allows you to reuse one base file across all of your environments (development, staging, production) and then overlay unique specifications for each.

2. **Fast Generation**  
Since Kustomize has no templating language, you can use standard YAML to quickly declare your configurations.

3. **Easier to Debug**  
YAML itself is easy to understand and debug when things go wrong. Pair that with the fact that your configurations are isolated in patches, and you’ll be able to triangulate the root cause of performance issues in no time. Simply compare performance to your base configuration and any other variations that are running.

## Structure

```text
.
├── base
│   ├── resources
│   └── kustomization.yaml
├── components
├── config
│   └── dev
├── overlays
│   └── dev
│       ├── patches
│       ├── replacements
│       ├── resources
│       └── kustomization.yaml
├── .editorconfig
├── .gitignore
├── CHANGELOG.md
├── CITATION.cff
├── CODEOWNERS
├── CONTRIBUTING.md
├── LICENSE.md
├── Makefile
└── README.md
```

### base

Specifies the most common resources for the project.

As a good practice, the `base` layer can't contains any patches.

### components

The `components` directory contains any [Kustomize component](https://kubectl.docs.kubernetes.io/guides/config_management/components/) that is agnostic from any environment and adds capabilities for an specific environment.

Any component created inside this directory, can be referenced using `components` node in the Kustomization file in any overlay.

### config

The `config` directory in the root of the project, holds each of the layers and resources generated in the build process with the `make build` command. 

Each of the layers in this directory gives us an idea of the final result of the build process and allows us to review what will be applied using the `kubectl apply -k config/<overlay>` command.

###  overlays

The `overlays` directory holds environment-specific settings. Within this directory there are as many overlays as required environments.

In an overlay, there are 3 directories:

- patches
- replacements
- resources

#### patches

The `patches` directory holds any file that can add or override fields on resources.

Any file created inside this directory, can be referenced using `patches` node in the Kustomization file.

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

patches:
  - path: patches/update-revision-history-limit-patch.yaml
    target:
      group: apps
      kind: Deployment
      version: v1
```

#### replacements

The `replacements` directory holds any file that are used to copy fields from one source into any number of specified targets.

Any file created inside this directory, can be referenced using `replacements` node in the Kustomization file.

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

replacements:
  - replacements/update-revision-history-limit-patch.yaml
```

#### resources

The `resources` directory holds any new resource that must be included in the overlay.

Any file created inside this directory, can be referenced using `resources` node in the Kustomization file.

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - resources/pvc.yaml
```


## Usage

### Build resources

For build all resources in all overlays, you can use make.

```shell
make build
```

This will build all overlays and output the resulting resources to `config/` directory.

### Validate resources

To validate the resources generated through the build process with `make validate` command, we use [kubeconform](https://github.com/yannh/kubeconform) tool under the hood.

```shell
make validate
```

This output will be printed on successful validation.

```
Check for installed tools
 - kubeconform [OK]

Validating all resources using Kubeconform
 - DEV

Validating DEV overlay resources
{
  "resources": [],
  "summary": {
    "valid": 4,
    "invalid": 0,
    "errors": 0,
    "skipped": 0
  }
}
```

This output will be printed on failed validation.

```
Check for installed tools
 - kubeconform [OK]

Validating all resources using Kubeconform
 - DEV

Validating DEV overlay resources
{
  "resources": [
    {
      "filename": "config/dev/apps_v1_deployment_my-awesome-application.yaml",
      "kind": "Deployment",
      "name": "my-awesome-application",
      "version": "apps/v2",
      "status": "statusError",
      "msg": "could not find schema for Deployment"
    }
  ],
  "summary": {
    "valid": 3,
    "invalid": 0,
    "errors": 1,
    "skipped": 0
  }
}
```

## Requirements

These are the tools needed to take advantage of the full potential of this skeleton package.

- [kustomize](https://github.com/kubernetes-sigs/kustomize) <sup>(required)</sup>
- [kubeconform](https://github.com/yannh/kubeconform) (Only required if you will validate kubernetes resources with this tool)
- [make](https://www.gnu.org/software/make/) (Only required if you run make commands)

## Maintainers

- 🧑‍💻 Angel Campos Muñoz