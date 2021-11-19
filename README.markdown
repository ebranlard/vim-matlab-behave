<a href="https://www.buymeacoffee.com/hTpOQGl" rel="nofollow"><img alt="Donate just a small amount, buy me a coffee!" src="https://warehouse-camo.cmh1.psfhosted.org/1c939ba1227996b87bb03cf029c14821eab9ad91/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f446f6e6174652d4275792532306d6525323061253230636f666665652d79656c6c6f77677265656e2e737667"></a>

matlab-behave.vim  
==============

Facilitates the use of vim/gvim as external editor to Matlab (GUI or terminal):
- attempts to reproduce typical F5, F9, Ctrl-Enter "run" functionalities of matlab editor (Linux only).
- adds cell folding and highlighting
- jumping to an error location by clicking on a error link in the command window.


Functionalities
----------------

Below is a list of functionalities. Default mappings are written within parenthesis (See section "Mapping"), and the vim functions are written within brackets. If they do not work, see section "Customization" below.

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

Opening files in vim when an error is thrown: (see "Installation - matlab side" below)


NOTE: The run functionalities are Linux only for now. It is based on "wmctrl" (see Installation - System). 



Basic principle of the "run" functionalities
---------------------------------------------------------------------

- (Save file)
- Copy some text (selection, cell, line, script, etc.) into the two unix clipboards. A tmp file is sometimes used.
- Automatically switch to matlab window (GUI or terminal) using wmctrl (The window name is customized with "g:matlab_behave_window_name", if two windows have this name, this might fail).
- Automatically focus MATLAB's prompt (In modern MATLAB versions it is done with "Ctrl-0" by default. In some previuos edition it was "Escape". It can be customized with "g:matlab_behave_focus_cmd").
- The content is paste automatically (If it fails try customizing "g:matlab_behave_paste_cmd", or use "Ctrl-V" or the middle mouse button).
- (Depending on the command, after pasting, it will go back to vim (see Installation - matlab side) )


Customization
-------------

For mapping customization, see section "Mapping".

- The terminal used by MatRunExtern is customized either by the environment variable $TERM or using the following variable

    let g:matlab_behave_terminal="xterm"  (default)

Depending on the terminal, you might need to customize the pasting cmd (see below).

- The command pasting is customized using the following variable:

    let g:matlab_behave_paste_cmd="ctrl+v" (default)

You can change this variable in your vimrc, for instance "Ctrl+Shift+v" or "Shift+Insert", or any other mapping that would work in the matlab window (GUI or Terminal).


- The software (Matlab and Octave supported) used is customized using the following variable:

    let g:matlab_behave_software="matlab" (default)

or

    let g:matlab_behave_software="octave"



- The Switch to matlab window (GUI or terminal) is done using the linux tool "wmctrl" and is based on the name of the window (try "wmctrl -l" to see a list of window name).
The window base name is defined by default as:

    let g:matlab_behave_window_name="MATLAB R" (default)

This should work for Matlab GUI. When using MatRunExtern the pluggin attempt to force the title of the terminal window using the command line switch -T (supported by xterm and xfce4-terminal) and the above variable.  You can change the variable in your vimrc. If you are opening the terminal yourself and not using MatRunExtern, you could try to set the variable above so that it fits the title of your terminal window (run "wmctrl -l" to find it) or alternatively change the title of the terminal window to fit the variable. For example, for xfce4-terminal, the following command will open Matlab in a proper terminal window with the title "MATLAB R":

    xfce4-terminal -T "MATLAB R" --working-directory=/work/code --command='matlab -nojvm'


<--- If you change to Octave, don't forget to change window base name:
 
     let g:matlab_behave_window_name="OCTAVE"
 
 and use Octave on a window with OCTAVE name, for example:
 
     xfce4-terminal -T "OCTAVE" --working-directory=/work/code --command='octave' --->


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


Special configurations
----------------------------
Below are some tips for special system configurations. 

**Uxing xmonat windows manager**

Include the Ewmh package from contrib in your xmonad config: http://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Hooks-EwmhDesktops.html

**Using Termite (matlab in the terminal)**

Use the ```-t``` switch to set the wm_name of the termite window such that wmctrl can find it (```-t "MATLAB R"``` or change the ```g:matlab_behave_window_name``` variable in your .vimrc)
Pasting from the selection clipboard (used by xclip in this plugin) you need ```let g:matlab_behave_paste_cmd = 'ctrl+shift+v'``` in .vimrc.



Contributing
------------

Please do, and don't hesitate to contact me.


License
-------

Copyright (c) E. Branlard (lastname at gmail dot com).  Distributed under the same terms as Vim itself.
See `:help license`.




Contributing
------------
Any contributions to this project are welcome! If you find this project useful, you can also buy me a coffee (donate a small amount) with the link below:


<a href="https://www.buymeacoffee.com/hTpOQGl" rel="nofollow"><img alt="Donate just a small amount, buy me a coffee!" src="https://warehouse-camo.cmh1.psfhosted.org/1c939ba1227996b87bb03cf029c14821eab9ad91/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f446f6e6174652d4275792532306d6525323061253230636f666665652d79656c6c6f77677265656e2e737667"></a>

