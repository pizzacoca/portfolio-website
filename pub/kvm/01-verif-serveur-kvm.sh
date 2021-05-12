#! /bin/bash
# source youtube xavki

confirm() {
#
# syntax: confirm [<prompt>]
#
# Prompts the user to enter Yes or No and returns 0/1.
#
# This  program  is free software: you can redistribute it and/or modify  it
# under the terms of the GNU General Public License as published by the Free
# Software  Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This  program  is  distributed  in the hope that it will  be  useful,  but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public  License
# for more details.
#
# You  should  have received a copy of the GNU General Public License  along
# with this program. If not, see <http://www.gnu.org/licenses/>
#
#  04 Jul 17   0.1   - Initial version - MEJT
#
  local _prompt _default _response
 
  if [ "$1" ]; then _prompt="$1"; else _prompt="installation ?"; fi
  _prompt="$_prompt [y/n] ?"
 
  # Loop forever until the user enters a valid response (Y/N or Yes/No).
  while true; do
    read -r -p "$_prompt " _response
    case "$_response" in
      [Yy][Ee][Ss]|[Yy]) # Yes or Y (case-insensitive).
        return 1
        ;;
      [Nn][Oo]|[Nn])  # No or N.
        exit
        ;;
      *) # Anything else (including a blank) is invalid.
        ;;
    esac
  done
} 

install() {
    echo "c'est parti"
    echo "verif de l'installabilité"
    sudo apt install -y cpu-checker
    echo "taper sudo kvm-ok"
    lsmod | grep kvm
    echo "verif du module kernel"
    lsmod | grep -i kvm
#    echo "verif reseau"
#    echo "virsh net-list"
#    sudo virsh net-list
#    sudo virsh net-list --all
#    echo "demarrage du reseau"
#    echo "virsh net-start default"
#    sudo virsh net-start default
#    echo "demarrage automatique du reseau"
#    echo "virsh net-autostart default"
#    sudo virsh net-autostart default
}

verif() {
    local processeurs
    echo "verif de processeurs compatibles"
    processeurs=$(grep -E -c "vmx|svm" /proc/cpuinfo)
    echo "$processeurs processeurs compatibles et disponibles"
}

verif
confirm 
install


