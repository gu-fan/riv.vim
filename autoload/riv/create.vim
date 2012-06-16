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
fun! riv#create#scratch() "{{{
    let id = s:id()
    let name = strftime("%Y%d%m")
    let ext =  g:_riv_c.p[id].rst_ext
    let scr = s:get_root_path() . 'scratch/'.name.'.'.ext
    exe 'sp ' scr
    let b:riv_p_id = id
    let rel = s:get_rel_to('scratch', scr)
    if g:riv_localfile_linktype == 2
        let rel = '['.fnamemodify(scr,':t:r').']'
    endif
    call s:append_scr_index(rel)
endfun "}}}
fun! s:append_scr_index(line) "{{{
    let path = s:get_root_path().'scratch'
    if !isdirectory(path)
        echo
        call mkdir(path,'p')
    endif
    let id = s:id()
    let index = g:_riv_c.p[id].index
    let ext = g:_riv_c.p[id].rst_ext
    let file = path.'/'.index.'.'.ext
    
    let lines = readfile(file)

    for line in lines[-5:]
        if line == a:line
            return
        endif
    endfor
    call writefile(add(lines, a:line) , file)
endfun "}}}
fun! riv#create#view_scr() "{{{
    let path = s:get_root_path().'scratch'
    let id = s:id()
    let index = g:_riv_c.p[id].index
    let ext = g:_riv_c.p[id].rst_ext
    let file = path.'/'.index.'.'.ext
    exe 'sp '.file
    let b:riv_p_id = id
endfun "}}}
fun! s:escape_file_ptn(file) "{{{
    if g:riv_localfile_linktype == 2
        return   '\%(^\|\s\)\zs\[' . fnamemodify(a:file, ':t:r') 
                    \ . '\]\ze\%(\s\|$\)'
    else
        return   '\%(^\|\s\)\zs' . fnamemodify(a:file, ':t') . '\ze\%(\s\|$\)'
    endif
endfun "}}}
fun! riv#create#delete() "{{{
    let file = expand('%:p')
    if input("Deleting '".file."'\n Continue? (y/N)?") !~?"y"
        return 
    endif
    let id = s:id()
    let index = g:_riv_c.p[id].index
    let ext =  g:_riv_c.p[id].rst_ext
    let ptn = s:escape_file_ptn(file)
    call delete(file)
    let index_file = expand('%:p:h').'/'.index.'.'.ext
    exe 'edit ' index_file
    let f_idx = filter(range(1,line('$')),'getline(v:val)=~ptn')
    for i in f_idx
        call setline(i, substitute(getline(i), ptn ,'','g'))
    endfor
    update
    redraw
    echo len(f_idx) ' relative link in index deleted.'
endfun "}}}

fun! s:get_rel_to(dir,path) "{{{
    let root = s:get_root_path().a:dir.'/'
    if match(a:path, root) == -1
        throw 'Riv: Not Same Path with Project'
    endif
    let r_path = substitute(a:path, root , '' , '')
    let r_path = substitute(r_path, '^/', '' , '')
    return r_path
endfun "}}}
fun! s:get_root_path() "{{{
    let root = expand(g:_riv_c.p[s:id()].path)
    return s:is_directory(root) ? root : root.'/'
endfun "}}}
fun! s:cache_todo() "{{{
    if exists("g:_riv_cached") && g:_riv_cached == 1
        return
    endif
    let root = s:get_root_path()
    let files = split(glob(root.'**/*.rst'))
    let files  =filter(files, ' v:val !~ ''_build''')
    let todos = []
    echo 'Caching...'
    for file in files
        let lines = readfile(file)
        let list  = range(len(lines))
        call filter(list, 'lines[v:val]=~g:_riv_p.todo_all && lines[v:val] !~ g:_riv_p.todo_done_list_ptn ')
        let list = map(list, '[v:val , lines[v:val]]')
        let todos += [[file, list]]
    endfor
    echon 'Done'
    let cache = root.'.rst_cache'
    call filter(todos, ' !empty(v:val[1])')
    
    let lines = s:list2lines(todos)

    call writefile(lines , cache)
    let g:_riv_cached = 1
endfun "}}}
fun! s:list2lines(list)
    let lines = []
    for [file, todos] in a:list
        call add(lines , "F: ".file)
        for [lnum, item] in todos
            call add(lines, lnum.":\t".item)
        endfor
    endfor
    return lines
endfun
fun! s:lines2list(lines)
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
endfun
fun! s:lines2helper(lines) "{{{
    let list = []
    let todos = []
    let path =[]
    let lines =[]
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
            call add(todos , td)
        endif
    endfor
    return list
endfun "}}}
fun! s:load_todo() "{{{
    call s:cache_todo()
    return s:lines2helper(readfile(s:get_root_path().'.rst_cache'))
    " return readfile(s:get_root_path().'.rst_cache')
endfun "}}}
fun! riv#create#todo()
    return s:load_todo()
endfun
fun! riv#create#todo_helper()
    let todo = riv#helper#new()
    let todo.content_dic = s:load_todo()
    call todo.win()
endfun

fun! s:is_directory(name) "{{{
    return a:name =~ '/$' 
endfun "}}}
fun! s:id() "{{{
    return exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
