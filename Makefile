# define shell where command are run to improve reproducibility
SHELL := /bin/bash

# PROJECT_NAME defaults to name of the current directory.
# should not to be changed if you follow GitOps operating procedures.
PROJECT_NAME := $(notdir $(CURDIR))

# docker variables
BASE_ARCH ?= amd64
BASE_DISTRO ?= debian
BASE_VERSION ?= 10
SERVICE_TARGET ?= main

# define default command
.DEFAULT_GOAL: help

# export arguments to be used by docker (docker-compose and dockerfile)
export PROJECT_NAME
export BASE_ARCH
export BASE_DISTRO
export BASE_VERSION

.PHONY: help

#help:	@ List available tasks on this project
help:
	@grep --extended-regexp '[a-zA-Z0-9\.\-]+:.*?@ .*$$' Makefile | tr --delete '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: env.login env.service env.build env.prune

#env.login: @ run as a service and attach to it
env.login: env.service
	docker exec --interactive --tty $(PROJECT_NAME)_$(BASE_ARCH)-$(BASE_DISTRO)-$(BASE_VERSION) bash

#env.service: @ run as a (background) service
env.service:
	docker-compose --project-name $(PROJECT_NAME)_$(BASE_ARCH)-$(BASE_DISTRO)-$(BASE_VERSION) up --detach $(SERVICE_TARGET)

#env.build: @ build the container
env.build:
	docker-compose build $(SERVICE_TARGET) 

#env.prune: @ clean all that is not actively used
env.prune:
	docker system prune --all --force
	#TODO: remove also image, docker images rm

.PHONY: build

#build: @ Build project src code
build:
	cargo build
