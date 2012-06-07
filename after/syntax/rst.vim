" Vim Syntax File for ReStructuredText in after/syntax
" fix rst.vim
" Author:   Rykka. G  <Rykka10(at)gmail.com>
" Update:   2012-06-01
" load after /usr/share/vim/vim73/syntax/rst.vim

" my settings
exe 'syn match rstRSTfile `\v%([~0-9a-zA-Z:./_-]+%(\.%(rst|'.
            \ g:RESTIN_Conf['ext_ptn'] .')|/))\S@!`'
" 
" {{{code block
let s:rst_hl_codes = ["lua","python","cpp","c","javascript","vim","sh"]
let s:usr_syn_dir = ""
for code in s:rst_hl_codes
    " for performance , use $VIMRUNTIME only
    let s:{code}path= fnameescape(split(globpath(join([$VIMRUNTIME,s:usr_syn_dir],','),"syntax/".code.".vim"),'\n')[0])
    if filereadable(s:{code}path)
        unlet! b:current_syntax
        exe "syn include @rst_".code." ".s:{code}path
        exe 'syn region rstDirective_'.code.' matchgroup=rstDirective fold '
            \.'start=#\%(\%(source\)\=code\|code-block\)::\s\+'.code.'\_s*# '
            \.'skip=#^$# '
            \.'end=#^\s\@!# contains=@rst_'.code
        exe 'syn cluster rstDirectives add=rstDirective_'.code
        exe 'syn region rstDirective_hl_'.code.' matchgroup=rstDirective fold '
            \.'start=#highlights::\s\+'.code.'\_s*# '
            \.'skip=#^$# '
            \.'end=#\_^\(..\shighlights::\)\@=# contains=@rst_'.code
        exe 'syn cluster rstDirectives add=rstDirective_hl_'.code
    endif
    unlet s:{code}path
endfor
" }}}
let b:current_syntax = "rst"
" todo list "{{{
syn match rstTodoBoxRegion '\v\c%(^\s*%([-*+]|%(\d+|[#a-z]|[imcxv]+)[.)])\s+)@<=\[.\]%(\s\d{4}-\d{2}-\d{2})=\ze\s' transparent contains=@rstTodoBoxGroup
syn match rstTodoBoxRegion '\v\c%(^\s*\(%(#|\d+|[a-z]|[imcxv]+)\)\s+)@<=\[.\]%(\s\d{6}|\s\d{4}-\d{2}-\d{2})=\ze\s' transparent contains=@rstTodoBoxGroup
syn cluster rstTodoBoxGroup contains=rstTodoBoxList,rstTodoTmsList
syn match rstTodoBoxList `\[.\]` nextgroup=rstTodoTmsList contained
syn match rstTodoTmsList `\v(\d{6}|\d{4}-\d{2}-\d{2})` contained
"}}}
" relink "{{{

hi def link rstTodoBoxList Include
hi def link rstTodoTmsList Number
hi def link rstRSTfile Underlined

hi link rstStandaloneHyperlink          Underlined
hi link rstFootnoteReference            Underlined
hi link rstCitationReference            Underlined
hi link rstHyperLinkReference           Underlined
"}}}
