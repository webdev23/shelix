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

USESESSION="$1"

logs() {
    local message=$1
    echo "$(date)" >> shelix.logs  
    echo $message >> shelix.logs    
}


pwn() {
    local session_name=$1
    local session_path=$2
    local commands=$3
    local theme=$4

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
    tmux_theme "$SHELIXPATH/themes/$theme.json" --session
    # Maximize window
    wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
    # Attach to screen 
    tmux attach -t "$session_name"
}

# if [[ " $@ " =~ " --theme " ]] || ;then

# fi

if [[ " $@ " =~ " --install " ]];then
    echo "Installing. See shelix.sh for details. "
    # exit
    ln -sf $SHELIXPATH/shelix.sh ~/.local/bin/shelixy
    # Place the shelix.desktop file somewhere it can be found by the OS
    cp -f $SHELIXPATH/install/shelix.desktop ~/.local/share/applications/
    # Add the shelix.desktop file
    cp -f $SHELIXPATH/install/shelix-open.desktop ~/.local/share/applications/
    # Icon
    xdg-icon-resource install --size 128 $SHELIXPATH/shelix-ide.png 
    # Update the paths to the shelix and its icon in the shelix.desktop file(s)
    sed -i "s|SHELIXPATH|$SHELIXPATH|g" ~/.local/share/applications/shelix*.desktop
    # sed -i "s|Icon=SHELIXPATH|Icon=$SHELIXPATH/shelix.png|g" ~/.local/share/applications/shelix*.desktop
    # sed -i "s|Exec=SHELIXPATH|Exec=$SHELIXPATH/shelix|g" ~/.local/share/applications/shelix*.desktop
    exit
fi


if [[ " $@ " =~ " --uninstall " ]];then
    echo "Cleaning down."
    rm ~/.local/bin/shelix
    rm ~/.local/share/applications/shelix.desktop
    rm ~/.local/share/applications/shelix-open.desktop
    xdg-icon-resource uninstall --size 128 shelix-ide.png 
    exit
fi



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
THEME="embers.dark"

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
        --theme) # Adding the new condition for --theme
            if [[ -n $2 && $2 != -* ]]; then
                THEME="$2"
            else
                echo "Error: Missing or invalid value for --theme parameter."
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
    echo -e "$head80"
    echo -e "\033[0:5H$GNUV3"
    echo -e "\033[17;0H=== Welcome to the Shelix IDE ==="

    if [ -n "$USESESSION" ]; then
        echo "::: $USESESSION"
        if [ -e "$USESESSION" ] && [ -d "$USESESSION" ]; then
            session_path="$USESESSION"
            session_name="$(basename $USESESSION)"
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
                pwn "$session_name" "$session_path" "$COMMANDS" "$THEME"
                ;;
            "R" | "r")
                # user pressed R/r
                echo "Extending session on the right..."
                logs "=== Extend session on right === $session_name $PWD"
                printf '\033]2;%s\033\\' "Shelix - $session_name"_R # Terminal title
                pwn "$session_name"_R "$session_path" "$COMMANDS" "$THEME"
                ;;
            "L" | "l")
                # user pressed L/l
                echo "Extending session on the left..."
                logs "=== Extend session on left === $session_name $PWD"
                printf '\033]2;%s\033\\' "Shelix - $session_name"_L # Terminal title
                pwn "$session_name"_L "$session_path" "$COMMANDS" "$THEME"
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
        pwn "$session_name" "$session_path" "$COMMANDS" "$THEME"
    fi
fi

