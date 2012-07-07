"=============================================
"    Name: action.vim
"    File: action.vim
" Summary: simulate and fix some misc actions
"  Author: Rykka G.Forest
"  Update: 2012-07-07
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
fun! riv#action#ins_bs() "{{{
    let [row,col]  = getpos('.')[1:2]
    let line = getline('.')

    " if it's empty before cursor.
    if line[:col-1] =~ '^\s*$'
        let norm_tab = repeat(' ',&sw)
        let norm_col  = substitute(line[:col-1],'\t', norm_tab ,'g')
        let norm_col_len  = len(norm_col)
        let ind = riv#insert#fix_indent(row)
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
        let cmd = "\<CR>"
    else
        let cmd = ''
    endif
    let cmd .= "\<C-O>:call riv#list#new(0)\<CR>\<Esc>A"
    return cmd
endfun "}}}
fun! riv#action#ins_s_enter() "{{{
    let line = getline('.')
    if line=~ '\S'
        let cmd = "\<CR>\<CR>"
    else
        let cmd = ''
    endif
    let cmd .= "\<C-O>:call riv#list#new(1)\<CR>\<Esc>A"
    return cmd
endfun "}}}
fun! riv#action#ins_m_enter() "{{{
    let line = getline('.')
    if line=~ '\S'
        let cmd = "\<CR>\<CR>"
    else
        let cmd = ''
    endif
    let cmd .= "\<C-O>:call riv#list#new(-1)\<CR>\<Esc>A"
    return cmd
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
                return "\<Tab>"
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
                return "\<S-Tab>"
            endif
        endif
    else
        return "\<C-O>:call cursor(riv#table#prevcell())\<CR>"
    endif
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
