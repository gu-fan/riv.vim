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
    
    " for adjust cursor position
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
fun! s:list_str(type,idt,num,attr, space) "{{{
    if a:attr == "()"
        return a:idt ."(".a:num .")" . a:space
    else
        return a:idt . a:num .  a:attr . a:space
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
        let line = substitute(line, '^\s*', '\0'.list_str, '')
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

    let todo_match = matchlist(a:line, g:_riv_p.todo_all)
    if empty(todo_match)
        return [-1, 0]
    endif
    
    if !empty(todo_match[2])            
        return s:get_box_id(s:strip(todo_match[2]))
    elseif !empty(todo_match[3])        
        return s:get_key_id(s:strip(todo_match[3]))
    endif
endfun "}}}
fun! s:strip(text) "{{{
    return matchstr(a:text, '^\s*\zs\S.*\S\ze\s*$')
endfun "}}}
fun! s:get_box_id(text) "{{{
    return [0, index(g:_riv_t.todo_levels, a:text)]
endfun "}}}
fun! s:get_key_id(key) "{{{
    if has_key(g:_riv_t.td_keyword_dic, a:key)
        return g:_riv_t.td_keyword_dic[a:key]
    else
        return [-1, 0]
    endif
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
   let max_id = len(g:_riv_t.todo_all_group[a:grp])-1
   let id = a:id > max_id ? max_id : a:id < 0 ? 0 : a:id 
   return substitute(a:line, g:_riv_p.list_all, '\0'.g:_riv_t.todo_all_group[a:grp][id].' ','')
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
"
fun! s:split(file) "{{{
    exe 'sp ' a:file
    let b:riv_p_id = s:id()
endfun "}}}

" Todo Helper: "{{{
let s:slash = has('win32') || has('win64') ? '\' : '/'
fun! s:cache_todo(force) "{{{
    " TODO: we should cache once for the first time or manually
    " and update them with editing buffer only.
    let root = riv#path#root()
    let cache = root.'.todo_cache'
    if filereadable(cache) && a:force==0
        return
    endif
    let files = split(glob(root.'**/*.rst'))
    let files = filter(files, ' v:val !~ ''_build''')
    let todos = []
    echo 'Caching...'
    let lines = []
    for file in files
        let lines += s:file2lines(readfile(file), riv#path#rel_to_root(file))
    endfor
    echon 'Done'
    
    call writefile(lines , cache)
endfun "}}}
fun! s:file2list(filelines,filename) "{{{
    " setup a qflist dict list
    let lines = a:filelines
    let list  = range(len(lines))
    call filter(list, 'lines[v:val]=~g:_riv_p.todo_all && lines[v:val] !~ g:_riv_p.todo_done_list_ptn ')
    let dictlist = map(list,
        \'{"filename": a:filename ,"bufnr":0 , "lnum":v:val+1 , "line":lines[v:val] }')
    return dictlist
endfun "}}}
fun! s:strip(line) "{{{
    return substitute(a:line,'^\s*\(.\{-}\)\s*$','\1','')
endfun "}}}

fun! s:file2lines(filelines,filename) "{{{
    let lines = a:filelines
    let list  = range(len(lines))
    call filter(list, 'lines[v:val]=~g:_riv_p.todo_all  ')

    call map(list , 'printf("%-20s %4d | ", a:filename ,(v:val+1)). s:strip(lines[v:val])')
    return list
endfun "}}}

fun! s:list2lines(list) "{{{
    let lines = []
    for [file, todos] in a:list
        call add(lines , "F: ".file)
        for [lnum, item] in todos
            call add(lines, lnum.":\t".item)
        endfor
    endfor
    return lines
endfun "}}}
fun! s:lines2list(lines) "{{{
    let list = []
    let todos = []
    for line in a:lines
        let str=matchstr(line, '^F: \zs.*')
        if !empty(str) "{{{
            if !empty(todos)
                call add(list,todos)
            endif
            let tds = []
            let todos = [str, tds]
        endif "}}}
        let td= matchstr(line, '^\d\+:\t.*')
        if !empty(td)
            call add(tds , td)
        endif
    endfor
    return list
endfun "}}}
fun! s:lines2helper(lines) "{{{
    let list = []
    let todos = []
    let path = []
    let lines = []
    let g:_riv_td_path = [path, lines]
    for line in a:lines
        let file=matchstr(line, '^F: \zs.*')
        if !empty(file) "{{{
            if !empty(todos)
                call extend(list,todos)
            endif
            let f = file
            let todos = []
        endif "}}}
        let td= matchstr(line, '^\d\+:\t\zs.*')
        if !empty(td)
            let lnum= matchstr(line, '^\d\+\ze:\t.*')
            call add(path, [f, lnum])
            call add(lines, td)
            call add(todos, td)
        endif
    endfor
    return list
endfun "}}}
fun! s:load_todo() "{{{
    let file = expand('%:p')
    if riv#path#is_rel_to(riv#path#root(), file ) || &ft!='rst'
        call s:cache_todo(0)
        return readfile(riv#path#root().'.todo_cache')
    else
        let s:todo_file = file
        return s:file2lines(readfile(file), '%')
    endif
endfun "}}}
fun! riv#todo#force_update() "{{{
    call s:cache_todo(1)
endfun "}}}
fun! riv#todo#update() "{{{
    " every time writing buffer.
    " parse the buffer. find the todo item.
    " then parse the cache , remove lines match the buffer filename
    " add with the buffer's new todo-item
    let file = expand('%:p')
    " windows use '\' as directory delimiter
    if riv#path#is_rel_to(riv#path#build_path, file)
        return
    endif
    try
        let f = riv#path#rel_to_root(file)
        let lines = s:file2lines(getline(1,line('$')), f)
        let cache = riv#path#root() .'.todo_cache'
    catch 
        return
    endtry
    if filereadable(cache)
        let c_lines = filter(readfile(cache), ' v:val!~escape(f,''\'')')
    else
        let c_lines = []
    endif
    call writefile(c_lines+lines , cache)
endfun "}}}
fun! riv#todo#enter() "{{{
    let [all,file,lnum;rest] = matchlist(getline('.'),  '\v^(\S*)\s+(\d+)\ze |')
    call s:todo.exit()
    if file !=  '%'
        call s:split(riv#path#root().file)
    else
        let file = s:todo_file
        let win = bufwinnr(file)  
        if win != -1
            exe win. 'wincmd w'
        else
        call s:split(file)
        endif
    endif
    call cursor(lnum, 1)
    normal! zv
endfun "}}}
let s:td_keywords = g:_riv_p.td_keywords
fun! riv#todo#syn_hi() "{{{
    syn match rivHelperFile  '^\S*' 
    syn match rivHelperLNum  '\s\+\d\+ |'
    exe 'syn match rivHelperTodo '
            \.'`\v\c%(^\S*\s+\d+ |)@<=\s*%([-*+]|:[^:]+:|%(\d+|[#a-z]|[imlcxvd]+)[.)])\s+'
            \.'%(\[.\]|'. s:td_keywords .')'
            \.'%(\s+\d{4}-\d{2}-\d{2})='.'%(\s\~ \d{4}-\d{2}-\d{2})='
            \.'\ze%(\s|$)` transparent contains=@rivTodoBoxGroup'

    exe 'syn match rivHelperTodoDone '
            \.'`\v\c%(^\S*\s+\d+ |)@<=\s*%([-*+]|%(\d+|[#a-z]|[imlcxvd]+)[.)])\s+'
            \. g:_riv_p.todo_done_ptn
            \.'%(\s+\d{4}-\d{2}-\d{2})='.'%(\s\~ \d{4}-\d{2}-\d{2})='
            \.'\ze%(\s|$)` '
    syn cluster rivTodoBoxGroup contains=rivTodoList,rivTodoBoxList,rivTodoTmsList,rivTodoTmsEnd
    syn match rivTodoList `\v\c\s*%([-*+]|%(\d+|[#a-z]|[imlcxvd]+)[.)])\s+`
                \ contained nextgroup=rivTodoBoxList
    exe 'syn match rivTodoBoxList '
                \.'`\v%(\[.\]|'. s:td_keywords .')`'
                \.' nextgroup=rivTodoTmsList contained'
    syn match rivTodoTmsList `\v\d{4}-\d{2}-\d{2}` contained nextgroup=rivTodoTmsEnd
    syn match rivTodoTmsEnd  `\v\~ \zs\d{4}-\d{2}-\d{2}` contained
    hi def link rivTodoList    Function
    hi def link rivTodoBoxList Include
    hi def link rivTodoTmsList Number
    hi def link rivTodoTmsEnd  Number
    hi def link rivHelperTodoDone Comment

    hi link rivHelperLNum SpecialComment
    hi link rivHelperFile Function
endfun "}}}
fun! riv#todo#todo_helper() "{{{
    " TODO: Create more actions.
    let s:todo = riv#helper#new()
    let All = s:load_todo()
    let Todo = filter(copy(All),'v:val!~''\v''.g:_riv_p.todo_done_ptn ')
    let Done = filter(copy(All),'v:val=~''\v''.g:_riv_p.todo_done_ptn ') 
    let s:todo.contents = [All,Todo,Done]
    let s:todo.contents_name = ['All', 'Todo', 'Done']
    let s:todo.content_title = "Todo Helper"

    let s:todo.maps['<Enter>'] = 'riv#todo#enter'
    let s:todo.maps['<KEnter>'] = 'riv#todo#enter'
    let s:todo.maps['<2-leftmouse>'] = 'riv#todo#enter'
    let s:todo.syntax_func  = "riv#todo#syn_hi"
    let s:todo.input=""
    cal s:todo.win()
endfun "}}}
"}}}


fun! s:id() "{{{
    return exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
endfun "}}}
fun! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun "}}}
fun! riv#todo#SID() "{{{
    return '<SNR>'.s:SID().'_'
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
