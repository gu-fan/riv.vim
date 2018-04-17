"=============================================
"    Name: python.vim
"    File: python.vim
" Summary: highlight reStructuredText in python docstring.
"  Author: Rykka G.F
"  Update: 2012-09-25
"=============================================

if exists("b:af_py_loaded") 
    finish
endif

let b:af_py_loaded = 1

let s:cpo_save = &cpo
set cpo-=C

if g:riv_python_rst_hl == 1 
    " Store the current syntax because python-mode set's it's syntax to pymode and
    " not python
    if exists('b:current_syntax')
        let g:_riv_stored_syntax = b:current_syntax
        unlet! b:current_syntax
    endif
    " Let the after/syntax/rst.vim know that this is not a full RST file, this
    " way, it won't enable spelling on the whole file
    let g:_riv_including_python_rst = 1

    syn include @python_rst <sfile>:p:h:h:h/syntax/rst.vim
    syn include @python_rst <sfile>:p:h/rst.vim
    syn region pythonRstString matchgroup=pythonString
        \ start=+[bBfFrRuU]\{0,2}\z('''\|"""\)+ end="\z1" keepend
        \ contains=@python_rst,@Spell
    " Restore the previous syntax
    if exists('g:_riv_stored_syntax')
        let b:current_syntax = g:_riv_stored_syntax
    endif
    " Clear the temporary variable
    unlet! g:_riv_stored_syntax
    unlet! g:_riv_including_python_rst
endif

hi link pythonRstString pythonString

let &cpo = s:cpo_save
unlet s:cpo_save

