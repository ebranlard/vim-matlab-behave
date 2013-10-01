matlab-behave.vim
==============

Reproduces several matlab behavior.

Attempts to reproduce: 
- "Run current cell" (Ctrl-Enter -> ,k)
- "Run script" (F5 -> ,m) 
- "Run selection" (F9)

Provides also the following:
- "Run line" (,l)
- "Run in new external matlab" (F4)


Gives other functionality:
- Put cell title in bold. 
- Allow cell folding (za zo) and jumping from cell to cell using vim folding mappings (zj zk)


NOTE: See section "Mapping" below

NOTE: The run functionalities are Linux only for now.


Basic principle of the run functionality 
----------------------------------------

- copy some text into the two unix clipboards (sometimes use a tmp file first)
- switch to matlab window
- user have to paste (using Ctrl-V for instance).
- Depending on the command, after command is pasted and executed, it will go back to vim (see Installation - matlab side)



Installation - vim
------------------

Copy the file "ftplugin/matlab_behave.vim" into the equivalent location in your Vim config directory, e.g.: ~/.vim/ftplugin/ 


If you don't have a preferred installation method, I recommend installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and then simply copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/elmanuelito/vim-matlab-behave.git


Installation - matlab side
---------------------------

For matlab to switch back to vim/gvim automatically
In Matlab: File/Preferences/Editor: set Editor to vim/gvim , e.g. "gvim --remote-tab-silent"

To have the possibility to click on matlab command window links when an error or a warning is thrown to jump directly to the right location in vim you will neet to create a matlab sctip called opentoline.m  and put it in your matlab path. The file content is listed below. For best fonctionality (line number), you might need the vim plugin "file:line.vim".

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

Please do!

License
-------

Copyright (c) E. Branlard (lastname at gmail dot com).  Distributed under the same terms as Vim itself.
See `:help license`.
