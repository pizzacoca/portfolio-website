# !/bin/bash

LOG=~/.config/install.log

function apt_update() { apt-get update >> $LOG 2>&1; }
function apt_upgrade() { apt-get full-upgrade -y >> $LOG 2>&1; }
function apt_install() { apt-get install $* -qy >> $LOG 2>&1; }

function wget_file() { 
    echo_step "\e[1;34mDownloading\e[m \e[0;33m$PWD/${file}\e[m"
    echo "wget_file $*" >> $LOG; wget -nc $* >> $LOG 2&>1
    echo -e "\e[1;32m    OK \e[m"
} #wget_file

function echo_step() { echo "> $*" >> $LOG; echo -e " \u2022 ${*}"; }
function i3() {
    apt_install i3
    apt_install xorg
    apt_install suckless-tools
    apt_install xbacklight
    echo ‘exec i3’ > ~/.xsession
    wget https://florian.lassenay.fr/pub/confs/config ~/.config/i3/config_new
    wget https://florian.lassenay.fr/pub/confs/i3status.conf ~/.config/i3/i3status.conf_new
    
} #bureau


function help() {
    echo -e "\e[36m\nConfiguration script for tuning Debian linux system\e[m"
    echo -e "\e[1;31mGPLv3 \e[0;36mand above\e[m"
    echo -e "\e[36mPizzacoca 2021\e[m"

    echo -e "\n\e[32mHelp (single config)\e[m"
    
    echo -e " \u2022 \e[36mupdate\e[m  : apt-get update and full-upgrade -y"


    echo -e "\n\e[32mHelp (batch config)\e[m"
    
    echo -e " \u2022 \e[36mi3\e[m = Install et configuration i3"
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

