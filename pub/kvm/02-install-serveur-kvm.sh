#!/bin/sh
# source https://wiki.debian.org/KVM
#preparation du systeme
prerequis(){
    echo "installation des pré-requis"
    sudo apt install sudo adduser vim
    echo "pour l'installations des packages"
    echo "apt install -y qemu qemu-kvm libvirt-daemon"
    echo "pour l'installation d'interface visuelle"
    echo "apt install virt-manager"
    echo "installation des packages"
    echo "outil réseau"
    sudo apt install bridge-utils
    echo "outil installation"
    echo "installation de dnsmasq"
    sudo apt install dnsmasq
    sudo apt install virtinst
    # installation des utilitaires usuels (gestion graphique)
    echo "apt-get install qemu-system libvirt-clients libvirt-daemon-system"
    apt-get install qemu-system libvirt-clients libvirt-daemon-system
    #echo "apt-get install --no-install-recommends qemu-system libvirt-clients libvirt-daemon-system"
    #sudo apt-get install --no-install-recommends qemu-system libvirt-clients libvirt-daemon-system
    sudo apt install -y qemu qemu-kvm libvirt-daemon bridge-utils virtinst
}
user() {
    echo "ajout de $USER au groupe libvirt"
    sudo adduser $USER libvirt
    sudo gpasswd -a $USER libvirt
    echo "ajout de $USER au groupe libvirt-qemu"
    sudo adduser $USER libvirt-qemu
    sudo gpasswd -a $USER libvirt-qemu
    echo "ajout de $USER au groupe libvirt"
    sudo usermod --append --groups libvirt $USER
    sudo exec su -l $USER
    echo "ajout de $USER au groupe kvm"
    sudo adduser $USER kvm
    echo "Pour rafraichir les groupes :"
    echo "newgrp libvirt"
    echo "newgrp libvirt-qemu"
    echo "affichage des domaines"
    sudo virsh list --all
}

activation() {
    echo "############################"
    echo "activation du daemon"
    sudo systemctl start libvirtd
    sudo systemctl enable libvirtd
    sudo systemctl status libvirtd.service
    echo "affichage du reseau"
    sudo virsh net-list --all
    echo "Lancement du reseau au démarrage"
    sudo virsh net-start default
    sudo virsh net-autostart default
    echo "############################"
    echo "edition de /etc/network/interfaces"
}

web() {
sudo apt install cockpit cockpit-machines curl
}

prerequis
user
activation
web
