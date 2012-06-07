"=============================================
"    Name: action.vim
"    File: action.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-07
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! riv#action#db_click() "{{{
    if !riv#cursor#parse()
        exe "normal! \<2-leftmouse>"
    endif
endfun "}}}

fun! riv#action#ins_bs() "{{{
    let [row,col]  = getpos('.')[1:2]
    let line = getline('.')
    if line[:col-1] =~ '^\s*$'
        let norm_tab = repeat(' ',&sw)
        let norm_col  = substitute(line[:col-1],'\t', norm_tab ,'g')
        let norm_col_len  = len(norm_col)
        " we should get two indent here for list item.
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
    if getline('.') =~ g:_RIV_c.ptn.tbl
        let cmd  = "\<C-O>:call riv#table#newline()|"
        let cmd .= "call cursor(".(row+1).",".col.")|"
        let cmd .= "call search(g:_RIV_c.ptn.cel0,'Wbc')\<CR>"
    else
        let cmd = "\<Enter>"
    endif
    return cmd
endfun "}}}
fun! riv#action#ins_tab() "{{{
    let [row,col] = riv#table#nextcell()
    if row==0
        return "\<Tab>"
    else
        return "\<C-O>:call cursor(".row.",".col.")\<CR>"
    endif
endfun "}}}
fun! riv#action#ins_stab() "{{{
    let [row,col] = riv#table#prevcell()
    if row==0
        return "\<BS>"
    else
        return "\<C-O>:call cursor(".row.",".col.")\<CR>"
    endif
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
