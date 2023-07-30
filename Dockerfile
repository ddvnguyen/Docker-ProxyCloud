# syntax=docker/dockerfile:1

ARG CLOUDFLARED_VERSION=2023.7.3
ARG XX_VERSION=1.2.1

# https://github.com/cloudflare/cloudflared/blob/2023.5.1/.github/workflows/check.yaml#L7
ARG GO_VERSION=1.19

FROM --platform=${BUILDPLATFORM:-linux/amd64} tonistiigi/xx:${XX_VERSION} AS xx
FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:${GO_VERSION}-alpine AS builder
RUN apk --update --no-cache add file git
COPY --from=xx / /
WORKDIR /src
ARG CLOUDFLARED_VERSION
# RUN git clone --branch ${CLOUDFLARED_VERSION} https://github.com/cloudflare/cloudflared .
RUN git clone https://github.com/Asutorufa/cloudflared .
ARG TARGETPLATFORM
ENV GO111MODULE=on
ENV CGO_ENABLED=0
RUN xx-go build -v -mod=vendor -trimpath -o /bin/cloudflared \
    -ldflags="-w -s -X 'main.Version=${CLOUDFLARED_VERSION}' -X 'main.BuildTime=${BUILD_DATE}'" \
    ./cmd/cloudflared \
  && xx-verify --static /bin/cloudflared

FROM ubuntu:22.04

# ENV TUNNEL_METRICS="0.0.0.0:49312" \
#     TUNNEL_DNS_ADDRESS="0.0.0.0" \
#     TUNNEL_DNS_PORT="5053" \
#     TUNNEL_DNS_UPSTREAM="https://1.1.1.1/dns-query,https://1.0.0.1/dns-query"



# Update Ubuntu Software repository
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y ca-certificates openssl tzdata doas sudo bash \
 && apt-get install -y python3 python3-pip curl gcc 

RUN rm -rf /var/lib/apt/lists/*
RUN apt clean

RUN pip3 install --upgrade pip
RUN pip3 install mitmproxy
RUN rm -rf /var/cache/apt/* \
 && rm -rf ~/.cache/pip \
 && rm -rf ~/.cache/pip3 \
 && rm -rf /tmp/pip_build_root \
 && rm -rf /root/.cache \
 && rm -rf /usr/lib/python*/ensurepip
    
ENV LANG=en_US.UTF-8
COPY --from=builder /bin/cloudflared /usr/local/bin/cloudflared
COPY ".mitmproxy" /root/.mitmproxy
RUN sudo openssl x509 -in /root/.mitmproxy/mitmproxy-ca-cert.pem -inform PEM -out /usr/local/share/ca-certificates/mitmproxy-ca-cert.crt
RUN sudo update-ca-certificates

# TODO: auto run mitmweb with correct config and set proxy by default
#       add  CMD start mitmweb when start docker container also config proxy in Dockerfile
# TODO: steam line how to setup cloudflared tunnel so it can work with mitmproxy 
#       => using command cloudflared tunnel run --token <tokenvalue> (this will help using tunnel with out any config file in docker container)

VOLUME /root/.mitmproxy

ENV http_proxy="http://127.0.0.1:9099/" \
    https_proxy="https://127.0.0.1:9099/"

EXPOSE 5053/udp
EXPOSE 49312/tcp
EXPOSE 9091
EXPOSE 9099

ENTRYPOINT mitmweb --listen-port 9099 --listen-host 0.0.0.0 --web-port 9091 --web-host 0.0.0.0

HEALTHCHECK --interval=30s --timeout=20s --start-period=10s \
  CMD dig +short @127.0.0.1 -p $TUNNEL_DNS_PORT cloudflare.com A || exit 1
