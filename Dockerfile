FROM debian:buster-slim AS add-apt-repository

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y gnupg --no-install-recommends \
    && apt-key adv --fetch-keys http://www.webmin.com/jcameron-key.asc \
    && echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list

FROM debian:buster-slim

LABEL maintainer "IT4smart GmbH <info@it4smart.eu>"

ENV DATA_DIR=/data \
    BIND_USER=bind

COPY --from=add-apt-repository /etc/apt/trusted.gpg /etc/apt/trusted.gpg

COPY --from=add-apt-repository /etc/apt/sources.list /etc/apt/sources.list

RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes \
    && apt-get update -qq \
    && apt-get install -qq -y bind9=1:9.11.5.P4+dfsg-5.1 webmin=1.941 perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp
VOLUME ["${DATA_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named"]
