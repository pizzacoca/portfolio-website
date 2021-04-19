# !/bin/bash

REP="$HOME/.config/lass"
LOG=${REP}/logs/init.log
check_config

check_config() {
    if [ $HOME/.config]
    then
      echo_ok ".config existant"
    else
    mkdir -p $REP/logs
    touch $LOG
    mkdir_action $REP
    mkdir_action $REP/logs/
    mkdir_action $REP/keys/
    mkdir_action $REP/sites/
    mkdir_action $HOME/bin/
    mkdir_action $HOME/.config
    fi
} #check_config

function echo_part() { echo "=== $* ===" >> $LOG ; echo -e "\e[0;32m${*}\e[m"; }
function echo_step() { echo "==> $* ==" >> $LOG; echo -e " \u2022 \e[0;36m${*}\e[m"; }
function echo_point() { echo "=> $* =" >> $LOG; echo -e "   \e[0;32m${*}\e[m"; }
function echo_ok() { echo "=> $* =">> $LOG; echo -e "   \e[1;32m${*}\e[m"; }
function echo_ko() { echo "=> $* =" >> $LOG; echo -e "   \e[1;31m${*}\e[m"; }

function wget_file() { 
    echo_step "\e[1;34mDownloading $1 to \e[m \e[0;33m$PWD/${file}\e[m"
    echo "wget_file $*" >> $LOG 2>&1; wget -nc $* >> $LOG 2&>1
    echo_ok "\e[1;32mOK\e[m"
} #wget_file

function mkdir_action() {
    echo_point "création $1" 
    mkdir -p $1
} #mkdir_action

function install() {
    mkdir_action $REP
    mkdir_action $REP/logs/
    mkdir_action $REP/keys/
    mkdir_action $REP/sites/
    mkdir_action $HOME/bin/
    echo "https://florian.lassenay.fr" > $REP/sites/site_init
    echo "ponos.pizzacoca.fr" > $REP/sites/site_sauvegarde
    site_init=$(cat $REP/sites/site_init)
    echo $site_init 
    echo $REP
    wget_file ${site_init}/pub/admin/crgpg -O ${REP}/keys/crgpg
    wget_file ${site_init}/pub/admin/crpgpg -O ${REP}/keys/crpgpg
    admin=( "carbone_rsa.pub" "pizzacoca_rsa.pub" )
    for i in "${admin[@]}"
    	do
    wget_file ${site_init}/pub/admin/$i -O $REP/keys/$i
        done 
    wget_file ${site_init}/pub/maintenance.sh
    chmod +x maintenance.sh
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

