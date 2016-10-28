curl -s https://www.iblocklist.com/lists.php \
| grep -A 2 Bluetack \
| sed -n "s/.*value='\(http:.*\)'.*/\1/p" \
| xargs wget -O - \
| gunzip \
| egrep -v '^#' > blacklist
grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' blacklist > blacklist-ip
grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}[-][0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' blacklist > blacklist-ip-range
sed -i -E "s/[-][0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\./\//" blacklist-ip-range

sort blacklist-ip | uniq -u > blacklist-ip-sorted
sort blacklist-ip-range | uniq -u > blacklist-ip-range-sorted

while read IPADDR
do
    route add $IPADDR gw 127.0.0.1 lo &
done < blacklist-ip-range-sorted

while read IPADDR
do
    route add $IPADDR gw 127.0.0.1 lo &
done < blacklist-ip-sorted

rm -f blacklist-ip
rm -f blacklist-ip-sorted
rm -f blacklist-ip-range
rm -f blacklist-ip-range-sorted