" Vim syntax file
" Language:         reStructuredText documentation format
" Maintainer:       Nikolai Weibull <now@bitwi.se>
" Latest Revision:  2014-08-14

if exists("b:current_syntax")
  finish
endif
let s:cpo_save = &cpo
set cpo&vim

call riv#load_opt()

syn match   rstTodo         '\v(<|:)%(FIXME|TODO|XXX|NOTE)%(:|\_s@=)' contained

syn case ignore

" NOTE: When the above line length longer than '::' , then it's literal_block
" but we can not compare it's length, so we ignore '::' and '..'
syn match   rstSections /\v%(\S\s*\n)@<!\_^\s*\S.*\n%(([=`'"~^_*+#-])\1*|([:.])\2{2,})\s*$/
syn match   rstSections /\v%(\S\s*\n)@<!\_^(([=`:.'"~^_*+#-])\2*\s*)\n\s*\S.*\n\1$/
syn match   rstTransition  /\v%(\_^\s*\n)@<=\_^[=`:.'"~^_*+#-]{4,}\s*(\n\s*\_$)\@=/

syn cluster rstCruft                contains=rstEmphasis,rstStrongEmphasis,
      \ rstInterpretedText,rstInlineLiteral,rstSubstitutionReference,
      \ rstInlineInternalTargets,rstFootnoteReference,rstHyperlinkReference

" A blank line is needed after the LiteralBlock
syn region  rstLiteralBlock         matchgroup=rstDelimiter
      \ start='::\_s*\n\s*\n\ze\z(\s\+\)' skip='^$' end='^\z1\@!'
      \ contains=@Spell

syn region  rstLineBlock
      \ start='^\s*\ze|\_s' end='^\s*$'
      \ contains=@Spell

syn region  rstQuotedLiteralBlock   matchgroup=rstDelimiter
      \ start="::\_s*\n\ze\z([!\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]\)"
      \ end='^\z1\@!' contains=@Spell

syn region  rstDoctestBlock         display matchgroup=rstDelimiter
      \ start='^>>>\s' end='^\s*$'

syn region  rstTable                transparent start='\%(\_^\s*\n\)\@<=\s*+[-=+]\+' end='^\s*$'
      \ contains=rstTableLines,@rstCruft,@Spell
syn match   rstTableLines           contained display '|\|+\%(=\+\|-\+\)\='

syn region  rstSimpleTable          transparent
      \ start='\%(\_^\s*\)\@<=\%(\%(=\+\)\@>\%(\s\+\)\@>\)\%(\%(\%(=\+\)\@>\%(\s*\)\@>\)\+\)\@>$'
      \ end='^\s*$'
      \ contains=rstSimpleTableLines,@rstCruft
syn match   rstSimpleTableLines     contained display
      \ '\%(\_^\s*\)\@<=\%(\%(=\+\)\@>\%(\s\+\)\@>\)\%(\%(\%(=\+\)\@>\%(\s*\)\@>\)\+\)\@>$'
syn match   rstSimpleTableLines     contained display
      \ '^\s*-\+\%(\s*-\+\)*\s*$'

syn cluster rstDirectives           contains=rstFootnote,rstCitation,
      \ rstHyperlinkTarget,rstExDirective



" NOTE: Fix #66 https://github.com/Rykka/riv.vim/pull/66
" Here we match all the whitespace that's more than 'z1' and ignore it. (skip=#^\(\(\z1\s\+\)\@>\S\)#')
" See 'syn-skip', 'syn-keepend' and '\@>'
"
execute 'syn region rstExplicitMarkup keepend'
        \ ' start=#^\z(\s*\)\.\.\s#'
        \ ' skip=#^\(\(\z1\s\+\)\@>\S\|\s*$\)#'
        \ ' end=#^\ze\s*\S#'
        \ ' contains=rstExplicitMarkupDot,@rstDirectives,rstSubstitutionDefinition,rstComment'

syn match   rstExplicitMarkupDot       '^\s*\.\.\_s' contained
      \ nextgroup=@rstDirectives,rstSubstitutionDefinition,rstComment

" NOTE: the rst recongnize unicode_char_ target and refernce
" So use [^[:punct:][:space:]] here.
if g:riv_unicode_ref_name == 1
    let s:ReferenceName = '[^[:cntrl:][:punct:][:space:]]\+\%([_.-][^[:space:][:punct:][:cntrl:]]\+\)*'
" XXX
" unicode mathing seems a bit slow
else
    let s:ReferenceName = '\w\+\%([_.-]\w\+\)*'
endif

" NOTE: #66 If we use '.*' all explicit markup will became comment.
" So use '[^.]' here. us \_s to skip the exdirective match
" See '/collection' 
" Also use '\@='to match \_s with zero width
execute 'syn region rstComment contained'
        \ ' start=#[^.|[_[:blank:]]\+[^:[:blank:]]\_s\@=#'
        \ ' skip=+^$+' .
        \ ' end=+^\s\@!+'
        \ ' contains=@rstCommentGroup,@Spell'

execute 'syn region rstFootnote contained matchgroup=rstDirective' .
      \ ' start=+\[\%(\d\+\|#\%(' . s:ReferenceName . '\)\=\|\*\)\]\_s+' .
      \ ' skip=+^$+' .
      \ ' end=+^\s\@!+'
      \ ' contains=@rstCruft,@Spell'

execute 'syn region rstCitation contained matchgroup=rstDirective' .
      \ ' start=+\[' . s:ReferenceName . '\]\_s+' .
      \ ' skip=+^$+' .
      \ ' end=+^\s\@!+'
      \ ' contains=@s:ReferenceNamerstCruft,@Spell'

syn region rstHyperlinkTarget contained matchgroup=rstDirective
      \ start='_\%(_\|[^:\\]*\%(\\.[^:\\]*\)*\):\_s' skip=+^$+ end=+^\s\@!+

syn region rstHyperlinkTarget contained matchgroup=rstDirective
      \ start='_`[^`\\]*\%(\\.[^`\\]*\)*`:\_s' skip=+^$+ end=+^\s\@!+

syn region rstHyperlinkTarget matchgroup=rstDirective
      \ start=+^__\_s+ skip=+^$+ end=+^\s\@!+

" To Fix #61 (https://github.com/Rykka/riv.vim/issues/61) , I removed the SubstitutionDefinition from 
" ExDirective's inline hightlight group
syn cluster rstONECruft                contains=
      \ rstInterpretedText,rstInlineLiteral,
      \ rstInlineInternalTargets,rstFootnoteReference,rstHyperlinkReference

" For Strong/Emphasis. Only oneline pattern could be used here.
execute 'syn region rstExDirective contained matchgroup=rstDirective' .
      \ ' start=+' . s:ReferenceName . '::\_s+' .
      \ ' skip=+^$+' .
      \ ' end=+^\s\@!+ contains=@rstONECruft'

execute 'syn match rstSubstitutionDefinition contained' .
      \ ' /|' . s:ReferenceName . '|\_s\+/ nextgroup=@rstDirectives'

function! s:DefineOneInlineMarkup(name, start, middle, end, char_left, char_right)
  execute 'syn region rst' . a:name .
        \ ' start=+' . a:char_left . '\zs' . a:start .
        \ '\ze[^[:space:]' . a:char_right . a:start[strlen(a:start) - 1] . ']+' .
        \ a:middle .
        \ ' end=+\S' . a:end . '\ze\%($\|\s\|[''")\]}>/:.,;!?\\-]\)+'
endfunction

function! s:DefineInlineMarkup(name, start, middle, end)
  let middle = a:middle != "" ?
        \ (' skip=+\\\\\|\\' . a:middle . '+') :
        \ ""

  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, "'", "'")
  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, '"', '"') 
  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, '(', ')') 
  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, '\[', '\]') 
  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, '{', '}') 
  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, '<', '>') 

  call s:DefineOneInlineMarkup(a:name, a:start, middle, a:end, '\%(^\|\s\|[/:]\)', '')

  execute 'syn match rst' . a:name .
        \ ' +\%(^\|\s\|[''"([{</:]\)\zs' . a:start .
        \ '[^[:space:]' . a:start[strlen(a:start) - 1] . ']'
        \ a:end . '\ze\%($\|\s\|[''")\]}>/:.,;!?\\-]\)+'

  execute 'hi def link rst' . a:name . 'Delimiter' . ' rst' . a:name
endfunction

call s:DefineInlineMarkup('Emphasis', '\*', '\*', '\*')
call s:DefineInlineMarkup('StrongEmphasis', '\*\*', '\*', '\*\*')
call s:DefineInlineMarkup('InterpretedTextOrHyperlinkReference', '`', '`', '`_\{0,2}')
call s:DefineInlineMarkup('InlineLiteral', '``', "", '``')
call s:DefineInlineMarkup('SubstitutionReference', '|', '|', '|_\{0,2}')
call s:DefineInlineMarkup('InlineInternalTargets', '_`', '`', '`')
" call s:DefineInlineMarkup('PhaseHyperLinkReference', '`', '`', '`_\{1,2}')

" TODO: Can’t remember why these two can’t be defined like the ones above.
execute 'syn match rstFootnoteReference contains=@NoSpell' .
      \ ' +\[\%(\d\+\|#\%(' . s:ReferenceName . '\)\=\|\*\)\]_+'

execute 'syn match rstCitationReference contains=@NoSpell' .
      \ ' +\[' . s:ReferenceName . '\]_\ze\%($\|\s\|[''")\]}>/:.,;!?\\-]\)+'

execute 'syn match rstHyperlinkReference' .
      \ ' /\<' . s:ReferenceName . '__\=\ze\%($\|\s\|[''")\]}>/:.,;!?\\-]\)/'

exe 'syn match  rstStandaloneHyperlink  contains=@NoSpell '
    \. '`\<\%(\%(\%(https\=\|file\|ftp\|gopher\)://\|\%(mailto\|news\):\)[^[:space:]''\"<>]\+\|www[[:alnum:]_-]*\.[[:alnum:]_-]\+\.[^[:space:]''\"<>]\+\)[[:alnum:]/]'
    \.'\|\<[[:alnum:]_-]\+\%(\.[[:alnum:]_-]\)*@[[:alnum:]]\%([[:alnum:]-]*[[:alnum:]]\.\)\+[[:alnum:]]\%([[:alnum:]-]*[[:alnum:]]\)\=\>`'

" TODO: Use better syncing.  I don’t know the specifics of syncing well enough,
" though.
syn sync minlines=50 linebreaks=1
" every line start with \S will end pevious highlight group

hi def link rstTodo                         Todo
hi def link rstComment                      Comment
hi def link rstSections                     Label
hi def link rstTransition                   Type
hi def link rstLiteralBlock                 String
hi def link rstLineBlock                    String
hi def link rstQuotedLiteralBlock           String
hi def link rstDoctestBlock                 PreProc
hi def link rstTableLines                   rstDelimiter
hi def link rstSimpleTableLines             rstTableLines
hi def link rstExplicitMarkup               rstDirective
hi def link rstExplicitMarkupDot            PreProc
hi def link rstDirective                    Keyword
hi def link rstFootnote                     String
hi def link rstCitation                     String
hi def link rstHyperlinkTarget              String
hi def link rstExDirective                  String
hi def link rstSubstitutionDefinition       rstDirective
hi def link rstDelimiter                    Delimiter
" TODO: I dunno...
hi def      rstEmphasis                     term=italic cterm=italic gui=italic
hi def link rstStrongEmphasis               Special
"term=bold cterm=bold gui=bold
hi def link rstInterpretedTextOrHyperlinkReference Float 
hi def link rstInlineLiteral                String
hi def link rstSubstitutionReference        PreProc
hi def link rstInlineInternalTargets        Identifier
hi def link rstFootnoteReference            Identifier
hi def link rstCitationReference            Identifier
hi def link rstHyperLinkReference           Identifier
hi def link rstStandaloneHyperlink          Identifier

let b:current_syntax = "rst"

let &cpo = s:cpo_save
unlet s:cpo_save
