#!/bin/bash
# THIS IS UNDER CONSTRUCTION
#██████╗ ███████╗██╗     ███████╗████████╗███████╗
#██╔══██╗██╔════╝██║     ██╔════╝╚══██╔══╝██╔════╝
#██║  ██║█████╗  ██║     █████╗     ██║   █████╗
#██║  ██║██╔══╝  ██║     ██╔══╝     ██║   ██╔══╝
#██████╔╝███████╗███████╗███████╗   ██║   ███████╗
#╚═════╝ ╚══════╝╚══════╝╚══════╝   ╚═╝   ╚══════╝
#
#████████╗██████╗  █████╗  ██████╗    ██╗      ██████╗  ██████╗ ███████╗
#╚══██╔══╝██╔══██╗██╔══██╗██╔════╝    ██║     ██╔═══██╗██╔════╝ ██╔════╝
#   ██║   ██████╔╝███████║██║         ██║     ██║   ██║██║  ███╗███████╗
#   ██║   ██╔══██╗██╔══██║██║         ██║     ██║   ██║██║   ██║╚════██║
#   ██║   ██║  ██║██║  ██║╚██████╗    ███████╗╚██████╔╝╚██████╔╝███████║
#   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝    ╚══════╝ ╚═════╝  ╚═════╝ ╚══════╝
######## Made by GeordieR. ########
######## Please take a snapshot/backup before you run this #######



#Functions

function get_user_answer_yn(){
  while :
  do
    read -p "$1 [y/n]: " answer
    answer="$(echo $answer | tr '[:upper:]' '[:lower:]')"
    case "$answer" in
      yes|y) return 0 ;;
      no|n) return 1 ;;
      *) echo  "Invalid Answer [yes/y/no/n expected]";continue;;
    esac
  done
}



cat << "MENUEOF"
███╗   ███╗███████╗███╗   ██╗██╗   ██╗
████╗ ████║██╔════╝████╗  ██║██║   ██║
██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝
MENUEOF

shopt -s globstar dotglob

PS3='Please choose what action you would like below: '
vfiles="View log files only"
dfiles="Delete log files"
cancelit="Cancel"
options=("$vfiles" "$dfiles" "$cancelit")
asktorestart=0
select opt in "${options[@]}"
do
    case $opt in
        "$vfiles")
        action="view"
        echo "You chose to view the files only"
        cd /var/lib/docker/overlay2
        ls -lS **/*.log | grep "otnode" | awk  '{print $9}'
        break
            ;;
        "$dfiles")
            echo "You chose to DELETE the log files"
        action="delete"
        cd /var/lib/docker/overlay2
        ls -lS **/*.log | grep "otnode" | awk  '{print $9}' | xargs rm -f
        asktorestart=1
        break
            ;;
       "$cancelit")
            echo "You chose to cancel going any further"
        action="cancel"
break
            ;;
        "Quit")
            exit 1
break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


if [[ $asktorestart -eq 1 ]]
then
  if get_user_answer_yn "Do you want to restart OT node?"
    then
    docker restart otnode && docker logs otnode
  fi
fi
