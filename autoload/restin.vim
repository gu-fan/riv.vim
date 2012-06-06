"=============================================
"    Name: autoload/restin.vim
"    File: autoload/restin.vim
"  Author: Rykka G.Forest
"  Update: 2012-05-17
" Version: 0.5
"=============================================

" <sfile> shoud be out of function
let g:restin#autoload_path = expand('<sfile>:p:h')

if has("python") "{{{
    let g:restin#py = "py "
    let g:restin#has_py = 2
elseif has("python3")
    let g:restin#py = "py3 "
    let g:restin#has_py = 3
else
    let g:restin#py = "echom "
    let g:restin#has_py = 0
endif "}}}
if g:restin#has_py "{{{
    exe g:restin#py."import sys"
    exe g:restin#py."import vim"
    exe g:restin#py."sys.path.append(vim.eval('g:restin#autoload_path')  + '/restin/')"
    exe g:restin#py."from restinlib.table import GetTable,Add_Row"
    exe g:restin#py."from restinlib.utils import *"
endif "}}}

fun! restin#init() "{{{
    let g:restin#tbl_ptn = '^\s*+[-=+]\++\s*$\|^\s*|\s.\{-}\s|\s*$'
    let g:restin#sep_ptn = '^\s*+[-=+]\++\s*$'
    let g:restin#con_ptn = '^\s*|\s.\{-}\s|\s*$'
endfun "}}}


