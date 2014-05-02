" Name: matlab_behave.vim
" Site: http://github.com/elmanuelito/vim-matlab-behave
" Help And Description:
"   See readme file shipped with plugin
" Author: E. Branlard (lastname at gmail dot com)

" Do not enable this plugin if xclip or wmctrl is unavailable.
if !executable('xclip') || !executable('wmctrl')
    finish
endif

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
    execute "!echo \"edit ".expand("%:p")."\">>/tmp/buff"
    !cat /tmp/buff|xclip -selection c
    normal `m
    !wmctrl -a MATLAB 
endfunction

""" Run Current line
function! MatRunLine()
    " write current line and pipe to xclip
    :.w !xclip -selection c
    "     normal "+yy
    !wmctrl -a MATLAB 
endfunction

""" Run Current Cell
function! MatRunCell()
    normal mm
    :?%%\|\%^?;/%%\|\%$/w !xclip -selection c 
    normal `m
    !wmctrl -a MATLAB 
endfunction

""" Run Current cell and go back to editor
function! MatRunCellAdvanced()
    normal mm
    execute "!echo \"cd(\'".expand("%:p:h")."\')\">/tmp/buff"  
    :?%%\|\%^?;/%%\|\%$/w>> /tmp/buff
    execute "!echo \"edit ".expand("%:f")."\">>/tmp/buff"
    !cat /tmp/buff|xclip -selection c
    normal `m
    !wmctrl -a MATLAB 
endfunction

""" Run current script 
function! MatRun()
    normal mm
    let @+="cd('".expand("%:p:h")."\'); run('".expand("%:p")."')"
    call system('xclip -selection c ', @+)
    call system('xclip ', @+)
    normal `m
    !wmctrl -a MATLAB 
endfunction

""" Run current script in a new matlab session
function! MatRunExtern()
    call system('xterm -e "matlab -nojvm -r '.shellescape('run '.expand("%:p")).'"&')
"     call system('$TERM -e "matlab -nojvm -r '.shellescape('run '.expand("%:p")).'"')
"     call system('matlab -nojvm', "run(\'".expand("%:p")."')" )
"    execute '!echo "' ."run(\'".expand("%:p")."\')" . '"| matlab -nojvm'  
endfunction


" --------------------------------------------------------------------------------
" --- Mappings 
" --------------------------------------------------------------------------------
" Matlab like mappings: 
" map <buffer><F5> :w <cr> :call MatRun() <cr><cr>
" map <buffer><C-CR>,k :w <cr> :call MatRunCell()  <cr><cr>
" vmap <buffer><F9> :call MatRunSelect()  <cr><cr>
" map <buffer>,l :w <cr> :call MatRunLine()  <cr><cr>
" map <buffer><f4> :w <cr> :call MatRunExtern() <cr><cr>
" map <buffer>,n :call MatRunCellAdvanced()  <cr><cr>

" Mapping preferred by the author
map <buffer>,m :w! <cr> :call MatRun() <cr><cr>
map <buffer>,k :w! <cr> :call MatRunCell()  <cr><cr>
map <buffer>,o :call MatRunCellAdvanced()  <cr><cr>
map <buffer>,l :w! <cr> :call MatRunLine()  <cr><cr>
map <buffer><f4> :w! <cr> :call MatRunExtern() <cr><cr>
vmap <buffer><f9> :call MatRunSelect()  <cr><cr>

" 

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
