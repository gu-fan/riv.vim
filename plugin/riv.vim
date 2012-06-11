"=============================================
"    Name: restin.vim
"    File: restin.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-09
" Version: 0.1
"=============================================
let s:cpo_save = &cpo
set cpo-=C
if exists("g:_riv_loaded") "{{{
    finish
endif "}}}
let g:_riv_loaded = 1

call riv#init()

let &cpo = s:cpo_save
unlet s:cpo_save
