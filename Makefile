#!/usr/bin/make -f

KUBECONFORM_TOOL := $(shell command -v kubeconform)
KUSTOMIZE_TOOL := $(shell command -v kustomize)
YAMLFMT_TOOL := $(shell command -v yamlfmt)
YAMLLINT_TOOL := $(shell command -v yamllint)

.PHONY: help build clean

help:
	@echo
	@echo "Please use 'make <target>' where <target> is one of"
	@echo
	@echo "  build       to build an overlay"
	@echo "  clean       to clean a config generated overlay"
	@echo "  format      to apply formatters to generated resources"
	@echo "  lint        to lint YAML files"
	@echo "  validate    to validate a previously generated resources"
	@echo

build: check-kustomize
	$(info Build all overlays for the project)
	@for directory in `ls -L overlays`; \
		do \
			echo; \
			echo "Building $${directory^^} overlay"; \
			if [[ ! -d "config/$${directory}" ]]; \
				then \
					echo " - Create config directory for $${directory^^} overlay"; \
					mkdir -p config/$${directory}; \
				fi \
				; \
			echo " - Running kustomize build on $${directory} overlay"; \
			kustomize build overlays/$${directory} --output config/$${directory} --load-restrictor LoadRestrictionsNone; \
			echo; \
		done
	@echo ">>> build process finished <<<"
	@echo

clean:
	$(info Cleaning all resources generated for the following overlays:)
	@for directory in `ls -L overlays`; \
		do \
			echo " - $${directory^^}"; \
		done
	@echo
	@for directory in `ls -L overlays`; \
		do \
			echo "Cleaning $${directory^^}"; \
			rm --recursive --force config/$${directory}/*; \
		done
	@echo ">>> clean process finished <<<"
	@echo

format: check-yamlfmt
	$(info Running YAML formatters on all resources using yamlfmt)
	@yamlfmt
	@echo ">>> YAML format finished <<<"
	@echo

lint: check-yamllint
	$(info Running linters on all resources using yamllint)
	@yamllint --format colored . || true
	@echo ">>> lint process finished <<<"
	@echo

validate: check-kubeconform
	$(info Validating all resources using Kubeconform)
	@for directory in `ls -L overlays`; \
		do \
			echo " - $${directory^^}"; \
		done
	@echo
	@for directory in `ls -L overlays`; \
		do \
			echo "Validating $${directory^^} overlay resources"; \
			kubeconform -summary -output json config/$${directory}/; \
		done
	@echo ">>> validation process finished <<<"
	@echo

# Check if kubeconform is installed
#
ifeq ("$(KUBECONFORM_TOOL)", "")
check-kubeconform: tools-check
	$(info You must install Kubeconform before validating)
	$(info Please visit: "https://github.com/yannh/kubeconform/releases")
	$(error Missing tool kubeconform)
else
check-kubeconform: tools-check
	@echo " - kubeconform [OK]"
	@echo
endif

# Check if kustomize is installed
#
ifeq ("$(KUSTOMIZE_TOOL)", "")
check-kustomize: tools-check
	$(info You must install Kustomize before building)
	$(info Please visit: "https://github.com/kubernetes-sigs/kustomize/releases")
	$(error Missing tool kustomize)
else
check-kustomize: tools-check
	@echo " - kustomize [OK]"
	@echo
endif

# Check if yamlfmt is installed
#
ifeq ("$(YAMLFMT_TOOL)", "")
check-yamlfmt: tools-check
	$(info You must install yamlfmt before formating any YAML file)
	$(info Please visit: "https://github.com/google/yamlfmt")
	$(error Missing tool yamlfmt)
else
check-yamlfmt: tools-check
	@echo " - yamlfmt [OK]"
	@echo
endif

# Check if yamllint is installed
#
ifeq ("$(YAMLLINT_TOOL)", "")
check-yamllint: tools-check
	$(info You must install yamllint before linting)
	$(info Please visit: "https://github.com/adrienverge/yamllint")
	$(error Missing tool yamllint)
else
check-yamllint: tools-check
	@echo " - yamllint [OK]"
	@echo
endif

tools-check:
	$(info Check for installed tools)