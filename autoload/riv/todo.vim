"=============================================
"    Name: todo.vim
"    File: todo.vim
" Summary: todo items
"  Author: Rykka G.Forest
"  Update: 2013-05-26
"=============================================
let s:cpo_save = &cpo
set cpo-=C


let s:p = g:_riv_p
let s:t = g:_riv_t
let s:c = g:_riv_c
let s:s = g:_riv_s
let s:e = g:_riv_e

let s:grp_num = len(s:t.todo_all_group)
let s:prior_str = s:t.prior_str
let s:date_callback = "s:change_datestamp"

" Todo Obj: "{{{1
fun! s:todo_object(line) "{{{
    " groups: list,b_k,priority,tms,tms_end
    return riv#ptn#match_object(a:line,s:p.todo_check)
endfun "}}}
fun! riv#todo#obj(line) "{{{
    let obj = s:todo_object(a:line)
    if !empty(obj)
        let obj.td_list = obj.groups[1]
        let obj.td_item = obj.groups[2]
        let obj.td_prior = obj.groups[3]
        let obj.td_tm_bgn = obj.groups[4]
        let obj.td_tm_end = obj.groups[5]
    endif
    return obj
endfun "}}}
fun! riv#todo#col_item(line, col) "{{{
    " return [is_in, bgn , end, obj]
    " bgn end is index_1
    
    " is_in : 0  not in
    " is_in : 1  in list
    " is_in : 2  in keyword/todo group
    " is_in : 3  in piority
    " is_in : 4  in begin datestamp
    " is_in : 5  in end datestamp 
    
    let obj = riv#todo#obj(a:line)
    if empty(obj)
        return [0, 0, 0, {}]
    endif

    let end = 0
    let i = 0
    for group in obj.groups[1:5]
        let bgn = end + 1
        let len = len(group)
        let end = bgn + len - 1
        let i += 1
        if bgn <= a:col && a:col <= end
            let fix_end = bgn + len(riv#ptn#strip(group)) - 1
            if bgn <= a:col && a:col <= fix_end
                if i == 5
                    " The td_tms_end have a preceding '~ ' 
                    let fix_bgn = bgn + 2
                    if a:col < fix_bgn
                        return [0,0,0,obj]
                    else
                        return [i, fix_bgn, fix_end, obj]
                    endif
                endif
                return [i, bgn, fix_end, obj]
            endif
            break
        endif
    endfor

    return [0,0,0,obj]

endfun "}}}

" Todo Misc: "{{{1
fun! s:grp_len(grp) "{{{
    if a:grp < s:grp_num
        return len(s:t.todo_all_group[a:grp])
    endif
endfun "}}}
fun! s:grp_max_i(grp) "{{{
    return s:grp_len(a:grp) - 1
endfun "}}}

fun! s:add_item(line,grp,idx) "{{{
   let max_i = s:grp_max_i(a:grp)
   let id = a:idx > max_i ? max_i : a:idx < 0 ? 0 : a:idx 
   return substitute(a:line, s:p.all_list, '\0'.s:t.todo_all_group[a:grp][id].' ','')
endfun "}}}
fun! s:mod_item(line,grp,idx) "{{{
   let max_i = s:grp_max_i(a:grp)
   let id = a:idx > max_i ? max_i : a:idx < 0 ? 0 : a:idx 
   return substitute(a:line, s:p.todo_b_k, '\1'.s:t.todo_all_group[a:grp][id].' ','')
endfun "}}}
fun! s:rmv_item(line) "{{{
    return substitute(a:line, s:p.todo_all, '\1','')
endfun "}}}
fun! s:item_stat(item) "{{{
    let item = riv#ptn#strip(a:item)
    if has_key(s:t.td_group_dic, item)
        return s:t.td_group_dic[item]
    else
        throw g:_riv_e.INVALID_TODO_GROUP
    endif
endfun "}}}

fun! s:add_tm_bgn(line,...) "{{{
    let tm = a:0 ? a:1 : strftime(s:t.time_fmt)
    return substitute(a:line, s:p.todo_all, '\1\2\3'.tm.' \5','')
endfun "}}}
fun! s:add_tm_end(line,...) "{{{
    let tm = a:0 ? a:1 : strftime(s:t.time_fmt)
    let groups = matchlist(a:line , s:p.todo_all)
    let line = a:line
    if empty(groups[4])             " add a tm_bgn if not exists
        let line = substitute(line, g:_riv_p.todo_b_k, '\1\2\3'.tm.' ','')
    endif
    return substitute(line, s:p.todo_all, '\1\2\3\4~ '.tm.' ','')
endfun "}}}
fun! s:rmv_tm_bgn(line) "{{{
    return substitute(a:line, s:p.todo_all, '\1\2\3','')
endfun "}}}
fun! s:rmv_tm_end(line) "{{{
    return substitute(a:line, s:p.todo_all, '\1\2\3\4','')
endfun "}}}

fun! s:add_prior(line, id) "{{{
    let max_i = len(s:prior_str) -1
   let id = a:id > max_i ? max_i : a:id < 0 ? 0 : a:id 
    return substitute(a:line, s:p.todo_all, '\1\2[#'.s:prior_str[id].'] \4\5','')
endfun "}}}
fun! s:rmv_prior(line) "{{{
    return substitute(a:line, s:p.todo_all, '\1\2\4\5','')
endfun "}}}
fun! s:prior_id(prior) "{{{
    let p = matchstr(a:prior, s:p.td_prior)
    if empty(p)
        return -1
    else
        return stridx(s:prior_str,p)
    endif
endfun "}}}


" Todo Main: "{{{1
fun! riv#todo#toggle() "{{{
    " Toggle todo item of current line
    " if is list
    "   if not todo
    "      add todo item
    "   else
    "      next todo item idx
    "      add or remove tm
    let [row, col] = [line('.'), col('.')]
    let line = getline(row)
    
    let obj = riv#todo#obj(line)
    if empty(obj)
        call riv#warning(s:e.NOT_LIST_ITEM)
        return
    endif

    let date = g:riv_todo_datestamp
    let prv_len = strwidth(line)

    if empty(obj.td_item)
        " g:riv_todo_default_group
        let grp = g:riv_todo_default_group
        let idx = 0
        let line = s:add_item(line, grp, idx)
        if date == 2
            let line = s:add_tm_bgn(line)
        endif
    else
    
        let [grp, idx] = s:item_stat(obj.td_item)
        let max_i = s:grp_max_i(grp)
        
        let idx += 1
        if idx == max_i
            if date == 1
                let line = s:add_tm_bgn(line)
            elseif date == 2
                let line = s:add_tm_end(line)
            endif
        elseif idx > max_i
            let idx = 0
            if date == 1
                let line = s:rmv_tm_bgn(line)
            elseif date == 2
                let line = s:rmv_tm_end(line)
            endif
        endif

        let line = s:mod_item(line, grp, idx)
    endif

    call setline(row, line)

    call cursor(row, riv#list#fix_col(col, obj.end, (strwidth(line) - prv_len)))

endfun "}}}
fun! riv#todo#delete() "{{{
    let [row, col] = [line('.'), col('.')]
    let line = getline(row)
    let prv_len = strwidth(line)
    let end = matchend(line, g:_riv_p.todo_all)
    if end != -1
        let line = s:rmv_item(line)
        call setline(row,line)
        call cursor(row, riv#list#fix_col(col, end, (strwidth(line) - prv_len)))
    else
        call riv#warning(s:e.NOT_TODO_ITEM)
    endif
endfun "}}}
fun! riv#todo#change(grp) "{{{

    let [row, col] = [line('.'), col('.')]
    let line = getline(row)

    let obj = riv#todo#obj(line)
    if empty(obj)
        call riv#warning(s:e.NOT_LIST_ITEM)
        return
    endif

    let prv_len = strwidth(line)
    if empty(obj.td_item)
        let [grp,idx] = [0, 0]
    else
        let [grp, idx] = s:item_stat(obj.td_item)
    endif
    let line = s:rmv_item(line)
    if a:grp > s:grp_num
        call riv#warning("The keyword group [".a:grp."] is not defined.")
        return
    endif

    let line = s:add_item(line, a:grp, idx)
    call setline(row, line)
    call cursor(row, riv#list#fix_col(col, obj.end, (strwidth(line) - prv_len)))

endfun "}}}

fun! riv#todo#todo_ask() "{{{
    let grp =  inputlist(s:t.td_ask_keywords)
    if  grp > 0 && grp <= len(s:t.td_keyword_groups)
        call riv#todo#change(grp)
    endif
endfun "}}}

fun! riv#todo#stat(line) "{{{
    let obj = riv#todo#obj(a:line)
    if empty(obj) || empty(obj.td_item)
        return -1
    endif
    let [grp, idx] = s:item_stat(obj.td_item)
    let max_i = s:grp_max_i(grp)
    " the one item group will return 1
    return max_i != 0 ? (idx+0.0)/max_i : 1
endfun "}}}

fun! riv#todo#toggle_prior(del) "{{{
    let [row, col] = [line('.'), col('.')]
    let line = getline(row)

    let obj = riv#todo#obj(line)
    if empty(obj) || empty(obj.td_item)
        call riv#warning(s:e.NOT_TODO_ITEM)
        return -1
    endif

    let prv_len = strwidth(line)

    let id = s:prior_id(obj.td_prior)
    let id += 1
    let max_i = len(s:prior_str) -1
    if id > max_i
        if a:del
            let line = s:rmv_prior(line)
        else
            let line = s:add_prior(line, 0)
        endif
    else
        let line = s:add_prior(line, id)
    endif

    call setline(row,line)

    call cursor(row, riv#list#fix_col(col, obj.end, (strwidth(line) - prv_len)))

endfun "}}}

" Todo Datestamp: "{{{1
fun! riv#todo#change_datestamp() "{{{
    
    let [row, col] = [line('.'), col('.')]
    let line = getline(row)
    let buf = bufnr('%')

    let [in, bgn, end, obj] = riv#todo#col_item(line, col)
    if in == 4 
        let s:date_call_args = [0, buf, row]
    elseif in == 5
        let s:date_call_args = [1, buf, row]
    else
        call riv#warning(s:e.NOT_DATESTAMP)
        return -1
    endif
    
    call s:input_date()
endfun "}}}
fun! s:input_date() "{{{
    " use Calendar(dir,year,month) 
    " g:calendar_action: the action function(day, month, year, week, dir)
    " g:calendar_sign:   show sign of the day
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
endfun "}}}
fun! riv#todo#feed_date(day,month,year,...) "{{{
    if exists("s:cal_action_save")
        let g:calendar_action = s:cal_action_save
        if bufname("%") == '__Calendar'
            quit
        endif
    endif
    let date =  printf("%04.4s-%02.2s-%02.2s", a:year,a:month,a:day)
    call call(s:date_callback, add(s:date_call_args, date) )
endfun "}}}
fun! s:change_datestamp(id, buf, row, date) "{{{
    let win = bufwinnr(a:buf)
    if win == -1
        exe 'sb ' a:buf
    elseif win != winnr()
        exe win."wincmd w"
    endif

    let line = getline(a:row)
    if a:id == 1
        let line = s:add_tm_end(line, a:date)
    elseif a:id == 0
        let line = s:add_tm_bgn(line, a:date)
    endif
    call setline(a:row, line)
endfun "}}}

" Helper:  "{{{1
" Cache: "{{{2
fun! s:cache_todo(force) "{{{
    let root = riv#path#root()
    let cache = root.'.todo_cache'
    if filereadable(cache) && a:force==0
        return
    endif

    let files = split(glob(root.'**/*'.riv#path#ext()))
    let b_path = riv#path#build_path()
    let files = filter(files, '! riv#path#is_rel_to(b_path, v:val)')

    let todos = []
    let lines = []

    echo 'Caching Todo...'
    for file in files
        let lines += s:file2lines(readfile(file), riv#path#rel_to_root(file))
    endfor
    echon 'Done'
    
    call writefile(lines , cache)
endfun "}}}
fun! s:file2lines(filelines,filename,...) "{{{
    let l = a:0 ? a:1 : 20
    let lines = a:filelines
    let list  = range(len(lines))
    call filter(list, 'lines[v:val]=~g:_riv_p.todo_b_k  ')
    call map(list, 
    \'printf("%-".l."s %4d | ", a:filename, (v:val+1)).riv#ptn#strip(lines[v:val])')
    return list
endfun "}}}

fun! s:load_todo() "{{{
    let file = expand('%:p')
    if riv#path#is_rel_to(riv#path#root(), file ) || &ft!='rst'
        call s:cache_todo(0)
        return readfile(riv#path#root().'.todo_cache')
    else
        return s:file2lines(readfile(file), '%', 5)
    endif
endfun "}}}
fun! riv#todo#force_update() "{{{
    call s:cache_todo(1)
endfun "}}}
fun! riv#todo#update() "{{{
    " update the todo cache with current file
    let file = expand('%:p')
    
    " don't cache file in build path
    if riv#path#is_rel_to(riv#path#build_path(), file)
        return
    endif

    try
        let f = riv#path#rel_to_root(file)
        let lines = s:file2lines(getline(1,line('$')), f)
        let dir = riv#path#root()
        let cache = dir .'.todo_cache'
        if !isdirectory(dir)
            call mkdir(dir,'p')
        endif
        if filereadable(cache)
            let c_lines = filter(readfile(cache), ' v:val!~escape(f,''\'')')
        else
            let c_lines = []
        endif
        call writefile(c_lines+lines , cache)
    catch 
        call riv#debug("Update todo cache failed:". v:exception)
        return -1
    endtry
endfun "}}}

fun! riv#todo#enter() "{{{
    let [all,file,lnum;rest] = matchlist(getline('.'),  '\v^(\S*)\s+(\d+)\ze |')
    if file !=  '%'
        let file = riv#path#root().file
    else
        let file = s:todo.prev_file
    endif
    if s:todo.exit()
        if expand('%:p') != file
            call riv#file#edit(file)
        endif
    else
        call riv#file#split(file)
    endif
    call cursor(lnum, 1)
    normal! zvz.
endfun "}}}
fun! riv#todo#syn_hi() "{{{
    syn clear
    exe 'syn match rivFile `' . s:s.rivFile .'`'
    exe 'syn match rivLnum `' . s:s.rivLnum .'`'
    exe 'syn match rivTodo `' . s:s.rivTodo .'` transparent contains=@rivTodoGroup'
    exe 'syn match rivDone `' . s:s.rivDone .'`'

    syn cluster rivTodoGroup contains=rivTodoList,rivTodoItem,rivTodoPrior
                \ ,rivTodoTmBgn,rivTodoTmEnd
    exe 'syn match rivTodoList `'.s:s.rivTodoList.'` contained nextgroup=rivTodoItem'
    exe 'syn match rivTodoItem `'.s:s.rivTodoItem.'` contained nextgroup=rivTodoPrior'
    exe 'syn match rivTodoPrior `'.s:s.rivTodoPrior.'` contained nextgroup=rivTodoTmBgn'
    exe 'syn match rivTodoTmBgn `'.s:s.rivTodoTmBgn.'` contained nextgroup=rivTodoTmEnd'
    exe 'syn match rivTodoTmEnd `'.s:s.rivTodoTmEnd.'` contained'

    hi def link rivFile Function
    hi def link rivLnum SpecialComment

    " should be the same as rstTodo
    
    hi def link rivTodoList     Function
    hi def link rivTodoPrior    Include
    hi def link rivTodoItem     Include
    hi def link rivTodoTmBgn    Number
    hi def link rivTodoTmEnd    Number

    hi def link rivDone         Comment
endfun "}}}
fun! riv#todo#todo_helper() "{{{
    let All = s:load_todo()
    let s:todo = riv#helper#new()
    let Todo = filter(copy(All),'v:val!~s:p.help_todo_done ')
    let Done = filter(copy(All),'v:val=~s:p.help_todo_done ') 
    let PriorInput = All
    if exists('g:riv_todo_helper_ignore_done') && g:riv_todo_helper_ignore_done == 1
       let PriorInput = Todo
    endif
    let Prior1 = filter(copy(PriorInput),'v:val=~s:p.help_prior1 ') 
    let Prior2 = filter(copy(PriorInput),'v:val=~s:p.help_prior2 ') 
    let Prior3 = filter(copy(PriorInput),'v:val=~s:p.help_prior3 ') 
    let s:todo.contents = [Todo,Done,All,Prior1,Prior2,Prior3]
    let prior_strs = map(range(3), '"#".s:t.prior_str[v:val]')
    let s:todo.contents_name = ['Todo', 'Done', 'All'] + prior_strs
    let s:todo.content_title = "Todos"

    let s:todo.maps['<Enter>'] = ':cal riv#todo#enter()<CR>'
    let s:todo.maps['<KEnter>'] = ':cal riv#todo#enter()<CR>'
    let s:todo.maps['<2-leftmouse>'] = ':cal riv#todo#enter()<CR>'
    let s:todo.syntax_func  = 'riv#todo#syn_hi'
    let s:todo.input=""
    cal s:todo.win()
endfun "}}}

" Misc: "{{{1
fun! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun "}}}
fun! riv#todo#SID() "{{{
    return '<SNR>'.s:SID().'_'
endfun "}}}

fun! riv#todo#test() "{{{
    " Todo Item check
    let list =  '- TODO [#A] 1111-11-11 ~ 1222-22-22 '
    for i in range(1,len(list))
        echo i riv#todo#col_item(list, i)[0:2]
    endfor

    " Todo functions:
    " should be tested manually
    
    " toggle todo  ee / click
    " toggle todo pioritymap ep /click
    " change datestamp setting  ed / click 
    " disable clanedar in s:input_date() .  click
    " del todo       ex
    " todo item highlighs
    " todo item cursor highlights
    " 
    " todo helper in project and no-rst file/ single file
    " toggle helper contents toggle
endfun "}}}

if expand('<sfile>:p') == expand('%:p') 
    " call riv#todo#test()
endif


let &cpo = s:cpo_save
unlet s:cpo_save
