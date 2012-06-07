"=============================================
"    Name: autoload/restin.vim
"    File: autoload/restin.vim
"  Author: Rykka G.Forest
"  Update: 2012-05-17
" Version: 0.5
"=============================================

fun! riv#init() "{{{
    " for init autoload
endfun "}}}
fun! riv#normlist(list) "{{{
    return map(a:list,'matchstr(v:val,''\w\+'')')
endfun "}}}
fun! riv#norm(str) "{{{
    return matchstr('\w+',a:str)
endfun "}}}


