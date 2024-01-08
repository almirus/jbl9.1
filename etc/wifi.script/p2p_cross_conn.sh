
#!/bin/sh
#this script is used to enable NAT and redirect packet & dns query.

IPTABLES_BIN=/usr/sbin/iptables

if [ "$1" == ra0 ]; then
echo "1" >> /proc/sys/net/ipv4/ip_forward
$IPTABLES_BIN  -F -t nat
$IPTABLES_BIN  -t nat -A POSTROUTING -s 192.168.211.160/19 -o ra0 -j MASQUERADE
$IPTABLES_BIN  -t nat -A PREROUTING -p udp -i p2p0 --dport 53 -j DNAT --to-destination $2:53
$IPTABLES_BIN  -L -t nat -nv
elif [ "$1" == eth0 ]; then
echo "1" >> /proc/sys/net/ipv4/ip_forward
$IPTABLES_BIN  -F -t nat
$IPTABLES_BIN  -t nat -A POSTROUTING -s 192.168.211.160/19 -o eth0 -j MASQUERADE
$IPTABLES_BIN  -t nat -A PREROUTING -p udp -i p2p0 --dport 53 -j DNAT --to-destination $2:53
$IPTABLES_BIN  -L -t nat -nv
else
echo "0" >> /proc/sys/net/ipv4/ip_forward
fi

exit 0
