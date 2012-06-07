"=============================================
"    Name: autoload/restin.vim
"    File: autoload/restin.vim
"  Author: Rykka G.Forest
"  Update: 2012-05-17
" Version: 0.5
"=============================================

fun! riv#init() "{{{
    " for init autoload
endfun "}}}
fun! riv#normlist(list) "{{{
    return map(a:list,'matchstr(v:val,''\w\+'')')
endfun "}}}
fun! riv#norm(str) "{{{
    return matchstr('\w+',a:str)
endfun "}}}


"{{{ file jump 
fun! s:cindex(ftype) "{{{
    let idx = "index.".a:ftype
    if filereadable(idx)
        if expand('%') == idx
            edit #
        else
            exe "edit ". idx
        endif
    else
        echo "No index for current page"
    endif
endfun "}}}
"}}}
"{{{ todo list

let s:fm_timestamp = "%Y-%m-%d"
let s:todo_lvs =  [' ','o','X']
let s:show_tms = exists("g:rst_show_tms") ? g:rst_show_tms : 1

let s:list_ptn = '^\s*%([-*+]|%(\d+|[#a-z]|[imcxv]+)[.)])\s+'
let s:list_ptn2 = '^\s*\(%(\d+|[#a-z]|[imcxv]+)\)\s+'
" it's \1 when match
let s:list_ptn_group =  '\v\c('.s:list_ptn.'|'.s:list_ptn2.')'
" the '.' is \2 when match
let s:todobox_ptn = s:list_ptn_group.'\[(.)\] '
" the rx_time is \3 when match
let s:timestamp_ptn = '(\d{6}|\d{4}-\d{2}-\d{2})\_s'
let s:tms_ptn = s:todobox_ptn.s:timestamp_ptn

fun! s:list_tog_box(row) "{{{
    " toggle list with s:todo_lvs ptn.
    " when idx get max, add an timestamp is show_tms is on
    let line = getline(a:row) 
    let idx = match(line,s:list_ptn_group)
    if idx == -1
        return -1
    endif
    let boxlist = matchlist(line,s:todobox_ptn,idx)
    if empty(boxlist)
        let line = substitute(line, s:list_ptn_group, '\0[ ] ','')
        call setline(a:row,line)
    else
        let t_idx = index(s:todo_lvs,boxlist[2])
        let max_i = len(s:todo_lvs)-1
        if  t_idx != -1 && t_idx < max_i-1
            let tstr = s:todo_lvs[t_idx+1]
        elseif t_idx == max_i-1
            let tstr = s:todo_lvs[max_i]
            if exists("*strftime") && s:show_tms==1
                let tms = strftime(s:fm_timestamp)." "
            else
                let tms = ""
            endif
        else
            let tstr = s:todo_lvs[0]
        endif
        if t_idx == max_i
            if match(line,s:tms_ptn)!=-1
                let line = substitute(line, s:tms_ptn, '\1','')
            else
                let line = substitute(line, s:todobox_ptn, '\1','')
            endif
        elseif t_idx ==max_i-1
            let line = substitute(line, s:todobox_ptn, '\1['.tstr.'] '.tms,'') 
        else
            let line = substitute(line, s:todobox_ptn, '\1['.tstr.'] ','')
        endif
        call setline(a:row,line)
    endif
endfun "}}}

let s:list_lvs = ["*","+","-"]
fun! s:list_shift_len(row,len) "{{{
    let line = getline(a:row)
    let m_str = matchstr(line,s:list_ptn_group)
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
        let l_idx = index(s:list_lvs,l_str)
        let max_i = len(s:list_lvs)-1
        if a:len>=0 && l_idx < max_i
            let line = substitute(line,'[*+-]',s:list_lvs[l_idx+1],'')
        elseif a:len<0 && l_idx > 0 && l_idx <= max_i
            let line = substitute(line,'[*+-]',s:list_lvs[l_idx-1],'')
        endif
    endif
    call setline(a:row,line)
endfun "}}}
fun! s:list_shift_idt(direction) range "{{{
    " > to add indent, < to rmv indent 
    " if line is list then change bullet.
    let line = getline(a:firstline) 
    let m_str = matchstr(line,s:list_ptn_group)
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

let s:list_typ = ["*","#.","(#)"]
let s:list_typ_ptn = ['[*+#-]','\(#\|\d\+\)\(\.\|)\)','(\(\d\+\|\.\))']
fun! s:list_tog_typ(row,typ) "{{{
    let line = getline(a:row) 
    if line=~'^\s*$'
        return -1
    endif
    let str = matchstr(line,s:list_ptn_group)
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
