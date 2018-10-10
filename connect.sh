#!/bin/bash

LOG_FILE=/tmp/openvpn.log

set -e

echo "==> Connecting to vpn..."
openvpn --config /client.ovpn --daemon --log "$LOG_FILE"

CONNECTED=false
tail -f "$LOG_FILE" | while read LOGLINE; do
  if [[ "${LOGLINE}" == *"Initialization Sequence Completed"* ]]; then
     pkill -P $$ tail
  elif [[ "${LOGLINE}" == *"AUTH_FAILED"* ]]; then
     pkill -P $$ tail
     echo "##> Impossible to connect!"
     exit 1
  else 
    echo "${LOGLINE}"
  fi
done

echo '==> OpenVPN is connected!'

if [ -n "$NAMESERVER" ] && [ -n "$DOMAIN" ]; then
  echo -e "nameserver ${NAMESERVER}\ndomain ${DOMAIN}" > /etc/resolv.conf
else
  echo "==> No nameserver/domain defined"
fi

echo 1 > /proc/sys/net/ipv4/ip_forward

iptables -F
iptables -t nat -F
iptables -X

if [[ -n "$PROXY" ]]; then
  iptables -t nat -A PREROUTING -p tcp --dport 3128 -i eth0 -j DNAT --to ${PROXY}
  iptables -t nat -A POSTROUTING -o tun+ -j MASQUERADE
else
  echo "==> No target proxy defined"
fi
