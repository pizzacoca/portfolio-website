# !/bin/bash

rep="$HOME/.config/lass"
LOG=${rep}/logs/init.log

function echo_part() { echo "=== $* ===" >> $LOG ; echo -e "\e[0;32m${*}\e[m"; }
function echo_step() { echo "==> $* ==" >> $LOG; echo -e " \u2022 \e[0;36m${*}\e[m"; }
function echo_point() { echo "=> $* =" >> $LOG; echo -e "   \e[0;32m${*}\e[m"; }
function echo_ok() { echo "=> $* =">> $LOG; echo -e "   \e[1;32m${*}\e[m"; }
function echo_ko() { echo "=> $* =" >> $LOG; echo -e "   \e[1;31m${*}\e[m"; }

function wget_file() { 
    echo_step "\e[1;34mDownloading\e[m \e[0;33m$PWD/${file}\e[m"
    echo "wget_file $*" >> $LOG 2>&1; wget -nc $* >> $LOG 2&>1
    echo_ok "\e[1;32mOK\e[m"
} #wget_file

function install() {
    mkdir ~/.config/client
    mkdir -p ~/.config/client/logs/
    mkdir -p ~/.config/client/keys/
    mkdir -p ~/.config/client/sites/
    echo "https://florian.lassenay.fr" > ~/.config/client/sites/site_init
    echo "ponos.pizzacoca.fr" > ~/.config/client/sites/site_sauvegarde
    site_init=$(cat ~/.config/client/sites/site_init)
    echo $site_init 
    echo $rep
    wget_file ${site_init}/pub/admin/crgpg -O ${rep}/keys/crgpg
    wget_file ${site_init}/pub/admin/crpgpg -O ${rep}/keys/crpgpg
    admin=( "carbone_rsa.pub" "pizzacoca_rsa.pub" )
    for i in "${admin[@]}"
    	do
    wget_file ${site_init}/pub/admin/$i -O ~/.config/client/keys/$i
        done 
    wget_file ${site_init}/pub/maintenance.sh
} #install

function help() {
    echo_part "\nConfiguration script for tuning Debian linux system"
    echo_part "\e[1;31mGPLv3 \e[0;32mand above"
    echo_part "Pizzacoca 2021"

    echo_part "\nHelp (single config)"
    
    echo_step "install\e[m  : initialisation du répertoire de config pour init.sh "

    echo_part "\nfichier log : "$LOG

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

