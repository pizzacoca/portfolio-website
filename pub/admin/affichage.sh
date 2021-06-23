# Configuration script for :
# DEBIAN 10 (Buster), 9 (Stretch) or 8 (Jessie)

function echo_part() { echo "=== $* ===" >> $LOG; echo -e "\e[0;32m${*}\e[m"; }
function echo_step() { echo "==> $* ==" >> $LOG; echo -e " \u2022 \e[0;36m${*}\e[m"; }
function echo_point() { echo "=> $* =" >> $LOG; echo -e "   \e[0;32m${*}\e[m"; }
function echo_ok() { echo "=> $* =" >> $LOG; echo -e "   \e[1;32m${*}\e[m"; }
function echo_ko() { echo "=> $* =" >> $LOG; echo -e "   \e[1;31m${*}\e[m"; }

