# kustomize-iac-skeleton

[Kustomization](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/) Skeleton Repository

* [About](#about)
* [Benefits of using Kustomize](#benefits-of-using-kustomize)
* [Best Practices](#best-practices)
* [Structure](#structure)
* [Usage](#usage)
	- [Build](#build-resources)
	- [Format](#format-yaml-resources)
	- [Lint](#lint-project-resources)
	- [Scan](#security-scan)
	- [Validate](#validate-resources)
* [Contributing](#contributing)
* [Changelog](#changelog)
* [Requirements](#requirements)
* [Maintainers](#maintainers)

## About

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

Below are some of the benefits of Kustomize.

1. **Simplified Configuration Management**:  
Kustomize is easy to use and allows you to manage and customize your Kubernetes configurations in a structured and modular way.

2. **Reusability**:  
Kustomize allows you to reuse one base file across all of your environments (development, staging, production) and then overlay unique specifications for each.

3. **Version Control**:  
Kustomize files are plain text files, so you can use a `git` repository to version control your Kubernetes configurations, making it easier to track changes and roll back to previous versions when necessary.

4. **Template Free**:  
Kustomize provides a solution for customizing Kubernetes resource configuration free from templates and DSLs. Only raw `YAML` files.

5. **Extendability**:  
Kustomize has buil-in transformers to modify resources and It can be extended with a plug-in mechanism.

6. **Easier to Debug**  
YAML itself is easy to understand and debug when things go wrong. Pair that with the fact that your configurations are isolated in patches, and you’ll be able to triangulate the root cause of performance issues in no time. Simply compare performance to your base configuration and any other variations that are running.

## Best Practices

Here are some [Kustomize](https://github.com/kubernetes-sigs/kustomize) best practices:

1. Keep base resources, overlays and patches in separate directories. This helps us to maintain clarity between different configurations.
2. Adhere to Kubernetes best practices.
3. Keep the common resources like `Namespace` resource in the `base` directory.
4. Before deploying your Kustomize IaC, validate It.


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
│   ├── dev
│   │   ├── patches
│   │   ├── replacements
│   │   ├── resources
│   │   └── kustomization.yaml
│   └── pro
│       ├── patches
│       ├── replacements
│       ├── resources
│       └── kustomization.yaml
├── .editorconfig
├── .gitattributes
├── .gitignore
├── CHANGELOG.md
├── CITATION.cff
├── CODE_OF_CONDUCT.md
├── CODEOWNERS
├── CONTRIBUTING.md
├── LICENSE.md
├── Makefile
└── README.md
└── SECURITY.md
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

For build all overlays, you can execute `make build` command. We use [kustomize](https://github.com/kubernetes-sigs/kustomize) tool under the hood.

```shell
make build
```

This command will launch a build process that will build all the overlays present in the `overlays/` directory and store the generated resources in the `config/` directory.

```text
Check for installed tools
 - kustomize [OK]

Build all overlays for the project

Building DEV overlay
 - Create config directory for DEV overlay
 - Running kustomize build on dev overlay


Building PRO overlay
 - Create config directory for PRO overlay
 - Running kustomize build on pro overlay

>>> build process finished <<<
```

### Format YAML resources

You can run code formatters to format YAML files to a standarized format. We use [yamlfmt](https://github.com/google/yamlfmt) tool under the hood.

```shell
make format
```

```text
Check for installed tools
 - yamlfmt [OK]

Running YAML formatters on all resources using yamlfmt
>>> YAML format finished <<<
```

### Lint project resources

You can lint all YAML files to check syntax and correct problems such as lines length, trailing spaces, indentation, etc. We use [yamllint](https://github.com/adrienverge/yamllint) tool under the hood.

```shell
make lint
```

This output will be printed on successful lint.

```text
Check for installed tools
 - yamllint [OK]

Running linters on all resources using yamllint
>>> lint process finished <<<
```

This output will be printed on when lint fails.

```text
Check for installed tools
 - yamllint [OK]

Running linters on all resources using yamllint
./config/pro/apps_v1_deployment_my-awesome-application.yaml
  1:1       warning  found forbidden document start "---"  (document-start)
  56:13     error    trailing spaces  (trailing-spaces)
  95:41     error    no new line character at the end of file  (new-line-at-end-of-file)

>>> lint process finished <<<
```

### Security Scan

You can run security scans on your IaC YAML files to find vulnerabilities and IaC misconfigurations, SBOM discovery, Kubernetes security risks, and much more. 

We use [trivy](https://github.com/aquasecurity/trivy) tool under the hood.

```shell
make scan
```

This output will be printed when no problem is found in your IaC resources.

```text
Check for installed tools
 - trivy [OK]

Running security scan on all resources using trivy
2024-08-16T14:44:00+02:00       INFO    [vuln] Vulnerability scanning is enabled
2024-08-16T14:44:00+02:00       INFO    [misconfig] Misconfiguration scanning is enabled
2024-08-16T14:44:00+02:00       INFO    [secret] Secret scanning is enabled
2024-08-16T14:44:00+02:00       INFO    [secret] If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2024-08-16T14:44:00+02:00       INFO    [secret] Please see also https://aquasecurity.github.io/trivy/v0.54/docs/scanner/secret#recommendation for faster secret detection      
2024-08-16T14:44:01+02:00       INFO    Number of language-specific files       num=0
2024-08-16T14:44:01+02:00       INFO    Detected config files   num=7
>>> security scan finished <<<

```

This output will be printed on when [trivy](https://trivy.dev) founds any issue.

```text
Check for installed tools
 - trivy [OK]

Running security scan on all resources using trivy
2024-08-16T14:44:00+02:00       INFO    [vuln] Vulnerability scanning is enabled
2024-08-16T14:44:00+02:00       INFO    [misconfig] Misconfiguration scanning is enabled
2024-08-16T14:44:00+02:00       INFO    [secret] Secret scanning is enabled
2024-08-16T14:44:00+02:00       INFO    [secret] If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2024-08-16T14:44:00+02:00       INFO    [secret] Please see also https://aquasecurity.github.io/trivy/v0.54/docs/scanner/secret#recommendation for faster secret detection      
2024-08-16T14:44:01+02:00       INFO    Number of language-specific files       num=0
2024-08-16T14:44:01+02:00       INFO    Detected config files   num=7

pro/apps_v1_deployment_my-awesome-application.yaml (kubernetes)

Tests: 95 (SUCCESSES: 94, FAILURES: 1, EXCEPTIONS: 0)
Failures: 2 (UNKNOWN: 0, LOW: 2, MEDIUM: 0, HIGH: 0, CRITICAL: 0)

LOW: Container 'my-app' of Deployment 'my-awesome-application' should set 'securityContext.runAsUser' > 10000
══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Force the container to run with user ID > 10000 to avoid conflicts with the host’s user table.

See https://avd.aquasec.com/misconfig/ksv020
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────
 pro/apps_v1_deployment_my-awesome-application.yaml:51-104
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  51 ┌       - args:
  52 │         - infinity
  53 │         command:
  54 │         - sleep
  55 │         env:
  56 │         - name: APP_NAME
  57 │           value: my-awesome-application
  58 │         - name: POD_NAME
  59 └           valueFrom:
  ..   
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────
>>> security scan finished <<<

```

### Validate resources

To validate the resources generated through the build process with `make validate` command, we use [kubeconform](https://github.com/yannh/kubeconform) tool under the hood.

```shell
make validate
```

This output will be printed on successful validation.

```text
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

```text
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

## Contributing

Please see [CONTRIBUTING.md](https://github.com/angelcamposm/kustomize-iac-skeleton/CONTRIBUTING.md) for more details.

## Changelog

The changelog is available on [CHANGELOG.md](https://github.com/angelcamposm/kustomize-iac-skeleton/CHANGELOG.md).

## Requirements

These are the tools needed to take advantage of the full potential of this skeleton package.

- [kustomize](https://github.com/kubernetes-sigs/kustomize) <sup>(required)</sup>
- [kubeconform](https://github.com/yannh/kubeconform) (Only required if you will validate kubernetes resources with this tool)
- [make](https://www.gnu.org/software/make/) (Only required if you run make commands)
- [python3](https://www.python.org/) (Only required if you run lint over YAML files)
- [trivy](https://github.com/aquasecurity/trivy) (Only required if you run security scans over your IaC generated resources)
- [yamlfmt](https://github.com/google/yamlfmt) (Only required if you run format over YAML files)
- [yamllint](https://github.com/adrienverge/yamllint) (Only required if you run lint over YAML files)

## Maintainers

- 🧑‍💻 Angel Campos Muñoz
