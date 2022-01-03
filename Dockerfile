FROM balenalib/raspberry-pi2-debian:buster

# Install prerequisites
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update \
&& apt-get -qqy --no-install-recommends install \
  apache2 \
  icinga \
  icinga-doc \
  nagios-nrpe-plugin \
  ssmtp \
  supervisor \
&& rm -rf /var/lib/apt/lists/*

# Add Rasperry-Pi logos
COPY raspberry/ /usr/share/icinga/htdocs/images/logos/raspberry/

# Add Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Secure SSMTP configuration
RUN mv /etc/ssmtp/ssmtp.conf /etc/icinga/ \
&& ln -snf /etc/icinga/ssmtp.conf /etc/ssmtp/ \
&& groupadd ssmtp \
&& chown :ssmtp /etc/icinga/ssmtp.conf \
&& chown :ssmtp /usr/sbin/ssmtp \
&& chmod 640 /etc/icinga/ssmtp.conf \
&& chmod g+s /usr/sbin/ssmtp

# Fix external commands
RUN chmod 2770 /var/lib/icinga/rw

# Timezone configuration
ARG TZ=Europe/Berlin
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
