FROM ubuntu:14.10

WORKDIR /vpn

RUN apt-get install -y curl
RUN curl -sL http://nginx.org/keys/nginx_signing.key | apt-key add -
RUN echo "deb http://nginx.org/packages/ubuntu/ utopic nginx" >> /etc/apt/sources.list && \
    echo "deb-src http://nginx.org/packages/ubuntu/ utopic nginx" >> /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    openvpn \
    iptables \
    traceroute \
    dnsutils \
    nginx

COPY config/nginx.conf /etc/nginx/
COPY data/vpn_config/ /vpn
COPY bin/ /usr/local/bin/

RUN chmod 600 /vpn/* && chmod 600 /vpn/*.key

EXPOSE 80
ENTRYPOINT ["entrypoint"]

CMD ["nginx && openvpn --config /vpn/config.conf --log-append /var/log/openvpn.log"]
