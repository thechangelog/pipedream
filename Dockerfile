# https://hub.docker.com/_/varnish
FROM varnish:7.4.3
ENV VARNISH_HTTP_PORT=9000
COPY default.vcl /etc/varnish/default.vcl
