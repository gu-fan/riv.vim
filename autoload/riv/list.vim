"=============================================
"    Name: list.vim
"    File: list.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-07
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

"{{{ todo list

fun! riv#list#tog_box(row) "{{{
    " toggle list with g:riv_todo_levels ptn.
    " when idx get max, add an timestamp is show_tms is on
    let line = getline(a:row) 
    let idx = match(line,g:_RIV_c.ptn.list_m1)
    if idx == -1
        return -1
    endif
    let boxlist = matchlist(line,g:_RIV_c.ptn.list_box,idx)
    if empty(boxlist)
        let line = substitute(line, g:_RIV_c.ptn.list_m1, '\0[ ] ','')
        call setline(a:row,line)
    else
        let t_idx = index(g:riv_todo_levels,boxlist[2])
        let max_i = len(g:riv_todo_levels)-1
        if  t_idx != -1 && t_idx < max_i-1
            let tstr = g:riv_todo_levels[t_idx+1]
        elseif t_idx == max_i-1
            let tstr = g:riv_todo_levels[max_i]
            if exists("*strftime") && g:riv_todo_timestamp==1
                let tms = strftime(g:_RIV_c.ptn.fmt_time)." "
            else
                let tms = ""
            endif
        else
            let tstr = g:riv_todo_levels[0]
        endif
        if t_idx == max_i
            if match(line,g:_RIV_c.ptn.list_tms)!=-1
                let line = substitute(line, g:_RIV_c.ptn.list_tms, '\1','')
            else
                let line = substitute(line, g:_RIV_c.ptn.list_box, '\1','')
            endif
        elseif t_idx ==max_i-1
            let line = substitute(line, g:_RIV_c.ptn.list_box, '\1['.tstr.'] '.tms,'') 
        else
            let line = substitute(line, g:_RIV_c.ptn.list_box, '\1['.tstr.'] ','')
        endif
        call setline(a:row,line)
    endif
endfun "}}}

fun! s:list_shift_len(row,len) "{{{
    let line = getline(a:row)
    let m_str = matchstr(line,g:_RIV_c.ptn.list_m1)
    let l_str = matchstr(m_str,'[*+-]')
    " sub all \t to ' ' to avoid wrong indenting
    let line = substitute(line,'\t',repeat(" ",&sw),'g')
    " if l_str is empty , then we do not substitute the list_str
    if a:len>=0
        let line = substitute(line,'^',repeat(' ',a:len),'')
    else
        let line = substitute(line,'^\s\{,'.abs(a:len).'}','','')
    endif
    if !empty(m_str) && !empty(l_str)
        let l_idx = index(g:_RIV_c.list_lvs,l_str)
        let max_i = len(g:_RIV_c.list_lvs)-1
        if a:len>=0 && l_idx < max_i
            let line = substitute(line,'[*+-]',g:_RIV_c.list_lvs[l_idx+1],'')
        elseif a:len<0 && l_idx > 0 && l_idx <= max_i
            let line = substitute(line,'[*+-]',g:_RIV_c.list_lvs[l_idx-1],'')
        endif
    endif
    call setline(a:row,line)
endfun "}}}
fun! riv#list#shift_idt(direction) range "{{{
    " > to add indent, < to rmv indent 
    " if line is list then change bullet.
    let line = getline(a:firstline) 
    let m_str = matchstr(line,g:_RIV_c.ptn.list_m1)
    if empty(m_str)
        let len = &shiftwidth
    else
        let len = len(m_str) - indent(a:firstline)
    endif
    if a:firstline == a:lastline
        call s:list_shift_len(a:firstline, a:direction.len)
    else
        for line in range(a:firstline,a:lastline)
            call s:list_shift_len(line, a:direction.len)
        endfor
        normal! gv
    endif
endfun "}}}

fun! riv#list#tog_typ(row,typ) "{{{
    let line = getline(a:row) 
    if line=~'^\s*$'
        return -1
    endif
    let str = matchstr(line,g:_RIV_c.ptn.list_m1)
    let white = matchstr(line,'^\s*')
    if empty(str)
        let line = substitute(line,white, white.a:typ,'')
    else
        let line = substitute(line,escape(str,'*'),white,'')
        let line = substitute(line,white, white.a:typ,'')
    endif
    call setline(a:row,line)
endfun "}}}
"}}}
let &cpo = s:cpo_save
unlet s:cpo_save
