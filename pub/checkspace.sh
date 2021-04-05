echo "##########################################"
echo"nettoyage"
echo "##########################################"
apt autoclean
apt clean
apt --purge autoremove


echo "##########################################"
echo "liste des images "
echo "dpkg --list | grep linux-image"
echo "##########################################"
dpkg --list | grep linux-image


echo "##########################################"
echo "delete old kernels"
echo "##########################################"
v="$(uname -r | awk -F '-virtual' '{ print $1}')"
i="linux-headers-virtual|linux-image-virtual|linux-headers-${v}|linux-image-$(uname -r)"
apt-get --purge remove $(dpkg --list | egrep -i 'linux-image|linux-headers' | awk '/ii/{ print $2}' | egrep -v "$i")


echo "##########################################"
echo "liste des partitions"
echo "sfdisk -l"
echo "##########################################"
sfdisk -l

echo "##########################################"
echo "utilisation des partitions"
echo "df -lhT"
echo "##########################################"
df -lhT

echo "##########################################"
echo "big directories"
echo "/usr/bin/du --total --summarize --human-readable --one-file-system"
echo "##########################################"
cd /
/usr/bin/du --total --summarize --human-readable --one-file-system

echo "##########################################"
echo "Installed package by size"
echo "dpkg-query -W -show-format='${Installed-Size} ${Package}_n' | sort -n | tail"
echo "##########################################"
dpkg-query -W --showformat='${Installed-Size} ${Package}\n' | sort -n | tail 
