"=============================================
"    Name: table.vim
"    File: table.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-05
" Version: 0.5
"=============================================
fun! riv#table#format() "{{{
    if getline('.') =~ g:RESTIN_Conf.tbl_ptn
        exe g:RESTIN_Conf['py']."GetTable().format_table()"
        return 1
    endif
    return 0
endfun "}}}
fun! riv#table#format_pos() "{{{
    let pos = getpos('.')
    if riv#table#format()
        call setpos('.',pos)
        if foldclosed(pos[1])
            foldopen!
        endif
    endif
endfun "}}}
fun! riv#table#newline() "{{{
    if getline('.') =~ g:RESTIN_Conf.tbl_ptn
        exe g:RESTIN_Conf['py']."GetTable().add_line()"
    endif
endfun "}}}
fun! riv#table#enter_or_newline() "{{{
    let [row,col] = getpos('.')[1:2]
    if getline('.') =~ g:RESTIN_Conf.con_ptn
        let cmd  = "\<C-O>:call riv#table#newline()|"
        let cmd .= "call cursor(".(row+1).",".col.")|"
        let cmd .= "call search(g:RESTIN_Conf.cel0_ptn,'Wbc')\<CR>"
    else
        let cmd = "\<Enter>"
    endif
    return cmd
endfun "}}}

fun! riv#table#nextcell() "{{{
    if getline('.') =~ g:RESTIN_Conf.tbl_ptn
        return searchpos(g:RESTIN_Conf.cel_ptn,'Wn')   
    endif
    return [0,0]
endfun "}}}
fun! riv#table#prevcell() "{{{
    if getline('.') =~ g:RESTIN_Conf.tbl_ptn
        return searchpos(g:RESTIN_Conf.cel_ptn,'Wbn')   
    endif
    return [0,0]
endfun "}}}
fun! riv#table#tab_or_next() "{{{
    let [row,col] = riv#table#nextcell()
    if row==0
        return "\<Tab>"
    else
        return "\<C-O>:call cursor(".row.",".col.")\<CR>"
    endif
endfun "}}}
fun! riv#table#tab_or_prev() "{{{
    let [row,col] = riv#table#prevcell()
    if row==0
        return "\<BS>"
    else
        return "\<C-O>:call cursor(".row.",".col.")\<CR>"
    endif
endfun "}}}
