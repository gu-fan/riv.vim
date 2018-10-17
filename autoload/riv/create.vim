"=============================================
"    Name: create.vim
"    File: riv/create.vim
" Summary: Create miscellaneous things.
"  Author: Rykka G.Forest
"  Update: 2014-08-16
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:p = g:_riv_p

let s:months = g:_riv_t.month_names
" link "{{{

fun! s:norm_ref(str) "{{{
    " return normalized ref name
    if a:str !~ '\v^'.s:p.ref_name.'$'
        return '`'.a:str.'`_'
    else
        return ''.a:str.'_'
    endif
endfun "}}}
fun! s:norm_tar(str) "{{{
    " return normalized tar name
    " >>> echo s:norm_tar_line('其他', 'hello.rst')
    " .. _其他: hello.rst
    " >>> echo s:norm_tar_line('sep one.rst', 'hello.rst')
    " .. _`sep one.rst`: hello.rst
    if a:str !~ '\v^'.s:p.ref_name.'$'
        return '.. _`'.a:str.'`: '
    else
        return '.. _'.a:str.': '
    endif
endfun "}}}
fun! s:normal_phase(text) "{{{
    " remove the __ `` []
    " >>> echo s:normal_phase('`te fe | st:_`_')
    " te fe | st:_
    let text = substitute(a:text ,'\v(^__=|_=_$)','','g')
    let text = substitute(text ,'\v(^`|`$)','','g')
    let text = substitute(text ,'\v(^\[|\]$)','','g')
    return text
endfun "}}}

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
            let tar = file
            let loc = file
    elseif riv#path#is_directory(file)
        let tar = file 
        let loc = file.'index.html'
    else
        if riv#path#is_ext(file)
            let tar = file 
            let loc = fnamemodify(file, ':r').'.html' 
        elseif fnamemodify(file, ':e') == '' && riv#path#file_link_style() == 2
            let tar = file 
            let loc = file.'index.html'
        else
            let tar = file 
            let loc = file.'index.html'
        endif
    endif
    let ref = s:norm_ref(file)
    return [ref, tar, loc]
endfun "}}}

fun! s:expand_link(word,...) "{{{
    " expand file, and let the refname expand
    let word = a:word
    if word=~ riv#ptn#link_file()
        return s:expand_file_link(word)
    else
        if word =~ '^[[:alnum:]]\{40}$' && !a:0 
            " For github
            let loc = word
            let [ref, tar] = [word[:7].'_', '.. _' . word[:7].': ']
        elseif word =~ s:p.link_ref_footnote
            " footnote, remove '[' and ']'
            let trim = strpart(word,  0 , len(word)-1)
            let ref = word
            let loc = a:0 ? a:1 : word
            let tar = '.. '.trim.' '
        elseif word =~ s:p.link_ref_normal
            let trim = strpart(word,  0 , len(word)-1)
            let ref = word
            let loc = a:0 ? a:1 : trim
            let tar = '.. _'.trim.': '
        elseif word =~ s:p.link_ref_anonymous
            " anonymous link
            let ref = word
            let loc = a:0 ? a:1 : s:normal_phase(word)
            let tar = '__ '
        elseif word =~ s:p.link_ref_phase
            let trim = s:normal_phase(word)
            let ref = word
            let _tar = substitute(word, '\v(^__=|_=_$)','','g')
            let loc = a:0 ? a:1 : trim
            let tar = '.. _'._tar.': '
        else
            let loc = a:0 ? a:1 : word
            let ref = s:norm_ref(word)
            let tar = s:norm_tar(word)
        endif
        return [ref, tar, loc]
    endif
endfun "}}}

fun! s:get_cWORD_obj() "{{{
    " return current cWORD 
    " str, start ,end
    " NOTE: This is unicode compatible.
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
    " return current `xxx xxx`__
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
fun! riv#create#link(...) range "{{{
    " TODO: add visual mode support for creating phase link.
    " if a:0 && a:1 == 'v'
    "     echom 'V'
    "     let _v = @v
    "     " get visual lines
    "     norm! gv"vy
    "     let vs = @v
    "     let @v = _v
    "     echom vs
    " endif
    "
    let [row, col] = [line('.'), col('.')]
    let line = getline(row)
    let eof = line('$')

    let obj = s:get_phase_obj()
    if empty(obj)
        let obj = s:get_cWORD_obj()
    endif

    if !empty(obj)
        let word = obj.str
        let idx  = obj.start + 1
        let end  = obj.end + 1
    else
        let word = input("Input link name: ")
        if word =~ '^\s*$' | return | endif
        let idx = col
        let end = col
    endif

    let _loc = word

    " If it's a relative file path, then expand to PATH/index.rst
    if riv#path#is_directory(_loc) 
        \ && riv#path#is_relative(_loc)
        let _loc = _loc . riv#path#idx_file()
        " remove the final slash
        " NOTE: removed all '/' though this should not be happended
        let word = substitute(word, '/\+$', '' ,'')
        let [ref, tar, loc] = s:expand_link(word, _loc)
    else
        let [ref, tar, loc] = s:expand_link(word)
    endif

    let loc = input("\nInput link location of '". ref . "':\n", loc, "file")

    if loc =~ '^\s*$' | return | endif

    let tar_line = tar.loc
    
    " Change current line with Ref
    let line = substitute(line, '\%>'.(idx-1).'c.*\%<'.(end+1).'c', ref, '')
    call setline(row , line)
    
    " Append target line
    if g:riv_create_link_pos == '$' && tar !~ '^__'
        if  getline(eof) =~ '\v^\s*$|^\.\.%(\s|$)'
            call append(eof, [tar_line])
        else
            call append(eof, ["",tar_line])
        endif
    else
        " anonymous line
        call append(row, ["",tar_line])
    endif
    redraw
    call riv#echo('Link Created.')

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
            call riv#echo(len(f_idx).' relative link in index deleted.')
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

    if line =~ s:p.table
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
        call riv#warning(" NO fugitive installed.")
        return
    endif
    try
        let sha = fugitive#repo().rev_parse('HEAD')
    catch
        call riv#warning(" NOT a valid repo.")
        return
    endtry

    let [ref, tar, loc] = s:expand_link(sha)

    call append(line('.'), [ref])

    if g:riv_create_link_pos == '$' 
        let eof = line('$')
        if  getline(eof) =~ '\v^\s*$|^\.\.%(\s|$)'
            call append(eof, [tar.loc])
        else
            call append(eof, ["",tar.loc])
        endif
    else
        call append(line('.'), ["",tar.loc])
    endif
endfun "}}}

fun! riv#create#wrap_inline(sign,mode) "{{{
    " We should consider when in visual mode and insert mode.
    " **This** is a Test
    let region = a:mode == 'v' ? 'gv' : 'viW' 
    let recov = a:mode == 'v' ? "\<Esc>gv".(len(a:sign)*2).'l' : a:mode == 'n' ? "\<Esc>" : ''
    exe 'norm!' region.'c'.a:sign."\<C-R>\"".a:sign.recov 
endfun "}}}
fun! riv#create#transition() "{{{
    let lines = ['','----','']
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
                \filter(copy(s:cmd.contents[0]),'v:val=~s:p.todo_done '),
                \filter(copy(s:cmd.contents[0]),'v:val!~s:p.todo_done '),
                \]
    let s:cmd.input=""
    cal s:cmd.win()
endfun "}}}
"}}}

if expand('<sfile>:p') == expand('%:p') "{{{
    call doctest#start()
endif "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
