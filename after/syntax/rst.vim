"=============================================
"    Name: rst.vim
"    File: after/syntax/rst.vim
"  Author: Rykka G.Forest
" Summary: syntax file with options.
"  Update: 2012-06-12
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

if g:_riv_p.link_file != ''
    exe 'syn match rstFileLink `'.g:_riv_p.link_file.'`'
endif

syn cluster rstCommentGroup add=@rstLinkGroup

" {{{code block
for code in g:_riv_t.highlight_code
    " for performance , use $VIMRUNTIME only
    let s:{code}path= fnameescape(split(globpath(join([$VIMRUNTIME,g:riv_usr_syn_dir],','),"syntax/".code.".vim"),'\n')[0])
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
let s:td_keywords = g:_riv_p.td_keywords

exe 'syn match rstTodoBoxRegion '
        \.'`\v\c%(^\s*%([-*+]|%(\d+|[#a-z]|[imcxv]+)[.)])\s+)@<='
        \.'%(\[.\]|'. s:td_keywords .')'
        \.'%(\s\d{4}-\d{2}-\d{2})='.'%(\s\~ \d{4}-\d{2}-\d{2})='
        \.'\ze%(\s|$)` transparent contains=@rstTodoBoxGroup'
exe 'syn match rstTodoBoxRegion `\v\c%(^\s*\(%(#|\d+|[a-z]|[imcxv]+)\)\s+)@<='
        \.'%(\[.\]|'. s:td_keywords .')'
        \.'%(\s\d{4}-\d{2}-\d{2})='.'%(\s\~ \d{4}-\d{2}-\d{2})='
        \.'\ze%(\s|$)` transparent contains=@rstTodoBoxGroup'

syn cluster rstTodoBoxGroup contains=rstTodoBoxList,rstTodoTmsList,rstTodoTmsEnd
exe 'syn match rstTodoBoxList '
            \.'`\v%(\[.\]|'. s:td_keywords .')`'
            \.' nextgroup=rstTodoTmsList contained'
syn match rstTodoTmsList `\v\d{4}-\d{2}-\d{2}` contained nextgroup=rstTodoTmsEnd
syn match rstTodoTmsEnd  `\v\~ \zs\d{4}-\d{2}-\d{2}` contained

let s:td_done = g:_riv_p.todo_done_ptn
exe 'syn match rstTodoBoxRegionDone '
        \.'`\v\c%(^\s*%([-*+]|%(\d+|[#a-z]|[imcxv]+)[.)])\s+)@<='
        \. s:td_done
        \.'%(\s\d{4}-\d{2}-\d{2})='.'%(\s\~ \d{4}-\d{2}-\d{2})='
        \.'\ze%(\s|$)` '
exe 'syn match rstTodoBoxRegionDone `\v\c%(^\s*\(%(#|\d+|[a-z]|[imcxv]+)\)\s+)@<='
        \. s:td_done
        \.'%(\s\d{4}-\d{2}-\d{2})='.'%(\s\~ \d{4}-\d{2}-\d{2})='
        \.'\ze%(\s|$)` '

"}}}
" relink "{{{

if &background == 'light'
    hi def rstFileLink    guifg=#437727  gui=underline
    hi def rstLinkHover  ctermbg=gray guibg=#A9E597  gui=underline
else
    hi def rstFileLink    guifg=#58A261  gui=underline
    hi def rstLinkHover  ctermbg=gray guibg=#494E2B  gui=underline
endif

hi def link rstTodoBoxList Include
hi def link rstTodoTmsList Number
hi def link rstTodoTmsEnd  Number
hi def link rstFileLink    hlrstFileLink
hi def link rstTodoBoxRegionDone Comment


hi link rstStandaloneHyperlink          Underlined
hi link rstFootnoteReference            Underlined
hi link rstCitationReference            Underlined
hi link rstHyperLinkReference           Underlined
"}}}
let &cpo = s:cpo_save
unlet s:cpo_save
