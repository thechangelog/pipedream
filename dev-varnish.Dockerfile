# https://hub.docker.com/_/varnish
FROM varnish:7.4.3
ENV VARNISH_HTTP_PORT=9000
COPY default.vcl /etc/varnish/default.vcl

# Hack up a local docker container to fake DNS to run locally
# If there is a better solution for development, please open an issue to discuss it.
USER root
RUN apt update && apt -y install curl net-tools vim iproute2 dnsutils procps iputils-ping
RUN apt -y install dnsmasq
ENV VARNISH_BACKEND_DOMAIN="changelog-2024-01-12.internal"
ENV VARNISH_BACKEND_IPV4="172.18.0.2"
ENV VARNISH_BACKEND_IPV6="fd20:b007:398e::2"
RUN echo 'listen-address=127.0.0.1' >> /etc/dnsmasq.conf
RUN echo 'user=root' >> /etc/dnsmasq.conf
RUN echo 'server=8.8.8.8' >> /etc/dnsmasq.conf
RUN echo "address=/${VARNISH_BACKEND_DOMAIN}/${VARNISH_BACKEND_IPV4}" >> /etc/dnsmasq.conf
RUN echo "address=/${VARNISH_BACKEND_DOMAIN}/${VARNISH_BACKEND_IPV6}" >> /etc/dnsmasq.conf
RUN dnsmasq --test
USER varnish
