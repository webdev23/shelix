#!/bin/bash
# ╔-----------------------------------------------------------------------╗
# ║                                                                       ║
# ║ This file is part of the Shelix IDE.                                  ║
# ║ Copyright (C) 2024 NVRM webdev23 https://github.com/webdev23          ║
# ║                                                                       ║
# ║ This program is free software: you can redistribute it and/or modify  ║
# ║ it under the terms of the GNU General Public License as published by  ║
# ║ the Free Software Foundation, either version 3 of the License, or     ║
# ║ (at your option) any later version.                                   ║
# ║                                                                       ║
# ║ This program is distributed in the hope that it will be useful,       ║
# ║ but WITHOUT ANY WARRANTY; without even the implied warranty of        ║
# ║ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         ║
# ║ GNU General Public License for more details.                          ║
# ║                                                                       ║
# ║ You should have received a copy of the GNU General Public License     ║
# ║ along with this program.  If not, see <http://www.gnu.org/licenses/>. ║
# ╚-----------------------------------------------------------------------╝

export SHELIXPATH=$(dirname $(readlink -f $0))

export PATH="$SHELIXPATH/libs/:$PATH"

source $SHELIXPATH/env/utils.sh

logs() {
    local message=$1
    echo "$(date)" >> shelix.logs  
    echo $message >> shelix.logs    
}


pwn() {
    local session_name=$1
    local session_path=$2
    local commands=$3

    tmux new-session -d -s "$session_name" -c "$session_path"    
    # Write logs
    logs "=== New Session === $session_name $session_path"
    # tmux system config 
    tmux source ~/.tmux.conf
    # override tmux config 
    # tmux config
    tmux source $SHELIXPATH/env/tmux.conf.sh
    # Store workdir path for later
    tmux setenv SHELIXSESSIONDIR $session_path
    # Panes layout
    if [ "$commands" != "1" ];then
      "$SHELIXPATH"/libs/layouts/base $session_path
    else 
      "$SHELIXPATH"/libs/layouts/reactor $session_path $commands
    fi
    # Colors and ui  
    tmux_theme $SHELIXPATH/themes/embers.dark.json --session
    # Maximize window
    wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
    # Attach to screen 
    tmux attach -t "$session_name"
}


# @TODO improve command line param handling
if [[ " $@ " =~ " -l0 " ]]; then
    "$SHELIXPATH"/libs/layouts/base
    exit
fi

# STDIN
if [ -t 0 ]; then
  : # null
else
  if [[ " $@ " =~ " - " ]]; then  
    cat > /tmp/stdin.txt
    tmux respawnp        
    tmux send "cd $SHELIXPATH && ./main -f /tmp/stdin.txt" ENTER 
    exit
  fi
fi

# Parse commands -c 
rm /tmp/commands.txt 2> /dev/null
COMMANDS=""
# Commands feed
while [[ $# -gt 0 ]]; do
    case "$1" in
        -c)
            echo "has -c param"
            if [[ -n $2 && $2 != -* ]]; then
                echo "$2" >> /tmp/commands.txt
                COMMANDS="1"
                # echo "$2" >> COMMANDS
            else
                echo "Error: Missing or invalid value for -c parameter."
                exit 1
            fi
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done


if [ "$TERM_PROGRAM" = tmux ]; then
    # Shelix is ran under tmux, display the menu only
    printf '\033]2;%s\033\\' 'shelix' # Pane title
    cd $SHELIXPATH && ./main
    # cd $SHELIXPATH && ./main
else
    echo "=== Welcome (back) to the Shelix IDE :] ==="

    if [ -n "$1" ]; then
        if [ -e "$1" ] && [ -d "$1" ]; then
            session_path="$1"
            session_name="$(basename $1)"
            echo "Session name = $session_name "
            echo "Session path = $session_path "
        else
            session_name=$(basename $PWD)
            session_path=$PWD
        fi
    else
        session_name=$(basename $PWD)
        session_path=$PWD
    fi
    
    # Check if a session already exists
    if tmux has-session -t "$session_name" 2>/dev/null; then
     
       printf '\033]2;%s\033\\' "Shelix - $session_name" # Terminal title

        echo -e "Session \033[7m$session_name\e[0m already exists."
        echo " ENTER    Open session"
        echo " K/k      Kill and start a new $session_name session"
        echo " R/r      Extend $session_name on the right"
        echo " L/l      Extend $session_name on the left"
        read -p "? " choice


        case "$choice" in
            "K" | "k")
                # user pressed K/k
                tmux kill-session -t "$session_name" 
                logs "=== Session killed === $session_name"  
                printf '\033]2;%s\033\\' "Shelix - $session_name" # Terminal title
                echo "Killing and starting a new session..."
                pwn "$session_name" "$session_path" "$COMMANDS"
                ;;
            "R" | "r")
                # user pressed R/r
                echo "Extending session on the right..."
                logs "=== Extend session on right === $session_name $PWD"
                printf '\033]2;%s\033\\' "Shelix - $session_name"_R # Terminal title
                pwn "$session_name"_R "$session_path" "$COMMANDS"
                ;;
            "L" | "l")
                # user pressed L/l
                echo "Extending session on the left..."
                logs "=== Extend session on left === $session_name $PWD"
                printf '\033]2;%s\033\\' "Shelix - $session_name"_L # Terminal title
                pwn "$session_name"_L "$session_path" "$COMMANDS"
                ;;
            *)
                # user pressed ENTER
                echo "Opening session..."
                logs "=== Session attached === $session_name"
                printf '\033]2;%s\033\\' "Shelix - $session_name" # Terminal title
                tmux attach -t "$session_name"
                ;;
        esac

    else
        logs "=== New Session === $session_name $PWD"
        printf '\033]2;%s\033\\' "Shelix - $session_name" # Terminal title
        pwn "$session_name" "$session_path" "$COMMANDS"
    fi
fi

