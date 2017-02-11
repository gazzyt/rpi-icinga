FROM resin/rpi-raspbian:jessie
MAINTAINER Achim Christ

# Install prerequisites
RUN apt-get update && apt-get install -y \
  apache2 \
  icinga \
&& rm -rf /var/lib/apt/lists/*

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

