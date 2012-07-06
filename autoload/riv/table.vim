"=============================================
"    Name: table.vim
"    File: table.vim
"  Author: Rykka G.Forest
"  Update: 2012-07-07
"=============================================
fun! riv#table#format() "{{{
    exe g:_riv_c.py ."GetTable().format_table()"
endfun "}}}
fun! riv#table#newline() "{{{
    exe g:_riv_c.py ."GetTable().add_line()"
endfun "}}}

fun! riv#table#format_pos() "{{{
    let pos = getpos('.')
    if getline('.') =~ g:_riv_p.table
        call riv#table#format()
        call setpos('.',pos)
        " It may get folded after formating.
        if foldclosed(pos[1])!=-1
            foldopen!
        endif
    endif
endfun "}}}

fun! riv#table#nextcell() "{{{
    if getline('.') =~ g:_riv_p.table
        return searchpos(g:_riv_p.cell,'Wn')   
    endif
    return [0,0]
endfun "}}}
fun! riv#table#prevcell() "{{{
    if getline('.') =~ g:_riv_p.table
        return searchpos(g:_riv_p.cell,'Wbn')   
    endif
    return [0,0]
endfun "}}}
