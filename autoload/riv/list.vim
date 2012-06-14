"=============================================
"    Name: list.vim
"    File: list.vim
" Summary: the bullet list and enum list
"  Author: Rykka G.Forest
"  Update: 2012-06-14
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

" Toggle TO-DO item
" if not list, return 
" if is null todo item, add box/key (and ts if ts==2)
" else if is idx todo item , switch to next box/key (don't change ts)
"   if next box/key is end , (change ts if ts == 1 , add ts_end if ts == 2)
"   if next box/key is start, (remove ts if ts ==1, remove ts_end if ts == 2)
fun! riv#list#toggle_todo(...) "{{{
    let init_key = a:0  ? a:1 : 0
    let row = a:0>1 ? a:2 : line('.')
    let line = getline(row)
    let [type,idx] = s:get_todo_id(line)
    if type == -2 | return | endif
    if type == -1 
        if init_key == 0 
            let line = s:add_todo_box(line)
        else
            let line = s:add_todo_key(line, 0)
        endif
        if g:riv_todo_timestamp == 2
            let line = s:add_todo_tm_start(line)
        endif
    elseif type == 0
        let max_i = s:box_lv_len()-1
        if idx == max_i - 1       " change to max
            let line = s:change_todo_box(line,idx+1)
            if g:riv_todo_timestamp == 1
                let line = s:add_todo_tm_start(line)
            elseif g:riv_todo_timestamp == 2
                let line = s:add_todo_tm_end(line)
            endif
        elseif idx == max_i       " change to 0
            let line = s:change_todo_box(line,0)
            if g:riv_todo_timestamp == 1
                let line = s:rmv_todo_tm_start(line)
            elseif g:riv_todo_timestamp == 2
                let line = s:rmv_todo_tm_end(line)
            endif
        else
            let line = s:change_todo_box(line,idx+1)
        endif
    elseif type > 0
        let grp = type
        let max_i = s:todo_lv_len(grp)-1
        if idx == max_i - 1       " change to max
            let line = s:change_todo_key(line,grp,idx+1)
            if g:riv_todo_timestamp == 1
                let line = s:add_todo_tm_start(line)
            elseif g:riv_todo_timestamp == 2
                let line = s:add_todo_tm_end(line)
            endif
        elseif idx == max_i       " change to 0
            let line = s:change_todo_key(line,grp,0)
            if g:riv_todo_timestamp == 1
                let line = s:rmv_todo_tm_start(line)
            elseif g:riv_todo_timestamp == 2
                let line = s:rmv_todo_tm_end(line)
            endif
        else
            let line = s:change_todo_key(line,grp,idx+1)
        endif
    endif

    call setline(row, line)
endfun "}}}
fun! riv#list#del_todo(...) "{{{
    let row = a:0 ? a:1 : line('.')
    let line = getline(row)
    if line =~ g:_riv_p.todo_all
        let line = s:rmv_todo_tm_end(line)
        let line = s:rmv_todo_tm_start(line)
        let line = s:rmv_todo_item(line)
        call setline(row,line)
    endif
endfun "}}}
fun! riv#list#todo_change_type(grp,...) "{{{
    let row = a:0 ? a:1 : line('.')
    let line = getline(row)
    let [type,idx] = s:get_todo_id(line)
    if type == -2 | return | endif
    let max_i = s:todo_lv_len(a:grp)-1
    if idx > max_i 
        let idx = max_i
    elseif idx < 0
        let idx = 0
    endif

    let line = s:rmv_todo_item(line)
    if a:grp == 0 
        let line = s:add_todo_box(line)
        let line = s:change_todo_box(line, idx)
    else
        let line = s:add_todo_key(line, a:grp)
        let line = s:change_todo_key(line, a:grp, idx)
    endif

    call setline(row, line)
endfun "}}}

fun! s:get_todo_id(line) "{{{
    let idx  = match(a:line, g:_riv_p.list_all)
    if idx == -1 | return [-2, 0]  |  endif          " not an list

    let todo_match = matchlist(a:line,g:_riv_p.todo_all, idx)
    if empty(todo_match)
        return [-1, 0]                            
    endif
    
    " '[x] ' and 'KEYWORD '
    if !empty(todo_match[2])            
        return s:get_box_id(todo_match[2][1])
    elseif !empty(todo_match[3])
        return s:get_key_id(todo_match[3][:-2])
    endif
endfun "}}}
fun! s:get_box_id(text) "{{{
    " [0,id] : box
    let idx = index(g:_riv_t.todo_levels, a:text)
    if idx == -1 | return [0, -1]  | endif           " null idx match
    return [0, idx]                                   " a box idx
endfun "}}}
fun! s:get_key_id(text) "{{{
    " [1,id] : key grp[0] 
    " [2,id] : key grp[1]
    for i in range(len(g:_riv_t.td_keyword_groups))
        let idx = index(g:_riv_t.td_keyword_groups[i], a:text)
        if idx != -1
            return [i+1, idx]             " group , idx
        endif
    endfor
    return [-1, 0]                        " not keywords
endfun "}}}
fun! riv#list#get_td_stat(line)
    let [grp,idx] = s:get_todo_id(a:line)
    if grp < 0 || idx < 0
        return -1
    endif
    let max_i = s:todo_lv_len(grp)-1
    if max_i != 0
        return (idx+0.0)/max_i
    else
        return -1
    endif
endfun

fun! s:box_str(id) "{{{
    return g:_riv_p.todo_levels[a:id]
endfun "}}}
fun! s:key_str(grp,id) "{{{
    return g:_riv_p.todo_all_group[a:grp][a:id]
endfun "}}}
fun! s:add_todo_box(line) "{{{
   return substitute(a:line, g:_riv_p.list_all, '\0[ ] ','')
endfun "}}}
fun! s:add_todo_key(line,grp) "{{{
   return substitute(a:line, g:_riv_p.list_all, '\0'.g:_riv_t.todo_all_group[a:grp][0].' ','')
endfun "}}}
fun! s:change_todo_box(line,id) "{{{
    let str = g:_riv_t.todo_levels[a:id]
    return substitute(a:line, g:_riv_p.todo_box,'\1['.str.'] ','')
endfun "}}}
fun! s:change_todo_key(line,grp, id) "{{{
    let str = g:_riv_t.todo_all_group[a:grp][a:id]
    return substitute(a:line, g:_riv_p.todo_key,'\1'.str.' ','')
endfun "}}}

fun! s:input_date() "{{{
    " Calendar(dir,year,month) 
    " g:calendar_action: the action function(day, month, year, week, dir)
    " g:calendar_sign: show sign of the day
    if exists("*Calendar")
        let s:cal_action_save = g:calendar_action
        let g:calendar_action = "riv#list#feed_date"
        call Calendar(1)
    else
        let year = input("Input year :",strftime("%Y"))
        let month = input("Input month :",strftime("%m"))
        let day = input("Input date :",strftime("%d"))
        call riv#list#feed_date(day,month,year)
    endif
    " return  year-month-day
endfun "}}}
fun! riv#list#feed_date(day,month,year,...) "{{{
    " s:date_callback: the 
    if exists("s:cal_action_save")
        let g:calendar_action = s:cal_action_save
        if bufname("%") == '__Calendar'
            quit
        endif
    endif
    let date =  printf("%04d-%02d-%02d", a:year,a:month,a:day)
    call call(s:date_callback, add(s:date_call_args, date) )
endfun "}}}
fun! s:change_date(timestamp_id, buf, row, date) "{{{
    let win = bufwinnr(a:buf)
    if win == -1
        echo "Could not find the editing buffer."
        return 
    elseif win != winnr()
        exe win."wincmd w"
    endif

    let line = getline(a:row)
    if a:timestamp_id == 1
        let line = s:add_todo_tm_end(line, a:date)
    elseif a:timestamp_id == 0
        let line = s:add_todo_tm_start(line, a:date)
    endif
    call setline(a:row, line)
endfun "}}}
fun! riv#list#change_date() "{{{
    let row = line('.')
    let buf = bufnr('%')
    let col = col('.')
    let line = getline(row)
    let bgn = match(line, g:_riv_p.todo_tm_bgn )
    if bgn == -1
        echo "No timestamp to change..."
        return
    endif
    let end = matchend(line, g:_riv_p.todo_tm_bgn )
    let e_bgn = match(line, g:_riv_p.todo_tm_end )

    let s:date_callback = "s:change_date"
    if ( col >= bgn && col <= end ) || e_bgn == -1
        let s:date_call_args = [0, buf, row]
    else 
        let e_end = matchend(line, g:_riv_p.todo_tm_end)
        if ( col >= e_bgn && col <= e_end ) 
        let s:date_call_args = [1, buf, row ]
        else
            echo "Put cursor on the timestamp to choose one.  "
            return
        endif
    endif
    
    call s:input_date()
    
endfun "}}}

fun! s:add_todo_tm_start(line,...) "{{{
    let tms = a:0 ? a:1 : strftime(g:_riv_t.time_fmt)
    " substitute bgn if exists
    if  a:line =~ g:_riv_p.todo_tm_bgn
        return substitute(a:line, g:_riv_p.todo_tm_bgn, '\1\2\3'.tms.' ','')
    endif
    return substitute(a:line, g:_riv_p.todo_all, '\1\2\3'.tms.' ','')
endfun "}}}
fun! s:add_todo_tm_end(line,...) "{{{
    let tms = a:0 ? a:1 : strftime(g:_riv_t.time_fmt)
    let line = a:line
    " add a bgn timestamp if not exists.
    if  line !~ g:_riv_p.todo_tm_bgn
        let line = substitute(line, g:_riv_p.todo_all, '\1\2\3'.tms.' ','')
    endif
    " substitute end if exists
    if line =~ g:_riv_p.todo_tm_end
        return substitute(line, g:_riv_p.todo_tm_end, '\1\2\3\4~ '.tms.' ','')
    endif
    return substitute(line, g:_riv_p.todo_tm_bgn, '\1\2\3\4~ '.tms.' ','')
endfun "}}}
fun! s:rmv_todo_tm_start(line) "{{{
    " remove end if exists
    if  a:line =~ g:_riv_p.todo_tm_end
        return substitute(a:line, g:_riv_p.todo_tm_end, '\1\2\3','')
    endif
    return substitute(a:line, g:_riv_p.todo_tm_bgn, '\1\2\3','')
endfun "}}}
fun! s:rmv_todo_tm_end(line) "{{{
    return substitute(a:line, g:_riv_p.todo_tm_end, '\1\2\3\4','')
endfun "}}}
fun! s:rmv_todo_item(line) "{{{
    return substitute(a:line, g:_riv_p.todo_all, '\1','')
endfun "}}}

fun! s:box_lv_len() "{{{
    return len(g:_riv_t.todo_levels)
endfun "}}}
fun! s:todo_lv_len(grp) "{{{
    return len(g:_riv_t.todo_all_group[a:grp])
endfun "}}}


fun! riv#list#auto() "{{{
    " TODO: auto add it with level.
    " check with current level.
    " if have brother. then add brother id + 1
    " elseif have parent , then parent type +1 ,  id = 1
    " else add a top item.
    call riv#fold#init()
    
    let [lst_row,lst_col] = searchpos(g:_riv_p.list_all,'Wnb',0,100)
    if lst_row == 0 
        return -1
    endif

    let lst_str = matchstr(getline(lst_row),g:_riv_p.list_all)

    let row = line('.')
    let line = getline(row)

    let white = matchstr(line,'^\s*')
    let lst_line = substitute(line,white, white.lst_str,'')

    if line !~ g:_riv_p.list_all
        call setline(row,lst_line)
    endif
    
endfun "}}}

fun! s:get_list_level()
    
endfun
fun! s:get_list_type()
    
endfun
fun! s:get_list_num()
    
endfun
fun! s:list_str(type,level,num)
    
endfun


fun! riv#list#toggle_type(id,...) "{{{
    if a:0
        let row  = a:1
    else
        let row  = line('.')
    endif
    let line = getline(row) 
    let typ = get(g:_riv_t.list_type,a:id, '')
    if typ!=""
        let typ.=" "
    endif
    let str = matchstr(line,g:_riv_p.list_all)
    let white = matchstr(line,'^\s*')
    if empty(str)
        let line = substitute(line,white, white.typ,'')
    else
        let line = substitute(line,escape(str,'*'),white,'')
        let line = substitute(line,white, white.typ,'')
    endif
    call setline(row,line)
endfun "}}}

fun! s:list_shift_len(row,len) "{{{
    let line = getline(a:row)
    let m_str = matchstr(line,g:_riv_p.list_all)
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
        let l_idx = index(g:_riv_t.list_lvs,l_str)
        let max_i = len(g:_riv_t.list_lvs)-1
        if a:len>=0 && l_idx < max_i
            let line = substitute(line,'[*+-]',g:_riv_t.list_lvs[l_idx+1],'')
        elseif a:len<0 && l_idx > 0 && l_idx <= max_i
            let line = substitute(line,'[*+-]',g:_riv_t.list_lvs[l_idx-1],'')
        endif
    endif
    call setline(a:row,line)
endfun "}}}
fun! riv#list#shift(direction) range "{{{
    " > to add indent, < to rmv indent 
    " if line is list then change bullet.
    let line = getline(a:firstline) 
    let m_str = matchstr(line,g:_riv_p.list_all)
    if empty(m_str)
        let len = &shiftwidth
    else
        let len = len(m_str) - indent(a:firstline)
    endif
    if a:direction=="-"
        let vec = -len
    else
        let vec = len
    endif
    if a:firstline == a:lastline
        call s:list_shift_len(a:firstline, vec)
    else
        for line in range(a:firstline,a:lastline)
            call s:list_shift_len(line, vec)
        endfor
        normal! gv
    endif
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
