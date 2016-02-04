curl -s https://www.iblocklist.com/lists.php \
| grep -A 2 Bluetack \
| sed -n "s/.*value='\(http:.*\)'.*/\1/p" \
| xargs wget -O - \
| gunzip \
| egrep -v '^#' > blacklist
grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' blacklist > blacklist-ip
grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}[-][0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' blacklist > blacklist-ip-range
sed -i -E "s/[-][0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\./\//" blacklist-ip-range

while read IPADDR
do
    sudo ufw deny from $IPADDR to any 
done < blacklist-ip-range

while read IPADDR
do
    sudo ufw deny from $IPADDR to any 
done < blacklist-ip


sudo ufw disable
sudo ufw enable
sudo ufw status