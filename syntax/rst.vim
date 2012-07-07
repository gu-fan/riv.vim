" Vim syntax file
" Language:         reStructuredText documentation format
" Maintainer:       Nikolai Weibull <now@bitwi.se>
" Latest Revision:  2012-06-03

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match   rstTodo         '\v(<|:)%(FIXME|TODO|XXX|NOTE)%(:|\_s@=)' contained

syn case ignore

syn match   rstSections /\v%(\S\s*\n)@<!\_^\s*\S.*\n([=`:.'"~^_*+#-])\1*\s*$/
syn match   rstSections /\v%(\S\s*\n)@<!\_^(([=`:.'"~^_*+#-])\2*\s*)\n\s*\S.*\n\1$/
syn match   rstTransition  /\v%(\_^\s*\n)@<=\_^[=`:.'"~^_*+#-]{4,}\s*(\n\s*\_$)\@=/

syn cluster rstCruft                contains=rstEmphasis,rstStrongEmphasis,
      \ rstInterpretedText,rstInlineLiteral,rstSubstitutionReference,
      \ rstInlineInternalTargets,rstFootnoteReference,rstHyperlinkReference

" A blank line is needed after the LiteralBlock
syn region  rstLiteralBlock         matchgroup=rstDelimiter
      \ start='::\_s*\n\s*\n\ze\z(\s\+\)' skip='^$' end='^\z1\@!'
      \ contains=@NoSpell

syn region  rstLineBlock
      \ start='^\s*\ze|\_s' end='^\s*$'
      \ contains=@NoSpell

syn region  rstQuotedLiteralBlock   matchgroup=rstDelimiter
      \ start="::\_s*\n\ze\z([!\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]\)"
      \ end='^\z1\@!' contains=@NoSpell

syn region  rstDoctestBlock         display matchgroup=rstDelimiter
      \ start='^>>>\s' end='^\s*$'

syn region  rstTable                transparent start='\%(\_^\s*\n\)\@<=\s*+[-=+]\+' end='^\s*$'
      \ contains=rstTableLines,@rstCruft
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

syn match   rstExplicitMarkup       '^\.\.\_s'
      \ nextgroup=@rstDirectives,rstComment,rstSubstitutionDefinition

let s:ReferenceName = '[[:alnum:]]\+\%([_.-][[:alnum:]]\+\)*'


execute 'syn region rstComment contained' .
      \ ' start=/.*/'
      \ ' skip=+^$+' 
      \ ' end=/^\s\@!/ contains=@rstCommentGroup'

execute 'syn region rstFootnote contained matchgroup=rstDirective' .
      \ ' start=+\[\%(\d\+\|#\%(' . s:ReferenceName . '\)\=\|\*\)\]\_s+' .
      \ ' skip=+^$+' .
      \ ' end=+^\s\@!+ contains=@rstCruft,@NoSpell'

execute 'syn region rstCitation contained matchgroup=rstDirective' .
      \ ' start=+\[' . s:ReferenceName . '\]\_s+' .
      \ ' skip=+^$+' .
      \ ' end=+^\s\@!+ contains=@s:ReferenceNamerstCruft,@NoSpell'

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
hi def link rstSections                     Type
hi def link rstTransition                   Typedef
hi def link rstLiteralBlock                 String
hi def link rstLineBlock                    String
hi def link rstQuotedLiteralBlock           String
hi def link rstDoctestBlock                 PreProc
hi def link rstTableLines                   rstDelimiter
hi def link rstSimpleTableLines             rstTableLines
hi def link rstExplicitMarkup               rstDirective
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
hi def link rstInterpretedTextOrHyperlinkReference  Identifier
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
