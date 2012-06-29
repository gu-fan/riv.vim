"=============================================
"    Name: todo.vim
"    File: todo.vim
" Summary: todo items
"  Author: Rykka G.Forest
"  Update: 2012-06-30
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C


" Todo: "{{{
fun! riv#todo#toggle_todo() "{{{
" Toggle TO-DO item
" if not list, return 
" if is null todo item, add box/key (and timestamp if ts==2)
" else if is idx todo item , switch to next box/key (don't change timestamp)
"   if next box/key is end , (change timestamp if ts == 1 , add ts_end if ts == 2)
"   if next box/key is start, (remove timestamp if ts ==1, remove ts_end if ts == 2)
    let init_key = a:0  ? a:1 : 0
    let [row, col] = [line('.'), col('.')]
    let line = getline(row)
    let [type,idx] = s:get_todo_id(line)
    if type == -2 
        echo "It's not a List, stopped..."
        return 
    endif
    let prv_td_end = s:get_td_end(line)
    let prv_len = strwidth(line)
    if type == -1 
        if init_key == 0 
            let line = s:add_todo_box(line)
        else
            let line = s:add_todo_key(line, 0, 0)
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
    let mod_len = strwidth(line)
    let mod_td_end = prv_td_end + mod_len - prv_len
    if col >= prv_td_end
        let sft = mod_td_end - prv_td_end
        call cursor(row, col + sft )
    elseif col <= prv_td_end && col >= mod_td_end
        call cursor(row, mod_td_end )
    endif
endfun "}}}
fun! riv#todo#del_todo(...) "{{{
    let [row, col] = [line('.'), col('.')]
    let line = getline(row)
    let prv_td_end = s:get_td_end(line)
    let prv_len = strwidth(line)
    if line =~ g:_riv_p.todo_all
        let line = s:rmv_todo_tm_end(line)
        let line = s:rmv_todo_tm_start(line)
        let line = s:rmv_todo_item(line)
        call setline(row,line)
        let mod_len = strwidth(line)
        let mod_td_end = prv_td_end + mod_len - prv_len
        if col >= prv_td_end
            let sft = mod_td_end - prv_td_end
            call cursor(row, col + sft )
        elseif col <= prv_td_end && col >= mod_td_end
            call cursor(row, mod_td_end )
        endif
    endif
endfun "}}}
fun! riv#todo#todo_change_type(grp) "{{{
    " change current line's todo type
    " if it's not a list , add a list item
    let [row, col] = [line('.'), col('.')]

    let line = getline(row)
    let [type,idx] = s:get_todo_id(line)
    " record the todo item end idx to consider how to move cursor
    let prv_td_end = s:get_td_end(line)
    let prv_len = strwidth(line)
    if type == -2
        let list_str = s:list_str(1 , '', '' , "*", " ") 
        let line = substitute(line, '^\s*', list_str, '')
    elseif type == -1
        " change idx of previous group to current grp
        let max_i = s:todo_lv_len(a:grp)-1
        if idx > max_i 
            let idx = max_i
        elseif idx < 0
            let idx = 0
        endif
    endif

    let line = s:rmv_todo_item(line)
    if a:grp == 0 
        let line = s:add_todo_box(line)
        let line = s:change_todo_box(line, idx)
    else
        if a:grp > len(g:_riv_t.td_keyword_groups)
            call riv#warning("The keyword group is not defined.")
            return
        endif
        let line = s:add_todo_key(line, a:grp, idx)
    endif
    
    
    call setline(row, line)
    let mod_len = strwidth(line)
    let mod_td_end = prv_td_end + mod_len - prv_len
    if col >= prv_td_end
        let sft = mod_td_end - prv_td_end
        call cursor(row, col + sft )
    elseif col <= prv_td_end && col >= mod_td_end
        call cursor(row, mod_td_end )
    endif
endfun "}}}

fun! riv#todo#todo_ask() "{{{
    let grp =  inputlist(g:_riv_t.td_ask_keywords)
    if  grp > 0 && grp <= len(g:_riv_t.td_keyword_groups)
        call riv#todo#todo_change_type(grp)
    endif
endfun "}}}

fun! s:get_td_end(line) "{{{
    let grps = [g:_riv_p.todo_tm_end, g:_riv_p.todo_tm_bgn, 
               \g:_riv_p.todo_all,    g:_riv_p.list_all,
               \'^\s*']
    let i = 0
    let td_end = -1
    while td_end == -1
        let td_end = matchend(a:line, grps[i])
        let i += 1
    endwhile
    return td_end
endfun "}}}
fun! s:get_todo_id(line) "{{{
    let idx  = match(a:line, g:_riv_p.list_all)
    if idx == -1 | return [-2, 0]  |  endif          " not an list

    let todo_match = matchlist(a:line,g:_riv_p.todo_all, idx)
    if empty(todo_match)
        return [-1, 0]                            
    endif
    
    if !empty(todo_match[2])            " '[x] '
        return s:get_box_id(todo_match[2][1])
    elseif !empty(todo_match[3])        " 'KEYWORD '
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
fun! riv#todo#get_td_stat(line) "{{{
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
endfun "}}}

fun! s:box_str(id) "{{{
    return g:_riv_p.todo_levels[a:id]
endfun "}}}
fun! s:key_str(grp,id) "{{{
    return g:_riv_p.todo_all_group[a:grp][a:id]
endfun "}}}
fun! s:add_todo_box(line) "{{{
   return substitute(a:line, g:_riv_p.list_all, '\0[ ] ','')
endfun "}}}
fun! s:add_todo_key(line,grp,id) "{{{
   return substitute(a:line, g:_riv_p.list_all, '\0'.g:_riv_t.todo_all_group[a:grp][a:id].' ','')
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
        let g:calendar_action = "riv#todo#feed_date"
        call Calendar(1)
    else
        let year = str2nr(input("Input year :",strftime("%Y")))
        let month = str2nr(input("Input month :",strftime("%m")))
        let day = str2nr(input("Input date :",strftime("%d")))
        call riv#todo#feed_date(day,month,year)
    endif
    " return  year-month-day
endfun "}}}
fun! riv#todo#feed_date(day,month,year,...) "{{{
    " s:date_callback: the 
    if exists("s:cal_action_save")
        let g:calendar_action = s:cal_action_save
        if bufname("%") == '__Calendar'
            quit
        endif
    endif
    let date =  printf("%04.4s-%02.2s-%02.2s", a:year,a:month,a:day)
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

fun! riv#todo#change_date() "{{{
    let row = line('.')
    let buf = bufnr('%')
    let col = col('.')
    let line = getline(row)
    let pos = s:is_in_todo_time(line,col)
    if pos == 0
        echo "No timestamp to change..."
        return
    endif
    let s:date_callback = "s:change_date"
    if pos == 1
        let s:date_call_args = [0, buf, row]
    elseif pos == 2 
        let s:date_call_args = [1, buf, row ]
    endif
    
    call s:input_date()
endfun "}}}

fun! s:is_in_todo_time(line,col) "{{{
    if a:line=~ g:_riv_p.todo_tm_end
        if ( a:col < matchend(a:line, g:_riv_p.todo_tm_end)
                \ && a:col > matchend(a:line, g:_riv_p.todo_tm_bgn.'\~ ') )
            return 2
        elseif (  a:col < matchend(a:line, g:_riv_p.todo_tm_bgn)
                \ && a:col > matchend(a:line, g:_riv_p.todo_all))
            return 1
        endif
    else
        if a:col < matchend(a:line, g:_riv_p.todo_tm_bgn)
                \ && a:col > matchend(a:line, g:_riv_p.todo_all)
            return 1
        endif
   endif
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
"}}}
fun! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun "}}}
fun! riv#todo#SID() "{{{
    return '<SNR>'.s:SID().'_'
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
