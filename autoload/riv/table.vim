"=============================================
"    Name: table.vim
"    File: table.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-05
" Version: 0.5
"=============================================
fun! riv#table#format() "{{{
    exe g:_RIV_c.py ."GetTable().format_table()"
endfun "}}}
fun! riv#table#newline() "{{{
    exe g:_RIV_c.py ."GetTable().add_line()"
endfun "}}}

fun! riv#table#format_pos() "{{{
    let pos = getpos('.')
    if getline('.') =~ g:_RIV_p.tbl
        call riv#table#format()
        call setpos('.',pos)
        if foldclosed(pos[1])
            foldopen!
        endif
    endif
endfun "}}}

fun! riv#table#nextcell() "{{{
    if getline('.') =~ g:_RIV_p.tbl
        return searchpos(g:_RIV_p.cel,'Wn')   
    endif
    return [0,0]
endfun "}}}
fun! riv#table#prevcell() "{{{
    if getline('.') =~ g:_RIV_p.tbl
        return searchpos(g:_RIV_p.cel,'Wbn')   
    endif
    return [0,0]
endfun "}}}
