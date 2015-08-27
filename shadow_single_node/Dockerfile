FROM centos:centos7
MAINTAINER Dylan Wang dylan@strikingly.com

RUN yum update -y
ADD shadowsocks-server-linux64-1.1.4 /usr/bin/shadowsocks-go-server
ADD shadowsocks-config.json /etc/shadowsocks-config.json

CMD ["/usr/bin/shadowsocks-go-server", "-c", "/etc/shadowsocks-config.json"]
