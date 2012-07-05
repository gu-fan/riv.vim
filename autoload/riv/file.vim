"=============================================
"    Name: file.vim
"    File: file.vim
" Summary: file operation
"          find /match/delete/
"  Author: Rykka G.Forest
"  Update: 2012-06-08
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C


let &cpo = s:cpo_save
unlet s:cpo_save
