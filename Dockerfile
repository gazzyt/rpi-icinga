FROM resin/rpi-raspbian:jessie
MAINTAINER Achim Christ

# Install prerequisites
RUN apt-get -qq update && apt-get -qqy install \
  apache2 \
  icinga \
  supervisor \
&& rm -rf /var/lib/apt/lists/*

# Add supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

ENTRYPOINT ["/usr/bin/supervisord"]

