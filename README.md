# rpi-icinga

Raspberry Pi-compatible [Icinga](http://docs.icinga.com/latest/en/) Docker image. Includes [PNP4Nagios](https://docs.pnp4nagios.org/) to allow for performance data collection.

## Usage

Run manually with plain docker:

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

### Performance Data Collection

Refer to the PNP4Nagios [documentation](https://docs.pnp4nagios.org/pnp-0.6/config#bulk_mode_with_npcd_and_npcdmod) for details. Edit the following settings in `icinga.conf` to enable performance data collection:

```
etc/icinga.conf:
  ...
  process_performance_data=1
  ...
  broker_module=/usr/local/pnp4nagios/lib/npcdmod.o config_file=/usr/local/pnp4nagios/etc/npcd.cfg
  ...
```

Furthermore, define the following templates in your Icinga configuration (details in the [documentation](https://docs.pnp4nagios.org/pnp-0.6/webfe#popups)):

```
define host {
    name       host-pnp
    action_url /pnp4nagios/index.php/graph?host=$HOSTNAME$&srv=_HOST_' class='tips' rel='/pnp4nagios/index.php/popup?host=$HOSTNAME$&srv=_HOST_
    register   0
}
 
define service {
    name       srv-pnp
    action_url /pnp4nagios/index.php/graph?host=$HOSTNAME$&srv=$SERVICEDESC$' class='tips' rel='/pnp4nagios/index.php/popup?host=$HOSTNAME$&srv=$SERVICEDESC$
    register   0
}
```

You can now simply use these templates for hosts and services in order to integrate performance popups into the web view:

```
define host{
    use        host-pnp
    ...
}

define service{
    use        srv-pnp
    ...
}
```

## Copyright

Copyright 2017 Achim Christ
