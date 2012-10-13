"=============================================
"    Name: riv.vim
"    File: riv.vim
" Summary: rst filetype plugin
"  Author: Rykka G.F
"  Update: 2012-09-19
"=============================================

" for force reload
let g:riv_force = exists("g:riv_force") ? g:riv_force : 0
if exists("b:did_rstftplugin") && g:riv_force == 0 | finish | endif
let b:did_rstftplugin = 1
let s:cpo_save = &cpo
set cpo-=C

call riv#buf_init()

let &cpo = s:cpo_save
unlet s:cpo_save
