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

# That file is a tmux configuration file
# An extension ".sh" is given 
# So we may profit from syntax highlighting

set -ga terminal-overrides ",*256col*:Tc"

# set -g default-command /bin/bash

set -sg escape-time 0

set -g repeat-time 600 # Affects pane resizing

set -g window-size latest

setw -g aggressive-resize

set-option -g display-time 1000


#################################
set -g mouse on                 #
#################################
# Pane double click to zoom     #
#################################
bind -Troot DoubleClick1Pane resizep -Zt=
#################################
# Pane triple click to maximize #
#################################
bind -Troot TripleClick1Pane resizep -R 10
#################################
# Disallow wheel scrolling      #
#################################
#bind-key -T root WheelUpPane "send-keys -M"


####################################
setw -g mode-keys vi               #
####################################
# Enter copy mode: <prefix> [      #
# Select:          v  then arrows  #
# Yank             y               #
# Paste            <prefix> P or   #
#                  <prefix> ]      #
####################################
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -i -sel clipboard"
bind P paste-buffer


########################
# AI TOOLS             #
########################
bind-key -n F1 run-shell "$SHELIXPATH/scripts/Chat/./Chat_hx_selection"


########################
# Cycle trough windows #
########################
bind-key -n F9 previous-window
bind-key -n F10 next-window

##########################
# Maximize pane in focus #
##########################
bind-key -r -T root F12 resize-pane -Z

################################
# Shift + arrows to focus pane #
################################
bind-key -n S-Up    select-pane -U
bind-key -n S-Down  select-pane -D
bind-key -n S-Left  run-shell 'select_pane_right'
bind-key -n S-Right run-shell 'select_pane_left'

####################################
# Save and restore panes position #
###################################
bind M-Space run-shell 'save_layout'
bind C-M-Space run-shell 'restore_layout'

###############
# Rename pane #
###############
bind < command-prompt -p "New Title: " -I "#{pane_title}" "select-pane -T '%%1'"


#################
# Multi cursors #
#################
bind-key X set-window-option synchronize-panes\; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"

###################################
# Bind space to shelix popup menu #
###################################
# Desactivate <prefix> space (original: cycle layouts)
unbind Space
# bind Space popup -w 50% -h 50% -E "cd $SHELIXPATH && ./main"
# bind -n M-Space popup -w 50% -h 50% -E "cd $SHELIXPATH && ./main"
bind Space popup -x 0 -y 0 -w 50% -h 50% -E "shelix"
bind -n M-Space popup -x P -y P -w 20% -h 30% -E "shelix"

#################################
# Tmux menu with main functions #
#################################
bind-key -n M-Tab display-menu -x 0% -y S \
    "New Window"                         ␍ new-window \
    "Kill pane"                          k "respawn-pane -k" \
    "Kill Window"                        K "killw"  \
    "" \
    "Horizontal Split"                  \" "split-window -h" \
    "Vertical Split"                     % "split-window -v"  \
    "Layout Horizontal"                  h "select-layout even-horizontal"  \
    "Layout Vertical"                    k "select-layout even-horizontal"  \
    "" \
    "Mark/unmark pane"                   m "selectp -m" \
    "Swap with marked pane"              M  "swap-pane" \
    "Swap with next"                    \{ "swap-pane -U" \
    "Swap with previous"                \} "swap-pane -D" \
    "Break pane to new window"          \! "break-pane" \
    "Join Pane"                          j "choose-window 'join-pane -h -s \"%%\"'" \
    "#{?window_zoomed_flag,Unzoom,Zoom}" z "resize-pane -Z" \
    "" \
    "Choose Window"                      w choose-window \
    "Previous Window"                    p previous-window \
    "Next Window"                        n next-window \
    "New Session"                        S "command-prompt -p \"New Session:\" \"new-session -A -s '%%'\"" \
    "Kill Session"                       x "confirm-before kill-session" \
    "Kill Other Session(s)"              X "confirm-before kill-session -a"



# Focus hooks debug
#set focus-events on
#set-hook -g pane-focus-in "run 'echo I #{pane_id} $(date) >>/tmp/focus'; on_focus #{pane_id}"
#set-hook -g pane-focus-out "run 'echo O #{pane_id} $(date) >>/tmp/focus'"


# Pane title monitor
#set-hook -g after-new-pane "run-shell 'tmux set remain-on-exit on; pane_title_monitor &'"
#set-hook -g after-split-window "run-shell 'tmux set remain-on-exit on; pane_title_monitor &'"



display-message -p 'Configuration succeed'


