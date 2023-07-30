docker run -it --rm -p 7166:7166 cloudflare/cloudflared tunnel --url http://host.docker.internal:7166


cloudflared tunnel run --token eyJhIjoiYWI1ZjkxM2UxM2MzZjY0YWMzOTA4NzVlZTIyMWFjNTMiLCJ0IjoiZDNlZmJlYjctNmQyNS00MDg4LWFjZTQtM2Q5NmY1YzQyMTUwIiwicyI6Ik1UUm1aalUwWm1VdE1qSXhaUzAwWXprMkxUbGpZbVl0WTJNNVpqQTJaVEEyWWpneiJ9

docker run --name cloudflared-ddv -p 7166:7166 -p 8088:8088 --env http_proxy="http://127.0.0.1:9099" --env https_proxy="https://127.0.0.1:9099" cloudflared-ddv:local tunnel --no-autoupdate run --token eyJhIjoiYWI1ZjkxM2UxM2MzZjY0YWMzOTA4NzVlZTIyMWFjNTMiLCJ0IjoiZDNlZmJlYjctNmQyNS00MDg4LWFjZTQtM2Q5NmY1YzQyMTUwIiwicyI6Ik1UUm1aalUwWm1VdE1qSXhaUzAwWXprMkxUbGpZbVl0WTJNNVpqQTJaVEEyWWpneiJ9

docker cp mitmproxy-ca-cert.cer  cloudflared-ddv:/usr/local/share/ca-certificates/

docker cp mitmproxy-ca-cert.cer wizardly_jemison:/usr/local/share/ca-certificates/mitmproxy-ca-cert.cer

docker run --rm --name proxy-cloud-ddv  -it -p 9099:9099 -p 127.0.0.1:9091:9091 --env http_proxy="http://127.0.0.1:9099" --env https_proxy="https://127.0.0.1:9099" proxy-cloud:ddv mitmweb --listen-port 9099 --listen-host 0.0.0.0 --web-port 9091 --web-host 0.0.0.0
docker run -it --rm -p 9099:9099 -p 127.0.0.1:9091:9091 --env http_proxy="http://127.0.0.1:9099" --env https_proxy="https://127.0.0.1:9099" --name proxy-cloud-ddv proxy-cloud:ddv 

docker run -it --rm -p 9099:9099 -p 127.0.0.1:9091:9091 --env http_proxy="http://127.0.0.1:9099" --env https_proxy="https://127.0.0.1:9099" --name proxy-cloud-ddv mitmproxy/mitmproxy mitmweb --listen-port 9099 --listen-host 0.0.0.0 --web-port 9091 --web-host 0.0.0.0
docker run -it -p 9099:9099 -p 127.0.0.1:9091:9091 --name proxy-cloud-ubuntu proxy-cloud-ubuntu:t  /bin/bash
docker run -it -p 9099:9099 -p 127.0.0.1:9091:9091 --name proxy-cloud-1 ubuntu:22.04 /bin/bash

proxychains4 -f /etc/proxychains.conf cloudflared tunnel run --token eyJhIjoiYWI1ZjkxM2UxM2MzZjY0YWMzOTA4NzVlZTIyMWFjNTMiLCJ0IjoiZDNlZmJlYjctNmQyNS00MDg4LWFjZTQtM2Q5NmY1YzQyMTUwIiwicyI6Ik1UUm1aalUwWm1VdE1qSXhaUzAwWXprMkxUbGpZbVl0WTJNNVpqQTJaVEEyWWpneiJ9 --proxy-server=https://127.0.0.1:9099

mitmweb --listen-port 9099 --listen-host 0.0.0.0 --web-port 9091 --web-host 0.0.0.0

sudo http_proxy=http://192.168.1.99:8088 https_proxy=https://192.168.1.99:8088 chromium
sudo https_proxy=https://192.168.1.99:8088 apt-get update

export http_proxy="http://127.0.0.1:9099/"
export https_proxy="https://127.0.0.1:9099/"

docker exec -u root -t -i proxy-cloud-ubuntu /bin/bash
docker exec -u root -t -i proxy-cloud-ddv /bin/sh

cloudflared tunnel --url https://host.docker.internal:7166

COPY my-cert.pem /usr/local/share/ca-certificates/my-cert.crt

RUN cat /usr/local/share/ca-certificates/my-cert.crt >> /etc/ssl/certs/ca-certificates.crt && \
    apk --no-cache add \
        curl


export http_proxy=http://your.proxy.server:port/
export https_proxy=http://your.proxy.server:port/


cd /mnt/c/Users/Ddv/.mitmproxy/mitmproxy-ca-cert.pem
cd /mnt/c/Users/Ddv/.mitmproxy/

mkdir  /usr/local/share/ca-certificates/mitmproxy
cp  /home/cloudflaredRoot/.mitmproxy/mitmproxy-ca-cert.cer /usr/local/share/ca-certificates/

cp  /home/cloudflaredRoot/.mitmproxy/mitmproxy-ca-cert.cer /usr/local/share/ca-certificates/

cd /mnt/c/Users/Ddv/.mitmproxy/mitmproxy-ca-cert.pem
cp /home/cloudflaredRoot/.mitmproxy/mitmproxy-cert.pem /usr/local/share/ca-certificates/mitmproxy.crt

openssl x509 -in mitmproxy-ca-cert.pem -inform PEM -out mitmproxy-ca-cert.crt
openssl x509 -in /home/mitmproxy/.mitmproxy/mitmproxy-ca-cert.pem -inform PEM -out /usr/local/share/ca-certificates/mitmproxy-ca-cert.crt

openssl x509 -in mitmproxy-ca-cert.pem -inform PEM -out /usr/local/share/ca-certificates/mitmproxy/mitmproxy-ca-cert.crt