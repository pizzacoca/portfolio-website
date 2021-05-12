# !/bin/sh
echo "installation d'utilitaire réseau"
echo "sudo apt install uml-utilities bridge-utils"
sudo apt install uml-utilities 
echo "desactivation de network manager"
nmcli dev status
sudo systemctl stop NetworkManager.service
nmcli dev status
"sudo systemctl disable NetworkManager.service
echo "modification de /etc/NetworkManager/NetworkManager.conf"
sed -n 's/managed=false/managed=true/gip' /etc/NetworkManager/NetworkManager.conf
sudo systemctl start NetworkManager.service
nmcli dev status

