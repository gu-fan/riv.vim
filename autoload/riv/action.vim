"=============================================
"    Name: action.vim
"    File: action.vim
" Summary: simulate and fix some misc actions
"  Author: Rykka G.Forest
"  Update: 2014-02-10
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:p = g:_riv_p
fun! riv#action#tutor(fname, bname) "{{{
    " Read tutor in a nofile buffer.
    "   if not exists, create buffer
    "   if buffer exists, load buffer.
    if riv#win#new(a:bname)
        setl buftype=nofile bufhidden=hide noswapfile
        set ft=rst
        let file = g:_riv_c.doc_path . a:fname . '.rst'
        try
            call setline(1, readfile(file))
        catch
            call riv#error('Error while reading file: '.v:exception)
        endtry
        update
    endif

endfun "}}}
fun! riv#action#open(name) "{{{
    let file = g:_riv_c.doc_path . 'riv_'.a:name.'.rst'
    if riv#win#new(file)
        " exe 'noa keepa bot sp' file
        setl ro noma ft=rst
        update
    endif
endfun "}}}

fun! riv#action#db_click(mouse) "{{{
    " could not use map <expr>
    " cause it's editing file here.
    let row = line('.')
    if foldclosed(row) != -1
        exe "normal! zv"
    elseif riv#link#open() == 0
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

fun! s:table_newline_cmd(row,col,typ) "{{{
    let cmd  = "\<C-G>u\<C-O>:call riv#table#newline('".a:typ."')|"
    if a:typ == 'cont'
        let cmd .= "call cursor(".(a:row+1).",".a:col.")|"
    else
        let cmd .= "call cursor(".(a:row+2).",".a:col.")|"
    endif
    let cmd .= "call search(g:_riv_p.cell.'|^\s*$' ,'Wbc')\<CR>"
    return cmd
endfun "}}}

fun! riv#action#ins_enter() "{{{
    if getline('.') =~ s:p.table
        call riv#table#newline('cont')
    else
        " exe "norm! \<Esc>gi\<CR>\<Right>"
        " exe "norm! \<Esc>a\<C-G>u\<C-M>"
        call feedkeys("\<Esc>gi\<C-G>u\<C-M>",'n')
        " norm! o
    endif
endfun "}}}
fun! riv#action#ins_c_enter() "{{{
    if getline('.') =~ s:p.table
        call riv#table#newline('sepr')
    else
        call riv#list#new(0)
    endif
endfun "}}}
fun! riv#action#ins_s_enter() "{{{
    if getline('.') =~ s:p.table
        call cursor(riv#table#nextline())
    else
        call riv#list#new(1)
    endif
endfun "}}}
fun! riv#action#ins_m_enter() "{{{
    if getline('.') =~ s:p.table
        call riv#table#newline('head')
    else
        call riv#list#new(-1)
    endif
endfun "}}}

fun! riv#action#ins_backspace() "{{{
    let [row,col] = getpos('.')[1:2]
    let line = getline('.')
    if s:is_row_bgns_blank(col, line)
        let cmd = riv#insert#shiftleft_bs(row,col)
    else
        let cmd = ""
    endif
    return  !empty(cmd) ? cmd : "\<BS>"
endfun "}}}
fun! riv#action#ins_backspace2() "{{{
    " Test Test
    " The
    let [row,col] = getpos('.')[1:2]
    let line = getline('.')
    if s:is_row_bgns_blank(col, line)
        let cmd = riv#insert#shiftleft(row,col)
    else
        let cmd = ""
    endif
    let cmd =  !empty(cmd) ? cmd : "\<BS>"
    exe "norm! i".cmd
endfun "}}}


fun! s:is_in_list_item(col,line) "{{{
    " it's the col before last space in list-item
    return a:col <= matchend(a:line, s:p.all_list)
endfun "}}}
fun! s:is_row_bgns_blank(col,line) "{{{
    " it's the col include last space in a line
    return a:col <= matchend(a:line, '^\s*') + 1
endfun "}}}
fun! s:is_in_table(line) "{{{
    return a:line =~ s:p.table
endfun "}}}
fun! riv#action#nor_tab() "{{{
    call cursor(riv#table#nextcell())
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
    elseif s:is_row_bgns_blank(col, line)
        let cmd = riv#insert#shiftright(row,col)
    else
        let cmd = ''
    endif

    " We will execute user cmd only when there were no cmd context.
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
    elseif s:is_row_bgns_blank(col, line)
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
" vim:fdm=marker:
