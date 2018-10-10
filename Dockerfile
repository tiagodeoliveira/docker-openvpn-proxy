FROM ubuntu:xenial

RUN apt-get update && \ 
  apt-get install -y \
  netcat \
  iputils-ping \
  openvpn \
  debconf-utils \
  curl \
  net-tools \
  vim \
  dnsutils \
  iptables

COPY connect.sh /connect.sh

CMD ["tail", "-f", "/dev/null"]
