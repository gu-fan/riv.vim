"=============================================
"    Name: table.vim
"    File: table.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-05
" Version: 0.5
"=============================================

fun! restin#table#format() "{{{
    if getline('.') =~ g:restin#tbl_ptn
        exe g:restin#py."GetTable().format_table()"
        return 1
    endif
    return 0
endfun "}}}
fun! restin#table#format_pos() "{{{
    let pos = getpos('.')
    if restin#table#format()
        call setpos('.',pos)
        if foldclosed(pos[1])
            foldopen!
        endif
    endif
endfun "}}}
fun! restin#table#newline(row) "{{{
    if getline('.') =~ g:restin#tbl_ptn
        exe g:restin#py."Add_Row(vim.eval('a:row'))"
    endif
endfun "}}}

fun! restin#table#nextcell() "{{{
    if getline('.') =~ g:restin#tbl_ptn
        return searchpos('\v%(^|\s)\|\s\zs|^\s*$','Wn')   
    endif
    return [0,0]
endfun "}}}
fun! restin#table#prevcell() "{{{
    if getline('.') =~ g:restin#tbl_ptn
        return searchpos('\v%(^|\s)\|\s\zs|^\s*$','Wbn')   
    endif
    return [0,0]
endfun "}}}
fun! restin#table#enter_or_newline() "{{{
    let [row,col] = getpos('.')[1:2]
    if getline('.') =~ g:restin#con_ptn
        let cmd  = "\<C-O>:call restin#table#newline(1)\<CR>"
        let cmd .= "\<C-O>:call cursor(".(row+1).",".col.")\<CR>"
    elseif getline('.') =~ g:restin#sep_ptn
        let cmd  = "\<C-O>:call restin#table#newline(2)\<CR>"
        let cmd .= "\<C-O>:call cursor(".(row+1).",".col.")\<CR>"
    else
        let cmd = "\<Enter>"
    endif
    return cmd
endfun "}}}
fun! restin#table#tab_or_next() "{{{
    let [row,col] = restin#table#nextcell()
    if row==0
        return "\<Tab>"
    else
        return "\<C-O>:call cursor(".row.",".col.")\<CR>"
    endif
endfun "}}}
fun! restin#table#tab_or_prev() "{{{
    let [row,col] = restin#table#prevcell()
    if row==0
        return "\<BS>"
    else
        return "\<C-O>:call cursor(".row.",".col.")\<CR>"
    endif
endfun "}}}
