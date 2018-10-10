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

ENV LOG_FILE /tmp/openvpn.log
ENV INIT_MESSAGE "Please run\n\tdocker exec -it openvpn-proxy /connect.sh"

CMD ["sh", "-c", "echo $INIT_MESSAGE > $LOG_FILE && tail -f $LOG_FILE" ]
