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
    " Store the current syntax because python-mode set's it's syntax to pymode and
    " not python
    let g:_riv_stored_syntax = b:current_syntax
    " Let the after/syntax/rst.vim know that this is not a full RST file, this
    " way, it won't enable spelling on the whole file
    let g:_riv_incluing_python_rst = 1

    unlet! b:current_syntax
    syn include @python_rst <sfile>:p:h:h:h/syntax/rst.vim
    syn include @python_rst <sfile>:p:h/rst.vim
    syn region  pythonRstString matchgroup=pythonString
        \ start=+[uU]\=\z('''\|"""\)+ end="\z1" keepend
        \ contains=@python_rst,@Spell
    " Restore the previous syntax
    let b:current_syntax = g:_riv_stored_syntax
    " Clear the temporary variable
    unlet! g:_riv_stored_syntax
    unlet! g:_riv_incluing_python_rst
endif

let &cpo = s:cpo_save
unlet s:cpo_save
