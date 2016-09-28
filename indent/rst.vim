
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentkeys=!^F,o,O
setlocal nosmartindent

" NOTE: for using `<left><del>` instead of `<BS>`, we should set the
" `whichwrap` and `backspace` option 
setlocal ww=b,s,<,>,[,]
setlocal bs=indent,eol,start
" NOTE: Fix del here, Does it have any sideeffects?

if exists("g:riv_disable_del") && g:riv_disable_del != 1
    if ! has('nvim')
        " neovim got rid of the fixdel command
        fixdel
    endif
endif

if exists("g:riv_disable_indent") && g:riv_disable_indent == 1
    " from vim74/indent/rst.vim
    setlocal indentexpr=GetRSTIndent()

    if exists("*GetRSTIndent")
        finish
    endif

    function GetRSTIndent()
    let lnum = prevnonblank(v:lnum - 1)
    if lnum == 0
        return 0
    endif

    let ind = indent(lnum)
    let line = getline(lnum)

    if line =~ s:itemization_pattern
        let ind += 2
    elseif line =~ s:enumeration_pattern
        let ind += matchend(line, s:enumeration_pattern)
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
        if line =~ s:itemization_pattern
        let ind -= 2
        elseif line =~ s:enumeration_pattern
        let ind -= matchend(line, s:enumeration_pattern)
        elseif line =~ '^\s*\.\.'
        let ind -= 3
        endif
    endif

    return ind
    endfunction
else
    setlocal indentexpr=riv#insert#indent(v:lnum)
endif



