# rpi-icinga
Raspberry Pi-compatible Icinga Docker image

## Usage

Run with plain docker:

```
docker run --rm -p 8000:80 -v $(pwd)/etc:/etc/icinga -v $(pwd)/log:/var/log/icinga acch/rpi-icinga
```

Run with docker-compose:

```
  services:
    icinga:
      build: rpi-icinga
      ports:
        - "8000:80"
      volumes:
        - ./etc:/etc/icinga
        - ./log:/var/log/icinga
```

## Volumes

This image exposes the following volumes:

```
/etc/icinga        Icinga configuration files
/var/cache/icinga  Icinga state retention and cache files
/var/log/icinga    Log files
```

## Installation

Icinga does not set any default password for the admin user. Run the following command to define a password for the admin user:

```
htpasswd -c etc/htpasswd.users icingaadmin
```
