# rpi-icinga

[![GitHub Issues](https://img.shields.io/github/issues/acch/rpi-icinga.svg)](https://github.com/acch/rpi-icinga/issues) [![GitHub Stars](https://img.shields.io/github/stars/acch/rpi-icinga.svg?label=github%20%E2%98%85)](https://github.com/acch/rpi-icinga/) [![Docker Pulls](https://img.shields.io/docker/pulls/acch/rpi-icinga.svg)](https://hub.docker.com/r/acch/rpi-icinga/) [![License](https://img.shields.io/github/license/acch/rpi-icinga.svg)](LICENSE)

Raspberry Pi-compatible [Icinga](http://docs.icinga.com/latest/en/) Docker image. Includes [SSMTP](https://linux.die.net/man/8/ssmtp) for Email notifications.

## Usage

Run with plain [Docker](https://docs.docker.com/engine/reference/run):

```
# docker run --rm \
  --name icinga
  -p 80:80 \
  -v $(pwd)/etc:/etc/icinga \
  -v icinga_cache:/var/cache/icinga \
  -v $(pwd)/log:/var/log \
  acch/rpi-icinga
```

Run with [Docker-Compose](https://docs.docker.com/compose/compose-file):

```
version: '3'

services:
  app:
    image: acch/rpi-icinga
    container_name: icinga
    ports:
      - "80:80"
    volumes:
      - ./etc:/etc/icinga
      - cache:/var/cache/icinga
      - ./log:/var/log
    restart: always

volumes:
  cache:
    driver: local
```

## Volumes

This image exposes the following volumes:

```
/etc/icinga                   Icinga configuration files
/var/cache/icinga             Icinga state retention and cache files
/var/log                      Icinga & Apache log files
```

## Getting Started

Icinga configuration is stored in `/etc/icinga`, which is mounted as a volume to this image. When starting a container from this image for the first time it is necessary to initialize the volume with a default configuration. Run the following commands to copy the default configuration from a temporary container &mdash; the resulting `etc` directory can then be mounted as a volume to `/etc/icinga` as shown before:

```
id=$(docker create acch/rpi-icinga)
docker cp $id:/etc/icinga etc
docker rm -v $id
```

Icinga does not set any default password for the admin user. Run the following command to define such password:

```
# docker exec -it icinga htpasswd -c /etc/icinga/htpasswd.users icingaadmin
```

## Copyright

Copyright 2017 Achim Christ, released under the [MIT license](LICENSE)
