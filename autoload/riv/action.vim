"=============================================
"    Name: action.vim
"    File: action.vim
" Summary: simulate and fix some misc actions
"  Author: Rykka G.Forest
"  Update: 2012-07-07
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! riv#action#quick_start() "{{{
    let quick_start = g:_riv_c.doc_pat . 'riv_quickstart.rst'
    let lines = readfile(quick_start)
    noa keepa bot new QuickStart
	setl noswf nolist nospell nocuc wfh
	setl bt=nofile bh=unload
    set ft=rst
    call setline(1,lines)
    update
endfun "}}}

fun! riv#action#db_click(mouse) "{{{
    " could not use map <expr>
    " cause it's editing file here.
    let row = line('.')
    if foldclosed(row) != -1
        exe "normal! zv"
    elseif !riv#link#open()
        if s:is_in_sect_title(row)
            exe "normal! zc"
            return
        endif
        let line = getline(row)
        let col = col('.')
        let [is_in,bgn,end,obj] = riv#todo#col_item(line,col)
        if !is_in
            if a:mouse== 1
                exe "normal! \<2-LeftMouse>"
            else
                exe "normal! \<Enter>"
            endif
        elseif is_in == 2
            call riv#todo#toggle()
        elseif is_in == 3
            call riv#todo#toggle_prior(0)
        elseif is_in == 4 || is_in == 5
            call riv#todo#change_datestamp()
        endif
    endif
endfun "}}}
fun! s:is_in_sect_title(row) "{{{
   return exists("b:riv_obj") && has_key(b:riv_obj, a:row)
               \ && b:riv_obj[a:row].type =='sect'
endfun "}}}

fun! s:cmd_table_new_line(row,col) "{{{
    let cmd  = "\<C-O>:call riv#table#newline()|"
    let cmd .= "call cursor(".(a:row+1).",".a:col.")|"
    let cmd .= "call search(g:_riv_p.cell0,'Wbc')\<CR>"
    return cmd
endfun "}}}

fun! riv#action#ins_enter() "{{{
    if getline('.') =~ g:_riv_p.table
        let [row,col] = getpos('.')[1:2]
        return s:cmd_table_new_line(row,col)
    else
        return  "\<C-G>u\<Enter>"
    endif
endfun "}}}
fun! riv#action#ins_c_enter() "{{{
    let line = getline('.')
    if getline('.') =~ g:_riv_p.table
        let [row,col] = getpos('.')[1:2]
        return s:cmd_table_new_line(row,col)
    endif
    let cmd = "\<C-G>u"
    let cmd .= line=~ '\S' ? "\<CR>" : ''
    let cmd .= "\<C-O>:call riv#list#new(0)\<CR>\<Esc>A"
    return cmd
endfun "}}}
fun! riv#action#ins_s_enter() "{{{
    let line = getline('.')
    if getline('.') =~ g:_riv_p.table
        let [row,col] = getpos('.')[1:2]
        return s:cmd_table_new_line(row,col)
    endif
    let cmd = "\<C-G>u"
    let cmd .= line=~ '\S' ? "\<CR>\<CR>" : ''
    let cmd .= "\<C-O>:call riv#list#new(1)\<CR>\<Esc>A"
    return cmd
endfun "}}}
fun! riv#action#ins_m_enter() "{{{
    let line = getline('.')
    if getline('.') =~ g:_riv_p.table
        let [row,col] = getpos('.')[1:2]
        return s:cmd_table_new_line(row,col)
    endif
    let cmd = "\<C-G>u"
    let cmd .= line=~ '\S' ? "\<CR>\<CR>" : ''
    let cmd .= "\<C-O>:call riv#list#new(-1)\<CR>\<Esc>A"
    return cmd
endfun "}}}


fun! riv#action#ins_backspace() "{{{
    return riv#insert#shiftleft()
endfun "}}}

fun! riv#action#ins_tab() "{{{
    if riv#table#nextcell()[0] == 0
        if g:riv_ins_super_tab == 1 && pumvisible()
            return "\<C-N>"
        else
            " if it's before the list item position. indent list.
            if col('.') <= matchend(getline('.'), g:_riv_p.all_list)
                return "\<C-O>:call riv#list#shift('+')\<CR>"
            else
                return riv#insert#shiftright()
            endif
        endif
    else
        " NOTE: Find the cell after table get formated.
        return "\<C-O>:call cursor(riv#table#nextcell())\<CR>"
    endif
endfun "}}}
fun! riv#action#ins_stab() "{{{
    if riv#table#prevcell()[0] == 0
        if g:riv_ins_super_tab == 1 && pumvisible()
            return "\<C-P>"
        else
            if col('.') <= matchend(getline('.'), g:_riv_p.all_list)
                return "\<C-O>:call riv#list#shift('-')\<CR>"
            else
                return riv#insert#shiftleft()
            endif
        endif
    else
        return "\<C-O>:call cursor(riv#table#prevcell())\<CR>"
    endif
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
