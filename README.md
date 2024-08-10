# kustomize-iac-skeleton

Kustomization Skeleton Repository

This repository provides a foundational structure for Kubernetes deployments, serving as a starting point for rapid application deployment. It includes a pre-configured Kustomization overlay with essential resources like Deployments, Services, ConfigMaps, and Secrets, providing a solid base for building complex applications.

Think of this as a "skeleton" of your Kubernetes infrastructure, ready to be fleshed out with your specific application requirements. Customize and extend the provided resources to match your application's needs without starting from scratch.

By leveraging this repository, you can significantly accelerate your deployment cycles while maintaining consistency and best practices.

Key Features:

- Pre-configured Kustomization overlay
- Essential Kubernetes resource templates
- Flexible and customizable structure
- Clear documentation and examples
- Promotes best practices for Kubernetes deployments

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

### components

### config

### overlays

- **patches**:
- **replacements**:
- **resources**:

## Maintainers

- 🧑‍💻 Angel Campos Muñoz