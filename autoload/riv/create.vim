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
fun! riv#create#title(level) "{{{
    " Create a title of level.
    " If it's empty line, ask the title
    "     append line
    " If it's non empty , use it. 
    "     and if prev line is nonblank. append a blank line
    " append title 
    let row = line('.')
    let lines = []
    let pre = []
    let line = getline(row)
    let shift = 3
    if line =~ '^\s*$'
        let title = input("Create Level ".a:level." Title.\nInput The Title Name:")
        if title == ''
            return
        endif
        call add(lines, title)
    else
        let title = line
        if row-1!=0 && getline(row-1)!~'^\s*$'
            call add(pre, '')
        endif
    endif
    if len(title) >= 60
        call riv#warning("This line Seems too long to be a title."
                    \."\nYou can use block quote Instead.")
        return
    endif

    if exists("g:_riv_c.sect_lvs[a:level-1]")
        let t = g:_riv_c.sect_lvs[a:level-1]
    else
        let t = s:sect_lv_b[ a:level - len(g:_riv_c.sect_lvs) - 1 ]
    endif
    
    let t = repeat(t, len(title))
    call add(lines, t)
    call add(lines, '')

    call append(row,lines)
    call append(row-1,pre)
    call cursor(row+shift,col('.'))
    
endfun "}}}
fun! s:get_sect_txt() "{{{
    let row = line('.')
    if !exists('b:riv_obj')
        call riv#error('No buf object found.')
        return 0
    endif
    let sect = b:riv_obj['sect_root']
    while !empty(sect.child)
        for child in sect.child
            if child <= row && b:riv_obj[child].end >= row
                let sect = b:riv_obj[child]
                break
            endif
        endfor
        if child > row
            break       " if last child > row , then no match,
                        " put it here , cause we can not break twice inside
        endif
    endwhile
    if sect.bgn =='sect_root'
        return 0
    else
        return sect.txt
    endif
endfun "}}}
fun! riv#create#rel_title(rel) "{{{
    let sect = s:get_sect_txt()
    if !empty(sect)
        let level = len(split(sect, g:riv_fold_section_mark)) + a:rel
    else
        let level = 1
    endif
    let level = level<=0 ? 1 : level

    call riv#create#title(level)
    
endfun "}}}
fun! riv#create#show_sect() "{{{
    let sect = s:get_sect_txt()
    if !empty(sect)
        echo 'You are in section: '.sect
    else
        echo 'You are not in any section.'
    endif
endfun "}}}
fun! riv#create#scatch()
    let id =  exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id

endfun

let &cpo = s:cpo_save
unlet s:cpo_save
