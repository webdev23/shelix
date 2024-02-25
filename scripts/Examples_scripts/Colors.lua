#!/usr/bin/env lua

-- Get the current pane index
local tmuxCommand = io.popen("tmux display-message -p '#{pane_index}'")
local CURRENTPANE = tonumber(tmuxCommand:read("*a")) or 0
tmuxCommand:close()

-- Initialize variables
local wrap = 0

-- Loop through color codes and print color samples
for i = 0, 255 do
    io.write(('\27[38;5;%dm%3d '):format(i, i))
    wrap = wrap + 4

    -- Wrap to a new line after every 20 color samples
    if wrap >= 20 then
        io.write('\27[0m\n')
        wrap = 0
    end
end

-- Print newline for better formatting
print("\n")

-- Prompt user for background and text colors
io.write("Background color: ")
local BG = io.read()

io.write("Text color: ")
local FG = io.read()

-- Set tmux status style based on user input
os.execute("tmux set -s status-style 'bg=colour" .. BG .. ",fg=colour" .. FG .. ",none,align=left'")
os.execute("tmux kill-pane")
