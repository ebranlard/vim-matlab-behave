matlab-behave.vim  (Not for windows so far)
==============

Facilitates the use of vim/gvim as external editor to Matlab and attempt to reproduce typical F5, F9, Ctrl-Enter "run" functionalities of matlab editor.

Case 1: The user wants to use Matlab GUI functionalities while keeping the power of Vim for editing.
Both programs are running independently but the switch from one to the other is automated with this plugin:
- Going from vim to matlab is achieved using wmctrl (Linux). The user then have to paste to Matlab's command window (using mouse middle click or a mapping like Ctrl-V). If you are not on the command window the matlab shortcut Ctrl-0 should bring you there.
- Going from matlab to vim is done by using Matlab command edit(this command may be dumped automatically by this plugin for commands that "go back to the editor") or by using the mouse when an error or warning is thrown in the command window by your script.

Case 2: The use wants the script to be run in a new matlab instance. This is done with the function MatRunExtern (F4). Customize it to your need.


Functionalities
----------------

Below is a list of functionalities. Default mappings are written within parenthesis (see section "Mapping" below for more), and the vim-function are written within brackets.
Reproducing some matlab editor commands:
- "Run current cell" (,k) [MatRunCell]
- "Run current cell and go back to editor" (,o) [MatRunCellAdvanced]
- "Run script" (,m)  [MatRun]
- "Run selection and go back to editor" (F9) [MatRunSelect]

Some additions:
- "Run line" (,l) [MatRunLine]
- "Run in new external matlab" (F4) [MatRunExtern]


Cell and folding support:
- Put cell title in bold. 
- Allow cell folding (za zo) and jumping from cell to cell using vim folding mappings (zj zk)


NOTE: The run functionalities are Linux only for now. It is based on "wmctrl" (see Installation - System). 



Basic principle of the "run" functionalities
---------------------------------------------------------------------

- (Save file)
- Copy some text (selection, cell, line, script run command, etc.) into the two unix clipboards. For this it sometimes use a tmp file.
- Automatically switch to matlab window using wmctrl. If another window contains the name Matlab in it, this might fail.
- User have to paste (using Ctrl-V for instance or the middle mouse button).
- (Depending on the command, after pasting, it will go back to vim (see Installation - matlab side) )


Installation - System
---------------------

Install wmctrl and xclip from your linux distribution

Installation - Vim
------------------

Copy the file "ftplugin/matlab_behave.vim" into the equivalent location in your Vim config directory, e.g.: ~/.vim/ftplugin/ 


If you don't have a preferred installation method, I recommend installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and then simply copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/elmanuelito/vim-matlab-behave.git


Installation - matlab side
---------------------------

This is optional.  For matlab to switch back to vim/gvim automatically go to matlab options: File/Preferences/Editor: set Editor to vim/gvim , e.g. "gvim --remote-tab-silent"

Further, to have the possibility to click on matlab command window links when an error or a warning is thrown to jump directly to the right location in vim you will neet to create a matlab sctip called opentoline.m  and put it in your matlab path. The file content is listed below. For best fonctionality (line number), you might need the vim plugin "file:line.vim".

    function opentoline(file, line, column)
    %   This is a hack to override the built-in opentoline program in MATLAB.
    
        editor = system_dependent('getpref', 'EditorOtherEditor');
        editor = editor(2:end);
        
        if nargin==3
            linecol = sprintf('+%d:%d',line,column);
            linecol = sprintf('+%d',line); % tehre is something about -c "normal column|" but it didn't work
        else
            linecol = sprintf('+%d',line);
        end
        
        if ispc
            % On Windows, we need to wrap the editor command in double quotes
            % in case it contains spaces
            system(['"' editor '" "' linecol '" "' file '"&']);
        else
            % On UNIX, we don't want to use quotes in case the user's editor
            % command contains arguments (like "xterm -e vi")
    %         disp('proiu');
            system([editor ' "' linecol '" "' file '" &']);
        end
    end
    

Other complementary plugins
---------------------------

For best support of matlab use Fabrice Guy's plugin
(syntax, indent,ftplugin, compiler(mlint) )




Mappings
------------------------------------------------

Mappings are defined in the "matlab_behave.vim". (look for Mappings in this file)
The author prefer more "vim-like" mappings that do not require lifting up the hands: ",k" and ",m" respectively to run cell or run script.
Feel free to change these mappings, or uncomment the one above that are the "matlab ones".



Explanation of some commands used
----------------------------

- normal mm : set mark to rememeber where the cursor was
- normal `m : go back to mark
- :?%%\|\%^?;/%%\|\%$/w   : search backward to %% OR beginning of file  and then forward to %% OR \%$ (end of file) and write/pipe the selection to the xclip command
- !wmctrl -a MATLAB  : switch to a window that has "matlab" in its name (hopefully, Matlab itself...)



Contributing
------------

Please do, and don't hesitate to contact me.

License
-------

Copyright (c) E. Branlard (lastname at gmail dot com).  Distributed under the same terms as Vim itself.
See `:help license`.
