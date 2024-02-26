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

# Utility functions



getParamIfExists() {
    local param="$1"

    while [[ $# -gt 0 ]]; do
        case $1 in
            "$param")
                echo "$2"
                return 0
                ;;
        esac
        shift
    done

    return 1  # Parameter not found
}


renameEditorsPanes() {
  running=($(tmux list-panes -F '#{pane_current_command}'))

  for index in "${!running[@]}"; do
    if [ "${running[$index]}" = "hx" ]; then
      tmux selectp -t ":.$index" -T "hx"
    fi
  done
 
}

mountPanes() {
  COUNT=$(tmux list-panes -F '#P')
  # echo $TARGET
  for i in {0..$COUNT}
  do
    tmux send-keys -t $i "cd $SHELIXSESSIONDIR" Enter
  done

}



multibox() {
    local text="$1"
    local max_length=0

    # Get the maximum line length
    while IFS= read -r line; do
        (( ${#line} > max_length )) && max_length=${#line}
    done <<< "$text"

    # Top border
    printf "╔%*s╗\n" $((max_length + 2)) | tr ' ' '-'

    # Text with side borders
    while IFS= read -r line; do
        printf "║ %-${max_length}s ║\n" "$line"
    done <<< "$text"

    # Bottom border
    printf "╚%*s╝\n" $((max_length + 2)) | tr ' ' '-'
}

box() {
    local text="$1"
    local length=${#text}

    # Top border
    printf "╔%*s╗\n" $((length + 2)) | tr ' ' '@'

    # Text with side borders and color codes
    printf "║ %s ║\n" "$text"

    # Bottom border
    printf "╚%*s╝\n" $((length + 2)) | tr ' ' '@'
}

head30="
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⡀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠐⠣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⡄⢹⠀
⠀⢀⣀⣀⣀⠀⣀⠀⠀⡀⠀⣀⣀⣘⡀⢀⡀⠀⠀⠀⣀⠀⢀⠀⠀⣀⠀⡇⢸⠀
⠀⢸⣉⣉⣉⠀⣿⣀⣀⡇⠀⣉⣉⣉⡁⢸⡇⠀⠀⠀⢹⠀⠈⢷⡼⠃⠀⡇⢸⠀
⠀⢈⣉⣉⣿⠀⣿⠉⠉⡇⠀⣉⣉⣉⡁⢸⣇⣀⣀⠀⣼⡀⢠⡞⠻⣄⠀⡇⢸⠀
⠀⠈⠉⠉⠁⠀⠀⠀⠀⠁⠀⠉⠉⢩⠁⠀⠉⠉⠉⠀⠈⠀⠈⠀⠀⠈⠀⣇⡸⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠃⠀⠀
"

head50="

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣄⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣸⣇⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠀⣿⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⣿⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⣿⠀⠀
⠀⠀⢴⣶⣶⣶⣶⣶⠀⠀⣴⡆⠀⠀⠀⣶⠀⠀⢴⣶⣶⣶⣶⣶⠀⠀⣶⡆⠀⠀⠀⠀⠀⢰⣶⡆⠀⢰⣦⡀⠀⣠⡶⠀⠀⣿⠀⣿⠀⠀
⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠹⣷⣴⡿⠁⠀⠀⣿⠀⣿⠀⠀
⠀⠀⠺⠿⠿⠿⠿⣿⠀⠀⣿⡿⠿⠿⠿⣿⠀⠀⠺⠿⠿⠿⠿⠿⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⢀⣽⣿⡄⠀⠀⠀⣿⠀⣿⠀⠀
⠀⠀⢀⣀⣀⣀⣀⣿⠀⠀⣿⡇⠀⠀⠀⣿⠀⠀⢀⣀⣀⣀⣀⣀⠀⠀⣿⣇⣀⣀⣀⣀⠀⢀⣿⡀⠀⢀⣾⠏⠘⢿⣆⠀⠀⣿⠀⣿⠀⠀
⠀⠀⠙⠛⠛⠛⠛⠛⠀⠀⠙⠃⠀⠀⠀⠛⠀⠀⠙⠛⠛⠛⢛⠛⠀⠀⠛⠛⠛⠛⠛⠛⠀⠘⠛⠃⠀⠛⠋⠀⠀⠈⠛⠂⠀⣿⠀⣿⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣀⣿⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣿⠀⠀⠀⠀
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀


head60="
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⢹⡇⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⣿⠀⢸⡇⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⢸⡇⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⢸⡇⠀⠀
⠀⠀⢰⣿⡿⠿⠿⠿⠿⠷⠀⠀⢺⣿⠀⠀⠀⠀⣿⡇⠀⠀⠿⠿⠿⠿⠿⠿⠿⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⢿⣿⠇⠀⠐⢿⣧⠀⠀⣠⣿⠗⠀⠀⣿⠀⢸⡇⠀⠀
⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠈⢻⣷⣴⣿⠋⠀⠀⠀⣿⠀⢸⡇⠀⠀
⠀⠀⠸⣿⣿⣿⣿⣿⣿⣷⠀⠀⢸⣿⣿⣿⣿⣿⣿⡇⠀⠀⢾⣿⣿⣿⣿⣿⡷⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⢀⣿⣿⡇⠀⠀⠀⠀⣿⠀⢸⡇⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⢸⣿⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⢀⣾⡟⠙⣿⣆⠀⠀⠀⣿⠀⢸⡇⠀⠀
⠀⠀⠠⣶⣶⣶⣶⣶⣿⡿⠀⠀⢼⣿⠀⠀⠀⠀⣿⡇⠀⠀⣶⣶⣶⣶⣶⣶⣶⠀⠀⢸⣿⣶⣶⣶⣶⣶⡆⠀⣾⣿⡆⠀⢠⣿⠟⠀⠀⠘⢿⣧⠀⠀⣿⠀⢸⡇⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⢸⡇⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠤⠼⠇⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣿⠀⠀⠀⠀⠀
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀




head70="

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡟⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⢻⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⢀⣀⡀⠀⠀⠀⠀⣀⣀⠀⠀⠀⣀⣀⣀⣀⣀⣀⣁⣀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⠀⠀⢀⣀⡀⠀⠀⠀⢀⣀⡀⠀⠀⢸⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢸⣿⡟⠛⠛⠛⠛⠛⠛⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⣿⠀⠀⠀⠛⠛⠛⠛⠛⠛⠛⠛⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⡟⠀⠀⠈⢿⣷⡄⠀⢠⣾⡿⠁⠀⠀⢸⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⢻⣿⣶⣿⡟⠀⠀⠀⠀⢸⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀⣽⣿⣯⠀⠀⠀⠀⠀⢸⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⢀⣾⣿⠛⣿⣧⡀⠀⠀⠀⢸⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⣤⣤⣤⣤⣤⣤⣿⣿⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⣿⠀⠀⠀⣤⣤⣤⣤⣤⣤⣤⣤⠀⠀⠀⣿⣷⣤⣤⣤⣤⣤⣤⠀⠀⣼⣿⣇⠀⠀⢠⣾⡿⠁⠀⠈⢿⣷⡄⠀⠀⢸⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠛⠛⠛⠛⠛⠛⠛⠋⠀⠀⠈⠛⠃⠀⠀⠀⠀⠙⠋⠀⠀⠀⠛⠛⠛⠛⠛⠛⠛⠛⠀⠀⠀⠛⠛⠛⠛⠛⠛⠛⠛⠀⠀⠛⠛⠋⠀⠀⠙⠛⠁⠀⠀⠀⠈⠛⠋⠀⠀⢸⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠗⠓⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
"

head80="
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⡄⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⢹⡇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⠶⠶⠾⠷⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⣶⡄⠀⢸⡇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀
⠀⠀⠀⢠⣤⣤⣤⣤⣤⣤⣤⣤⣤⠀⠀⠀⢠⣤⡄⠀⠀⠀⠀⢀⣤⣤⠀⠀⠀⣠⣤⣤⣤⣤⣤⣤⣤⣤⡄⠀⠀⢀⣤⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⣤⡄⠀⠀⢠⣤⣤⠀⠀⠀⠀⢀⣤⣤⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀
⠀⠀⠀⢸⣿⣿⠛⠛⠛⠛⠛⠛⠛⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠙⠛⠛⠛⠛⠛⠛⠛⠛⠃⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⠃⠀⠀⠀⠻⣿⣧⡀⠀⢠⣾⣿⠋⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀
⠀⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⠠⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠹⣿⣷⣤⣿⡿⠃⠀⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀
⠀⠀⠀⢸⣿⣿⣶⣶⣶⣶⣶⣶⣦⠀⠀⠀⢸⣿⣷⣶⣶⣶⣶⣾⣿⣿⠀⠀⠀⣤⣶⣶⣶⣶⣶⣶⣶⣶⡄⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠘⣿⣿⡿⠁⠀⠀⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀
⠀⠀⠀⠈⠛⠛⠛⠛⠛⠛⠛⣿⣿⠀⠀⠀⢸⣿⡟⠛⠛⠛⠛⠻⣿⣿⠀⠀⠀⠙⠛⠛⠛⠛⠛⠛⠛⠛⠃⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣆⠀⠀⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⠈⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⢀⣾⣿⠏⠈⢿⣿⣆⠀⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀
⠀⠀⠀⢠⣶⣶⣶⣶⣶⣶⣶⣿⣿⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⢀⣿⣿⠀⠀⠀⣴⣶⣶⣶⣶⣶⣶⣶⣶⡆⠀⠀⢸⣿⣿⣶⣶⣶⣶⣶⣶⣶⡄⠀⢰⣿⣿⡆⠀⠀⢠⣾⣿⠋⠀⠀⠀⢻⣿⣧⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀
⠀⠀⠀⠈⠛⠛⠛⠛⠛⠛⠛⠛⠋⠀⠀⠀⠈⠛⠁⠀⠀⠀⠀⠀⠙⠋⠀⠀⠀⠘⠛⠛⠛⠛⠛⠛⠛⠛⠁⠀⠀⠀⠙⠛⠛⠛⠛⠛⠛⠛⠛⠀⠀⠈⠛⠛⠃⠀⠀⠈⠛⠁⠀⠀⠀⠀⠀⠙⠛⠁⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⢸⡇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡷⠶⠾⠇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠃⠀ ⠀⠀⠀⠀
"

GNUV3="
    Shelix IDE Copyright (C) 2024 NVRM 
    This program comes with ABSOLUTELY NO WARRANTY; for details type show w.
    This is free software, and you are welcome to redistribute it
    under certain conditions; type show c for details.
"

