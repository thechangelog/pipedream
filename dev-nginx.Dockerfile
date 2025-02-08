# https://hub.docker.com/_/nginx
FROM nginx:latest

ENV NGINX_LB_HOST="pipedream.changelog.com nginx"
ENV NGINX_LB_PORT=80
ENV NGINX_LB_SSL_PORT=443
ENV NGINX_LB_PROXY_PASS="http://172.17.0.1:9000"

ENV NGINX_BACK_PORT=4000
ENV NGINX_BACK_HOST="changelog-2024-01-12.fly.dev"
ENV NGINX_BACK_REV_PROXY_LOC_MATCH="/feed"
ENV NGINX_BACK_REV_PROXY="http://feeds.changelog.place/feed.xml"

COPY dev-nginx.conf.template /etc/nginx/templates/default.conf.template

# Generate (weak/fast) self-signed cert for useless mocking
# INSECURE: Bad idea to generate sensitive cryptographic keys and store in container image
# If there is a better solution for development, please open an issue to discuss it.
RUN apt update && apt -y install openssl
ENV SSL_KEY="/etc/nginx/ssl/www.example.com.key"
ENV SSL_CSR="/etc/nginx/ssl/www.example.com.csr"
ENV SSL_REQ_COUNTRY="US"
ENV SSL_REQ_STATE="Texas"
ENV SSL_REQ_LOCALITY="Austin"
ENV SSL_REQ_ORGANIZATION="Example Company"
ENV SSL_REQ_ORGANIZATIONALUNIT="Example Department"
ENV SSL_REQ_COMMONNAME="example.com"
ENV SSL_REQ_EMAIL="webmaster@example.com"
RUN /usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/server.key -out /etc/nginx/server.crt -subj "/C=${SSL_REQ_COUNTRY}/ST=${SSL_REQ_STATE}/L=${SSL_REQ_LOCALITY}/O=${SSL_REQ_ORGANIZATION}/OU=${SSL_REQ_ORGANIZATIONALUNIT}/CN=${SSL_REQ_COMMONNAME}/emailAddress=${SSL_REQ_EMAIL}"
