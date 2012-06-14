"=============================================
"    Name: restin/insert.vim
"    File: restin/insert.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-05
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C


" TODO:  multi idt level
" for multi line list.
"  with every <BS>
"  first get the prev indent. (fixed)
"  then get the prev before indent (fixed)
"  then get the prev before prev indent (fixed)
fun! riv#insert#indent(row) "{{{
    " return GetRSTIndent(a:row)
    " have some fix for insert with GetRSTIndent.
    let pnb_num = prevnonblank(a:row - 1)
    if pnb_num == 0
        return 0
    endif

    let p_line = getline(a:row - 1)

    " Field List
    " 1:ind
    let p_ind =  matchend(p_line, g:_riv_p.field_list)
    if p_ind != -1
        return p_ind
    endif

    let pnb_line = getline(pnb_num)
    let ind = indent(pnb_num)
    
    " list
    " <=3: ind: we want a stop at the list begin here
    let l_ind = matchend(pnb_line, g:_riv_p.list_all)
    if l_ind != -1
        return ind
    endif
    
    " literal-block
    " 1/2+:ind  
    " 2:4
    let l_ind = matchend(pnb_line, g:_riv_p.literal_block)
    if l_ind != -1 &&  a:row == pnb_num+2
        return 4
    endif

    " exp_markup
    " 1~2: ind
    let l_ind = matchend(pnb_line, g:_riv_p.s_exp)
    if l_ind != -1 &&  a:row <= pnb_num+2
        return (ind + l_ind - matchend(pnb_line, g:_riv_p.indent))
    endif
    
    " without match
    " 1+: search list/exp_mark or  \S starting line to stop.
    if a:row >= pnb_num+1
        call cursor(pnb_num,1)
        let p_num = searchpos(g:_riv_p.indent_stoper, 'bW')[0]
        let p_line = getline(p_num)
        let l_ind  = matchend(p_line,'^\s*\.\.\s')
        if l_ind != -1
            return l_ind
        endif
        let l_ind = matchend(p_line, g:_riv_p.list_all)
        if l_ind != -1
            return indent(p_num)
        endif
    endif
    
    return ind
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
