# rpi-icing

Raspberry Pi-compatible [Icinga](http://docs.icinga.com/latest/en/) Docker image. Includes [PNP4Nagios](https://docs.pnp4nagios.org/) to allow for performance data collection, and [SSMTP](https://linux.die.net/man/8/ssmtp) for Email notifications.

## Usage

Run manually with plain docker:

```
# docker run --rm \
  -p 80:80 \
  -v $(pwd)/etc:/etc/icinga \
  -v cache:/var/cache/icinga \
  -v $(pwd)/log:/var/log/icinga \
  -v perfdata:/var/lib/pnp4nagios/perfdata \
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
        - perfdata:/var/lib/pnp4nagios/perfdata
        - ./etc:/etc/icinga
        - ./log:/var/log/icinga
      restart: always

  volumes:
    cache:
      driver: local
    perfdata:
      driver: local
```

## Volumes

This image exposes the following volumes:

```
/etc/icinga                   Icinga configuration files
/var/cache/icinga             Icinga state retention and cache files
/var/log/icinga               Icinga log files
/var/lib/pnp4nagios/perfdata  PNP4Nagios performance data
```

## Installation

Icinga does not set any default password for the admin user. Run the following command to define a password for the admin user:

```
# htpasswd -c etc/htpasswd.users icingaadmin
```

### Performance Data Collection

Refer to the PNP4Nagios [documentation](https://docs.pnp4nagios.org/pnp-0.6/config#bulk_mode_with_npcd_and_npcdmod) for details. Edit the following settings in `icinga.cfg` to enable performance data collection:

```
etc/icinga.cfg:
  ...
  process_performance_data=1
  ...
```

Define the npcd_mod event broker module by adding the following file to `etc/modules/`:

```
etc/modules/npcd_mod.cfg:
  define module {
    module_name  npcd_mod
    path         /usr/lib/pnp4nagios/npcdmod.o
    module_type  neb
    args         config_file=/etc/pnp4nagios/npcd.cfg
    }
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
  define host {
    use        host-pnp
    ...
    }

  define service {
    use        srv-pnp
    ...
    }
```

## Copyright

Copyright Achim Christ
