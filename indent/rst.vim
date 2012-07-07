
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=riv#insert#indent(v:lnum)
setlocal indentkeys=!^F,o,O
setlocal nosmartindent

