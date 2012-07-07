" Vim indent file
" Language:         reStructuredText Documentation Format
" Maintainer:       Nikolai Weibull <now@bitwi.se>
" Modified By:      Rykka G.Forest <Rykka10@gmail.com>
" Latest Revision:  2012-06-05

if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=riv#insert#indent(v:lnum)
setlocal indentkeys=!^F,o,O
setlocal nosmartindent

