#!/bin/bash

# Configuration script for :
# DEBIAN 10 (Buster), 9 (Stretch) or 8 (Jessie)

LOG=/root/config.log

function apt_update() { apt-get update >> $LOG 2>&1; }
function apt_upgrade() { apt-get upgrade -y >> $LOG 2>&1; }
function apt_install() { apt-get install $* -qy >> $LOG 2>&1; }

function wget_file() { echo "wget_file $*" >> $LOG; wget -nc $* >> $LOG 2&>1; }

function echo_part() { echo "=== $* ===" >> $LOG; echo -e "\e[32m${*}\e[m"; }
function echo_step() { echo "> $*" >> $LOG; echo -e " \u2022 ${*}"; }

function help() {

    basics=( "vim" "i3" "redshift" "sudo" "keepass2" "thunar" "net-tools" )
    devs=( "git" "python3" "python3-pip" "virtualenv" "virtualenvwrapper" )
    graphics=( "kile" "dia" "gimp" "blender" "XnView-MP")
    echo -e "\nConfiguration script for Debian linux system"
    echo -e "Tested with version 10 (buster), 9 (stretch) and 8 (jessie)"
    echo -e "Copyright ISI-Group (2019)"
    
    echo -e "\n\e[32mHelp (batch config)\e[m"
    
    echo -e " \u2022 \e[36mc0\e[m = update + basic"
    echo -e " \u2022 \e[36mc1\e[m = c0 + dev"
    echo -e " \u2022 \e[36mc2\e[m = c1 + graphics"
#    echo -e " \u2022 \e[36mc2\e[m = c1 + lxde + ipscan + x2go"
#    echo -e " \u2022 \e[36mc3\e[m = c2 + tv"
#    echo -e " \u2022 \e[36mcw\e[m = c0 + web + wssl"
    
    echo -e "\n\e[32mHelp (single config)\e[m"
    
    echo -e " \u2022 \e[36mupdate\e[m  : apt-get update n upgrade"
    echo -e " \u2022 \e[36mbasic\e[m   : minimal system conf : " ${basics[*]// /|}
    echo -e " \u2022 \e[36mdev\e[m   : outils dev : " ${devs[*]// /|}
    echo -e " \u2022 \e[36mgraphics\e[m   : outils graphiques : " ${graphics[*]// /|}


    echo -e "\n\e[32mHelp (Memo)\e[m"

    echo -e " \u2022 \e[36mvirtu\e[m  : Vérification capacité virtualisation"
    echo -e " \u2022 \e[36mmemo\e[m  : memo commandes"
#    echo -e " \u2022 \e[36mmisc\e[m    : add some tools like glances, arp-scan, etc."
#    echo -e " \u2022 \e[36msshd\e[m    : add and configure SSH server"
#    echo -e " \u2022 \e[36mlxde\e[m    : add minimal LXDE and Firefox"
#    echo -e " \u2022 \e[36mipscan\e[m  : add Angry IP Scanner"
#    
    exit 0
    
} #help

function update() {
    
    echo_part "Update system"
    
    apt_update
    echo_step "Update repository"
    
    apt_upgrade
    echo_step "Upgrade packages"    
} #update


function basic() {
    basics=( "vim" "i3" "redshift" "sudo" "keepass2" "thunar" "net-tools" )
    echo "mise à jour et installation utilitaires de base"
    for i in "${basics[@]}"
    	do
    apt_install $i
    echo_step $i
    	done
} #basics

function dev() {
    devs=( "git" "python3" "python3-pip" "virtualenv" "virtualenvwrapper" )
    echo "mise à jour et installation utilitaires de dev"
    for i in "${devs[@]}"
    	do
    apt_install $i
    echo_step "install" $i
    	done
    
} #dev

function graphics() {

    graphic=( "kile" "dia" "gimp" )
    echo "installation d'outils graphiques"
    for i in "${graphic[@]}"
    	do
    apt_install $i
    echo_step "install" $i
    	done

    file=XnViewMP-linux-x64.deb
    cd /opt 
    wget_file https://download.xnview.com/${file}
    echo_step "Download /opt/$file"
    dpkg -i $file >> $LOG 2>&1
    echo_step "Install /opt/$file"
    
    file=blender-2.92.0-linux64
    wget_file https://www.blender.org/download/Blender2.92/${file}.tar.xz
    echo_step "Download /opt/$file"
    dpkg -i $file >> $LOG 2>&1
    echo_step "Install /opt/$file"
} #graphics

function virtu() {
    processeurs=$(grep -E -c "vmx|svm" /proc/cpuinfo)
    echo "$processeurs processeurs compatibles et disponibles"
} #verif_virtu



function memo() {
    
    echo "#############################"
    echo "pour ajouter le GIT_SSH_COMMAND taper :"
    variable=$(cat /etc/hostname)
    nomclef=$(ls ~/.ssh/ | grep $variable | grep -v "pub" | grep -v "no_rsa")
    echo "export GIT_SSH_COMMAND='ssh -i "$HOME"/.ssh/"$nomclef"' git clone" 
    echo $nomclef
    
    echo "#############################"
    eval "$(ssh-agent -s)"
    echo "ssh-add ~/.ssh/"$nomclef
    
    echo "#############################"
    echo "# Créer une clef ssh :"
    echo "ssh-keygen -t rsa -b 4096"
    
    echo "#############################"
    echo "# ajouter le sudoer"
    echo "sudo usermod -a -G sudo username"
    
    echo "#############################"
    echo "# memo crontab"
    echo " 1 * * * * /usr/bin/autossh.sh"
    
} #fonctions a ajouter


# appel des fonctions
function c0() { exec $0 update basic $basics; }
function c1() { exec $0 update basic dev; }
function c2() { exec $0 update basic dev graphics; }
#function c2() { exec $0 update basic misc sshd lxde ipscan x2go; }
#function c3() { exec $0 update basic misc sshd lxde ipscan x2go tv; }
#function cw() { exec $0 update basic misc sshd web wssl; }

[ $# -eq 0 ] && help


echo -e "Configure : $*" > $LOG
echo -e "$(date)" >> $LOG

for RUN in $*
do
  echo -e "\n[ $RUN ]" >> $LOG
  $(declare -f -F $RUN)
done

echo -e "\nDone." >> $LOG
echo -e "Configure : $*" > $LOG
echo -e "$(date)" >> $LOG

for RUN in $*
do
  echo -e "\n[ $RUN ]" >> $LOG
  $(declare -f -F $RUN)
done

echo -e "\nDone." >> $LOG
