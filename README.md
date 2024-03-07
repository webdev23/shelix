
### This is Shelix IDE.
</summary>

Shelix does intent to maximize the hidden power of [Tmux](https://github.com/tmux/tmux) as an [IDE](https://en.wikipedia.org/wiki/Integrated_development_environment), enhance capabilities of the incredibly efficient [Helix editor](https://github.com/helix-editor/helix), around an interactive menu that performs IDE related actions.
 
Since the Helix editor does not provide an API, controls are automated via keystrokes.

This toolsuite is made to allow the developer to keep full control over all aspects of his development environement, allowing further customisations without third party configurations, in the most straightforward way: shell scripts.

The goal is to obtain the most of our keyboard with a symbiosis of tools that work well together. 

[Contributions](https://github.com/webdev23/shelix/blob/main/CONTRIBUTING.md) and [suggestions](https://github.com/webdev23/shelix/discussions) are welcome! 

Screenshots gallery: https://github.com/webdev23/shelix/wiki/Screen-captures

![Shelix_IDE](https://github.com/webdev23/shelix/assets/2503337/37f558bf-b2a1-4557-ad68-bd56d429cf7c)

<details>
<summary>👀

### Features
</summary>

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


<details>
<summary>👀

### Requirements
</summary>

The system require tmux (tested 3.2, 3.3, 3.4, 3.4 next), PHP8+, and the Helix editor.

`sudo apt install tmux php helix`

Some user-level tools do use ripgrep, fzf, inotify, wmctrl, git, cowsay, unimatrix

`sudo apt install ripgrep fzf wmctrl git`

Files explorer (any of): lf, ranger, fzf (Adapting another one should be straightforward)

`sudo apt install lf`

</details>

<details open>
<summary>👀

## Run and Install
</summary>

Get a copy of the archive, or clone using git:
```
git clone --depth 1 https://github.com/webdev23/shelix.git 
cd shelix
./shelix.sh
```

#### Install globally
Make sure `./.local/bin` is sourced in your **PATH**

`./shelix.sh --install`

#### Uninstall

`shelix --uninstall`

</details>

<details>
<summary>👀

### Basic Usage
</summary>

When an element has underscore, we can catch by acronyms, for example:

`nsw`                New_Shelix_Window

And if no conflicts in the list, elements can also be called naturally:

`lay`                Layouts

This makes shortcuts available from any panes, using the popup:

`Alt + Space ne`     open a New Editor


Elements have different behavior between their type.

```
¤--------------¤-------------¤-----------¤-------------¤
|  Executable  |  Directory  |  Symlink  |  Text file  |
¤-------¤------¤-------------¤-----------¤-------------¤
```

To run the associated action, `right arrow` or `Enter`.

To open a script for editing, press `Ctrl + Shift + right arrow`

To insert a file content into a pane that has a running Helix instance, use `Ctrl + right arrow`.

Using links to direcctories, Shelix can be used as file explorer.

</details>

<details open>
<summary>👀

### Command line usage
</summary>
 From outside tmux:

```
  shelix                              Open or create a new session in the current directory

  shelix /path/to/dir                 Create a session in that dir
  
  shelix <session_name>               Re-attach to a session, create anew, or extend to multi-screen

  shelix -c <command> -c '...'        Pass (multiple) commands to run on multiple pane on startup

  shelix --theme monokai              Specify a theme (See themes directory for names)

```

  From within tmux, running shelix does simply display the menu, and mount the shell to working path.

  ```shelix```

 Feed elements in the menu via pipe (we may use ! to copy to clipboard)

  `history | shelix -`

  `ls | shelix -`

 We may use built-in capabilities and create layouts.

 `shelix --theme Visiblue -c 'php -S localhost:8080' -c 'hx index.html'`

 [X11]
  To work on the same project on multiple screens and multiple terminal, first create a session within your project dir, then open again the same one, you will be asked if you want to extend on the Left or Right. 
  
  By then, the focus key shortcut Shift + arrows will dispatch the focus on all screens, enabling, if all goes well for you, an amazing multi screens workfloW!

  By marking panes, we could dispatch actions from any terminal, for example opening a file on the right screen from the menu on the left screen



</details>

<details open>
<summary>👀

### Keybindings
</summary>

Shortcuts can be re-configured. (see `/env` directory)

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

Ctrl + Shift + right  Edit scripts source file 
Ctrl + Shift + Enter
                                                                       
Keys                Trigger elements by first letter after underscores 
                    (Example: New_shelix_Window = nsw)                 
                                                                       
Escape              Quit and force close popup                                  
                                                                       
!                   Copy selection to system clipboard                 


Ctrl + Up/Down      Move selection faster

Ctrl + PageUp/Down  Move selection even faster

```
                                                                       
Mouse actions can be triggered without focusing on the pane!           


Tmux is enhanced with those keybindings:

```
Tmux <prefix> is Ctrl + b

<prefix> Alt + Space            Save pane layout
<prefix> Ctrl + Alt + Space     Restore previously saved pane layout

Shift + Arrows                  Move focus betweeen panes

F8 F9                           Move focus between windows

F12                             Zoom pane
Double click


Alt + Tab                       Tmux related operations in a menu


<prefix> < or >                 Panes related menu operations can be accessed with:


```

</details>

<details>
<summary>👀

### Create new tools
</summary>

To create a new tool, we have to populate the "scripts" directory.

We could build a tool using any language, using the hashbang mechanism.
A script may return a simple JSON array, to create a menu list, and the selection is ran again as $1.
This mechansim may allow to build complex utilities on a single file. 

By passing a rocket a 🚀 in the last element in the array, we may dispatch the selection immediatly.

The content of the "scripts" directory could be fully erased, so we may start fresh anew to build our own dedicated toolbox. 
See "libs" dir for a list of built-in tools that makes the core. Those tools are sourced in the environnement and are available by their namme from any shell within shelix.

Further customisations could be obtained with external utilities like powerline or nerd fonts.

Optimisation of ressources, could be improved by removing elements of the status line or the status line itself. 

#### Logs:

`tail -f $SHELIXPATH/shelix.logs `                                              

</details>

<details>
<summary>👀

### More keybindings
</summary>

All other tmux keybindings are left untouched, between them some that are useful for our purpose:
```
<prefix> {                  Swap pane to left
<prefix> }                  Swap pane to Right

<prefix> !                  Move the pane in a new window

<prefix> Ctrl arrows        Resize pan
                            Press Ctrl + b, release b while holding Ctrl, use the arrows

<prefix> [                  Enter copy mode
v                           Enter select mode:
y                           Copy to system clipboard:
<prefix> ]                  Paste (Ctrl + Shift + v)  

<prefix> &                  Kill current window:

<prefix> d                  Detach from session (back to shell, exit tmux)

<prefix> w                  List sessions (we could kill sessionsq from there with `x` to close, `y` to confirm)

```
</details>

```
╔----------------------------------------------------------------╗
║ Shelix won't modify any configuration of the host machine,     ║
║ it does source his own environement, path, and detach          ║
║ it all at exit. Not a single internet call is made at anytime. ║
╚----------------------------------------------------------------╝
```
