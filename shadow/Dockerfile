FROM centos:centos7
MAINTAINER Dylan Wang dylan@strikingly.com

RUN yum update -y && yum install -y m2crypto python-setuptools
RUN easy_install pip
RUN pip install cymysql
ADD shadowsocks/ /usr/bin/shadowsocks

WORKDIR "/usr/bin/shadowsocks/shadowsocks"

CMD ["python", "server.py"]
