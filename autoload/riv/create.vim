"=============================================
"    Name: create.vim
"    File: riv/create.vim
" Summary: Create miscellaneous things.
"  Author: Rykka G.Forest
"  Update: 2012-09-17
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:months = g:_riv_t.month_names
" link "{{{

fun! s:expand_file_link(file) "{{{
    " all with ``
    " when file_link_style = 1
    " the name with rst and is relative will be sub to .html
    " the rel directory will add index.html
    " other's unchanged
    " when file_link_style =2
    " the name with [xx] and is relative will be sub to .html
    " the rel directory with [] will add index.html
    " other unchanged.
    let file = a:file
    if riv#path#file_link_style() == 2 && !empty(file)
        let file = matchstr(file, '^\[\zs.*\ze\]$')
    endif
    if !riv#path#is_relative(file)
            let tar = s:str_to_tar(file,file)
    elseif riv#path#is_directory(file)
        let tar = s:str_to_tar(file, file.'index.html')
    else
        if riv#path#is_ext(file)
            let tar = s:str_to_tar(file, fnamemodify(file, ':r').'.html') 
        elseif fnamemodify(file, ':e') == '' && riv#path#file_link_style() == 2
            let tar = s:str_to_tar(file, file.'index.html')
        else
            let tar = s:str_to_tar(file,file)
        endif
    endif
    let ref = s:str_to_ref(file)
    return [ref, tar]
endfun "}}}
fun! s:str_to_ref(str) "{{{
    if a:str !~ '[[:alnum:]._-]'
        return '`'.a:str.'`_'
    else
        return ''.a:str.'_'
    endif
endfun "}}}
fun! s:str_to_tar(str,loc) "{{{
    if a:str =~ '[`\\]'
        return '.. _`'.a:str.'`: '.a:loc
    else
        return '.. _'.a:str.': '.a:loc
    endif
endfun "}}}

fun! s:expand_link(word) "{{{
    " expand file, and let the refname expand
    let word = a:word
    if word=~ riv#ptn#link_file()
        return s:expand_file_link(word)
    else
        if word =~ '\v^'.g:_riv_p.ref_name.'$'
            if word =~ '^[[:alnum:]]\{40}$'
                let [ref, tar] = [word[:7].'_', '.. _' . word[:7].': '.word]
            else
                let ref = word.'_'
                let tar = '.. _'.word.': '.word
            endif
        elseif word =~ g:_riv_p.link_ref_footnote
            " footnote
            let trim = strpart(word,  0 , len(word)-1)
            let ref = word
            let tar = '.. '.trim.' '.trim
        elseif word =~ g:_riv_p.link_ref_normal
            let trim = strpart(word,  0 , len(word)-1)
            let ref = word
            let tar = '.. _'.trim.': '.trim
        elseif word =~ g:_riv_p.link_ref_anonymous
            " anonymous link
            let ref = word
            let tar = '__ '.s:normal_phase(word)
        elseif word =~ g:_riv_p.link_ref_phase
            let trim = s:normal_phase(word)
            let ref = word
            let tar = '.. _'.trim.': '.trim
        else
            let ref = s:str_to_ref(word)
            let tar = s:str_to_tar(word, word)
        endif
        return [ref, tar]
    endif
endfun "}}}


fun! s:normal_phase(text) "{{{
    let text = substitute(a:text ,'\v(^__=|_=_$)','','g')
    let text = substitute(text ,'\v(^`|`$)','','g')
    let text = substitute(text ,'\v(^\[|\]$)','','g')
    return text
endfun "}}}
fun! s:get_cWORD_obj() "{{{
    let line = getline('.')
    let ptn = printf('\%%%dc.', col('.'))
    let obj = {}
    if matchstr(line, ptn)=~'\S'
        let ptn = '\S*'.ptn.'\S*'
        let obj.str = matchstr(line, ptn)
        let obj.start = match(line, ptn)
        let obj.end  = matchend(line, ptn)
    endif
    return obj
endfun "}}}
fun! s:get_phase_obj() "{{{
    " if cursor is in a phase ,return it's idx , else return -1
    let line = getline('.')
    let col = col('.')
    let ptn = printf('`[^`]*\%%%dc[^`]*`__\?\|\%%%dc`[^`]*`__\?', col, col)
    let obj = {}
    let start = match(line, ptn)
    if start != -1
        let obj.start = start
        let obj.str = matchstr(line, ptn)
        let obj.end  = matchend(line, ptn)
    endif
    return obj
endfun "}}}
fun! riv#create#link() "{{{
    let [row, col] = [line('.'), col('.')]
    let line = getline(row)

    let obj = s:get_phase_obj()
    if empty(obj)
        let obj = s:get_cWORD_obj()
    endif
    if !empty(obj)
        let word = obj.str
        let idx  = obj.start + 1
        let end  = obj.end + 1
    else
        let word = input("Input a link name:")
        if word =~ '^\s*$'
            return
        endif
        let idx = col
        let end = col
    endif

    let [ref, tar] = s:expand_link(word)

    let line = substitute(line, '\%'.idx.'c.\{'.(end-idx).'}', ref, '')

    call setline(row , line)
    if g:riv_create_link_pos == '$' && tar !~ '^__'
        call append(line('$'), ["",tar])
        exe "normal! G0f:2lv$\<C-G>"
    else
        call append(row, ["",tar])
        exe "normal! jj0f:2lv$\<C-G>"
    endif
endfun "}}}
"}}}
" scratch "{{{
fun! riv#create#scratch() "{{{
    call riv#file#split(riv#path#scratch_path() . strftime("%Y-%m-%d") . riv#path#ext())
endfun "}}}
fun! s:format_src_index() "{{{
    " category scratch by month and format it 4 items a line
    let path = riv#path#scratch_path()
    if !isdirectory(path)
        return -1
    endif
    let files = split(glob(path.'*'.riv#path#ext()),'\n')
    "
    let dates = filter(map(copy(files), 'fnamemodify(v:val,'':t:r'')'),'v:val=~''[[:digit:]_-]\+'' ')

    " create a years dictionary contains year dict, 
    " which contains month dict, which contains days list
    let years = {}
    for date in dates
        let [_,year,month,day;rest] = matchlist(date, '\(\d\{4}\)-\(\d\{2}\)-\(\d\{2}\)')
        if !has_key(years, year)
            let years[year] = {}
        endif
        if !has_key(years[year], month)
            let years[year][month] = []
        endif
        call add(years[year][month], date)
    endfor
    
    let lines = []
    for year in sort(keys(years))
        call add(lines, "Year ".year)
        call add(lines, "=========")
        for month in sort(keys(years[year]))
            call add(lines, "")
            call add(lines, s:months[month-1])
            call add(lines, repeat('-', strwidth(s:months[month-1])))
            let line_lst = [] 
            for day in sort(years[year][month])
                if riv#path#file_link_style() == 1 
                    let f = printf("[[%s]]",day)
                elseif riv#path#file_link_style() == 2 
                    let f = printf(":doc:`%s`",day)
                else
                    let f = printf("%s".riv#path#ext(),day)
                endif
                call add(line_lst, f)
                if len(line_lst) == 4
                    call add(lines, join(line_lst, "    "))
                    let line_lst = [] 
                endif
            endfor
            call add(lines, join(line_lst, "    "))
        endfor
        call add(lines, "")
    endfor

    let file = path. riv#path#idx_file()
    call writefile(lines , file)
endfun "}}}

fun! riv#create#view_scr() "{{{
    call s:format_src_index()
    let path = riv#path#scratch_path()
 
    call riv#file#split(path . riv#path#idx_file() )
endfun "}}}

fun! s:escape(str) "{{{
    return escape(a:str, '.^$*[]\~')
endfun "}}}
fun! s:escape_file_ptn(file) "{{{
    if riv#path#file_link_style() == 2
        return   '\%(^\|\s\)\zs\[' . fnamemodify(s:escape(a:file), ':t:r') 
                    \ . '\]\ze\%(\s\|$\)'
    else
        return   '\%(^\|\s\)\zs' . fnamemodify(s:escape(a:file), ':t')
                    \ . '\ze\%(\s\|$\)'
    endif
endfun "}}}
fun! riv#create#delete() "{{{
    let file = expand('%:p')
    if input("Deleting '".file."'\n Continue? (y/N)?") !~?"y"
        return 
    endif
    let ptn = s:escape_file_ptn(file)
    call delete(file)
 
    if riv#path#is_rel_to_root(file)
        let index = expand('%:p:h'). '/' . riv#path#idx_file()
        if filereadable(index)
            call riv#file#edit(index)
            let f_idx = filter(range(1,line('$')),'getline(v:val)=~ptn')
            for i in f_idx
                call setline(i, substitute(getline(i), ptn ,'','g'))
            endfor
            update | redraw
            echo len(f_idx) ' relative link in index deleted.'
        endif
    endif

endfun "}}}
"}}}

" misc "{{{
fun! riv#create#foot() "{{{
    " return a link target and ref def.
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
    let footnote = input("[".id."]: Your footnote message is?\n")
    if empty(footnote) | return | endif
    let def = ".. [".id."] ".footnote
    call setline(line('.'),tar)
    call append(line('$'),def)
    
endfun "}}}
fun! riv#create#date(...) "{{{
    if a:0 && a:1 == 1
        exe "normal! a" . strftime('%H:%M:%S') . "\<ESC>"
    else
        exe "normal! a" . strftime('%Y-%m-%d') . "\<ESC>"
    endif
endfun "}}}
fun! riv#create#auto_mkdir() "{{{
    let dir = expand('%:p:h')
    if !isdirectory(dir)
        call mkdir(dir,'p')
    endif
endfun "}}}
fun! riv#create#git_commit_url() "{{{
    if !exists("*fugitive#repo")
        call riv#warning("NO fugitive")
        return
    endif
    let sha = fugitive#repo().rev_parse('HEAD')

    let [ref, tar] = s:expand_link(sha)
    call append(line('.'), [ref,"",tar])
endfun "}}}

fun! riv#create#wrap_inline(sign,mode) "{{{
    " We should consider when in visual mode and insert mode.
    " **This** is a Test
    let region = a:mode == 'v' ? 'gv' : 'viW' 
    let recov = a:mode == 'v' ? "\<Esc>gv".(len(a:sign)*2).'l' : a:mode == 'n' ? "\<Esc>" : ''
    exe 'norm!' region.'c'.a:sign."\<C-R>\"".a:sign.recov 
endfun "}}}
fun! riv#create#transition() "{{{
    let lines = ['','---','']
    call append('.',lines)
    norm! 4j
endfun "}}}
fun! riv#create#hyperlink() "{{{
    exe "norm! \<Esc>Bihttp://\<Esc>E"
endfun "}}}
fun! riv#create#exp_mark() "{{{
    exe "norm! A\<Enter>\<Enter>\<Esc>A.. "
    starti!
endfun "}}}
fun! riv#create#literal_block() "{{{
    exe "norm! A::\<Enter>\<Enter>    "
    starti!
endfun "}}}
"}}}

" cmd helper "{{{
fun! s:load_cmd() "{{{
    let list = items(g:riv_default.buf_maps)
    return map(list, 'string(v:val[0]).string(v:val[1])')
endfun "}}}
fun! riv#create#cmd_helper() "{{{
    " showing all cmds
    
    let s:cmd = riv#helper#new()
    " let s:cmd.contents = s:load_cmd()
    let s:cmd.maps['<Enter>'] = 'riv#create#enter'
    " let s:cmd.maps['<KEnter>'] = 'riv#create#enter'
    " let s:cmd.maps['<2-leftmouse>'] = 'riv#create#enter'
    " let s:cmd.syntax_func  = "riv#create#syn_hi"
    let s:cmd.contents = [s:load_cmd(),
                \filter(copy(s:cmd.contents[0]),'v:val=~g:_riv_p.todo_done '),
                \filter(copy(s:cmd.contents[0]),'v:val!~g:_riv_p.todo_done '),
                \]
    let s:cmd.input=""
    cal s:cmd.win()
endfun "}}}
"}}}

fun! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun "}}}
fun! riv#create#SID() "{{{
    return '<SNR>'.s:SID().'_'
endfun "}}}

if expand('<sfile>:p') == expand('%:p') 
    call riv#test#doctest('%','%',2)
endif

let &cpo = s:cpo_save
unlet s:cpo_save
