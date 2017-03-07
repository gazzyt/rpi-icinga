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
  patch \
  pnp4nagios \
  supervisor \
&& rm -rf /var/lib/apt/lists/*

# Configure Apache
RUN ln -s ../../pnp4nagios/apache.conf /etc/apache2/conf-available/pnp4nagios.conf \
&& /usr/sbin/a2enconf pnp4nagios \
&& /usr/sbin/a2enmod rewrite

# Add Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Patch PNP4Nagios
COPY index.php.patch /tmp/index.php.patch
COPY apache.conf.patch /tmp/apache.conf.patch
COPY config.php.patch /tmp/config.php.patch
COPY status-header.ssi /usr/share/icinga/htdocs/ssi/status-header.ssi
RUN /usr/bin/patch /usr/share/pnp4nagios/html/index.php /tmp/index.php.patch \
&& /usr/bin/patch /etc/pnp4nagios/apache.conf /tmp/apache.conf.patch \
&& /usr/bin/patch /etc/pnp4nagios/config.php /tmp/config.php.patch

# Expose volumes
VOLUME ["/etc/icinga", "/var/cache/icinga", "/var/log/icinga"]

# Expose ports
EXPOSE 80

# Start services via Supervisor
ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c","/etc/supervisor/conf.d/supervisord.conf"]
