sudo apt-get update && apt-get install -y iprange # Comment this out if you have installed iprange
curl -s https://www.iblocklist.com/lists.php \
| grep -A 2 Bluetack \
| sed -n "s/.*value='\(http:.*\)'.*/\1/p" \
| xargs wget -O - \
| gunzip \
| egrep -v '^#' > blacklist
grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' blacklist > blacklist-ip
grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}[-][0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' blacklist > blacklist-ip-range
iprange blacklist-ip-range > blacklist-ip-cidr

sort blacklist-ip-cidr | grep -v '/' |uniq -u >> blacklist-ip # Here are added only single IP's from range file
sort blacklist-ip | uniq -u > blacklist-ip-sorted # Sort, check and remove duplicates
sort blacklist-ip-cidr | grep '/' |uniq -u > blacklist-ip-cidr-sorted # Here are only network segments, sorted and removed duplicates

echo blacklist-ip-cidr-sorted > blocklist
echo blacklist-ip-sorted >> blocklist

rm blacklist-ip
rm blacklist-ip-sorted
rm blacklist-ip-range
rm blacklist-ip-cidr
rm blacklist-ip-cidr-sorted