" Vim Syntax File for ReStructuredText in after/syntax
" fix rst.vim
" Author:   Rykka. G  <Rykka10(at)gmail.com>
" Update:   2012-06-01
" first load /usr/share/vim/vim73/syntax/rst.vim
" vim: fdm=marker:

" rstComment:a line start with '\n\n\s\w' maybe considered end comment
" so end should not match eol:'^\n' either  "{{{
syn clear rstComment
execute 'syn region rstComment contained' .
      \ ' start=/.*/'
      \ ' end=/^\v(\s|\n)@!/ contains=rstTodo'
"}}}
" it's a side effect of defining rstComment here that it have highest prior to
" highlight . we should redefine ALL the next group of rstExplicitMarkUp "{{{
syn clear rstFootnote rstCitation rstHyperlinkTarget rstExDirective
syn clear rstSubstitutionDefinition
let s:ReferenceName = '[[:alnum:]]\+\%([_.-][[:alnum:]]\+\)*'
execute 'syn region rstFootnote contained matchgroup=rstDirective' .
      \ ' start=+\[\%(\d\+\|#\%(' . s:ReferenceName . '\)\=\|\*\)\]\_s+' .
      \ ' skip=+^$+' .
      \ ' end=+^\s\@!+ contains=@rstCruft,@NoSpell'

execute 'syn region rstCitation contained matchgroup=rstDirective' .
      \ ' start=+\[' . s:ReferenceName . '\]\_s+' .
      \ ' skip=+^$+' .
      \ ' end=+^\s\@!+ contains=@rstCruft,@NoSpell'

syn region rstHyperlinkTarget contained matchgroup=rstDirective
      \ start='_\%(_\|[^:\\]*\%(\\.[^:\\]*\)*\):\_s' skip=+^$+ end=+^\s\@!+

syn region rstHyperlinkTarget contained matchgroup=rstDirective
      \ start='_`[^`\\]*\%(\\.[^`\\]*\)*`:\_s' skip=+^$+ end=+^\s\@!+

syn region rstHyperlinkTarget matchgroup=rstDirective
      \ start=+^__\_s+ skip=+^$+ end=+^\s\@!+
execute 'syn region rstExDirective contained matchgroup=rstDirective' .
      \ ' start=+' . s:ReferenceName . '::\_s+' .
      \ ' skip=+^$+' .
      \ ' end=+^\s\@!+ contains=@rstCruft'

execute 'syn match rstSubstitutionDefinition contained' .
      \ ' /|' . s:ReferenceName . '|\_s\+/ nextgroup=@rstDirectives'
"}}}

" fix section and transition "{{{
" NOTE: use %(\_^\s*\n)@<=  to match preceding with a blank line.
" %(\S.*\n)@<! matches no preceding non-blank line (blank or file start)
syn clear rstSections
syn match   rstSections &\v%(\S+\s*\n)@<!\_^.*\S.*\n([=`:.'"~^_*+#-])\1+$&
" syn match   rstSections "^\%^.\+\n\([=`:.'"~^_*+#-]\)\1\+$"
syn match   rstSections "^\v%(\S+\s*\n)@<!(([=`:.'"~^_*+#-])\2+)\n.*\S.*\n\1$"

" NOTE: transition should sep with blank line before and after.
syn clear rstTransition
syn match   rstTransition  /\v%(\_^\s*\n)@<=[=`:.'"~^_*+#-]{4,}\s*(\n\s*\_$)\@=/
"}}}

" define missing rst objects "{{{
syn match rstEnumList `\v\c^\s*([-*+•‣⁃]|%(\d+|[a-z]|[imcxv]+)(\.|\))) @=`
syn match rstEnumList `\v\c^\s*\((%(\d+|[a-z]|[imcxv]+)\)) @=`
syn match rstDefList `\v\c%(\_^\s*\n)@<=(\w[[:alnum:] _.-]+)\ze(:.+)*\n\s@=`
syn match rstDefList `\v\c%(\_^\s*\n)@<=(\w[[:alnum:] _.-]+)\ze(:.+)*\n\s@=`
syn match rstFieldList `\v\c^\s*:[[:alnum:]_.-]+: `
syn cluster rstLists contains=rstEnumList,rstDefList,rstFieldList
let g:restin_ext_ptn= exists("g:restin_ext_ptn") ? g:restin_ext_ptn : '|vim|cpp|c|py|rb|lua|pl'
 
let ext_ptn = g:restin_ext_ptn
let ptn_rst = '\v%([~0-9a-zA-Z:./-]+%(\.%(rst'.ext_ptn.')|/))\S@!'
exe 'syn match rstRSTfile `'.ptn_rst.'`'
syn match rstOption `\v^(-\w|--[[:alnum:]_.-]+|/\u)>`
syn match rstQuote  `\v%(\_^\s*\n)@<=    -- .*`
"}}}

" relink "{{{
hi link rstTransition Typedef
hi link rstStandaloneHyperlink Underlined
hi def link rstRSTfile Underlined
hi def link rstEnumList Function
hi def link rstDefList Function
hi def link rstFieldList Function
hi def link rstOption Statement
hi def link rstQuote Delimiter 
"}}}
