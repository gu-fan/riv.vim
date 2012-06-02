" Vim indent file
" Language:         reStructuredText Documentation Format
" Maintainer:       Nikolai Weibull <now@bitwi.se>
" Latest Revision:  2011-08-03

let s:keepcpo= &cpo
set cpo&vim
if exists("b:did_rst_indent")
  finish
endif
let b:did_rst_indent = 1
setlocal indentexpr=GetRSTinIndent()
setlocal indentkeys=!^F,o,O
setlocal nosmartindent

if exists("*GetRSTinIndent")
  finish
endif

let s:lst_ptn = '^\s*[-*+]\s\+\|^\s*\%(\d\+\|#\)\.\s\+'

function GetRSTinIndent()
  let lnum = prevnonblank(v:lnum - 1)
  if lnum == 0
    return 0
  endif

  let ind = indent(lnum)
  let line = getline(lnum)
    
  let pind = matchend(line,s:lst_ptn)
  if pind != -1
      let pwht = matchend(line,'^\s*')
      return pind-pwht+ind
  endif

  let line = getline(v:lnum - 1)

  " Indent :FIELD: lines.  Don’t match if there is no text after the field or
  " if the text ends with a sent-ender.
   if line =~ '^:.\+:\s\{-1,\}\S.\+[^.!?:]$'
     return matchend(line, '^:.\{-1,}:\s\+')
   endif

  if line =~ '^\s*$'
    execute lnum
    call search('^\s*\%([-*+]\s\|\%(\d\+\|#\)\.\s\|\.\.\|$\)', 'bW')
    let line = getline('.')
    if line =~ s:bul_ptn
      let ind -= 2
    elseif line =~ s:enm_ptn
      let ind -= matchend(line, s:enm_ptn)
    elseif line =~ '^\s*\.\.'
      let ind -= 3
    endif
  endif

  return ind
endfunction
let &cpo = s:keepcpo
unlet s:keepcpo
