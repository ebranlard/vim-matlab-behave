" Name: matlab_behave.vim
" Site: http://github.com/elmanuelito/vim-matlab-behave
" Help And Description:
"   See readme file shipped with plugin
" Author: E. Branlard (lastname at gmail dot com) and Github contributors!

" Documentation:
" Registers:
"    Clear register a
"       normal qaq 
"    Set a register to a given value
"       let @a ="\n" 
"    Use redirection to a buffer       
"       redir @s
"       echo "..."
"       redir end
"    Search backward and forawrd and paste in register s (uppercase S is to append)
"       :?%%\|\%^?;/%%\|\%$/y S
"       :?%%\|\%^?;/%%\|\%$/y s



" --------------------------------------------------------------------------------
" --- Cell title in bold 
" --------------------------------------------------------------------------------
highlight MATCELL cterm=bold term=bold gui=bold
match MATCELL /%%.*$/

" --------------------------------------------------------------------------------
" --- Folding 
" --------------------------------------------------------------------------------
function! MatlabFolds()
    let thisline = getline(v:lnum)
    if match(thisline,'^[\ ]*%%') >=0
        return ">1"
    else
        return "="
    endif
endfunction

setlocal foldmethod=expr
setlocal foldexpr=MatlabFolds()


" --------------------------------------------------------------------------------
" --- Run functionality requirements 
" --------------------------------------------------------------------------------
" Do not enable this plugin if some if these tools are unavailable.
" Linux: they should be installed by the user
" Windows: The rest of the script is rely on these tools, so is not compatible
if !executable('xclip') || !executable('wmctrl') || !executable('xdotool')
	echo "vim-matlab-behave needs xclip, wmctrl and xdotool to be installed."
    finish
endif


" --------------------------------------------------------------------------------
" --- Customization of the command to swtich to matlab and paste
" --------------------------------------------------------------------------------
if !exists("g:matlab_behave_window_name")
    let g:matlab_behave_window_name="MATLAB R"
endif
if !exists("g:matlab_behave_paste_cmd")
    let g:matlab_behave_paste_cmd="ctrl+v"
endif
if !exists("g:matlab_behave_software")
    let g:matlab_behave_software="matlab"
    let g:matlab_behave_software_param="-nojvm"
endif
" Which terminal to use for MatRunExtern
if !exists("g:matlab_behave_terminal")
    " Testing wheter environment variable exists
    if empty($TERM)
        " Default value
        let g:matlab_behave_terminal="xterm" 
    else
        let g:matlab_behave_terminal=$TERM
    end
endif

""" SwitchPastecommand: Switch to matlab window and paste in it. 
" Customize it with the two variables above in your vimrc.  
" Thanks to adrianolinux for the idea.
function! SwitchPasteCommand()
    " !wmctrl -a "MATLAB R";xdotool key "ctrl+v"
    execute "!wmctrl -a \"".g:matlab_behave_window_name."\";xdotool key \"Escape\";xdotool key \"".g:matlab_behave_paste_cmd."\""
endfunction

" --------------------------------------------------------------------------------
" --- Cell title in bold 
" --------------------------------------------------------------------------------
""" Run selection (and go back to vim)
function! MatRunSelect()
    normal mm
    !rm -f /tmp/buff
    redir > /tmp/buff
    echo @*
    redir END
    execute "!echo \" \">>/tmp/buff"
    " execute "!echo \"edit ".expand("%:p")."\">>/tmp/buff"
    !cat /tmp/buff|xclip -selection c
    normal `m
    :call SwitchPasteCommand()
endfunction

""" Run Current line
function! MatRunLine()
    " write current line and pipe to xclip
    :.w !xclip -selection c
    "     normal "+yy
    :call SwitchPasteCommand()
endfunction

""" Run Current Cell
function! MatRunCell()
    normal mm
"     :?%%\|\%^?;/%%\|\%$/w !xclip -selection c 
" Search cell and write to register b (uppercase B to append)
    :?%%\|\%^?;/%%\|\%$/y b
    call system('xclip -selection c ', @b)
    call system('xclip ', @b)
    normal `m
    :call SwitchPasteCommand()
endfunction

""" Run Current cell and go back to editor
function! MatRunCellAdvanced()
    normal mm
    execute "!echo \"cd(\'".expand("%:p:h")."\')\">/tmp/buff"  
    :?%%\|\%^?;/%%\|\%$/w>> /tmp/buff
    execute "!echo \"edit ".expand("%:f")."\">>/tmp/buff"
    !cat /tmp/buff|xclip -selection c
    normal `m
    :call SwitchPasteCommand()
endfunction

""" Run current script 
function! MatRun()
    normal mm
    let @+="\n cd('".expand("%:p:h")."\'); run('".expand("%:p")."')"
    call system('xclip -selection c ', @+)
    call system('xclip ', @+)
    normal `m
    :call SwitchPasteCommand()
endfunction

""" Run current script in a new matlab session
function! MatRunExtern()
    if g:matlab_behave_software == "matlab"
        call system(g:matlab_behave_terminal." -T '".g:matlab_behave_window_name."' -e \"".g:matlab_behave_software." ".g:matlab_behave_software_param." -r ".shellescape('run '.expand("%:p"))."\"&")
    elseif g:matlab_behave_software == "octave"
        call system(g:matlab_behave_terminal." -T '".g:matlab_behave_window_name."' -e ".g:matlab_behave_software." --persist ".shellescape(expand("%:p"))."&")
    endif
endfunction


" --------------------------------------------------------------------------------
" --- Mappings 
" --------------------------------------------------------------------------------
if !exists("g:matlab_behave_mapping_kind")
    let g:matlab_behave_mapping_kind=1
endif

" Matlab like mappings: 
if g:matlab_behave_mapping_kind == 0
    map <buffer><F5> :w <cr> :call MatRun() <cr><cr>
    map <buffer><C-CR>,k :w <cr> :call MatRunCell()  <cr><cr>
    vmap <buffer><F9> :call MatRunSelect()  <cr><cr>
    map <buffer>,l :w <cr> :call MatRunLine()  <cr><cr>
    map <buffer><f4> :w <cr> :call MatRunExtern() <cr><cr>
    map <buffer>,n :call MatRunCellAdvanced()  <cr><cr>
endif

" Mapping preferred by the author
if g:matlab_behave_mapping_kind == 1
    map <buffer>,m :w! <cr> :call MatRun() <cr><cr>
    map <buffer>,k :w! <cr> :call MatRunCell()  <cr><cr>
    map <buffer>,o :call MatRunCellAdvanced()  <cr><cr>
    map <buffer>,l :w! <cr> :call MatRunLine()  <cr><cr>
    map <buffer><f4> :w! <cr> :call MatRunExtern() <cr><cr>
    vmap <buffer><f9> :call MatRunSelect()  <cr><cr>
endif

" 

" --------------------------------------------------------------------------------
" ---  With Align plugin
" --------------------------------------------------------------------------------
" Remeber there is \tt for latex tables and \tsp for spaces
vmap ,af :Align Ip0p1= = ( ) ; % ,<CR>
vmap ,ae :Align Ip0p1= = ; %<CR>
"  vmap ,aa :Align Ip0p1= = ; %<CR>
" --------------------------------------------------------------------------------
" ---  Old
" --------------------------------------------------------------------------------
" autocmd BufEnter *.m compiler mlint 
" Save Matlab session
" map ,ss :w <cr> :mksession! /work/code/SessionMatlab.vim <cr>
