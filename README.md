<div align="center">
  <br>
  <img src="icinga.png" alt="Icinga logo" width="800" height="289">
  <br>
  <br>
</div>

[![GitHub Issues](https://img.shields.io/github/issues/gazzyt/rpi-icinga.svg)](https://github.com/gazzyt/rpi-icinga/issues) [![GitHub Stars](https://img.shields.io/github/stars/gazzyt/rpi-icinga.svg?label=github%20%E2%98%85)](https://github.com/gazzyt/rpi-icinga/) [![Docker Pulls](https://img.shields.io/docker/pulls/gazzyt/rpi-icinga.svg)](https://hub.docker.com/r/gazzyt/rpi-icinga/) [![License](https://img.shields.io/github/license/gazzyt/rpi-icinga.svg)](LICENSE)

Raspberry Pi-compatible [Icinga](http://docs.icinga.com/latest/en/) Docker image. Includes [SSMTP](https://linux.die.net/man/8/ssmtp) for Email notifications.

This is a fork of [acch/rpi-icinga](https://github.com/acch/rpi-icinga) updated to Debian Buster. This fixes the issue of check_nrpe failing against hosts running Debian Bullseye.

## Building

I didn't use the Makefile from the original project but build under WSL2 via:

    ❯ docker buildx build --platform linux/arm/v7 -t gazzyt/rpi-icinga:latest .

## Usage

Run with plain [Docker](https://docs.docker.com/engine/reference/run):

    # docker run --rm \
      --name icinga
      -p 80:80 \
      -v $(pwd)/etc:/etc/icinga \
      -v icinga_cache:/var/cache/icinga \
      -v $(pwd)/log:/var/log \
      gazzyt/rpi-icinga

Run with [Docker-Compose](https://docs.docker.com/compose/compose-file):

    version: '3'

    services:
      app:
        image: gazzyt/rpi-icinga
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

## Volumes

This image exposes the following volumes:

    /etc/icinga                   Icinga configuration files
    /var/cache/icinga             Icinga state retention and cache files
    /var/log                      Icinga & Apache log files

## Getting Started

Icinga configuration is stored in `/etc/icinga`, which is mounted as a volume to this image. When starting a container from this image for the first time it is necessary to initialize the volume with a default configuration. Run the following commands to copy the default configuration from a temporary container — the resulting `etc` directory can then be mounted as a volume to `/etc/icinga` as shown before:

    # id=$(docker create acch/rpi-icinga)
    # docker cp $id:/etc/icinga etc
    # docker rm -v $id

Icinga does not set any default password for the admin user. Run the following command to define such password:

    # docker exec -it icinga htpasswd -c /etc/icinga/htpasswd.users icingaadmin

## Copyright

Copyright 2017 Achim Christ, released under the [MIT license](LICENSE)
