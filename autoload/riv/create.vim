"=============================================
"    Name: create.vim
"    File: riv/create.vim
" Summary: Create miscellaneous snippet.
"  Author: Rykka G.Forest
"  Update: 2012-06-11
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C


fun! riv#create#link(type,ask) "{{{
    " return a link target and ref def.
    let type = "footnote"
    if type == "footnote"
    " DONE: 2012-06-10 get buf last footnote.
    " DONE: 2012-06-10 they should add at different position.
    "       current and last.
    "   
    " put cursor in last line and start backward search.
    " get the last footnote and return.

        let id = riv#link#get_last_foot()[1] + 1
        let line = getline('.') 

        if line =~ g:_riv_p.table
            let tar = substitute(line,'\%' . col(".") . 'c' , ' ['.id.']_ ', '')
        elseif line =~ '\S\@<!$'
        " have \s before eol.
            let tar = line."[".id."]_"
        else
            let tar = line." [".id."]_"
        endif
        if a:ask==1
            let footnote = input("[".id."]: Your FootNote message is?\n")
        else
            let footnote = " $FootNote "
        endif
        let def = ".. [".id."] :  ".footnote
        call setline(line('.'),tar)
        call append(line('$'),def)
    endif
    
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
