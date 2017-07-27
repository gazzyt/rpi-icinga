FROM resin/rpi-raspbian:stretch
MAINTAINER Achim Christ

# Install prerequisites
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update \
&& apt-get -qqy install \
  apache2 \
  icinga \
  icinga-doc \
  nagios-nrpe-plugin \
  pnp4nagios \
  pnp4nagios-web-config-icinga \
  supervisor \
&& rm -rf /var/lib/apt/lists/*

# Add Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Enable popups
COPY status-header.ssi /usr/share/icinga/htdocs/ssi/status-header.ssi

# Expose volumes
VOLUME ["/etc/icinga", "/var/cache/icinga", "/var/log/icinga", "/var/lib/pnp4nagios/perfdata"]

# Expose ports
EXPOSE 80

# Start services via Supervisor
ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c","/etc/supervisor/conf.d/supervisord.conf"]
