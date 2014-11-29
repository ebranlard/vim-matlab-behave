matlab-behave.vim  
==============

Facilitates the use of vim/gvim as external editor to Matlab and attempt to reproduce typical F5, F9, Ctrl-Enter "run" functionalities of matlab editor.

Case 1: The user wants to use Matlab GUI functionalities while keeping the power of Vim for editing.
Both programs are running independently but the switch from one to the other is automated with this plugin:
- Going from vim to matlab is achieved using wmctrl (Linux). The user then have to paste to Matlab's command window (using mouse middle click or a mapping like Ctrl-V). If you are not on the command window the matlab shortcut Ctrl-0 should bring you there.
- Going from matlab to vim is done by using Matlab command edit(this command may be dumped automatically by this plugin for commands that "go back to the editor") or by using the mouse when an error or warning is thrown in the command window by your script.

Case 2: The use wants the script to be run in a new matlab instance. This is done with the function MatRunExtern (F4). Customize it to your need.


Functionalities
----------------

Below is a list of functionalities. Default mappings are written within parenthesis (Mappings are activated by default. See section "Mapping" below for more), and the vim-function are written within brackets.
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

Opening files in vim when an error is trown: (see "Installation - matlab side" below)


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


Install wmctrl, xclip and xdotool from your linux distribution.

I didn't look for alternatives on windows. Please contribute. 


Installation - Vim
------------------

Copy the file "ftplugin/matlab_behave.vim" into the equivalent location in your Vim config directory, e.g.: ~/.vim/ftplugin/ 


If you don't have a preferred installation method, I recommend installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and then simply copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/elmanuelito/vim-matlab-behave.git


Installation - matlab side
---------------------------

This is optional.  For matlab to switch back to vim/gvim automatically go to matlab options: File/Preferences/Editor: set Editor to vim/gvim , e.g. "gvim --remote-tab-silent"

Further, to have the possibility to click on matlab command window links when an error or a warning is thrown to jump directly to the right location in vim: 

- For versions before 2012 (I think), things were easier. It was enough to add the file "opentoline.m" (present in this repository) to your matlab path.
For best fonctionality (line number), you might need the vim plugin "file:line.vim".

- For version 2013 (I think), they started to hard-code the opentoline functionality in their java interface. I doesnt hurt to add opentoline.m to your matlab path. It might work.
When an error is thrown, it is still possible to open a file in vim by overriding the file +helpUtils/errorDocCallback.m
   - Create a folder "+helpUtils"
   - put the file errorDocCallback.m (from this repository)
   - Add the root folder to your maltba path. 
This will work when you click on the filename, but not when you click on the line number (this would open matlab editor...). If you manage to override this opentoline, let me know...


- For above versions, I haven't tried but maybe the 2013 option works..



    

Other complementary plugins
---------------------------

For best support of matlab use Fabrice Guy's plugin
(syntax, indent,ftplugin, compiler(mlint) )




Mappings
------------------------------------------------

Mappings are activated by default.
Mappings are defined in the "matlab_behave.vim". (look for Mappings in this file)
- To desactivate the mappings add in your vimrc:

    let g:matlab_behave_mapping_kind=-1


- To switch between the different kinds of mapping, change the value of the variable above.
   - The "kind=1" mappings are the one prefered by the author (more "vim-like", they do not require lifting up the hands: ",k" and ",m" respectively to run cell or run script)
   - The "kind=0" mappings are the "matlab ones"



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
