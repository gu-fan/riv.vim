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
    let [row,col] = getpos('.')[1:2]
    let line = getline('.')
    if s:is_in_bgn_blank(col, line)
        let cmd = riv#insert#shiftleft(row,col)
    else
        let cmd = ""
    endif
    return  !empty(cmd) ? cmd : "\<BS>"
endfun "}}}

fun! s:is_in_list_item(col,line) "{{{
    " it's the col before last space in list-item
    return a:col <= matchend(a:line, g:_riv_p.all_list)
endfun "}}}
fun! s:is_in_bgn_blank(col,line) "{{{
    " it's the col include last space in a line
    return a:col <= matchend(a:line, '^\s*') + 1
endfun "}}}
fun! s:is_in_table(line) "{{{
    return a:line =~ g:_riv_p.table
endfun "}}}

fun! riv#action#ins_tab() "{{{
" tab for insert mode.
" to support other command. 
" the g:riv_i_tab_pum_next is used to act as '<C-N>' when pumvisible
" the g:riv_i_tab_user_cmd is used to execute user defined command or '\<Tab>'
" the g:riv_i_stab_user_cmd is used to execute user defined command 

    let [row,col] = getpos('.')[1:2]
    let line = getline('.')

    if pumvisible() && g:riv_i_tab_pum_next
        return "\<C-N>"
    elseif s:is_in_table(line)
        " Format the table and find the cell.
        return "\<C-O>:call cursor(riv#table#nextcell())\<CR>"
    elseif s:is_in_list_item(col, line)
        " before the list item, shift the list
        return "\<C-O>:call riv#list#shift('+')\<CR>"
    elseif s:is_in_bgn_blank(col, line)
        let cmd = riv#insert#shiftright(row,col)
    else
        let cmd = ''
    endif
    if !empty(cmd)
        return cmd
    else
        if !empty(g:riv_i_tab_user_cmd) 
            return g:riv_i_tab_user_cmd
        else
            return "\<Tab>"
        endif
    endif
endfun "}}}
fun! riv#action#ins_stab() "{{{
    let [row,col] = getpos('.')[1:2]
    let line = getline('.')

    if pumvisible() && g:riv_i_tab_pum_next
        return "\<C-P>"
    elseif s:is_in_table(line)
        " Format the table and find the cell.
        return "\<C-O>:call cursor(riv#table#prevcell())\<CR>"
    elseif s:is_in_list_item(col, line)
        " before the list item, shift the list
        return "\<C-O>:call riv#list#shift('-')\<CR>"
    elseif s:is_in_bgn_blank(col, line)
        let cmd = riv#insert#shiftleft(row,col)
    else
        let cmd = '' 
    endif

    if !empty(cmd)
        return cmd
    else
        if !empty(g:riv_i_stab_user_cmd) 
            return g:riv_i_stab_user_cmd
        else
            return "\<BS>"
        endif
    endif
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
