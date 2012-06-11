"=============================================
"    Name: fold.vim
"    File: fold.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-12
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:p = g:_RIV_p

" A python version
fun! riv#fold#py_expr() "{{{
    exe g:_RIV_c.py "GetFoldLevel"
endfun "}}}
" Get the type of current line
fun! riv#fold#expr2() "{{{
    
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
    if c_line =~ s:p.list && b:is_in_exp==0
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
    
    if (c_line=~s:p.S_bgn) "{{{
        " Ignored '..'
        if c_line == ".." && n_line =~ '^\s*$'
            return b:foldlevel
        endif

        " ExplicitMarkup "{{{
        if c_line =~ s:p.exp_m && n_line =~ s:p.s_bgn
                    \ && getline(v:lnum+2) =~ s:p.s_bgn
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
        let c_match = matchstr(c_line, s:p.section)
        let n_match = matchstr(n_line, s:p.section)
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
        elseif !empty(n_match) && c_line !~ '^\s*$'
            \ && len(c_line) <= len(n_line)
            let p_line = getline(v:lnum-1)
            if p_line =~ '^\s*$'
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
    if (c_line =~ '^\s*$' && p_line =~ '^\s*$' && nnb_line=~s:p.S_bgn ) || (c_line=~s:p.S_bgn)
    " leave all blank line 
    " if (c_line =~ '^\s*$' && nnb_line=~s:p.S_bgn ) || (c_line=~s:p.S_bgn)
    " leave one blank line
    " if (c_line =~ '^\s*$' && n_line=~s:p.S_bgn ) || (c_line=~s:p.S_bgn)
    " no blank line
    " if (c_line=~s:p.S_bgn) "{{{

        " close exp"{{{
        if b:is_in_exp==1
            let b:foldlevel = b:fdl_before_exp
            let b:is_in_exp = 0
            return b:foldlevel
        endif "}}}
        " close list {{{
        if b:is_in_list==1  && nnb_line!~s:p.exp_m
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
    if c_line=~s:p.table
        return 10
    endif "}}}

    " fold simple table  "{{{
    " for simple table . we should find the last line of the three or two
    " the end line must with a blank line
    " Not contained by exp_m
    " if c_line=~s:p.spl_tbl && p_line=~'^\s*$' && b:is_in_spl_tbl==0 && b:is_in_exp==0
    "     let b:is_in_spl_tbl = 1
    "     let b:fdl_before_tbl = b:foldlevel
    "     let b:foldlevel = 16
    "     return 16
    " endif
    " if c_line=~s:p.spl_tbl && n_line=~'^\s*$' && b:is_in_spl_tbl==1
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
fun! riv#fold#parse() "{{{
    exe g:_RIV_c.py "t = RivBuf().parse()[1]"
endfun "}}}
fun! riv#fold#expr3(row) "{{{
    
    let c_line = getline(a:row)
    let n_line = getline(a:row+1)

    if a:row == 1 
        let b:dyn_sec_list = []
        let [b:fdl_before_list, b:fdl_before_exp,  
            \b:foldlevel,       b:is_in_list,     b:is_in_exp , 
            \b:is_in_spl_tbl,   b:fdl_before_tbl, b:is_in_tbl ] = [0,0,0,0,0,0,0,0]
        let b:riv = {}
    endif
    


    " section title line
    if has_key(b:riv,a:row)
        return b:foldlevel
    endif

    " List : depends on indent "{{{
    " Can contain exp_markup , can not be exp_m contained.
    if  b:is_in_exp==0
        let attr = matchstr(c_line, s:p.list) 
        if !empty(attr)
            let b:is_in_tbl=0
            let nnb_num = nextnonblank(a:row+1)
            let c_idt = indent(v:lnum)
            if c_idt < indent(nnb_num)
                " some are 2, some are 3..
                " don't update fdl_before if in a fdl list.
                if b:is_in_list==0
                    let b:fdl_before_list =  b:foldlevel
                    let b:is_in_list = 1
                endif
                let b:foldlevel = c_idt/2 + 8
                let b:riv[a:row] = {'typ': 'list', 'fdl': b:foldlevel,
                            \'attr': attr , 'level':(c_idt/2+1)}
                return '>'.b:foldlevel
            endif
        endif
    endif
    "}}}
    if (c_line=~s:p.S_bgn) "{{{
        " the 
        if c_line == ".." && n_line =~ '^\s*$'
            let b:is_in_tbl=0
            return b:foldlevel
        endif
        

        " ExplicitMarkup "{{{
        if c_line =~ s:p.exp_m && n_line =~ s:p.s_bgn
                    \ && getline(a:row+2) =~ s:p.s_bgn
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
            let b:is_in_tbl=0
            let b:riv[a:row] = {'typ':'exp' , 'fdl': b:foldlevel}
            return ">15"
        endif "}}}

        " Sections "{{{
        " we could not use multiline match here
        " And we need the matchstr to calculate level.
        let c_match = matchstr(c_line, s:p.section)
        let n_match = matchstr(n_line, s:p.section)
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
            let b:is_in_tbl=0
            let t = {'typ':'sect', 'fdl': idx , 'level':idx}
            let b:riv[a:row]   = t
            let b:riv[a:row+1] = t
            let b:riv[a:row+2] = t
            return ">".idx
        elseif !empty(n_match) && empty(c_match) && c_line !~ '^\s*$' 
            \ && len(c_line) <= len(n_line)
            let p_line = getline(a:row-1)
            if p_line =~ '^\s*$'
                let idx = index(b:dyn_sec_list,n_match[1])+1
                if idx == 0
                    call add(b:dyn_sec_list,n_match[1])
                    let idx = len(b:dyn_sec_list)
                endif
                let b:foldlevel = idx
                let [b:is_in_list, b:is_in_exp] = [ 0, 0]
                let b:is_in_tbl=0
                let t = {'typ':'sect', 'fdl': idx , 'level':idx}
                let b:riv[a:row]   = t
                let b:riv[a:row+1] = t
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
                let b:is_in_tbl=0
                return idx
            endif
        endif "}}}
    endif "}}}
    
    let nnb_num = nextnonblank(a:row+1)
    let nnb_line= getline(nnb_num)
    let p_line = getline(a:row-1)
    " list and exp blank line
    " leave all but one blank line 
    if (c_line =~ '^\s*$' && p_line =~ '^\s*$' && nnb_line=~s:p.S_bgn ) || (c_line=~s:p.S_bgn)
    " leave all blank line 
    " if (c_line =~ '^\s*$' && nnb_line=~s:p.S_bgn ) || (c_line=~s:p.S_bgn)
    " leave one blank line
    " if (c_line =~ '^\s*$' && n_line=~s:p.S_bgn ) || (c_line=~s:p.S_bgn)
    " no blank line
    " if (c_line=~s:p.S_bgn) "{{{

        let b:is_in_tbl=0
        " close exp"{{{
        if b:is_in_exp==1
            let b:foldlevel = b:fdl_before_exp
            let b:is_in_exp = 0
            return b:foldlevel
        endif "}}}
        " close list {{{
        if b:is_in_list==1  && nnb_line!~s:p.exp_m
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
    if  c_line=~s:p.table
        if b:is_in_tbl==0
            let b:fdl_before_tbl = b:foldlevel
            let b:foldlevel = 10
            let b:is_in_tbl=1
            let b:riv[a:row] = {'typ': 'table', 'fdl': b:foldlevel }
            return b:foldlevel
        endif
    else
        let b:is_in_tbl=0
    endif "}}}


    " fold simple table  "{{{
    " for simple table . we should find the last line of the three or two
    " the end line must with a blank line
    " Not contained by exp_m
    " if c_line=~s:p.spl_tbl && p_line=~'^\s*$' && b:is_in_spl_tbl==0 && b:is_in_exp==0
    "     let b:is_in_spl_tbl = 1
    "     let b:fdl_before_tbl = b:foldlevel
    "     let b:foldlevel = 16
    "     return 16
    " endif
    " if c_line=~s:p.spl_tbl && n_line=~'^\s*$' && b:is_in_spl_tbl==1
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
    let lnum = v:foldstart
    let line = b:lines[lnum]
    let cate = "    "
    if has_key(b:fdl_dict,lnum)
        if b:fdl_dict[lnum].type == 'sect'
            let cate = " ".b:fdl_dict[lnum].txt
            if b:fdl_dict[lnum].row == 3
                let line = b:lines[lnum+1]
            endif
        elseif b:fdl_dict[lnum].type == 'list'
            if exists("b:fdl_dict[lnum].td_child")
                let td = 100 * b:fdl_dict[lnum].td_child
                let cate = printf(" %3.0f%%",td)
            elseif b:fdl_dict[lnum].td_stat != -1
                let td = 100 * b:fdl_dict[lnum].td_stat
                let cate = printf(" %3.0f%%",td)
            endif
        elseif b:fdl_dict[lnum].type == 'table'
            let cate = " " . b:fdl_dict[lnum].row 
                        \  . 'x' . b:fdl_dict[lnum].col." "
            let line = b:lines[lnum+1]
        elseif b:fdl_dict[lnum].type == 'spl_table'
            let cate = " " . b:fdl_dict[lnum].row . '+' 
                        \  . b:fdl_dict[lnum].col . " "
        elseif b:fdl_dict[lnum].type == 'exp'
            let cate = "."
        elseif b:fdl_dict[lnum].type == 'block'
            let cate = ":"
        elseif b:fdl_dict[lnum].type == 'trans'
            let cate = "-"
            let line = strtrans(line)
        endif
    endif
    let m_line = winwidth(0)-12
    if len(line) <= m_line
        let line = line."  ".repeat('-',m_line) 
    endif
    let line = printf("%-4s| %s", cate, line)
    let line = printf("%-".m_line.".".(m_line)."s", line)
    let num  = printf("%5s+", (v:foldend-lnum))
    return  line."[".num."]"
endfun "}}}

fun! riv#fold#expr(row) "{{{
    if a:row == 1
        call s:init_stat()
    endif
    return b:fdl_list[a:row]
endfun "}}}
fun! s:init_stat() "{{{
    let len = line('$')
    let b:fdl_list = map(range(len+1),'0')
    let b:fdl_dict={}
    let b:state = { 's_chk':[], 'l_chk':[], 'e_chk':[], 'b_chk':[], 't_chk':[],
                \'matcher':[], 'sectmatcher':[], 
                \'s_root': { 'parent':{}  , 'child':[] ,'sec_num':0 } ,
                \'l_root': { 'parent':{}  , 'child':[] ,'lst_num':0 } ,
                \}

    
    " 4%
    let b:lines= map(range(len+1),'getline(v:val)')
    for i in range(len+1)
    " 65%
        call s:check(i)
    endfor
    " sort the unordered list.
    call sort(b:state.matcher,"s:sort_match")
    " 12%
    call s:set()
    call s:get_child_td(b:state.l_root)
endfun "}}}
fun! s:get_child_td(o) "{{{
    let c_td = 0
    let len = 0
    for chd in a:o.child
        if empty(chd.child)
            if chd.td_stat != -1
                let c_td += chd.td_stat
                let len +=1
            endif
        else
            let d = s:get_child_td(chd)
            if d > 0
                let c_td += d
                let len +=1
            endif
        endif
    endfor
    if len !=0
        let c_td = (c_td+0.0)/len
        let a:o['td_child'] = c_td
    else
        let c_td = 0
    endif
    return c_td
endfun "}}}

" section fold level with empty line showing  
" All BUT ONE
"                       0                       
"  sec1                 1           child = subsec1,subsec2
"                       1
"                       1
"  subsec1              2           parent= sec1   brother = parent.child
"                       2
"                       1
"  subsec2              2           parent= sec1 
"                       2
"                       2
"     subsubsec1        3           parent = sec1 subsec2 
"
"                       0
"  sec2                 1
"                       1
"

fun! s:add_child(p,o) "{{{
    call add(a:p.child, a:o )
    let a:o.parent = a:p
endfun "}}}
fun! s:add_brother(b,o) "{{{
    let a:o.parent = a:b.parent
    call add(a:o.parent.child, a:o )
endfun "}}}
fun! s:get_td_stat(lnum) "{{{
    " second submatch is todo item.
    let m_lst = matchlist(b:lines[a:lnum], s:p.list_box)
    if !empty(m_lst)
        let td = m_lst[2]
        let d =  index(g:riv_todo_levels, td)
        if d != -1 && (len(g:riv_todo_levels)-1)!=0
            return (d+0.0)/(len(g:riv_todo_levels)-1)
        else
            return -1
        endif
    endif
    return -1
endfun "}}}
fun! s:set() "{{{
    let stat = b:state
    let mat = stat.matcher

    let sec_punc_list = []      " the punctuation list used by section

    let s_i = 0                 " the sect_matcher index , used to get next
                                " section object.

    let p_s_obj = stat.s_root   " previous section object, init with root
    let sec_lv = 0              " the section level calced by punc_list
    let p_sec_lv = sec_lv       

    let lst_lv = 0              " current list_level
    let p_lst_lv = 0
    let p_l_obj = stat.l_root   " previous list object 
    let p_lst_end = line('$')   " let  root contains all level 1 list object
    for i in range(len(mat))
        let m = mat[i]
        let f = 0
        if m.type == 'sect'
            " Sect Part "{{{
            let level = index(sec_punc_list,m.attr)+1
            if level == 0
                call add(sec_punc_list,m.attr)
                let level = len(sec_punc_list)
            endif
            let lst_lv = 0
            let sec_lv = level
            

            " Add child and parent to document object.
            if sec_lv > p_sec_lv
                let sec_num = 1
                let m.sec_num = sec_num
                call s:add_child(p_s_obj,m)
            elseif sec_lv == p_sec_lv
                let sec_num = p_sec_num + 1
                let m.sec_num =sec_num
                call s:add_brother(p_s_obj,m)
            elseif sec_lv < p_sec_lv 
                let p_s_obj= p_s_obj.parent
                for i in range(p_sec_lv - sec_lv)
                    let p_s_obj = p_s_obj.parent
                endfor
                let brother = p_s_obj.child[-1]
                let sec_num = brother.sec_num+1
                let m.sec_num = sec_num
                call s:add_brother(brother, m)
            endif

            let p_s_obj = m
            let p_sec_lv = sec_lv
            let p_sec_num = sec_num
            
            let t_obj = m
            let t_lst = []
            while !empty(t_obj) && exists("t_obj['sec_num']")
                call add(t_lst, t_obj['sec_num'])
                let t_obj = t_obj.parent
            endwhile
            let txt = ""
            for i in reverse(t_lst)
                if i != 0
                    let txt .= i."."
                endif
            endfor
            let m.txt = txt
            let b:fdl_dict[m.bgn]   = m
            let b:fdl_dict[m.bgn+1] = m
            if m['row'] == 3
                let b:fdl_dict[m.bgn+2] = m
            endif
            " Stop Sect Part "}}}
        elseif m.type== 'list'
            " The List Part "{{{

            let lst_lv = m.level
            let lst_end = m.end

            if lst_lv > p_lst_lv
                call s:add_child(p_l_obj,m)
            elseif lst_lv == p_lst_lv  
                call s:add_brother(p_l_obj,m)
            elseif lst_lv < p_lst_lv 
                let p_l_obj= p_l_obj.parent
                for i in range(p_lst_lv - lst_lv)
                    if !exists("p_l_obj.parent.child")
                        break
                    endif
                    let p_l_obj = p_l_obj.parent
                endfor
                let brother = p_l_obj.child[-1]
                call s:add_brother(brother, m)
            endif

            let m.td_stat = s:get_td_stat(m.bgn)

            let p_l_obj = m
            let p_lst_lv = lst_lv
            let p_lst_end = lst_end
                
            let b:fdl_dict[m.bgn] = m
            " Stop List Part "}}}
        elseif m.type == 'trans'
            " stop current sect_lv
            " may encounter erros
            let lst_lv = 0
            let sec_lv = sec_lv>1 ? sec_lv-1 : 0
            let b:fdl_dict[m.bgn] = m
        elseif m.type== 'exp'
            let f = 1
            let b:fdl_dict[m.bgn] = m
        elseif m.type == 'block'
            let f = 1
            let b:fdl_dict[m.bgn] = m
        elseif m.type == 'table'
            let f = 1
            let m.col = len(split(b:lines[m.bgn], '+',1)) - 2
            let m.row = len(filter(b:lines[m.bgn:m.end], 
                        \'v:val=~''^\s*+''')) - 1
            let b:fdl_dict[m.bgn] = m
        endif
        
        let fdl = sec_lv+lst_lv+f

        let bgn = m.bgn
        if m.type=='sect'
            " The sect's end is next sect's bgn
            let s_i+=1
            if exists("stat.sectmatcher[s_i]")
                let end = stat.sectmatcher[s_i].bgn
            else
                let end = line('$')-1
            endif
            let b:fdl_list[bgn : bgn] = map(b:fdl_list[bgn : bgn],'">".fdl')
            let b:fdl_list[bgn+1 : end+1] = map(b:fdl_list[bgn+1 : end+1],'fdl')

            " let r_end= end
            " let end=prevnonblank(end-1)
            " let b:fdl_list[bgn-1 : bgn-1] = map(b:fdl_list[bgn-1 : bgn-1],'">".fdl')
            " let b:fdl_list[bgn   : end] = map(b:fdl_list[bgn : end],'fdl')


            continue
        else
            if exists("m.end")
                " if m.type=='list'
                "     echo "L:\t"
                " elseif m.type=='exp'
                "     echo "E:\t"
                " endif 
                " echon m.bgn "\t" m.end
                let end = m.end
                " let end=prevnonblank(end-1)
                let b:fdl_list[bgn : bgn] = map(b:fdl_list[bgn : bgn],'">".fdl')
                if bgn+1 <= end-1
                    let b:fdl_list[bgn+1   : end-1] = map(b:fdl_list[bgn+1 : end-1],'fdl')
                endif
                let b:fdl_list[end   : end] = map(b:fdl_list[end : end],'"<".fdl')
                continue
            elseif exists("mat[i+1]")
                let end = mat[i+1].bgn
            else
                let end = line('$')-1
            endif
        endif
        " let end=prevnonblank(end-1)
        let b:fdl_list[bgn : bgn] = map(b:fdl_list[bgn : bgn],'">".fdl')
        let b:fdl_list[bgn+1 : end] = map(b:fdl_list[bgn+1 : end],'fdl')
    endfor
    
endfun "}}}
fun! s:check(row) "{{{
    " check and set the state and return the value dict.
    let row = a:row
    let line = b:lines[row]
                
    call s:sectcheck(row)
    call s:tablecheck(row)
    call s:listcheck(row)
    call s:expcheck(row)
    call s:blockcheck(row)

    if line=~'^\s*$'
        return
    endif
    
    " add checker. "{{{
    let s = b:state

    if line=~'[^:]::\s*$' && empty(s.e_chk)
        let s.b_chk= {'row':row, 'indent': s:indent(line)}
    endif
    
    " list can inculde multi roman char and digit.
    if line=~ '^\s*[[:alnum:]]\+\s'
        return
    endif

    if line=~s:p.list && empty(s.e_chk)
        call insert(s.l_chk, {'row':row,'indent': s:indent(line)},0)
    endif

    " \w will include '_'
    if line=~'^\s*[[:alnum:]]'
        return
    endif

    if line=~s:p.section && line!~ '^\.\.\_s*$'
        let s.s_chk =  {'row':row, 'attr': line[0]}
    endif

    if line=~'^\s*\w'
        return
    endif

    if line=~s:p.exp_m || line =~ '^\.\.\_s*$'
        let s.e_chk= {'row':row,'indent':0}
    elseif line=~s:p.table && empty(s.t_chk)
            let s.t_chk= {'row':row}
    elseif line=~''
        call add(s.matcher,{'type':'trans', 'bgn':row,})
    endif "}}}
endfun "}}}
fun! s:sectcheck(row) "{{{
    if empty(b:state.s_chk)
        return
    endif
    let sc = b:state.s_chk
    let row=a:row
    if row == b:state.s_chk.row+1
        let line = b:lines[row]
        let blank = '^\s*$'
        if line !~ blank  && b:lines[row-2] =~ blank && b:lines[row+1] == b:lines[row-1]
            " 3 row title : blank ,section , noblank(cur) , section
            let m = {'type':'sect', 'bgn':row-1,'attr':b:state.s_chk.attr,'row':3,'child':[],'parent':{}}
            call add(b:state.matcher,m)
            call add(b:state.sectmatcher,m)
        elseif line =~ blank && b:lines[row-2]=~ blank && len(b:lines[row-1])>=4
            " transition : blank, section ,blank(cur) ,len>4
            call add(b:state.matcher,{'type':'trans', 'bgn':row-1})
        elseif b:lines[row-2] !~ blank && b:lines[row-3] =~ blank && b:lines[row-1] != b:lines[row-2]
            " 2 row title : blank , noblank , section , cur
            let m = {'type':'sect', 'bgn':row-2,'attr':b:state.s_chk.attr,'row':2,'child':[],'parent':{}}
            call add(b:state.matcher,m)
            call add(b:state.sectmatcher,m)
        endif
        let b:state.s_chk = {}
    endif
endfun "}}}

" fold option
" One but ALL     prevnonblank(row-1)+1
" All but One     row-1 if row-1=~ blank
" All             row
fun! s:listcheck(row) "{{{
    " a list contain all lists.
    " the final order should be sorted.
    if empty(b:state.l_chk)
        return
    endif
    let l = b:state.l_chk
    let row=a:row
    while !empty(l)
        if ( b:lines[row]!~ '^\s*$' && (row>l[0].row && s:indent(b:lines[row]) <= l[0].indent )
            \ && (b:lines[row]!~s:p.exp_m && b:lines[row+1]!~'^\s*$') )
            \ || row==line('$')
            call add(b:state.matcher,{'type':'list', 'bgn':l[0].row, 'end': prevnonblank(row-1)+1,
            \ 'level':l[0].indent/2+1, 'parent':{}, 'child':[]})
            call remove(l , 0)
        else
            break
        endif
    endwhile
endfun "}}}
fun! s:expcheck(row) "{{{
    if empty(b:state.e_chk)
        return
    endif
    let row=a:row
    if (b:lines[row]!~ '^\s*$' &&  (b:state.e_chk.row < row && s:indent(b:lines[row]) <= b:state.e_chk.indent) )
                \ ||  row==line('$')
        call add(b:state.matcher,{'type':'exp', 'bgn':b:state.e_chk.row, 'end': prevnonblank(row-1)+1})
        let b:state.e_chk={}
    elseif b:lines[row]=~ '^\s*$' && b:lines[row-1]=~'^\.\.\_s*$'
        " the ignored comment
        call add(b:state.matcher,{'type':'exp', 'bgn':b:state.e_chk.row, 'end':row})
        let b:state.e_chk={}
    endif
endfun "}}}
fun! s:blockcheck(row) "{{{
    if empty(b:state.b_chk)
        return
    endif
    let row=a:row
    if (b:lines[row]!~ '^\s*$' && b:state.b_chk.row < row  
                \ && s:indent(b:lines[row]) <= b:state.b_chk.indent )
                \ ||  row==line('$')
        call add(b:state.matcher,{'type':'block', 'bgn':b:state.b_chk.row, 'end': prevnonblank(row-1)+1})
        let b:state.b_chk={}
    endif
endfun "}}}
fun! s:tablecheck(row) "{{{
    if empty(b:state.t_chk)
        return
    endif
    if (b:state.t_chk.row < a:row && b:lines[a:row] !~ s:p.table )
                 \  || a:row==line('$')
        call add(b:state.matcher,{'type':'table', 'bgn':b:state.t_chk.row, 'end':a:row-1})
        let b:state.t_chk={}
    endif
endfun "}}}

fun! s:sort_match(i1,i2) "{{{
    return a:i1.bgn - a:i2.bgn
endfun "}}}
fun! s:indent(line) "{{{
    return strdisplaywidth(strpart(a:line, 0, match(a:line,'\S')))
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
