#!/bin/bash

# Configuration script for :
# DEBIAN 10 (Buster), 9 (Stretch) or 8 (Jessie)

LOG=~/.config/install.log

function apt_update() { apt-get update >> $LOG 2>&1; }
function apt_upgrade() { apt-get full-upgrade -y >> $LOG 2>&1; }
function apt_install() { apt-get install $* -qy >> $LOG 2>&1; }

function echo_part() { echo "=== $* ===" >> $LOG; echo -e "\e[0;32m${*}\e[m"; }
function echo_step() { echo "==> $* ==" >> $LOG; echo -e " \u2022 \e[0;36m${*}\e[m"; }
function echo_point() { echo "=> $* =" >> $LOG; echo -e "   \e[0;32m${*}\e[m"; }

function wget_file() { 
    echo_step "\e[1;34mDownloading\e[m \e[0;33m$PWD/${file}\e[m"
    echo "wget_file $*" >> $LOG; wget -nc $* >> $LOG 2&>1
    echo_point "\e[1;32mOK\e[m"
} #wget_file

function test(){
	echo_part "ok"
	echo_step "ok"
	echo_point "\e[1;32mok\e[m"
} #test

function dpkg_file() {
    echo_step "\e[36mInstalling\e[m \e[0;33m${file} ...\e[m"
    #sudo dpkg -i $file >> $LOG 2>&1
    sudo dpkg -i $file >> $LOG 2>> $LOG
    case $? in
	    0)
    echo -e "\e[1;32m    OK\e[m"
    ;;
            *)
    echo -e "\e[1;31m    KO\e[m"
    ;;
    esac
} #dpkg_file


function f_basics() {
    array=( "vim" "i3" "redshift" "sudo" "keepass2" "thunar"\
	    "tcpdump" "rsync" "xpdf")
    use_array "${array[@]}"
} #f_basics

function f_client() {
    array=( "openssh-server" "wireshark" "x2goserver" "x2goserver-session" )
    use_array "${array[@]}"
} #f_client

function f_admin() {
    array=( "net-tools" "wireshark" "x2goclient" )
    use_array "${array[@]}"
} #f_admin

function f_devs() {
    array=( "git" "python3" "python3-pip" "virtualenv" "virtualenvwrapper" )
    use_array "${array[@]}"
} #f_devs

function f_graphics() {
    array=( "kile" "dia" "gimp" )
    use_array "${array[@]}"
} #f_graphics

use_array () { 
	 for idx in "$@"; 
	 do echo "$idx" 
	 done 
 } 
create_array () { 
	local array=("a" "b" "c") use_array "${array[@]}" 
}
function update() {
    echo_part "Update system"
    
    apt_update
    echo_step "Update repository"
    
    apt_upgrade
    echo_step "Upgrade packages"    
} #update


function install() {
    echo_step "Installing \e[33m$1"
    apt_install $1
    echo_point "\e[1;32mOK\e[m"
}
function admin() {
    admin=($(f_admin))
    echo_step "Mise à jour et installation utilitaires admin"
    for i in "${admin[@]}"
    	do
    install $i
    	done
} #admin
function todo() {
    echo "x2goclient"
    echo "x2goserver"
    echo "openssh-server"
} #todo

function basic() {
    basics=($(f_basics))
    echo_part "Mise à jour et installation utilitaires de base"
    for i in "${basics[@]}"
    	do
    install $i
    	done
} #basics

function client() {
     client=($(f_client))
    echo_part "MàJ & install poste client"
    for i in "${client[@]}"
    	do
    install $i
    	done
} #client

function clientsshadmin() {

    echo_part "Configuration poste client"
    echo_step "\nAjout de client.config"
    wget --no-http-keep-alive\ 
	    https://florian.lassenay.fr/pub/client.config\ 
	    -O ~/.ssh/client.config
    echo "Include ~/.ssh/client.config" >> ~/.ssh/config
    
    echo_step "\e[36mAjout de la clef ssh d'administration\e[m"
    wget --no-http-keep-alive\ 
	    https://florian.lassenay.fr/pub/carbone_rsa.pub\ 
	    -O /tmp/carbone_rsa.pub
    cat /tmp/carbone_rsa.pub >> ~/.ssh/authorized_keys
} #clientsshadmin
    
function clientssh() {
    echo_step "\e[36mGénération d'une clef ssh\e[m"
    echo_point -e "nom de la clef : "$HOME"/.ssh/"$HOSTNAME"_rsa"
    ssh-keygen -t rsa -b 4096
    #echo_step "parametrage de GIT_SSH_COMMAND"
    #nomclef=$(ls ~/.ssh/ | grep $variable | grep -v "pub" | grep -v "no_rsa")
    #echo "export GIT_SSH_COMMAND='ssh -i "$HOME"/.ssh/"$nomclef"' git clone" 
 
} #clientssh

function dev() {
    devs=($(f_devs))
    echo_part "Mise à jour et installation outils dev"
    for i in "${devs[@]}"
    	do
    install $i
    	done
    
    echo_step "\e[36mEdition de bashrc :\e[m"
    sed -i -e "s/#alias ll/alias ll/g" ~/.bashrc
    sed -i -e "s/#force_color_prompt/force_color_prompt/g" ~/.bashrc
    echo_point "ajout de PS1 dans .bashrc"
    echo "export PS1='\[\033[0;37m\]\h:\[\033[0;33m\]\W\[\033[0m\]\[\033[1;32m\]\$(__git_ps1)\[\033[0m\] \$ '" >> ~/.bashrc

} #dev

#function f_download() {
#    
#} #f_download

function graphics() {
    graphic=($(f_graphics))
    echo_part "Installation d'outils graphiques"
    for i in "${graphic[@]}"
    	do
    install $i
    	done

    file="XnViewMP-linux-x64.deb"
    cd /opt 
    wget_file https://download.xnview.com/${file}
    dpkg_file $file 
    
    file="blender-2.92.0-linux64.tar.xz"
    wget_file https://download.xnview.com/${file}

} #graphics

function virtu() {
    processeurs=$(grep -E -c "vmx|svm" /proc/cpuinfo)
    echo_point "\e[1;31m$processeurs \e[0;36mprocesseurs compatibles et disponibles\e[m"
} #verif_virtu

function memo() {
    echo -e " \u2022 \e[36mPour ajouter le GIT_SSH_COMMAND taper :\e[m"
    variable=$(cat /etc/hostname)
    nomclef=$(ls ~/.ssh/ | grep $variable | grep -v "pub" | grep -v "no_rsa")
    echo "export GIT_SSH_COMMAND='ssh -i "$HOME"/.ssh/"$nomclef"' git clone" 
    
    echo -e " \u2022 \e[36mCréer une clef ssh\e[m"
    echo "ssh-keygen -t rsa -b 4096"

    eval "$(ssh-agent -s)"
    echo "ssh-add ~/.ssh/"$nomclef
    
    echo -e " \u2022 \e[36mAjouter le sudoer\e[m"
    echo -e "   \e[31msudo usermod -a -G sudo username\e[m"
    
    echo -e " \u2022 \e[36mMemo crontab\e[m"
    echo -e "   \e[31m1 * * * * /usr/bin/autossh.sh\e[m"
} #fonctions a ajouter

function space() {
    cd /tmp 
    file="checkspace.sh"
    wget_file https://florian.lassenay.fr/pub/${file}
    chmod +x /tmp/$file 
    ./$file 
} #space

function help() {
    basics=$(f_basics)
    devs=$(f_devs)
    graphics=$(f_graphics)
    admin=$(f_admin)
    client=$(f_client)
    echo_part "\nConfiguration script for Debian linux system"
    echo_part "[1;31mGPLv3 \e[0;36mand above"
    echo_part "Pizzacoca 2021"
    
   
    echo_part "\nHelp (single config)"
    
    echo_step "update\e[m  : apt-get update and full-upgrade -y"
    echo_step " basic\e[m   : minimal system conf : \e[33m" ${basics[*]// /|}
    echo_step "client\e[m   : outils client administré : \e[33m" ${client[*]// /|}
    echo_step "clientssh\e[m  : création d'une clef ssh sur le poste client"
    echo_step "clientsshadmin\e[m  : ajout de la clef ssh admin sur le poste client"
    echo_step "graphics\e[m   : outils graphiques : \e[33m" ${graphics[*]// /|} blender XnView-MP
    echo_step "dev\e[m   : outils dev : \e[33m" ${devs[*]// /|}
    echo_step "admin\e[m   : outils admin : \e[33m" ${admin[*]// /|}

    echo_part "\nHelp (batch config)"
    
    echo_step "i0\e[m = update + basic"
    echo_step "mi1\e[m = i0 + client"
    echo_step "i2\e[m = i1 + graphics"
    echo_step "i3\e[m = i2 + dev"
    echo_step "i4\e[m = i3 + admin"

    echo_part "\nHelp (Maintenance)"

    echo_step "space\e[m   : récupération d'espace"
 
    echo_part "\nHelp (Memo)"

    echo_step "virtu\e[m  : Vérification capacité virtualisation"
    echo_step "memo\e[m  : memo commandes"


    echo_part "\nLog : \e[m$LOG"
#    echo -e " \u2022 \e[36mmisc\e[m    : add some tools like glances, arp-scan, etc."
#    echo -e " \u2022 \e[36msshd\e[m    : add and configure SSH server"

  
    exit 0
    
} #help


# appel des fonctions
function i0() { exec $0 update basic $basics; }
function i1() { exec $0 update basic client; }
function i2() { exec $0 update basic client graphics; }
function i3() { exec $0 update basic client graphics dev; }
function i4() { exec $0 update basic client graphics dev admin; }

[ $# -eq 0 ] && help


echo -e "Configure : $*" >> $LOG
echo -e "$(date)" >> $LOG

for RUN in $*
do
  echo -e "\n[ $RUN ]" >> $LOG
  $(declare -f -F $RUN)
done

echo -e "\nDone." >> $LOG
echo -e "Configure : $*" >> $LOG
echo -e "$(date)" >> $LOG

