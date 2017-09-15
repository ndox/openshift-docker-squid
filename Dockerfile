FROM registry.access.redhat.com/rhel7:latest
#FROM base-centos7:latest

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid

# squid should not write any logs => Stderr if it's not possible
#     && chmod -R 777 /var/log/squid \
RUN set -x \
    && yum -y install squid gettext socat lsof strace\
    && yum -y update \
    && yum -y clean all \
    && chown -R 1001:1001 /etc/squid \
    && chown -R 1001:1001 /var/log/squid \
    && chmod 777  /var/run/ \
    && mkdir /data \
    && mkdir -p /data/secrets /data/run \
    && chmod 777 /data


COPY containerfiles/ /
USER root
RUN chmod +x /openshift-entrypoint.sh

WORKDIR /data/run
USER 1001

RUN squid -v

EXPOSE 8080/tcp



ENTRYPOINT ["/openshift-entrypoint.sh"]

#ENTRYPOINT ["/usr/sbin/squid"]
#CMD ["-f","/etc/squid/squid.conf","-N"]

#CMD ["/bin/sh","-c","while true; do echo hello world; sleep 30; done"]
