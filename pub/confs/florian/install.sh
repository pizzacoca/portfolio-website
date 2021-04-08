# !/bin/bash

LOG=~/.config/install.log

function apt_update() { apt-get update >> $LOG 2>&1; }
function apt_upgrade() { apt-get full-upgrade -y >> $LOG 2>&1; }
function apt_install() { 
    echo_step "Installing \e[33m$1"
    apt-get install $* -qy >> $LOG 2>&1 
    echo_point "\e[1;32mOK\e[m"
} #apt_install

function echo_part() { echo "=== $* ===" >> $LOG; echo -e "\e[0;32m${*}\e[m"; }
function echo_step() { echo "==> $* ==" >> $LOG; echo -e " \u2022 \e[0;36m${*}\e[m"; }
function echo_point() { echo "=> $* =" >> $LOG; echo -e "   \e[0;32m${*}\e[m"; }
function echo_OK() { echo "=> $* =" >> $LOG; echo -e "   \e[1;32m${*}\e[m"; }
function echo_KO() { echo "=> $* =" >> $LOG; echo -e "   \e[1;31m${*}\e[m"; }

function wget_file() { 
    echo_step "\e[1;34mDownloading\e[m \e[0;33m$PWD/${file}\e[m"
    echo "wget_file $*" >> $LOG; wget -nc $* >> $LOG 2&>1
    echo_point "\e[1;32mOK \e[m"
} #wget_file

function test(){
	echo_part "ok"
	echo_step "ok"
	echo_point "\e[1;32mok\e[m"
	echo_point "\e[0;36mpass init un-identifiant-au-choix"
	echo_point "\e[0;33mpass init toto"
} #test

use_array () { 
	 for idx in "$@"; 
	 do echo "$idx" 
	 done 
 } #use_array 

create_array () { 
	local array=("a" "b" "c") use_array "${array[@]}" 
} #use_array

function f_app() {
    array=( "chromium" )
    use_array "${array[@]}"
} #f_app

function preuser() {
    echo_step "Edition ~/.profile"
    pro="~/.profile"
    echo "
    EDITOR=vim
    VISUAL=$EDITOR
    export EDITOR VISUAL" >> $pro
} #preuser

function premail () {
    echo_part "Installation neomutt"
	apt_install neomutt
	apt_install curl
	apt_install isync
	apt_install msmtp
	apt_install pass
    echo_step "Génération de la clef primaire gpg"
    gpg --full-generate-keya
    echo_ok "OK"
    echo_step "Installation mutt-wizard"
	cd ~/git
	git clone https://github.com/LukeSmithxyz/mutt-wizard
	cd mutt-wizard
	sudo make install
	echo_ok "OK"
	echo_point "Si pass n'est pas déja initié :"
	echo_point "\e[0;33mpass init un-identifiant-au-choix"
} #premail

function mail () {
    echo_part "Installation mails florian"
#    wget https://florian.lassenay.fr/pub/confs/$HOSTNAME ~/.config/florian	
    
} #mail
function app() {
    app=($(f_app))
    echo_part "Installation applis supplémentaires"
    for i in "${app[@]}"
    	do
    apt_install $i
    	done
} #app
function i3() {
    echo_step "Installation & paramétrage i3"
    apt_install i3
    apt_install xorg
    apt_install suckless-tools
    #apt_install xbacklight
    echo ‘exec i3’ > ~/.xsession
    wget https://florian.lassenay.fr/pub/confs/config ~/.config/i3/config_new
    wget https://florian.lassenay.fr/pub/confs/i3status.conf ~/.config/i3/i3status.conf_new    
} #i3


function help() {
    app=$(f_app)
    echo $app
    echo_part "\nConfiguration script for tuning Debian linux system"
    echo_part "\e[1;31mGPLv3 \e[0;32mand above"
    echo_part "Pizzacoca 2021"

    echo_part "\nHelp (single config)"
    
    echo_step "update\e[m  : apt-get update and full-upgrade -y"


    echo_part "\nHelp (batch config)"
    
    echo_step "i3\e[m = Install et configuration i3"
    echo_step "premail\e[m = pré-configuration comptes mail"
    echo_step "preuser\e[m = pré-configuration user"
    echo_step "app\e[m = install \e[33m" ${app[*]// /}
} # help


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

