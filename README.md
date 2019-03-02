# rpi-icinga

[![GitHub Issues](https://img.shields.io/github/issues/acch/rpi-icinga.svg)](https://github.com/acch/rpi-icinga/issues) [![GitHub Stars](https://img.shields.io/github/stars/acch/rpi-icinga.svg?label=github%20%E2%98%85)](https://github.com/acch/rpi-icinga/) [![Docker Pulls](https://img.shields.io/docker/pulls/acch/rpi-icinga.svg)](https://hub.docker.com/r/acch/rpi-icinga/) [![License](https://img.shields.io/github/license/acch/rpi-icinga.svg)](LICENSE)

Raspberry Pi-compatible [Icinga](http://docs.icinga.com/latest/en/) Docker image. Includes [SSMTP](https://linux.die.net/man/8/ssmtp) for Email notifications.

## Usage

Run manually with plain docker:

```
# docker run --rm \
  -p 80:80 \
  -v $(pwd)/etc:/etc/icinga \
  -v cache:/var/cache/icinga \
  -v $(pwd)/log:/var/log \
  --name icinga
  acch/rpi-icinga
```

Run with docker-compose:

```
# docker-compose.yml
  version: '3'

  services:
    app:
      image: acch/rpi-icinga
      container_name: icinga
      ports:
        - "80:80"
      volumes:
        - cache:/var/cache/icinga
        - ./etc:/etc/icinga
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

## Installation

Icinga does not set any default password for the admin user. Run the following command to define a password for the admin user:

```
# docker exec -it icinga htpasswd -c /etc/icinga/htpasswd.users icingaadmin
```

## Copyright

Copyright 2017 Achim Christ, released under the [MIT license](LICENSE)
