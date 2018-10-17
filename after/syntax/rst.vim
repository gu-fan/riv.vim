"=============================================
"    Name: rst.vim
"    File: after/syntax/rst.vim
"  Author: Rykka G.F
" Summary: syntax file with options.
"  Update: 2018-01-21
"=============================================

if exists("b:af_rst_loaded")
    finish
endif

let b:af_rst_loaded = 1

let s:cpo_save = &cpo
set cpo-=C

let s:s = g:_riv_s

syn sync match rstHighlight groupthere NONE #^\_s\@!#

" Link "{{{1
fun! s:def_inline_char(name, start, end, char_left, char_right) "{{{
    exe 'syn match rst'.a:name
      \ '+'.a:char_left.'\zs'.a:start.'\ze[^[:space:]'
      \.a:char_right.a:start[strlen(a:start)-1].'][^'
      \.a:start[strlen(a:start)-1]
      \.'\\]*'.a:end.'\ze\%($\|\s\|[''")\]}>/:.,;!?\\-]\)+'
endfun "}}}

for s:_pair in ['""', "''", '()', '{}', '<>']
    call s:def_inline_char('PhaseHyperLinkReference', '`', '`__\=', s:_pair[0] ,s:_pair[1],)
endfor
call s:def_inline_char('PhaseHyperLinkReference', '`', '`__\=', '\[','\]')
call s:def_inline_char('PhaseHyperLinkReference', '`', '`__\=', '\%(^\|\s\|[/:]\)','')
" List: "{{{1
syn match rstDefinitionList `\v^(\s*)\h[^:]*\ze%(\s:\s.*)*\n\1\s+\S`
syn match rstBulletList `\v^\s*[-*+]\ze\s+`
syn match rstEnumeratedList `\v\c^\s*%(\d+|[#a-z]|[imlcxvd]+)[.)]\ze\s+`
syn match rstEnumeratedList `\v\c^\s*\(%(\d+|[#a-z]|[imlcxvd]+)\)\ze\s+`
syn match rstOptionList `\v^\s*%(-\w%( \w+)=|--[[:alnum:]_-]+%(\=\w+)=|/\u)%(, %(-\w%( \w+)=|--[[:alnum:]_.-]+%(\=\w+)=|/\u))*%(  |\t)\ze\s*\S`
syn match rstFieldList `\v^\s*:[^:[:space:]][^:]+:\_s`
syn match rstRoles `\v\s:\zs\w+\ze:\``
syn match rstBibliographicField `\v^\s*:(Author|Authors|Organization|Contact|Address|Version|Status|Date|Copyright|Dedication|Abstract):\_s`

syn match rstBlockQuoteAttr  `\v%(\_^\s*\n)@<=\s+---=\s.*`

syn match   rstCommentTitle '\v(^\s+|(^\.\.\s+)@<=):=\u\w*(\s+\u\w*)*:' contained 
syn cluster rstCommentGroup contains=rstCommentTitle,rstTodo


" File: "{{{1
syn cluster rstCruft add=rstStandaloneHyperlink
syn cluster rstCommentGroup add=@rstLinkGroup
if g:riv_file_ext_link_hl == 1
    exe 'syn match rstFileExtLink &'.s:s.rstFileExtLink.'& contains=rstFileExtLinkConceal'
    exe 'syn match rstFileExtLinkConceal &\v\.rst(\_s)@=& conceal contained'
    syn cluster rstCruft add=rstFileExtLink
endif

" Code: "{{{1

" Add block indicator for code directive
syn match rstCodeBlockIndicator `^\_.` contained

" FIXME To Fix #61 ( Not Working!!!)
" For no code file contained , we still highlight in code group.
exe 'syn region rstDirective_code matchgroup=rstDirective fold '
    \.'start=#\%(sourcecode\|code\%(-block\)\=\)::\s\+\S\+\s*$# '
    \.'skip=#^$# '
    \.'end=#^\s\@!# contains=@NoSpell,rstCodeBlockIndicator,@rst_code'
exe 'syn cluster rstDirectives add=rstDirective_code'
" TODO Can we use dynamical loading? 
" parse the code name of code directives dynamicly and load the syntax file?

if exists("b:af_py_loaded")
    finish
endif
for code in g:_riv_t.highlight_code
    " for performance , use $VIMRUNTIME and first in &rtp
    let path = join([$VIMRUNTIME, split(&rtp,',')[0]],',')

    " NOTE: As pygments are using differnet syntax name versus vim.
    " The highlight_code will contain a name pair, which is pygments|vim
    
    if code =~ '[^|]\+|[^|]\+'
        let [pcode, vcode] = split(code, '|')
    else
        let [pcode, vcode] = [code, code]
    endif
    
    " NOTE: the syntax_group_name must be words only.
    let scode = substitute(pcode, '[^0-9a-zA-Z]', 'x','g')

    let paths = split(globpath(path, "syntax/".vcode.".vim"), '\n')
   
    if !empty(paths)
        let s:rst_{vcode}path= paths[0]
        if filereadable(s:rst_{vcode}path)
            unlet! b:current_syntax
            " echohl WarningMsg 
            " echom "SYN INCLUDE ". scode
            " echohl None
            " echom fnameescape(s:rst_{vcode}path)
            " echom "syntax/".vcode.".vim"
          
            " " NOTE: Use this can not include correctly.
            " (maybe with space in 'program file' dir name)
            " exe "syn include @rst_".scode." ".s:{vcode}path
           
            exe "syn include @rst_".scode." "."syntax/".vcode.".vim"
            exe 'syn region rstDirective_'.scode.' matchgroup=rstDirective fold '
                \.'start=#\%(sourcecode\|code\%(-block\)\=\)::\s\+'.pcode.'\s*$# '
                \.'skip=#^$# '
                \.'end=#^\s\@!# contains=@NoSpell,rstCodeBlockIndicator,@rst_'.scode
            exe 'syn cluster rstDirectives add=rstDirective_'.scode

            " For sphinx , the highlight directive can be used for highlighting
            " code block
            exe 'syn region rstDirective_hl_'.scode.' matchgroup=rstDirective fold '
                \.'start=#highlights::\s\+'.pcode.'\_s*# '
                \.'skip=#^$# '
                \.'end=#\_^\(..\shighlights::\)\@=# contains=@NoSpell,@rst_'.scode
            exe 'syn cluster rstDirectives add=rstDirective_hl_'.scode
        endif
        if exists("s:rst_".vcode."path")
            unlet s:rst_{vcode}path
        endif
    endif
endfor
let b:current_syntax = "rst"

if !exists("g:_riv_including_python_rst") && has("spell")
    " Enable spelling on the whole file if we're not being included to parse
    " docstrings
    syn spell toplevel
endif

" Todo: "{{{1
syn cluster rstTodoGroup contains=rstTodoItem,rstTodoPrior,rstTodoTmBgn,rstTodoTmsEnd

exe 'syn match rstTodoRegion `' . s:s.rstTodoRegion .'` transparent contains=@rstTodoGroup'

exe 'syn match rstTodoItem `'.s:s.rstTodoItem.'` contained nextgroup=rstTodoPrior'
exe 'syn match rstTodoPrior `'.s:s.rstTodoPrior.'` contained nextgroup=rstTodoTmBgn'
exe 'syn match rstTodoTmBgn `'.s:s.rstTodoTmBgn.'` contained nextgroup=rstTodoTmEnd'
exe 'syn match rstTodoTmEnd `'.s:s.rstTodoTmEnd.'` contained'

exe 'syn match rstDoneRegion `' . s:s.rstDoneRegion .'`'

" Highlights: "{{{1
if &background == 'light'
    hi def rstFileLink    guifg=#437727  gui=underline ctermfg=28 cterm=underline
else
    hi def rstFileLink    guifg=#58A261  gui=underline ctermfg=77 cterm=underline
endif
hi link rstFileExtLink rstFileLink
hi link rstFileExtLinkConceal rstFileLink

if exists("g:riv_code_indicator") && g:riv_code_indicator == 1
    hi def link rstCodeBlockIndicator DiffAdd
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
hi link rstInlineInternalTargets        Keyword
hi link rstPhaseHyperLinkReference      Underlined

hi def link rstBulletList                   Function
hi def link rstEnumeratedList               Function
hi def link rstDefinitionList               Statement
hi def link rstFieldList                    Function
hi def link rstBibliographicField           Constant
hi def link rstOptionList                   Statement
hi def link rstRoles                        Operator

hi def link rstBlockQuoteAttr               Exception
hi def link rstCommentTitle                 SpecialComment


if exists("s:cpo_save")
    let &cpo = s:cpo_save
    unlet s:cpo_save
endif
