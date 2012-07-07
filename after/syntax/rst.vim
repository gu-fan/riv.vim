"=============================================
"    Name: rst.vim
"    File: after/syntax/rst.vim
"  Author: Rykka G.Forest
" Summary: syntax file with options.
"  Update: 2012-06-12
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:s = g:_riv_s

" Local File: "{{{1
syn cluster rstCruft add=rstStandaloneHyperlink
syn cluster rstCommentGroup add=@rstLinkGroup

if g:riv_localfile_linktype != 0
    exe 'syn match rstFileLink `'.s:s.rstFileLink.'`'
    syn cluster rstCruft add=rstFileLink
endif


" Code Highlight: "{{{1
for code in g:_riv_t.highlight_code
    " for performance , use $VIMRUNTIME and first in &rtp
    let path = join([$VIMRUNTIME, split(&rtp,',')[0]],',')
    let s:{code}path= fnameescape(split(globpath(path, "syntax/".code.".vim"),'\n')[0])
    if filereadable(s:{code}path)
        unlet! b:current_syntax
        exe "syn include @rst_".code." ".s:{code}path
        exe 'syn region rstDirective_'.code.' matchgroup=rstDirective fold '
            \.'start=#\%(sourcecode\|code\%(-block\)\=\)::\s\+'.code.'\_s*# '
            \.'skip=#^$# '
            \.'end=#^\s\@!# contains=@rst_'.code
        exe 'syn cluster rstDirectives add=rstDirective_'.code
    endif
    unlet s:{code}path
endfor
let b:current_syntax = "rst"

" Todo Group: "{{{1
syn cluster rstTodoGroup contains=rstTodoItem,rstTodoPrior,rstTodoTmBgn,rstTodoTmsEnd

exe 'syn match rstTodoRegion `' . s:s.rstTodoRegion .'` transparent contains=@rstTodoGroup'

exe 'syn match rstTodoItem `'.s:s.rstTodoItem.'` contained nextgroup=rstTodoPrior'
exe 'syn match rstTodoPrior `'.s:s.rstTodoPrior.'` contained nextgroup=rstTodoTmBgn'
exe 'syn match rstTodoTmBgn `'.s:s.rstTodoTmBgn.'` contained nextgroup=rstTodoTmEnd'
exe 'syn match rstTodoTmEnd `'.s:s.rstTodoTmEnd.'` contained'

exe 'syn match rstDoneRegion `' . s:s.rstDoneRegion .'` transparent contains=@rstTodoGroup'

" Highlights: "{{{1
if &background == 'light'
    hi def rstFileLink    guifg=#437727  gui=underline ctermfg=28 cterm=underline
else
    hi def rstFileLink    guifg=#58A261  gui=underline ctermfg=77 cterm=underline
endif

hi def link rstTodoItem     Include
hi def link rstTodoPrior    Include
hi def link rstTodoTmBgn    Number
hi def link rstTodoTmEnd    Number
hi def link rstDoneRegion   Comment

hi link rstStandaloneHyperlink          Underlined
hi link rstFootnoteReference            Underlined
hi link rstCitationReference            Underlined
hi link rstHyperLinkReference           Underlined


let &cpo = s:cpo_save
unlet s:cpo_save
