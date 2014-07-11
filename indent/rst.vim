
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=riv#insert#indent(v:lnum)
setlocal indentkeys=!^F,o,O
setlocal nosmartindent

" NOTE: for using `<left><del>` instead of `<BS>`, we should set the
" `whichwrap` and `backspace` option 
setlocal ww=b,s,<,>,[,]
setlocal bs=indent,eol,start
" NOTE: Fix del here, Does it have any sideeffects?
fixdel

