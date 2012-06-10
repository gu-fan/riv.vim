"=============================================
"    Name: rst.vim
"    File: rst.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-07
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

" my settings
exe 'syn match rstFileLink `'.g:_RIV_p.link_file.'`'

syn cluster rstCommentGroup add=@rstLinkGroup

" syn cluster rstLinkGroup contains=rstStandaloneHyperlink,rstFileLink,rstHyperlinkReference,rstCitationReference,rstFootnoteReference
" syn cluster rstCruft add=@rstLinkGroup
" 
" syn match rstCursor '\S*\%#[^[:space:]`>]*' contained containedin=@rstLinkGroup
" 
" {{{code block
let s:rst_hl_codes = ["lua","python","cpp","c","javascript","vim","sh"]
let s:usr_syn_dir = ""
for code in g:riv_hl_code
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
hi hlrstUnderline    guibg=Gray  gui=underline,italic

hi def link rstTodoBoxList Include
hi def link rstTodoTmsList Number
hi def link rstFileLink Underlined

hi link rstCursor   hlrstUnderline       

hi link rstStandaloneHyperlink          Underlined
hi link rstFootnoteReference            Underlined
hi link rstCitationReference            Underlined
hi link rstHyperLinkReference           Underlined
"}}}
let &cpo = s:cpo_save
unlet s:cpo_save
