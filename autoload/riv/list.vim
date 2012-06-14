"=============================================
"    Name: list.vim
"    File: list.vim
" Summary: the bullet list and enum list
"  Author: Rykka G.Forest
"  Update: 2012-06-15
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
fun! riv#list#get_td_stat(line) "{{{
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

fun! s:get_list(row) "{{{
    " To find if a row is in  a list's arrange. 
    " this list's indent should smaller than current line (when not list).
    " return 0 if break by none list '^\S'.

    let c_row = prevnonblank(a:row)
    if getline(c_row) =~ g:_riv_p.list_all       " it's list
        return c_row
    else
        let c_idt = indent(c_row)
        if c_idt == 0       " it's '^\S'
            return 0
        else
            let save_pos = getpos('.')
            let [row,col] = searchpos(g:_riv_p.list_all.'|^\S', 'wnb',0,100)
            let s_idt = indent(row)
            while c_idt <= s_idt        " find a list have less indent
                if getline(row) !~ g:_riv_p.list_all
                    let row = 0
                    break         " could not find a list.
                endif
                " goto prev line
                exe prevnonblank(row-1)
                let [row,col] = searchpos(g:_riv_p.list_all.'|^\S', 'wnb',0,100)
                let s_idt = indent(row)
            endwhile
            call setpos('.',save_pos)
            return row
        endif
    endif
endfun "}}}
fun! s:get_older(row) "{{{
    " check if a list item have an older .
    let c_row = s:get_list(a:row)
    if c_row == 0
        return 0
    else
        let save_pos = getpos('.')
        exe prevnonblank(c_row-1)
        let c_idt = indent(c_row)
        let [row,col] = searchpos(g:_riv_p.list_all.'|^\S', 'wnb',0,100)
        let s_idt = indent(row)
        while c_idt < s_idt    " find a list have 
                               " same list level           
            if getline(row) !~ g:_riv_p.list_all
                let row = 0
                break         " could not find a list.
            endif
            " goto prev line
            exe prevnonblank(row-1)
            let [row,col] = searchpos(g:_riv_p.list_all.'|^\S', 'wnb',0,100)
            let s_idt = indent(row)
        endwhile
        call setpos('.',save_pos)
        if s_idt == c_idt
            return row
        else
            return 0
        endif
    endif
endfun "}}}
fun! s:get_parent(row) "{{{
    " check if a list item have an older .
    let c_row = s:get_list(a:row)
    if c_row == 0
        return 0
    else
        let c_idt = indent(c_row)
        if c_idt == 0
            return 0
        endif
        let save_pos = getpos('.')
        exe prevnonblank(c_row-1)
        let [row,col] = searchpos(g:_riv_p.list_all.'|^\S', 'wnb',0,100)
        let s_idt = indent(row)
        while c_idt <= s_idt  " find a list have 
                              " same list level           
            if getline(row) !~ g:_riv_p.list_all
                let row = 0
                break         " could not find a list.
            endif
            " goto prev line
            exe prevnonblank(row-1)
            let [row,col] = searchpos(g:_riv_p.list_all.'|^\S', 'wnb',0,100)
            let s_idt = indent(row)
        endwhile
        call setpos('.',save_pos)
        if s_idt < c_idt
            return row
        else
            return 0
        endif
    endif
endfun "}}}
fun! s:get_child(row) "{{{
    let child = []
    let c_row = s:get_list(a:row)
    if c_row == 0
        return child
    else
        let c_idt = indent(c_row)
        let save_pos = getpos('.')
        exe nextnonblank(c_row+1)
        let [row,col] = searchpos(g:_riv_p.list_all.'|^\S', 'wn',0,100)
        let s_idt = indent(row)
        while c_idt < s_idt
            if getline(row) =~ g:_riv_p.list_all
                call add(child, row)
            else 
                break
            endif
            " goto next line
            exe nextnonblank(row)
            let [row,col] = searchpos(g:_riv_p.list_all.'|^\S', 'wn',0,100)
            let s_idt = indent(row)
        endwhile
        call setpos('.',save_pos)
        return child
        endif
    endif
endfun "}}}

" the buf obj dict version.
fun! s:buf_get_older(row) "{{{
    let c_row = s:get_list(a:row)
    if c_row == 0
        return 0
    else
        call riv#fold#init()
        let obj = b:obj_dict[c_row]
        let older = riv#fold#get_prev_brother(obj)

        if !empty(older) && nextnonblank(older.end+1) == obj.bgn
            return older.bgn
        endif
        return 0
    endif
endfun "}}}
fun! s:buf_get_parent(row) "{{{
    let c_row = s:get_list(a:row)
    if c_row == 0
        return 0
    else
        call riv#fold#init()
        let parent = b:obj_dict[b:obj_dict[c_row].parent]
        if !empty(parent) && parent.bgn != 'list_root'
            return parent.bgn
        endif
        return 0
    endif
endfun "}}}
fun! s:buf_get_child(row) "{{{
    let c_row = s:get_list(a:row)
    if c_row == 0
        return 0
    else
        call riv#fold#init()
        return  b:obj_dict[c_row].child
    endif
    
endfun "}}}
" map <leader>tt :echo <SID>buf_get_older(line('.'))<CR>
" map <leader>ty :echo <SID>buf_get_child(line('.'))<CR>
" map <leader>tu :echo <SID>buf_get_parent(line('.'))<CR>

fun! s:has_prev_item(row) "{{{
    return s:get_older(a:row) != 0
endfun "}}}
fun! riv#list#act(act) "{{{
    let row = line('.')
    let cur_list = s:get_list(row)
    if cur_list == 0
        let list_str = s:list_str(1 , '', '' , "*", " ") 
    else
        let line = getline(cur_list)
        let has_prev_item = s:has_prev_item(cur_list)
        if a:act == -1
            let parent = s:buf_get_parent(cur_list)
            if parent == 0
                let idt = ''
            else
                let idt = repeat(' ',indent(parent))
            endif
        else
            let idt = ''
        endif
        let list_str = riv#list#act_line(line, a:act, idt, has_prev_item)
    endif
    let line = getline('.')
    let len = len(line)
    if line=~ g:_riv_p.list_all
        let line = substitute(line, g:_riv_p.list_all , list_str, '')
    else
        let line = substitute(line, '^\s*', list_str, '')
    endif
    let mv = len(line)-len
    call cursor(row, col('.') + mv )
    call setline(row, line)
endfun "}}}
fun! riv#list#act_line(line, act, idt,...) "{{{
    " create the next list item by line
    let has_prev_item = a:0 ? a:1 : 1
    let [type , idt , num , attr, space] = 
                \ riv#list#stat(a:line, has_prev_item)
    if type == -1
        return s:list_str(1 , '', '' , "*", " ") 
    endif
    if a:act == 1
        let level = s:stat2level(type, num, attr) 
        let [type,num,attr] = s:level2stat(level+1)

        let idt = idt.space. repeat(' ',len(num.attr))
        
    elseif a:act == -1
        let level = s:stat2level(type, num, attr) 
        let [type,num,attr] = s:level2stat(level-1)
        let idt = a:idt
    else
        let num = s:next_list_num(num, has_prev_item)
    endif
    return s:list_str(type,idt,num,attr,space)
endfun "}}}
" Level And Stats: "{{{
" *  => +  => -   =>
"       1   
" 1. => 1) => (1) => 
"    2         3  
" A. => A) => (A) => 
"    4         5  \u
" a. => a) => (a) => 
"    4         5
" I. => I) => (I) => 
"    6         7  \u
" i. => i) => (i)
"    6         7
fun! riv#list#stat(line,...) "{{{
    " return [type , idt , num , attr, space]
    let has_prev_item = a:0 ? a:1 : 1
    let ma = matchlist(a:line, g:_riv_p.list_checker)
    if empty(ma)
        return [-1,0,0,0,0]
    endif
    let idt = matchstr(a:line,'^\s*')       " max 9 sub match reached.
    " echo ma
    if !empty(ma[1])
        return [1, idt, '' , ma[1], ma[8]]
    elseif !empty(ma[2])
        let len= len(ma[2])
        return [2,idt,ma[2][  : len-2], ma[2][len-1], ma[8]]
    elseif !empty(ma[3]) 
        let len= len(ma[3])
        return [3,idt,ma[3][1 : len-2], "()", ma[8]]
    elseif !empty(ma[4]) 
        " we should check if 'i.' have prev smaller item.
        if ( match(ma[4], '[imcxv]') == -1 || has_prev_item == 1)
            return [4,idt,ma[4][0], ma[4][1], ma[8]]
        else
            return [6,idt,ma[6][0], ma[6][1], ma[8]]
        endif
    elseif !empty(ma[5]) 
        if ( match(ma[5], '[imcxv]') == -1 || has_prev_item == 1)
            return [5,idt,ma[5][1], "()", ma[8]]
        else
            return [7,idt,ma[5][1], "()", ma[8]]
        endif
    elseif !empty(ma[6])
        let len= len(ma[6])
        return [6,idt,ma[6][  : len-2], ma[6][len-1], ma[8]]
    elseif !empty(ma[7])
        let len= len(ma[7])
        return [7,idt,ma[7][1 : len-2], "()", ma[8]]
    endif
endfun "}}}
fun! s:listnum2nr(num) "{{{
    let has_prev_item = a:0 ? a:1 : 1
    if a:num == ''
        return 0
    elseif a:num =~ '\d\+'
        return a:num
    elseif a:num =~ '^[A-Za-z]$' &&
            \ ( match(a:num, '[imcxv]') == -1 || has_prev_item == 1)
        if a:num =~ '\u'
            return char2nr(a:num)-64
        else
            return char2nr(a:num)-96
        endif
    elseif a:num =~ '[imcxv]\+'
        return riv#roman#to_nr(a:num)
    endif
endfun "}}}
fun! s:nr2listnum(n,type) "{{{
    if a:type=='1'
        return ''
    elseif a:type=='2' || a:type=='3'
        if a:n <= 0 
            return 1
        endif
        return a:n
    elseif a:type=='4' || a:type=='5'
        if a:n >26 
            return 'Z'
        elseif a:n<= 0
            return 'A'
        endif
        return nr2char(a:n+64)
    elseif a:type=='6' || a:type=='7'
        return riv#roman#from_nr(a:n)
    endif
endfun "}}}
echoe s:nr2listnum(23,5)
echoe s:listnum2nr('cmxi')
fun! s:next_list_num(num,...) "{{{
    let has_prev_item = a:0 ? a:1 : 1
    if a:num == ''
        return a:num
    elseif a:num =~ '\d\+'
        return a:num+1
    elseif a:num =~ '^[A-Za-z]$' &&
            \ ( match(a:num, '[imcxv]') == -1 || has_prev_item == 1)
        if a:num=="z"
            return "a"
        elseif a:num=="Z"
            return "A"
        else
            return nr2char(char2nr(a:num)+1)
        endif
    elseif a:num =~ '[imcxv]\+'
        let nr =riv#roman#to_nr(a:num)
        if a:num!~ '\u\+'
            return tolower(riv#roman#from_nr(nr+1))
        else
            return riv#roman#from_nr(nr+1)
        endif
    endif
endfun "}}}
fun! s:list_str(type,idt,num,attr, space) "{{{
    if a:attr == "()"
        return a:idt ."(".a:num .")" . a:space
    else
        return a:idt . a:num .  a:attr . a:space
    endif
endfun "}}}
fun! riv#list#level(line,...) "{{{
    let has_prev_item = a:0 ? a:1 : 1
    let [type , idt , num , attr, space] = riv#list#stat(a:line,has_prev_item)
    if type!=-1
        return s:stat2level(type,num,attr)
    else
        return -1
    endif

endfun "}}}
let s:list_stats= [
            \ [1, '',  '*'],  [1, '',  '+'] , [1, '',   '-'],
            \ [2, '1', '.'],  [2, '1', ')'] , [3, '1', '()'],
            \ [4, 'A', '.'],  [4, 'A', ')'] , [5, 'A', '()'],
            \ [4, 'a', '.'],  [4, 'a', ')'] , [5, 'a', '()'],
            \ [6, 'I', '.'],  [6, 'I', ')'] , [7, 'I', '()'],
            \ [6, 'i', '.'],  [6, 'i', ')'] , [7, 'i', '()'],
            \]
fun! s:stat2level(type, num, attr) "{{{
    " return level
    if a:type == 1
        return stridx('*+-', a:attr)
    elseif a:type == 2
        return stridx('.)', a:attr)  + 3
    elseif a:type == 3
        return  5 
    else
        let is_lower = match(a:num,'\U')+1
        if a:type == 4
            return  6 + stridx('.)', a:attr)  +  is_lower * 3
        elseif a:type == 5
            return  8 +  is_lower * 3
        elseif a:type == 6
            return  12 + stridx('.)', a:attr)  +  is_lower * 3
        elseif a:type == 7
            return  14 +  is_lower * 3
        endif
    endif
    return 0
endfun "}}}
fun! s:level2stat(level) "{{{
    " return type , num , attr
    if a:level >= len(s:list_stats)
        return s:list_stats[-1]
    elseif a:level < 0
        return s:list_stats[0]
    endif
    return s:list_stats[a:level]
endfun "}}}
"}}}

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
    let line = substitute(line,'^\s*', repeat(' ',indent(a:row)),'g')
    let idt = repeat(' ', abs(a:len))
    if a:len>=0
        let act = 1
        let line = substitute(line,'^',repeat(' ',a:len),'')
    else
        let act = -1
        let line = substitute(line,'^\s\{,'.abs(a:len).'}','','')
    endif
    let [type , idt , num , attr, space] =  riv#list#stat(line)
    let nr = s:listnum2nr(num)
    if type != -1
        if act == 1
            let level = s:stat2level(type, num, attr) 
            let [type,num,attr] = s:level2stat(level+1)
        elseif act == -1
            let level = s:stat2level(type, num, attr) 
            let [type,num,attr] = s:level2stat(level-1)
        endif
        echo num
        if num =~ '\u'
            let num = toupper(s:nr2listnum(nr,type))
        else
            let num = tolower(s:nr2listnum(nr,type))
        endif
        echo num
        let list_str =  s:list_str(type,idt,num,attr,space)
        let line = substitute(line, g:_riv_p.list_all , list_str, '')
    endif
    call setline(a:row,line)
endfun "}}}
fun! riv#list#shift(direction) range "{{{
    " > to add indent, < to rmv indent 
    " if line is list then change bullet.
    let line = getline(a:firstline) 
    let [type , idt , num , attr, space] = riv#list#stat(line)
    if type == -1
        let ln = &shiftwidth
    else
        let ln = len(space) + len(num . attr)
    endif
    if a:direction=="-"
        let vec = -ln
    else
        let vec = ln
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
