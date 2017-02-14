FROM resin/rpi-raspbian:jessie
MAINTAINER Achim Christ

# Install prerequisites
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update \
&& apt-get -qqy install \
  apache2 \
  icinga \
  supervisor \
&& rm -rf /var/lib/apt/lists/*

# Add Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose volumes
VOLUME ["/etc/icinga", "/var/cache/icinga", "/var/log"]

# Expose ports
EXPOSE 80

# Start services via Supervisor
ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c","/etc/supervisor/conf.d/supervisord.conf"]
