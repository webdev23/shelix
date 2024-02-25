This is shelix IDE


- File watcher and auto reload in all Helix
- Theming
- Multi-cursor on multiple Helix instance
- Live menu similar to fzf, for your tooling, scripts, snippets, links
- File tree or binding to your favorite file explorer (lf, ranger, mc..)
- Recent files quick access and open multiple
- Save all buffers in multiple Helix in one action
- Run shell command on multiple pane at file saving + auto-reload
- Search in multiple buffers, multiples instance
- Copy/paste buffer with historic
- Multiple IDE alike layouts
- Layout saving by project directory
- Ability to detach an editor out of a pty in a new window
- Sessions management and persistence
- Profiling tools
- One click debugger
- Git integration
- Snippets collection links per directory with quick insert at cursor
- Remote session sharing
- Live screenkeys, show Numlock, Capslock status
- Search and replace user friendly tools over ripgrep
- Can spawn over SSH without X server
- Can spawn in a browser over xterm.js
- Icons and installers scripts
- Pack into one single executable file archive
- Does not modify the machine configurations and clean env
- ZERO config
- Does not require plugins, no remote call, safe and clear
- Ease of extending by following examples
- Dispatch themes on RGB hardware
- 
- 
- 




It's a primarly a set of configuration for tmux, around the Helix editor.
There is set of interactions to manage many running instances of hx.
You get an interactive menu to dispatch some set of actions without the hassle to renember too much keybindings.
You can open files in multiple editors, change themes.
There is tools to customize the UI.
We can dispatch actions on other panes at file change, dispatch multiple cursors on multiple instances, to edit and run commands with visual in realtime.
We can save multiples files in multiple instances of helix all at once.
There is scripts around rigpgrep, lf, fzf, to search for files or   content.    
Simply drop just a file, a script, a directory, or a link into the `scripts` directory, to make it appear in the menu.
If the file is executable, it will run when selected.
If it's a directory, it will dispatch the content.
It will follow symlinks, so we can attach projects directories or snippets, and continue to build our own tooling around the examples given. 

Shelix won't modify any configuration of the host machine, neither tmux or helix or anjything else, it does source it's own environement, path, and detach it all at exit.
There is scripts to build cool system menu launcher if necessary.

It's the proper way to start straight away to build or edit complex codebases. 


The menu allows to select elements and run their actions with the mouse with Ctrl + click.
It's not necessary to focus on the Shelix host pane to trigger elements with Ctrl + click. 
We could then use a combo of wheel and Ctrl + click to use it all.
The element triggered in the sone shown selected on the screen. 


This is tmux, run as many sessions as necessary per project and never lose the flow. Your sessions survives reboots. Your IDE can spawn everywhere , over SSH, even without any X environement on the slowest machine, it's all ready to go.
Enjoy editing 100s of files with 1% CPU of a Raspberry pi.


----------------------------
Use default Tmux keybindings

<prefix> is Ctrl + b

When the focus is on an editor, use:

<prefix> {   Swap pane to left
<prefix> }   Swap pane to Right



To swap the left menu to the right, focus it and:

<prefix> {  


Resize a pan
Press Ctrl + b, release b while holding Ctrl, use the arrows

<prefix> Ctrl arrows 



Enter copy mode
<prefix> [
Enter select mode:
v
Copy to system clipboard:
y
Paste: <prefix> ]
Or paste: Ctrl + Shift + v 


With a mouse, simply select and it will automatic copy to system clipboard


---
Focus pane
