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
let s:fb = g:riv_fold_blank

fun! riv#fold#expr(row) "{{{
    if a:row == 1
        call s:init_stat()
    endif
    return b:fdl_list[a:row]
endfun "}}}
fun! riv#fold#text() "{{{
    let lnum = v:foldstart
    let line = b:lines[lnum]
    let cate = "    "
    if has_key(b:fdl_dict,lnum)
        if b:fdl_dict[lnum].type == 'sect'
            let cate = " ".b:fdl_dict[lnum].txt
            if b:fdl_dict[lnum].title_rows == 3
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
    let max_len = winwidth(0)-12
    if len(line) <= max_len
        let line = line."  ".repeat('-',max_len) 
    endif
    let line = printf("%-4s| %s", cate, line)
    let line = printf("%-".max_len.".".(max_len)."s", line)
    let num  = printf("%5s+", (v:foldend-lnum))
    return  line."[".num."]"
endfun "}}}

fun! s:init_stat() "{{{
    let len = line('$')
    let b:fdl_list = map(range(len+1),'0')
    let b:fdl_dict = {}
    let b:state = { 's_chk':[], 'l_chk':[], 'e_chk':[], 'b_chk':[], 't_chk':[],
                \'matcher':[], 'sectmatcher':[], 
                \'s_root': { 'parent':{}  , 'child':[] ,'sec_num':0 } ,
                \'l_root': { 'parent':{}  , 'child':[] ,'lst_num':0 } ,
                \}

    
    " 3%
    let b:lines= ['']+getline(0,line('$'))
    for i in range(len+1)
    " 70%
        call s:check(i)
    endfor
    " sort the unordered list.
    call sort(b:state.matcher,"s:sort_match")
    " 20%
    call s:set_fdl_dict()
    call s:set_fdl_list()
    call s:set_td_child(b:state.l_root)
endfun "}}}

fun! s:set_fdl_dict() "{{{
    
    let stat = b:state
    let mat = stat.matcher

    let sec_punc_list = []      " the punctuation list used by section

    let p_s_obj = stat.s_root   " previous section object, init with root
    let sec_lv = 0              " the section level calced by punc_list
    let p_sec_lv = sec_lv       

    let lst_lv = 0              " current list_level
    let p_lst_lv = 0
    let p_l_obj = stat.l_root   " previous list object 
    let p_lst_end = line('$')   " let  root contains all level 1 list object
    for m in mat
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
            let m.level = level
            

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
            if m['title_rows'] == 3
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
        
        let m.fdl = sec_lv+lst_lv+f

    endfor
    
endfun "}}}
fun! s:set_fdl_list() "{{{
    let stat = b:state
    let mat = stat.matcher

    let s_i = 0                 " the sect_matcher index , used to get next
                                " section object.
    " fold_blank: 0,1,2 (default:0)
    " 0     fold one blank line at the most
    " 1     fold all but one blank line
    " 2     fold all blank line
    for m in mat
        let bgn = m.bgn
        let fdl = m.fdl
        if m.type=='sect' || m.type=='trans'
            " The sect's end is next sect's bgn
            if m.type=='sect'
                let s_i+=1
            endif
            if exists("stat.sectmatcher[s_i]") && m.type!='trans'
                let end = stat.sectmatcher[s_i].bgn
                if stat.sectmatcher[s_i].level <= m.level
                    if s:fb != 2
                        if s:fb == 1 && b:lines[end-2]=~'^\s*$'
                            let end2 = end
                            let end = end - 1
                        elseif s:fb == 0
                            let end2 = end
                            let end = prevnonblank(end-1)+1
                        endif
                        let b:fdl_list[end   : end2] = map(b:fdl_list[end : end2],'fdl-1')
                    endif
                endif
            else
                let end = line('$')
            endif
        else
            if exists("m.end")
                let end = m.end
            elseif exists("mat[i+1]")
                let end = mat[i+1].bgn
            else
                let end = line('$')-1
            endif
        endif
        if s:fb ==1 && b:lines[end] =~ '^\s*$'
            let end = end - 1
        elseif s:fb==0 && b:lines[end] =~ '^\s*$'
            let end = prevnonblank(end) + 1
        endif
        let b:fdl_list[bgn : bgn] = map(b:fdl_list[bgn : bgn],'">".fdl')
        if bgn+1 <= end
            let b:fdl_list[bgn+1 : end] = map(b:fdl_list[bgn+1 : end],'fdl')
        endif
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

    if line=~s:p.literal_block && empty(s.e_chk)
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

    if line=~s:p.exp_m
        let s.e_chk= {'row':row,'indent':0}
    elseif line=~s:p.table && empty(s.t_chk)
            let s.t_chk= {'row':row}
    elseif line=~''
        call add(s.matcher,{'type':'trans', 'bgn':row,})
    endif "}}}
endfun "}}}
fun! s:sectcheck(row) "{{{
    if empty(b:state.s_chk) | return | endif
    if a:row == b:state.s_chk.row+1
        let line = b:lines[a:row]
        let blank = '^\s*$'
        if line !~ blank  && b:lines[a:row-2] =~ blank && b:lines[a:row+1] == b:lines[a:row-1]
            " 3 row title : blank ,section , noblank(cur) , section
            let m = {'type':'sect', 'bgn':a:row-1,'attr':b:state.s_chk.attr,
                        \'title_rows':3,'child':[],'parent':{}}
            call add(b:state.matcher,m)
            call add(b:state.sectmatcher,m)
        elseif line =~ blank && b:lines[a:row-2]=~ blank && len(b:lines[a:row-1])>=4
            " transition : blank, section ,blank(cur) ,len>4
            call add(b:state.matcher,{'type':'trans', 'bgn':a:row-1})
        elseif b:lines[a:row-2] !~ blank && b:lines[a:row-3] =~ blank
                    \ && b:lines[a:row-1] != b:lines[a:row-2]
            " 2 row title : blank , noblank , section , cur
            let m = {'type':'sect', 'bgn':a:row-2,'attr':b:state.s_chk.attr,
                        \'title_rows':2,'child':[],'parent':{}}
            call add(b:state.matcher,m)
            call add(b:state.sectmatcher,m)
        endif
        let b:state.s_chk = {}
    endif
endfun "}}}
fun! s:listcheck(row) "{{{
    " a list contain all lists.
    " the final order should be sorted.
    if empty(b:state.l_chk) | return | endif
    let l = b:state.l_chk
    while !empty(l)
        if ( b:lines[a:row]!~ '^\s*$' && (a:row>l[0].row && s:indent(b:lines[a:row]) <= l[0].indent )
            \ && (b:lines[a:row]!~s:p.exp_m && b:lines[a:row+1]!~'^\s*$') )
            call add(b:state.matcher,{'type':'list', 'bgn':l[0].row, 'end': a:row-1,
            \ 'level':l[0].indent/2+1, 'parent':{}, 'child':[]})
            call remove(l , 0)
        elseif a:row==line('$')
            call add(b:state.matcher,{'type':'list', 'bgn':l[0].row, 'end': a:row,
            \ 'level':l[0].indent/2+1, 'parent':{}, 'child':[]})
            call remove(l , 0)
        else
            break
        endif
    endwhile
endfun "}}}
fun! s:expcheck(row) "{{{
    if empty(b:state.e_chk) | return | endif
    if ( b:lines[a:row]!~ '^\s*$' &&  b:state.e_chk.row < a:row
        \ && s:indent(b:lines[a:row]) <= b:state.e_chk.indent )
        \ || ( b:lines[a:row]=~ '^\s*$' && b:lines[a:row-1]=~'^\.\.\_s*$')
        call add(b:state.matcher,{'type':'exp', 'bgn':b:state.e_chk.row, 'end': a:row-1})
        let b:state.e_chk={}
    elseif  a:row==line('$')
        call add(b:state.matcher,{'type':'exp', 'bgn':b:state.e_chk.row, 'end': a:row})
        let b:state.e_chk={}
    endif
endfun "}}}
fun! s:blockcheck(row) "{{{
    if empty(b:state.b_chk) | return | endif
    if (b:lines[a:row]!~ '^\s*$' && b:state.b_chk.row < a:row  
        \ && s:indent(b:lines[a:row]) <= b:state.b_chk.indent )
        call add(b:state.matcher,{'type':'block', 'bgn':b:state.b_chk.row, 'end': a:row-1})
        let b:state.b_chk={}
    elseif  a:row==line('$')
        call add(b:state.matcher,{'type':'block', 'bgn':b:state.b_chk.row, 'end': a:row})
        let b:state.b_chk={}
    endif
endfun "}}}
fun! s:tablecheck(row) "{{{
    if empty(b:state.t_chk) | return | endif
    if (b:state.t_chk.row < a:row && b:lines[a:row] !~ s:p.table )
        call add(b:state.matcher,{'type':'table', 'bgn':b:state.t_chk.row, 'end':a:row-1})
        let b:state.t_chk={}
    elseif a:row==line('$')
        call add(b:state.matcher,{'type':'table', 'bgn':b:state.t_chk.row, 'end':a:row})
        let b:state.t_chk={}
    endif
endfun "}}}
fun! s:get_children(o) "{{{
    
endfun "}}}
fun! s:get_child(o,i) "{{{
    
endfun "}}}
fun! s:get_parent(o) "{{{
    
endfun "}}}
fun! s:add_child(p,o) "{{{
    call add(a:p.child, a:o.bgn )
    let a:o.parent = a:p.bgn
endfun "}}}
fun! s:add_brother(b,o) "{{{
    let a:o.parent = a:b.parent
    call add(b:fdl_dict[a:o.parent].child, a:o.bgn )
endfun "}}}

let s:tdl = g:_RIV_t.todo_levels
fun! s:get_td_stat(lnum) "{{{
    " second submatch is todo item.
    let m_lst = matchlist(b:lines[a:lnum], s:p.list_box)
    if !empty(m_lst)
        let td = m_lst[2]
        let d =  stridx(s:tdl, td)
        if d != -1 && (len(s:tdl)-1)!=0
            return (d+0.0)/(len(s:tdl)-1)
        else
            return -1
        endif
    endif
    return -1
endfun "}}}
fun! s:set_td_child(o) "{{{
    " Get All child's td_stat recursively
    " and update the td_child attr.
    let c_td = 0
    let len = 0
    for chd in a:o.child
        if empty(chd.child)
            if chd.td_stat != -1
                let c_td += chd.td_stat
                let len +=1
            endif
        else
            let d = s:set_td_child(chd)
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
fun! s:sort_match(i1,i2) "{{{
    return a:i1.bgn - a:i2.bgn
endfun "}}}
fun! s:indent(line) "{{{
    return strdisplaywidth(strpart(a:line, 0, match(a:line,'\S')))
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
