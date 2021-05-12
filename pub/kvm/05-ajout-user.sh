#!/bin/sh
# source https://wiki.debian.org/KVM
#preparation du systeme
user() {
    echo "ajout de $1 au groupe libvirt"
    sudo adduser $1 libvirt
    sudo gpasswd -a $1 libvirt
    echo "ajout de $1 au groupe libvirt-qemu"
    sudo adduser $1 libvirt-qemu
    sudo gpasswd -a $1 libvirt-qemu
    echo "ajout de $1 au groupe libvirt"
    sudo usermod --append --groups libvirt $1
    sudo exec su -l $1
    echo "ajout de $1 au groupe kvm"
    sudo adduser $1 kvm
    echo "Pour rafraichir les groupes :"
    echo "newgrp libvirt"
    echo "newgrp libvirt-qemu"
    echo "affichage des domaines"
    sudo virsh list --all
    echo "Liste des utilisateurs"
    sudo getent group | grep libvirt

}

user
