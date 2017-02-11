DOCKER=/bin/docker
DOCKER_IMAGE_NAME=acch/rpi-icinga
DOCKER_BASE_NAME=resin/rpi-raspbian
DOCKER_BASE_VERSION=jessie

default: build

build:
	$(DOCKER) pull $(DOCKER_BASE_NAME):$(DOCKER_BASE_VERSION) 
	$(DOCKER) build -t $(DOCKER_IMAGE_NAME) .

push:
	$(DOCKER) login
	$(DOCKER) push $(DOCKER_IMAGE_NAME)

test:
	$(DOCKER) run --rm $(DOCKER_IMAGE_NAME) /bin/echo "Success."

