#!/bin/bash

# Configuration script for :
# DEBIAN 10 (Buster), 9 (Stretch) or 8 (Jessie)

REP="$HOME/.config/lass"
mkdir -p ${REP}/logs
LOG=${REP}/logs/maintenance.log

function sauvegarde() {
    site=$(cat $REP)/sites/site_sauvegarde
    return $site
} #site

function site() {
    site=$(cat ${REP}/sites/site_init)
    #echo "site : "$site
    return $site
} #site

function k_init() {
    k_ssh=$(cat ${REP}/keys/crgpg)
    return $k_init
} #k_init

function k_pass() {
    k_pass=$(cat ${REP}/keys/crpgpg)
    return $k_pass
} #k_init

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
function echo_ok() { echo "=> $* =" >> $LOG; echo -e "   \e[1;32m${*}\e[m"; }
function echo_ko() { echo "=> $* =" >> $LOG; echo -e "   \e[1;31m${*}\e[m"; }

function wget_file() { 
    echo_step "\e[1;34mDownloading\e[m \e[0;33m$PWD/${file}\e[m"
    echo "wget_file $*" >> $LOG; wget -nc $* >> $LOG 2&>1
    echo_ok "\e[1;32mOK\e[m"
} #wget_file

function test(){
    echo_part "ok"
	echo_step "ok"
	echo_ok "ok"
	echo_ko "KO"
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

function f_packages() {
    case $1 in
basic)
    array=( "vim" "sudo" "pass" "gpg" "sshpass" "mcrypt" )
    ;;
admin)
    array=( "net-tools" "x2goclient" "nmap" "whois" "meld")
    ;;
bureau)
    array=( "i3" "redshift" "keepass2" "thunar"\
	    "xpdf" )
    ;;
network)
    array=( "rsync" "tcpdump" "net-tools" "sshpass" "nmap" )
    ;;
client)
    array=( "openssh-server" "x2goserver" "x2goserver-session" )
    ;;
dev)
    array=( "git" "python3" "python3-pip" "virtualenv" "virtualenvwrapper" )
    ;;
graphic)
    array=( "kile" "dia" "gimp" )
    ;;
clef_admin)
    array=$(clefs_admin( "carbone_rsa.pub" "pizzacoca_rsa.pub" ))
    ;;
    esac
    use_array "${array[@]}"
    if [ $2 ]
        then
        for i in "${array[@]}"
        	do
        apt_install $i
        	done
    fi
} #f_packages

function clefs_admin () {
    array=( "carbone_rsa.pub" "pizzacoca_rsa.pub" )
    use_array "${array[@]}"
} #clef_admin

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

function admin() {
    echo_step "Mise à jour et installation utilitaires admin"
    f_packages admin 1
} #admin

function todo() {
    echo "x2goclient"
    echo "x2goserver"
    echo "openssh-server"
} #todo

function basic() {
    echo_part "Mise à jour et installation utilitaires de base"
    f_packages basic 1
} #basics

function client() {
    echo_part "MàJ & install poste client"
    f_packages client 1
} #client

function dev() {
    echo_part "Mise à jour et installation outils dev"
    f_packages dev 1
    echo_step "\e[36mEdition de bashrc :\e[m"
    sed -i -e "s/#alias ll/alias ll/g" $HOME/.bashrc
    sed -i -e "s/#force_color_prompt/force_color_prompt/g" $HOME/.bashrc
    echo_point "ajout de PS1 dans .bashrc"
    echo "export PS1='\[\033[0;37m\]\h:\[\033[0;33m\]\W\[\033[0m\]\[\033[1;32m\]\$(__git_ps1)\[\033[0m\] \$ '" >> $HOME/.bashrc

} #dev

function graphics() {
    echo_part "Installation applis graphiques disponibles dans les dépots officiels"
    f_packages graphic 1
    file="XnViewMP-linux-x64.deb"
    cd /opt 
    wget_file https://download.xnview.com/${file}
    dpkg_file $file 
    
    file="blender-2.92.0-linux64.tar.xz"
    wget_file https://download.xnview.com/${file}

} # graphics

function sshadmin() {
	site=$(site)
    echo_part "Configuration poste client"
    echo_step "Ajout de client.config"
    wget_file ${site}/pub/confs/client/client.config 
    mv client.config $HOME/.ssh/client.config

    echo "Include $HOME/.ssh/client.config" >> $HOME/.ssh/config

    echo_part "Ajout des clefs ssh d'administration"
    echo $site
    echo $REP
    admin=$(ls $REP/admin)  #( "carbone_rsa.pub" "pizzacoca_rsa.pub" )
    for i in "${admin[@]}"
    	do
	echo "${site}/pub/admin/$i"
    wget_file ${site}/pub/admin/$i 
    cat $i >> $HOME/.ssh/authorized_keys
    rm $i
    echo_ok "$i ajoutée"
    	done
} #clientsshadmin
   
function savessh() {
	site=$(site)
    sauvegarde=$(sauvegarde)
    k_ssh=$(cat ${REP}/keys/crgpg)
    k_pass=$(cat ${REP}/keys/crpgpg)
    echo_step "Sauvegarde de la clef ssh"
    tar -cvf /tmp/${HOSTNAME}.tar $HOME/.ssh/${HOSTNAME}_rsa.pub #$HOME/.ssh/${HOSTNAME}_rsa 
    gpg -c /tmp/${HOSTNAME}.tar

    gpg -d ${k_ssh} > $HOME/.ssh/client_rsa
    
    export SSHPASS=$(gpg -d ${k_pass})
    sshpass -e scp -i $HOME/.ssh/client_rsa /tmp/${HOSTNAME}.gpg client@${sauvegarde}:ssh_clients/ 
    unset SSHPASS
    rm ${REP}/keys/crgpg
    rm ${REP}/keys/crpgpg
    rm $HOME/.ssh/client_rsa
    rm /tmp/${HOSTNAME}.gpg /tmp/${HOSTNAME}.tar
} #savessh

function sshGen() {
    echo_step "\e[36mGénération de la clef ssh $1\e[m"
    #echo_point -e "nom de la clef : "$HOME"/.ssh/"$HOSTNAME"_rsa"
    ssh-keygen -t rsa -b 4096 -f $1
 
} #sshGen

function sshclient() {
    clef=$HOME"/.ssh/"$HOSTNAME"_rsa"
    sshGen $clef
    #savessh
    #echo_step "parametrage de GIT_SSH_COMMAND"
    #nomclef=$(ls $HOME/.ssh/ | grep $variable | grep -v "pub" | grep -v "no_rsa")
    #echo "export GIT_SSH_COMMAND='ssh -i "$HOME"/.ssh/"$nomclef"' git clone" 
 
} #clientssh

function virtu() {
    processeurs=$(grep -E -c "vmx|svm" /proc/cpuinfo)
    echo_point "\e[1;31m$processeurs \e[0;36mprocesseurs compatibles et disponibles\e[m"
    mkdir kvm2
    cd kvm2 
    wget florian.lassenay.fr/pub/kvm/01-verif-serveur-kvm.sh
    wget florian.lassenay.fr/pub/kvm/02-install-serveur-kvm.sh
    wget florian.lassenay.fr/pub/kvm/03-reseau-serveur.sh
    wget florian.lassenay.fr/pub/kvm/04-gestion-graphique-serveur.sh
    wget florian.lassenay.fr/pub/kvm/05-ajout-user.sh
    wget florian.lassenay.fr/pub/kvm/102-remove-serveur-kvm.sh
    wget florian.lassenay.fr/pub/kvm/serveur-kvm.sh
} #verif_virtu

function memo() {
    echo -e " \u2022 \e[36mPour ajouter le GIT_SSH_COMMAND taper :\e[m"
    variable=$(cat /etc/hostname)
    nomclef=$(ls $HOME/.ssh/ | grep $variable | grep -v "pub" | grep -v "no_rsa")
    echo "export GIT_SSH_COMMAND='ssh -i "$HOME"/.ssh/"$nomclef"' git clone" 
    
    echo -e " \u2022 \e[36mCréer une clef ssh\e[m"
    echo "ssh-keygen -t rsa -b 4096"

    eval "$(ssh-agent -s)"
    echo "ssh-add $HOME/.ssh/"$nomclef
    
    echo -e " \u2022 \e[36mAjouter le sudoer\e[m"
    echo -e "   \e[31msudo usermod -a -G sudo username\e[m"
    
    echo -e " \u2022 \e[36mMemo crontab\e[m"
    echo -e "   \e[31m1 * * * * /usr/bin/autossh.sh\e[m"
} #fonctions a ajouter

function space() {
    cd /tmp 
    file="checkspace.sh"
    wget_file ${site}/pub/${file}
    chmod +x /tmp/$file 
    ./$file 
} #space

function getInfos() {
	cat infos.txt | grep $1 | cut -d: -f2
} #getInfos

function openssh() {
    clef=$HOME"/.ssh/"$HOSTNAME"_no_rsa"
    if [ "$clef" ];then
        echo_ko "$clef existe déja";
    else
        question="Voulez-vous créer une clef ssh sans mot de passe ?"
        askYesNo "$question"
        choixClef=$?
        if [ $choixClef -eq 1 ]; then
            sshGen $clef
        fi
    fi
    echo_part "Génération du script autossh"
    clef=$(ls $HOME/.ssh/ | grep no_rsa)
    #ssh_server=$(cat ref | grep ssh_server | cut -d: -f2 )
    ssh_server=$( getInfos ssh_server )
    #ssh_server=$(awk '{print $2}' "$server") 
    echo "#!/bin/sh
    ssh -N -f -R 22227:localhost:22222 $HOSTNAME@$ssh_server -p 22222 -i $HOME/.ssh/$clef -vvv &
    " #> /usr/bin/openssh
    echo_part "Récupération de clients.config"
    sshFile=$( getInfos admin_files )
    wget $sshFile"/clients.config" 
    echo_part "Enrichissement de clients.config"
    #numPort=$(cat admin/clients.config | grep port | awk '{print $2}' | tail -1)
    numPort=$(cat clients.config | grep port | awk '{print $2}' | tail -1)
    let "numPort=$numPort + 1"
    echo "
Host		$HOSTNAME.$ssh_server
port		$numPort" >> clients.config
    echo_part "Export de la configuration"
    wget $sshFile"/id_client_ponos_rsa.nc" 
    mcrypt -d id_client_ponos_rsa.nc
    scp client@$ssh_server:archives/clients.config -i ./id_client_ponos_rsa


} #openssh

function askYesNo() {
        QUESTION=$1
        DEFAULT=$2
        if [ "$DEFAULT" = true ]; then                    # Valeur par défaut définie en paramètre
                OPTIONS="[O/n]"
                DEFAULT="o"
            else
                OPTIONS="[o/N]"
                DEFAULT="n"
        fi
        #read -p "$QUESTION $OPTIONS" -n 1 -s -r INPUT    # Execute au premier caractère (-n 1)
        read -p "$QUESTION $OPTIONS" INPUT 
        INPUT=${INPUT:-${DEFAULT}}                        # Si $INPUT vide => remplace par $DEFAULT
        #echo_part ${INPUT}
        if [[ "$INPUT" =~ ^[yYoO]$ ]]; then               # True si y,Y,O ou o
            return 1
	    #ANSWER=true
        else                                              # Faux pour le reste
            return 0
	    #ANSWER=false
        fi
} #askYesNo
function help() {
    basics=$(f_packages basic)
    devs=$(f_packages dev)
    graphics=$(f_packages graphic)
    admin=$(f_packages admin)
    client=$(f_packages client)
    bureau=$(f_packages bureau) 
    network=$(f_packages network) 
    echo_part "\nConfiguration script for Debian linux system"
    echo_part "[1;31mGPLv3 \e[0;36mand above"
    echo_part "Pizzacoca 2021"
    
   
    echo_part "\nroot (mises à jour et installations)"
    
    echo_step "update    :\e[m apt-get update and full-upgrade -y"
    echo_step "basic     :\e[m minimal system conf : \e[33m" ${basics[*]// /|}
    echo_step "client    :\e[m outils client administré : \e[33m" ${client[*]// /|}
    echo_step "bureau     :\e[m installation bureau : \e[33m" ${bureau[*]// /|}
    echo_step "network     :\e[m outils réseau : \e[33m" ${network[*]// /|}
    echo_step "graphics  :\e[m outils graphiques : \e[33m" ${graphics[*]// /|} blender XnView-MP
    echo_step "dev :\e[m   : outils dev : \e[33m" ${devs[*]// /|}
    echo_step "admin     :\e[m : outils admin : \e[33m" ${admin[*]// /|}
    echo_step "openssh     :\e[m : cron openssh : \e[33m"

    echo_part "\nroot (config rapide)"
    
    echo_step "i0 =\e[m update + basic"
    echo_step "i1 =\e[m i0 + client"

    echo_part "\nHelp (Maintenance)"

    echo_step "space     :\e[m récupération d'espace"
    echo_step "sshclient :\e[m création d'une clef ssh sur le poste client"
    echo_step "sshadmin  :\e[m ajout de la clef ssh admin sur le poste client"
    echo_step "savessh     :\e[m sauvegarde des clefs ssh perso"
 
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

