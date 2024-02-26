This is Shelix IDE.

Shelix does intent to maximize the hidden power of tmux as an IDE, paliate to some young age deficiencies of the very cool and incredibly efficient Helix editor, around an interactive menu that performs IDE related actions.
 
Since the Helix editor does not provide an API, controls are automated via keystrokes.

This toolsuite is made to allow the developer to keep full control over all aspects of his development environement, allowing further customisations without third party configurations, in the most straightforward way: shell scripts.

The goal is to obtain the most of our keyboard with a symbiosis of tools that work well together. 

Contributions and suggestions are welcome! 

### System dependencies

Generic infos are given for the Debian family, it is higly recommended to install packages from the sources, in particular to get the last versions.
There is high chance that shelix runs out of the box on proprietary OS, if the blackbox has a shell and understand hashbang scripting, it's a good start.

The system require tmux (tested 3.2, 3.3, 3.4, 3.4 next), PHP8+, and the Helix editor.

`sudo apt install tmux php helix`

Some user-level tools do use ripgrep, fzf, inotify, wmctrl, git, cowsay, unimatrix

`sudo apt install ripgrep fzf wmctrl git`

Files explorer (any of): lf, ranger, fzf (Adapting another one should be straightforward)

`sudo apt install lf`

### Simple run

```
git clone https://github.com/webdev23/shelix.git 
cd shelix
./shelix.sh
```

### Installation into system menus

Make sure `./.local/bin` is sourced in your PATH

And run `./shelix.sh --install` or `shelix --uninstall`

### Quick usage

When an element has underscore, we can catch by acronyms, for example:

New_shelix_window has for natural shortcut: `nsw`

New_shell_above: `nsa`

`Alt + Space ne`     open a New Editor

We do not have to associate complex keyboard shortcuts in some configuration files, overthink them so that they come in symbiosis together, instead those comes naturally with the name of the element.
Shortcuts are then derived by how we name our tools, or are named files. 

```
¤--------------¤-------------¤-----------¤-------------¤
|  Executable  |  Directory  |  Symlink  |  Text file  |
¤-------¤------¤-------------¤-----------¤-------------¤
```

To run the associated action, right arrow or Enter.
To open a script for editing, press Ctrl + Shift + right arrow
To insert a file content into a pane that has a running Helix instance, use Ctrl + right arrow.


### Capabilities

#### Example

<details>
<summary>View features</summary>

- File watcher and auto reload in all running Helix instances
- Live menu tools, scripts, insert snippets, follow symlinks
- Binding to your favorite file explorer
- Explore files within the menu
- Quick access to recently edited files
- Save all buffers in multiple Helix in one action
- Run again the last command on a marked pane at file saving
- Search in multiple buffers, multiples hx instances
- Multiple IDE alike layouts
- Automatic sessions management
- Smart focus between multiple terminal window and sessions 
- Multi-cursor on multiple Helix instance (edit/open multiples files all at once)
- Git integration
- Snippets collection, quick insert at cursor
- Theming, per session, window, or globally. 
- Icons, Unicode for compatibility
- Search and replace tools
- Icons and installers scripts
- Multiple screens support under [X11]
- ZERO config (hopefully!)
- @TODO Pack into one single executable file archive
- @TODO Layout saving by project directory
- @TODO spawn in a browser over xterm.js (..why?)
- @WONT_IMPLEMENT One click debugger (That is too pecific to a language) 
- @TODO Profiling tools

</details>


```
╔----------------------------------------------------------------╗
║ Shelix won't modify any configuration of the host machine,     ║
║ it does source his own environement, path, and detach          ║
║ it all at exit. Not a single internet call is made at anytime. ║
╚----------------------------------------------------------------╝
```

Enjoy editing 100s of files at high speed with 1% CPU of a $5 VPS :)


### Command line usage

 There is a few command line parameters.

 From outside tmux:

```
  shelix                              Open or create a new session in the current dir

  shelix /path/to/dir                 Create a session 
  
  shelix <session_name>               Re-attach to a session, create anew, or extend to multi-screen

  shelix -c <command> -c (...)        Pass (multiple) commands to run on startup

```

 Further options are interactive, and may be scripted (see below)

 From within tmux, running shelix does simply display the menu, and mount the shell to working path.

  ```shelix```

 Feed elements in the menu via pipe (we may use ! to copy to clipboard)

  ```history | shelix -```

 We may feed keystrokes via the pipe: (example: opens a new editor and quit)

  `(echo -n "ne"; sleep 0.1; echo -n "q";) | shelix`


 [X11]
  To work on the same project on multiple screens and multiple terminal, first create a session within your project dir, then open again the same one, you will be asked if you want to extend on the Left or Right. 
  
  By then, the focus key shortcut Shift + arrows will dispatch the focus on all screens, enabling, if all goes well for you, an amazing multi screens workfloW!

  By marking panes, we could dispatch actions from any terminal, for example opening a file on the right screen from the menu on the left screen

```
╔---------------------------------------------------------------------------------------╗
║ Alt + Space opens shelix menu in a popup.                                             ║
║                                                                                       ║
║ Actions dispatched from a popup are dispatched on the pane on focus before the popup. ║
╚---------------------------------------------------------------------------------------╝

Alt + Space         Popup menu                                         
<prefix> Space                                                         
                                                                       
q                   Quit                                          
Escape                                                                 
Ctrl + c                                                               
                                                                       
Up/Down arrows      Move selection                                     
Mouse wheel                                                            
                                                                       
Right arrow         Trigger dispatch action                            
Enter                                                                  
Ctrl + click                                                           
                                                                       
Left arrow          Back up one level in the tree                      
                                                                       
Ctrl + right        Insert text file at cursor in marked editor pane   
Ctrl + Enter                                                           
                                                                       
Keys                Trigger elements by first letter after underscores 
                    (Example: New_shelix_Window = nsw)                 
                                                                       
Escape              Quit and force close popup                                  
                                                                       
!                   Copy selection to system clipboard                 


Ctrl + Up/Down      Move selection faster

Ctrl + PageUp/Down  Move selection even faster

```
                                                                       
Mouse actions can be triggered without focusing on the pane!           

---

To create a new tool, we just add to the "scripts" directory.
That directory is already populated with scripts that performs tiny actions.

We could build a tool using any language, using the hashbang mechanism.
A script may return a simple JSON array, to create a menu list, and the selection is ran again as $1.
This mechansim may allow to build complex utilities on a single file. 

By passing a rocket a 🚀 in the last element in the array, we dispatch selection immediatly.

The content of the "scripts" directory could be fully erased, so we may start fresh anew to build our own dedicated toolbox. 
See "libs" dir for a list of built-in tools that makes the core. Those tools are sourced in the environnement and are available by their namme from any shell within shelix.

Further customisations could be obtained with external utilities like powerline or nerd fonts.

Optimisation of ressources, could be improved by removing elements of the status line or the status line itself. 
                                                
---

```
Tmux <prefix> is Ctrl + b

<prefix> Space                  Open shelix popup
<prefix> Alt + Space            Save pane layout
<prefix> Ctrl + Alt + Space     Restore previously saved pane layout

An extended tmux menu is configured for all tmux related operations:

Alt + Tab

Panes related menu operations can be accessed with:

 <prefix> < or >

```

<details>
<summary>Some useful tmux keysbindings</summary>

All other tmux keybindings are left untouched, between them some that are useful for our purpose:
```
<prefix> {   Swap pane to left
<prefix> }   Swap pane to Right

<prefix> !   Move the pane in a new window

Resize a pan:
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


With a mouse, simply select, press y to copy to system clipboard

Kill current window:
<prefix> &

Detach from session (back to shell, exit tmux)
<prefix> d

List sessions
<prefix> w  , then x to close, y/n to confirm
```
</details>
