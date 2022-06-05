FROM balenalib/raspberry-pi2-debian:buster as target-arm
FROM balenalib/raspberrypi3-64-debian:buster as target-arm64

FROM target-$TARGETARCH

ARG TARGETARCH
RUN echo "Arch = $TARGETARCH"

# Install prerequisites
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update \
&& apt-get -qqy --no-install-recommends install \
  apache2 \
  icinga \
  icinga-doc \
  nagios-nrpe-plugin \
  supervisor \
&& rm -rf /var/lib/apt/lists/*

# Add Rasperry-Pi logos
COPY raspberry/ /usr/share/icinga/htdocs/images/logos/raspberry/

# Add Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Fix external commands
RUN chmod 2770 /var/lib/icinga/rw

# Timezone configuration
ARG TZ=Europe/London
ENV TZ=${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
&& echo $TZ > /etc/timezone

# Expose volumes
VOLUME ["/etc/icinga", "/var/cache/icinga", "/var/log"]

# Expose ports
EXPOSE 80

# Start services via Supervisor
ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c","/etc/supervisor/conf.d/supervisord.conf"]
