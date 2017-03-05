FROM resin/rpi-raspbian:jessie
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
  supervisor \
&& rm -rf /var/lib/apt/lists/*

# Configure Apache
RUN ln -s ../../pnp4nagios/apache.conf /etc/apache2/conf-available/pnp4nagios.conf \
&& /usr/sbin/a2enconf pnp4nagios \
&& /usr/sbin/a2enmod rewrite

# Add Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add PNP4Nagios configuration
COPY apache.conf /etc/pnp4nagios/apache.conf
COPY config.php /etc/pnp4nagios/config.php
COPY status-header.ssi /usr/share/icinga/htdocs/ssi/status-header.ssi

# Expose volumes
VOLUME ["/etc/icinga", "/var/cache/icinga", "/var/log/icinga"]

# Expose ports
EXPOSE 80

# Start services via Supervisor
ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c","/etc/supervisor/conf.d/supervisord.conf"]
