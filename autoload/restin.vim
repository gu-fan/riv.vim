"=============================================
"    Name: autoload/restin.vim
"    File: autoload/restin.vim
"  Author: Rykka G.Forest
"  Update: 2012-05-17
" Version: 0.5
"=============================================

fun! restin#normlist(list) "{{{
    return map(a:list,'matchstr(v:val,''\w\+'')')
endfun "}}}
fun! restin#norm(str) "{{{
    return matchstr('\w+',a:str)
endfun "}}}

fun! restin#init() "{{{
endfun "}}}
