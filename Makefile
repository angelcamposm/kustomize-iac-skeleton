#!/usr/bin/make -f

.PHONY: help build clean 

help:
	@echo "Please use 'make <target>' where <target> is one of"
	@echo "  build       to build an overlay"
	@echo "  clean       to clean a config generated overlay"

build:
	@echo "Build all overlays for the project"
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

clean:
	@echo "Cleaning all resources generated for the following overlays:"
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
	