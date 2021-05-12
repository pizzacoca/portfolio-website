#!/bin/sh
# source https://wiki.debian.org/KVM
#preparation du systeme
remove(){
    sudo apt remove bridge-utils
    echo "outil installation"
    echo "installation de dnsmasq"
    sudo apt remove dnsmasq
    sudo apt remove virtinst
    # installation des utilitaires usuels (gestion graphique)
    # apt-get install qemu-system libvirt-clients libvirt-daemon-system
    sudo apt remove --no-install-recommends qemu-system libvirt-clients libvirt-daemon-system
    sudo apt remove qemu qemu-kvm libvirt-daemon bridge-utils virtinst
}


web() {
sudo apt install cockpit cockpit-machines curl
}

remove 
