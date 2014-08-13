"=============================================
"    Name: restin/insert.vim
"    File: restin/insert.vim
"  Author: Rykka G.Forest
"  Update: 2014-08-14
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:p = g:_riv_p
let s:list_or_nonspace = s:p.all_list.'|^\S'

let s:f_cols = []
let s:f_row = 0
let s:f_buf = 0


" NOTE:
" Rewrite indent behavior as #71 mentioned.
" https://github.com/Rykka/riv.vim/issues/71
"
" indent and shift right/left functions are used.
"
fun! riv#insert#indent(row) "{{{
    " @param 
    " row: the input row
    " @return
    " idt: the indent
    
    let row = a:row == '.' ? line('.') :
            \ a:row == '$' ? line('$') : a:row

    let pnb_num = prevnonblank(row - 1)

    " If above lines don't having content , return 0
    if pnb_num == 0 | return 0 | endif

    let prev_line = getline(row - 1)
    let pnb_line = getline(pnb_num)
    
    " The prev non blank line's indent
    let ind = indent(pnb_num)
    
    " List-indent match the content's begin.
    let l_ind = matchend(pnb_line, s:p.all_list)
    if l_ind != -1 
        return l_ind
    endif
    
    " Literal-block match the start + &sw
    let l_ind = matchend(pnb_line, s:p.literal_block)
    if l_ind != -1 
        return ind+&sw
    endif

    " Exp markup match the start of content.
    let l_ind = matchend(pnb_line, s:p.exp_mark)
    if l_ind != -1
        return l_ind
    endif
    
    return ind
endfun "}}}


fun! riv#insert#fixed_col(row,col,sft) "{{{

    " s:f_cols: store fixed columns of current line
    "
    " return with fix indentation with row col and direction
    " context is the item with smaller indentation (parent)
    " find all possible context of current row
    
    " using the stored fixing info
    if s:f_row == a:row && s:f_buf == bufnr('%')
        return riv#ptn#fix_sfts(a:col, s:f_cols, a:sft)
    endif

    let pnb_row = prevnonblank(a:row - 1)
    if pnb_row == 0 | return a:col + a:sft | endif

    let f_idts = [indent(pnb_row)+1]


    let blk_row = riv#ptn#get(g:_riv_p.literal_block, a:row)
    if blk_row
        let f_idts += [indent(blk_row)+1+&sw]
    endif

    let lst_row = riv#list#get_all_list(a:row)

    if lst_row 
        let lst_idt = indent(lst_row)+1
        let lst_cdt = riv#list#get_con_idt(getline(lst_row))
        let f_idts += [lst_idt,lst_cdt]
        let par_row = riv#list#get_parent(lst_row)
        if par_row
            let par_idt = indent(par_row)+1
            let par_cdt = riv#list#get_con_idt(getline(par_row))
            let f_idts += [par_idt, par_cdt]
        endif
    else
        let exp_row = riv#ptn#get(g:_riv_p.exp_mark, a:row)
        let exp_cdt = riv#ptn#exp_con_idt(getline(exp_row))


        let f_idts += [exp_cdt]
    endif


    let s:f_cols = f_idts
    let s:f_row = a:row
    let s:f_buf = bufnr('%')

    return riv#ptn#fix_sfts(a:col, f_idts, a:sft)
    
endfun "}}}


fun! riv#insert#fixed_sft(row,col,sft) "{{{
    return riv#insert#fixed_col(a:row, a:col, a:sft) - a:col
endfun "}}}
fun! riv#insert#get_fidt() "{{{
    return riv#insert#fixed_col(line('.'),col('.'), &sw)
endfun "}}}

fun! riv#insert#shiftleft(row,col) "{{{
    " shift in insert mode.
    " should in blank line.
    let sft = -&sw
    let fix_sft = riv#insert#fixed_sft(a:row,a:col,sft)
    return repeat("\<Left>\<Del>", abs(fix_sft))
endfun "}}}

fun! riv#insert#shiftleft_bs(row,col) "{{{
    " shift in insert mode.
    " should in blank line.
    let sft = -&sw
    let fix_sft = riv#insert#fixed_sft(a:row,a:col,sft)
    if fix_sft != sft && fix_sft!=0
        " NOTE:
        " As `<BS>` will delete all in list context.
        " change it to `<Del>` and:
        " set ww+=[,]
        " set bs=indent,eol,start
        "
        " return repeat("\<BS>", abs(fix_sft))
        return repeat("\<Left>\<Del>", abs(fix_sft))
    else
        return ""
    endif
endfun "}}}
                                            
                                            
fun! riv#insert#shiftright(row,col) "{{{
    let sft = &sw
    let fix_sft = riv#insert#fixed_sft(a:row,a:col,sft)
    return repeat("\<Space>", abs(fix_sft))
endfun "}}}

if expand('<sfile>:p') == expand('%:p') "{{{
    call doctest#start()
endif "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
