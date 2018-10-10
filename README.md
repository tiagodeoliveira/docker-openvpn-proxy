## To run:
```
docker run --name openvpn-proxy -d -p 3128:3128 -e PROXY=proxy.com:3128 -v client.ovpn:/client.ovpn --privileged tiagodeoliveira/openvpn-proxy
docker exec -it openvpn-proxy /connect.sh
```

Additionally you can provide the resolv.conf config:
```
docker ... -e NAMESERVER=192.168.0.1 -e DOMAIN=my.domain ...
```
