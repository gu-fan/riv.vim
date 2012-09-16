"=============================================
"    Name: section.vim
"    File: section.vim
" Summary: For creating sections
"  Author: Rykka G.F
"  Update: 2012-09-17
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! s:is_title(str) "{{{
    return a:str =~ '\S' && a:str !~ g:_riv_p.section
endfun "}}}
fun! s:is_sline(str) "{{{
    return a:str =~ g:_riv_p.section
endfun "}}}
fun! s:is_blank(str) "{{{
    return a:str =~ '^\s*$'
endfun "}}}

fun! s:is_section(row) "{{{
    " detect if the line is a section.
    " return [total_rows, row_index], row index start from 1.
    " if it's not , return [0,0]
    "
    " The section should have :
    "   a blank line
    "   a optional sect-line, 
    "   a title line
    "   a sect-line
    let line = getline(a:row)
    let n_line = getline(a:row+1)
    let p_line = getline(a:row-1)
    let n2_line = getline(a:row+2)

    if !s:is_blank(line)
        if s:is_title(line) && s:is_sline(n_line)
            if s:is_sline(p_line) 
                \ && ( a:row - 2 == 0 || s:is_blank(getline(a:row-2)) )
                return [3,2]
            elseif s:is_blank(p_line) 
                return [2,1]
            endif
        elseif s:is_sline(line)  
            if s:is_title(n_line)
            \ && s:is_sline(n2_line)
            \ && s:is_blank(p_line) 
                return [3,1]
            elseif s:is_title(p_line) 
                if ( a:row - 2 == 0 || s:is_blank(getline(a:row-2)) )
                    return [2,2]
                elseif ( a:row - 3 == 0 || s:is_blank(getline(a:row-3)) ) 
                    \ && s:is_sline(getline(a:row-2))
                    return [3,3]
                endif
            endif
        endif
    endif

    return [0,0]
    
endfun "}}}
fun! s:title_row(rows,idx,c_row) "{{{
    " return the row number of the title
    return a:rows - 1 - a:idx + a:c_row
endfun "}}}

fun! s:sect_lines(title, level) "{{{
    " create section title lines with title and level.
    " return a list with all the lines.
    let [rows,punc] = g:_riv_c.sect_lvs_style[a:level]
    let sline = repeat(punc, strdisplaywidth(a:title))
    return rows == 2 ? [a:title, sline] : [sline, a:title,sline]
endfun "}}}

fun! s:get_sect_txt() "{{{
    " get the section text of the row
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
        return ''
    else
        return sect.txt
    endif
endfun "}}}

fun! s:del_sect_title(rows,idx,c_row) "{{{
    call s:del_line(a:c_row-a:idx+1, a:c_row-a:idx+a:rows)
endfun "}}}
fun! s:del_line(row,...) "{{{
    if a:0
        exe a:row ',' a:1 'delete'
    else
        exe a:row 'delete'
    endif
endfun "}}}

fun! riv#section#title(level,...) "{{{
    " Create the section with the level at current row.
    "
    " If it's empty , ask the title.
    " If it's not empty , check if it's already section title.
    "   if it is.
    "       remove it. and use the title.
    "   else if not
    "       remove current line
    "       use it as title
    "
    " get generated title lines of level.
    "
    " check current position whether to append preceding blank lines 
    " or not
    
    " a:1 must be a number
    let row = a:0 ? a:1 : line('.')
    let line = getline(row)
    if s:is_blank(line)
        let txt = s:get_sect_txt()
        if !empty(txt)
            echo 'Previous Section is:'
            echohl incSearch
            echon txt
            echohl Normal
        endif
        let title = input("Input the Title of a level ".a:level." Section: ")
        if title == '' | return | endif
    else
        let [rows,idx] = s:is_section(row)
        if rows == 0    " not in a section title. use it as title.
            let title = line
            call s:del_line(row)
        else
            let title_row = s:title_row(rows, idx, row)
            let title = getline(title_row)
            call s:del_sect_title(rows, idx, row)
        endif
    endif

    let lines = s:sect_lines(title, a:level)
    
    " cursor is now one line below the heading.
    let row = line('.')
    call append(row-1,lines)
    
    " in case if no preceding blank line
    if !s:is_blank(getline(row-1)) && row != 1
        call append(row-1,'')
    endif
    
    " as the cursor is put at the line after the heading
    " So no need to move anymore.
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
