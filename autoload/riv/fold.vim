"=============================================
"    Name: fold.vim
"    File: fold.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-07
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

" A python version
fun! riv#fold#py_expr()
    exe g:_RIV_c.py "GetFoldLevel"
endfun
" Get the type of current line
fun! riv#fold#expr() "{{{
    
    let c_line = getline(v:lnum)
    let n_line = getline(v:lnum+1)

    if v:lnum == 1 
        let b:dyn_sec_list = []
        let [b:fdl_before_list, b:fdl_before_exp,  
            \b:foldlevel,       b:is_in_list,       b:is_in_exp , 
            \b:is_in_spl_tbl,   b:fdl_before_tbl] = [0,0,0,0,0,0,0]
    endif
    
    " List : depends on indent "{{{
    " Can contain exp_markup , can not be exp_m contained.
    if c_line =~ g:_RIV_p.list && b:is_in_exp==0
        let nnb_num = nextnonblank(v:lnum+1)
        c_idt = indent(v:lnum)
        if c_idt < indent(nnb_num)
            " some are 2, some are 3..
            " don't update fdl_before if in a fdl list.
            if b:is_in_list==0
                let b:fdl_before_list =  b:foldlevel
                let b:is_in_list = 1
            endif
            let b:foldlevel = c_idt/2 + 8
            return '>'.b:foldlevel
        endif
    endif
    "}}}
    
    if (c_line=~g:_RIV_p.S_bgn) "{{{
        " Ignored '..'
        if c_line == ".." && n_line =~ g:_RIV_p.blank
            return b:foldlevel
        endif

        " ExplicitMarkup "{{{
        if c_line =~ g:_RIV_p.exp_m && n_line =~ g:_RIV_p.s_bgn
                    \ && getline(v:lnum+2) =~ g:_RIV_p.s_bgn
            " NOTE: for continuous exp_markup line  
            "       can not get the last fdl before first one.
            "       it depends on whether the first exp_markup have
            "       an blank endline or not.
            "       so we will not change it if it's the same
            if b:foldlevel!= 15
                let b:fdl_before_exp = b:foldlevel 
            endif
            let b:foldlevel = 15
            let b:is_in_exp = 1
            return ">15"
        endif "}}}
        " Sections "{{{
        " we could not use multiline match here
        " And we need the matchstr to calculate level.
        let c_match = matchstr(c_line, g:_RIV_p.section)
        let n_match = matchstr(n_line, g:_RIV_p.section)
        if !empty(c_match) && empty(n_match) && getline(v:lnum+2) == c_line
            " first line of 3
            " idx folding start from 1
            let idx = index(b:dyn_sec_list, c_match[1])+1
            if idx == 0
                call add(b:dyn_sec_list,c_match[1])
                let idx = len(b:dyn_sec_list)
            endif
            let b:foldlevel = idx
            let [b:is_in_list, b:is_in_exp] = [ 0, 0]
            return ">".idx
        elseif !empty(n_match) && c_line !~ g:_RIV_p.blank
            \ && len(c_line) <= len(n_line)
            let p_line = getline(v:lnum-1)
            if p_line =~ g:_RIV_p.blank
                let idx = index(b:dyn_sec_list,n_match[1])+1
                if idx == 0
                    call add(b:dyn_sec_list,n_match[1])
                    let idx = len(b:dyn_sec_list)
                endif
                let b:foldlevel = idx
                let [b:is_in_list, b:is_in_exp] = [ 0, 0]
                return ">".idx
            elseif p_line == n_line
            "  if prev line is same as next line. 
            "  then we get a 3-row title. 
            "  should return idx here
                let idx = index(b:dyn_sec_list,n_match[1])+1
                if idx == 0
                    call add(b:dyn_sec_list,n_match[1])
                    let idx = len(b:dyn_sec_list)
                endif
                let b:foldlevel = idx
                let [b:is_in_list, b:is_in_exp,b:is_in_spl_tbl] = [ 0, 0, 0]
                return idx
            endif
        endif "}}}
    endif "}}}
    
    let nnb_num = nextnonblank(v:lnum+1)
    let nnb_line= getline(nnb_num)
    let p_line = getline(v:lnum-1)
    " list and exp blank line
    " leave all but one blank line 
    if (c_line =~ g:_RIV_p.blank && p_line =~ g:_RIV_p.blank && nnb_line=~g:_RIV_p.S_bgn ) || (c_line=~g:_RIV_p.S_bgn)
    " leave all blank line 
    " if (c_line =~ g:_RIV_p.blank && nnb_line=~g:_RIV_p.S_bgn ) || (c_line=~g:_RIV_p.S_bgn)
    " leave one blank line
    " if (c_line =~ g:_RIV_p.blank && n_line=~g:_RIV_p.S_bgn ) || (c_line=~g:_RIV_p.S_bgn)
    " no blank line
    " if (c_line=~g:_RIV_p.S_bgn) "{{{

        " close exp"{{{
        if b:is_in_exp==1
            let b:foldlevel = b:fdl_before_exp
            let b:is_in_exp = 0
            return b:foldlevel
        endif "}}}
        " close list {{{
        if b:is_in_list==1  && nnb_line!~g:_RIV_p.exp_m
        " clean when nnb is not exp_m to contain exp in list.
            let b:foldlevel = b:fdl_before_list
            let [b:is_in_list, b:is_in_exp] = [ 0, 0]
            return b:foldlevel
        endif "}}}
        " close section
        " if next non blank line is section, then 
        " set to '<'.cur_sec level
    endif "}}}
    
    " fold the table "{{{
    if c_line=~g:_RIV_p.tbl
        return 10
    endif "}}}

    " fold simple table  "{{{
    " for simple table . we should find the last line of the three or two
    " the end line must with a blank line
    " Not contained by exp_m
    " if c_line=~g:_RIV_p.spl_tbl && p_line=~g:_RIV_p.blank && b:is_in_spl_tbl==0 && b:is_in_exp==0
    "     let b:is_in_spl_tbl = 1
    "     let b:fdl_before_tbl = b:foldlevel
    "     let b:foldlevel = 16
    "     return 16
    " endif
    " if c_line=~g:_RIV_p.spl_tbl && n_line=~g:_RIV_p.blank && b:is_in_spl_tbl==1
    "     let b:is_in_spl_tbl = 0
    "     let b:foldlevel = b:fdl_before_tbl
    "     return 16
    " endif
    "}}}
    
    " NOTE: fold-expr will eval last line first , then eval from start.
    " NOTE: it is too slow to use "="
    " XXX:  could not using foldlevel cause it returns -1
    return b:foldlevel
    
endfun "}}}
fun! riv#fold#expr_t(row) "{{{
    
    let c_line = getline(a:row)
    let n_line = getline(a:row+1)

    if a:row == 1 
        let b:dyn_sec_list = []
        let [b:fdl_before_list, b:fdl_before_exp,  
            \b:foldlevel,       b:is_in_list,       b:is_in_exp , 
            \b:is_in_spl_tbl,   b:fdl_before_tbl] = [0,0,0,0,0,0,0]
    endif
    
    " List : depends on indent "{{{
    " Can contain exp_markup , can not be exp_m contained.
    if c_line =~ g:_RIV_p.list && b:is_in_exp==0
        let nnb_num = nextnonblank(a:row+1)
        if indent(a:row) < indent(nnb_num)
            " some are 2, some are 3..
            " don't update fdl_before if in a fdl list.
            if b:is_in_list==0
                let b:fdl_before_list =  b:foldlevel
                let b:is_in_list = 1
            endif
            let b:foldlevel = indent(a:row)/2 + 8
            return '>'.b:foldlevel
        endif
    endif
    "}}}
    if (c_line=~g:_RIV_p.S_bgn) "{{{
        if c_line == ".." && n_line =~ g:_RIV_p.blank
            return b:foldlevel
        endif
        " ExplicitMarkup "{{{
        if c_line =~ g:_RIV_p.exp_m && n_line =~ g:_RIV_p.s_bgn
                    \ && getline(a:row+2) =~ g:_RIV_p.s_bgn
            " NOTE: for continuous exp_markup line  
            "       can not get the last fdl before first one.
            "       it depends on whether the first exp_markup have
            "       an blank endline or not.
            "       so we will not change it if it's the same
            if b:foldlevel!= 15
                let b:fdl_before_exp = b:foldlevel 
            endif
            let b:foldlevel = 15
            let b:is_in_exp = 1
            return ">15"
        endif "}}}

        " Sections "{{{
        " we could not use multiline match here
        " And we need the matchstr to calculate level.
        let c_match = matchstr(c_line, g:_RIV_p.section)
        let n_match = matchstr(n_line, g:_RIV_p.section)
        if !empty(c_match) && empty(n_match) && getline(a:row+2) == c_line
            " first line of 3
            " idx folding start from 1
            let idx = index(b:dyn_sec_list, c_match[1])+1
            if idx == 0
                call add(b:dyn_sec_list,c_match[1])
                let idx = len(b:dyn_sec_list)
            endif
            let b:foldlevel = idx
            let [b:is_in_list, b:is_in_exp] = [ 0, 0]
            return ">".idx
        elseif !empty(n_match) && c_line !~ g:_RIV_p.blank 
            \ && len(c_line) <= len(n_line)
            let p_line = getline(a:row-1)
            if p_line =~ g:_RIV_p.blank
                let idx = index(b:dyn_sec_list,n_match[1])+1
                if idx == 0
                    call add(b:dyn_sec_list,n_match[1])
                    let idx = len(b:dyn_sec_list)
                endif
                let b:foldlevel = idx
                let [b:is_in_list, b:is_in_exp] = [ 0, 0]
                return ">".idx
            elseif p_line == n_line
            "  if prev line is same as next line. 
            "  then we get a 3-row title. 
            "  should return idx here
                let idx = index(b:dyn_sec_list,n_match[1])+1
                if idx == 0
                    call add(b:dyn_sec_list,n_match[1])
                    let idx = len(b:dyn_sec_list)
                endif
                let b:foldlevel = idx
                let [b:is_in_list, b:is_in_exp,b:is_in_spl_tbl] = [ 0, 0, 0]
                return idx
            endif
        endif "}}}
    endif "}}}
    
    let nnb_num = nextnonblank(a:row+1)
    let nnb_line= getline(nnb_num)
    let p_line = getline(a:row-1)
    " list and exp blank line
    " leave all but one blank line 
    if (c_line =~ g:_RIV_p.blank && p_line =~ g:_RIV_p.blank && nnb_line=~g:_RIV_p.S_bgn ) || (c_line=~g:_RIV_p.S_bgn)
    " leave all blank line 
    " if (c_line =~ g:_RIV_p.blank && nnb_line=~g:_RIV_p.S_bgn ) || (c_line=~g:_RIV_p.S_bgn)
    " leave one blank line
    " if (c_line =~ g:_RIV_p.blank && n_line=~g:_RIV_p.S_bgn ) || (c_line=~g:_RIV_p.S_bgn)
    " no blank line
    " if (c_line=~g:_RIV_p.S_bgn) "{{{

        " close exp"{{{
        if b:is_in_exp==1
            let b:foldlevel = b:fdl_before_exp
            let b:is_in_exp = 0
            return b:foldlevel
        endif "}}}
        " close list {{{
        if b:is_in_list==1  && nnb_line!~g:_RIV_p.exp_m
        " clean when nnb is not exp_m to contain exp in list.
            let b:foldlevel = b:fdl_before_list
            let [b:is_in_list, b:is_in_exp] = [ 0, 0]
            return b:foldlevel
        endif "}}}
        " close section
        " if next non blank line is section, then 
        " set to '<'.cur_sec level
    endif "}}}
    
    " fold the table "{{{
    if c_line=~g:_RIV_p.tbl
        return 10
    endif "}}}

    " fold simple table  "{{{
    " for simple table . we should find the last line of the three or two
    " the end line must with a blank line
    " Not contained by exp_m
    " if c_line=~g:_RIV_p.spl_tbl && p_line=~g:_RIV_p.blank && b:is_in_spl_tbl==0 && b:is_in_exp==0
    "     let b:is_in_spl_tbl = 1
    "     let b:fdl_before_tbl = b:foldlevel
    "     let b:foldlevel = 16
    "     return 16
    " endif
    " if c_line=~g:_RIV_p.spl_tbl && n_line=~g:_RIV_p.blank && b:is_in_spl_tbl==1
    "     let b:is_in_spl_tbl = 0
    "     let b:foldlevel = b:fdl_before_tbl
    "     return 16
    " endif
    "}}}
    
    " NOTE: fold-expr will eval last line first , then eval from start.
    " NOTE: it is too slow to use "="
    " XXX:  could not using foldlevel cause it returns -1
    return b:foldlevel
    
endfun "}}}
fun! riv#fold#text() "{{{
    " NOTE: if it's three row title. show the content of next line.
    let line = getline(v:foldstart)

    let cate = " "
    if line =~ g:_RIV_p.section 
        let line = getline(v:foldstart+1)
        let cate = "T"
    elseif getline(v:foldstart+1) =~ g:_RIV_p.section 
        let cate = "S"
    endif
    if line=~g:_RIV_p.tbl
        if exists("b:rst_table[v:foldstart]")
            let line = b:rst_table[v:foldstart]
        else
            let line = getline(v:foldstart+1)
        endif
        let cate = "T"
    endif
    if line=~g:_RIV_p.spl_tbl
        let cate = "t"
    endif
    let m_line = winwidth(0)-11
    if len(line) <= m_line
        let line = line."  ".repeat('-',m_line) 
    endif
    let line = printf("%-".m_line.".".(m_line)."s",line)
    if v:foldlevel <= 3
        let dash = printf("%4s",repeat("<",v:foldlevel))
    else
        let dash = printf("%4s","<<+")
    endif
    let num = printf("%5s",(v:foldend-v:foldstart))
    return line."[".cate.num.dash."]"
endfun "}}}
fun! riv#fold#parse() "{{{
    exe g:_RIV_c.py "t = RivBuf().parse()[1]"
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
