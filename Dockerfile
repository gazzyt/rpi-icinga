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
  patch \
  pnp4nagios \
  pnp4nagios-web-config-icinga \
  ssmtp \
  supervisor \
&& rm -rf /var/lib/apt/lists/*

# Add Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Enable popups
COPY status-header.ssi /usr/share/icinga/htdocs/ssi/status-header.ssi

# Patch PNP4Nagios templates
COPY default.php.patch /tmp/default.php.patch
COPY check_users.php.patch /tmp/check_users.php.patch
RUN /usr/bin/patch /usr/share/pnp4nagios/html/templates.dist/default.php /tmp/default.php.patch \
&& /usr/bin/patch /usr/share/pnp4nagios/html/templates.dist/check_users.php /tmp/check_users.php.patch

# Timezone configuration
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
&& echo $TZ > /etc/timezone

# Expose volumes
VOLUME ["/etc/icinga", "/var/cache/icinga", "/var/log/icinga", "/var/lib/pnp4nagios/perfdata"]

# Expose ports
EXPOSE 80

# Start services via Supervisor
ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c","/etc/supervisor/conf.d/supervisord.conf"]
