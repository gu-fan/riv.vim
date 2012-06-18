"=============================================
"    Name: action.vim
"    File: action.vim
" Summary: simulate and fix some misc actions
"  Author: Rykka G.Forest
"  Update: 2012-06-08
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! riv#action#db_click(mouse) "{{{
    " could not use map <expr>
    " cause it's editing file here.
    let row = line('.')
    if foldclosed(row) != -1
        exe "normal! zv"
    elseif !riv#link#open()
        " Open fold with clicking on section title.
        if s:is_in_sect_title(row)
            exe "normal! zc"
            return
        endif
        let line = getline(row)
        let col = col('.')
        if s:is_in_todo_item(line,col)
            call riv#list#toggle_todo()
        elseif s:is_in_todo_time(line,col)
            call riv#list#change_date()
        else
            if a:mouse== 1
                exe "normal! \<2-LeftMouse>"
            else
                exe "normal! \<Enter>"
            endif

        endif
    endif
endfun "}}}


fun! s:is_in_sect_title(row) "{{{
   return exists("b:riv_obj") && has_key(b:riv_obj, a:row)
               \ && b:riv_obj[a:row].type =='sect'
endfun "}}}
fun! s:is_in_todo_item(line,col) "{{{
   return  a:col < matchend(a:line, g:_riv_p.todo_all)
            \ && a:col > matchend(a:line, g:_riv_p.list_all)
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
fun! riv#action#ins_bs() "{{{
    let [row,col]  = getpos('.')[1:2]
    let line = getline('.')
    if line[:col-1] =~ '^\s*$'
        let norm_tab = repeat(' ',&sw)
        let norm_col  = substitute(line[:col-1],'\t', norm_tab ,'g')
        let norm_col_len  = len(norm_col)
        let ind = riv#insert#indent(row)
        call cursor(row,col)
        if ind < norm_col_len && (ind + &sw) > norm_col_len
            return repeat("\<Left>\<Del>", (norm_col_len - ind))
        endif
    endif
    return "\<BS>"
endfun "}}}
fun! riv#action#ins_enter() "{{{
    let [row,col] = getpos('.')[1:2]
    if getline('.') =~ g:_riv_p.table
        let cmd  = "\<C-O>:call riv#table#newline()|"
        let cmd .= "call cursor(".(row+1).",".col.")|"
        let cmd .= "call search(g:_riv_p.cell0,'Wbc')\<CR>"
        return cmd
    else
        return  "\<Enter>"
    endif
endfun "}}}
fun! riv#action#ins_c_enter() "{{{
    let line = getline('.')
    if line=~ '\S'
        let cmd = "\<Esc>o"
    else
        let cmd = ''
    endif
    let cmd .= "\<C-O>:call riv#list#act(0)\<CR>\<Esc>A"
    return cmd
endfun "}}}
fun! riv#action#ins_s_enter() "{{{
    let line = getline('.')
    if line=~ '\S'
        let cmd = "\<Esc>o\<CR>"
    else
        let cmd = ''
    endif
    let cmd .= "\<C-O>:call riv#list#act(1)\<CR>\<Esc>A"
    return cmd
endfun "}}}
fun! riv#action#ins_m_enter() "{{{
    let line = getline('.')
    if line=~ '\S'
        let cmd = "\<Esc>o\<CR>"
    else
        let cmd = ''
    endif
    let cmd .= "\<C-O>:call riv#list#act(-1)\<CR>\<Esc>A"
    return cmd
endfun "}}}
fun! riv#action#ins_tab() "{{{
    if riv#table#nextcell()[0] == 0
        return "\<Tab>"
    else
        " NOTE: Find the cell after table get formated.
        return "\<C-O>:call cursor(riv#table#nextcell())\<CR>"
    endif
endfun "}}}
fun! riv#action#ins_stab() "{{{
    if riv#table#prevcell()[0] == 0
        return "\<S-Tab>"
    else
        return "\<C-O>:call cursor(riv#table#prevcell())\<CR>"
    endif
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
