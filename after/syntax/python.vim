"=============================================
"    Name: python.vim
"    File: python.vim
" Summary: highlight reStructuredText in python docstring.
"  Author: Rykka G.F
"  Update: 2012-09-25
"=============================================
let s:cpo_save = &cpo
set cpo-=C

if g:riv_python_rst_hl == 1 
    unlet! b:current_syntax
    syn include @python_rst <sfile>:p:h:h:h/syntax/rst.vim
    syn include @python_rst <sfile>:p:h/rst.vim
    syn region  pythonRstString matchgroup=pythonString
        \ start=+[uU]\=\z('''\|"""\)+ end="\z1" keepend
        \ contains=@python_rst
    let b:current_syntax = "python"
endif

let &cpo = s:cpo_save
unlet s:cpo_save
