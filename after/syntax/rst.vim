
" a line start with '\n\n\s\w' maybe considered end comment
" so end should not match eol:'^\n' either
syn clear rstComment
execute 'syn region rstComment contained' .
      \ ' start=/.*/'
      \ ' end=/^\v(\s|\n)@!/ contains=rstTodo'

" if we using syntax fold.
" we should use several section region to contain things
" error foldlevel
" syn region rstSectionR start=@^.\+\n\([=`:.'"~^_*+#-]\)\1\+$@ end=@^.\+\n\zs1\+$@ fold keepend transparent

" NOTE: use %(\_^\s*\n)@<=  to match preceding with a blank line.
syn clear rstSections
syn match   rstSections "\v%(\_^\s*\n)@<=\S+\n([=`:.'"~^_*+#-])\1+$"
syn match   rstSections "^\%^.\+\n\([=`:.'"~^_*+#-]\)\1\+$"
syn match   rstSections "^\(\([=`:.'"~^_*+#-]\)\2\+\)\n.\+\n\1$"

" transition should sep with blank line
syn clear rstTransition
syn match   rstTransition  /\v%(\_^\s*\n)@<=[=`:.'"~^_*+#-]{4,}\s*$/


syn match rstEnumList `\v\c^\s*([-*+•‣⁃]|%(\d+|[a-z]|[imcxv]+)(\.|\))) `
syn match rstDefList `\v\c%(\_^\s*\n)@<=(\w[[:alnum:] _.-]+)\ze(:.+)*\n    \w`
syn match rstDefList `\v\c%(\_^\s*\n)@<=(%(    )+)(\w[[:alnum:] _.-]+)\ze(:.+)*\n\1    \w`
syn match rstFieldList `\v\c^\s*:[[:alnum:]_.-]+: `
syn cluster rstLists contains=rstEnumList,rstDefList,rstFieldList
" g:ext_ptn
let ext_ptn = '|vim|cpp|c|py|rb'
let ptn_rst = '\v%([~0-9a-zA-Z:./]+%(\.%(rst'.ext_ptn.')|/))\S@!'
exe 'syn match rstRSTfile `'.ptn_rst.'`'
syn match rstOption `\v^(-\w|--[[:alnum:]_.-]+|/\u)>`
syn match rstQuote  `\v%(\_^\s*\n)@<=    -- .*`

hi def link rstRSTfile Underlined
hi link rstTransition Typedef
hi def link rstEnumList Function
hi def link rstDefList Function
hi def link rstFieldList Function
hi def link rstOption Statement
hi def link rstQuote Delimiter
hi link rstStandaloneHyperlink Underlined
