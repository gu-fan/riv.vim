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

fun! riv#action#db_click() "{{{
    " could not use map <expr>
    " cause it's editing file here.
    let row = line('.')
    if foldclosed(row) != -1
        exe "normal! zv"
    elseif !riv#link#open()
        " Open fold with clicking on section title.
        if has_key(b:fdl_dict, row)
            if b:fdl_dict[row].type =='sect'
                exe "normal! zc"
                return
            endif
        endif
        let line = getline(row)
        let col = col('.')
        if line=~ g:_riv_p.todo_all && col < matchend(line, g:_riv_p.todo_all)
                    \ && col > matchend(line, g:_riv_p.list_all)
            call riv#list#toggle_todo()
        else
            exe "normal! \<2-LeftMouse>"
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
    if getline('.') =~ g:_riv_p.table
        let cmd  = "\<C-O>:call riv#table#newline()|"
        let cmd .= "call cursor(".(row+1).",".col.")|"
        let cmd .= "call search(g:_riv_p.cell0,'Wbc')\<CR>"
        return cmd
    else
        return  "\<Enter>"
    endif
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
        return "\<BS>"
    else
        return "\<C-O>:call cursor(riv#table#prevcell())\<CR>"
    endif
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
