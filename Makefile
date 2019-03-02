DOCKER     := /bin/docker
IMAGE_NAME := acch/rpi-icinga
IMAGE_TAG  := latest

BUILDFLAGS := --no-cache --pull

default: build test

build:
	$(DOCKER) build $(BUILDFLAGS) -t $(IMAGE_NAME):$(IMAGE_TAG) .

test:
	$(DOCKER) run --rm $(IMAGE_NAME):$(IMAGE_TAG) --version

push:
	$(DOCKER) login
	$(DOCKER) push $(IMAGE_NAME):$(IMAGE_TAG)
