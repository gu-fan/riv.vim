"=============================================
"    Name: fold.vim
"    File: fold.vim
"  Author: Rykka G.F
"  Update: 2014-02-10
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:p = g:_riv_p
fun! s:init_stat(...) "{{{
    let len = line('$')
    let b:foldlevel = g:riv_fold_level
    if len > g:riv_auto_fold1_lines && g:riv_auto_fold_force == 1
        let b:foldlevel = b:foldlevel >= 1 ? 1 : 0 
    elseif len > g:riv_auto_fold2_lines && g:riv_auto_fold_force == 1
        let b:foldlevel = b:foldlevel >= 2 ? 2 : 0 
    endif
    " To avoid stuck with necompl
    if !exists("b:riv_flist") || ( len(b:riv_flist) != len + 1 )
        call s:parse_from_start()
    endif
    " Todo: Parse from the first modified line.
endfun "}}}
" Parse "{{{
fun! s:parse_from_start() "{{{
    redraw
    echo "Parsing buf ..."
    let len = line('$')
    let b:riv_state = { 'l_chk':[], 
                \'matcher':[], 'sectmatcher':[], 
                \'sect_root': { 'parent': 'None'  , 'child':[] ,
                \  'bgn': 'sect_root'} ,
                \'list_root': { 'parent': 'None'  , 'child':[] ,
                \ 'bgn': 'list_root'} ,
                \  'None': { 'parent': 'None'  , 'child':[] ,
                \ 'bgn': 'None'} ,
                \}
    let b:riv_obj = {'sect_root':b:riv_state.sect_root, 
                \ 'list_root':b:riv_state.list_root,
                \ 'None': b:riv_state.None }
    " 3%
    let b:riv_flist = map(range(len+1),'0')
    let b:lines= ['']+getline(1,line('$'))+['']     " [-1] and [0] are blank
    " 75%
    for i in range(len+1)
        call s:check(i)
    endfor
    " 20%
    call sort(b:riv_state.matcher,"s:sort_match")
    call s:set_obj_dict()
    call s:set_sect_end()
    call s:set_fdl_list()
    call s:set_td_child(b:riv_state.list_root)
    call garbagecollect(1)
    echon "Done"
endfun "}}}
let s:tmpfile = tempname()
fun! s:get_changed_range() "{{{
    sil exe 'w !diff % - > ' s:tmpfile
    let changes = []
    for line in readfile(s:tmpfile)
        if line =~ '^<\|^>\|^---' || line=~ '^\d\+\%(,\d\+\)\=c'
            continue
        endif 
        call add(changes , line)
    endfor 
    if len(changes) == 0
        return [[0]]
    elseif len(changes) >= 5
        return [[-1]]
    endif 
    let changed_list =[]
    for change in changes
        if change =~ 'a\|d'
            let [b,a ] = split(change,'a\|d')
            let b_r = split(b,',')
            let a_r = split(a,',')
            let bran = b_r[-1] - b_r[0] + 1
            let aran = a_r[-1] - a_r[0] + 1
            let changed = [b_r[0] , (aran - bran)+1]
            call add(changed_list, changed)
        endif
    endfor
    return changed_list
endfun "}}}
fun! s:add_change_range(change_list) "{{{
    if a:change_list[0][0] == 0
        return
    elseif a:change_list[0][0] == -1
        call s:parse_from_start()
        return
    endif
    for change in a:change_list
        call s:add_in_len(change[0],change[1])
    endfor
endfun "}}}
fun! s:add_in_len(bgn,len) "{{{
    call s:add_d_len(b:riv_obj, a:bgn, a:len)
    call s:add_l_len(b:riv_flist, a:bgn, a:len)
endfun "}}}
fun! s:add_d_len(dict, bgn, len) "{{{
    let changed = {}
    if a:len > 0
        let changed = filter(copy(a:dict),'v:key>a:bgn')
        for key in reverse(sort(keys(changed),'s:sort'))
            let changed[key+a:len] = changed[key]
            let changed[key+a:len].bgn += a:len
        endfor
    elseif a:len < 0
        let changed = filter(copy(a:dict),'v:key>(a:bgn+a:len)')
        for key in sort(keys(changed),'s:sort')
            let changed[key+a:len] = changed[key]
            let changed[key+a:len].bgn += a:len
        endfor
    endif
    
    call extend(a:dict, changed)
endfun "}}}
fun! s:sort(i1,i2) "{{{
    return a:i1 - a:i2
endfun "}}}
fun! s:add_l_len(list, bgn, len) "{{{
    if a:len > 0 
        call extend(a:list,map(range(a:len),'0'),a:bgn)
    elseif a:len < 0
        call remove(a:list,a:bgn,a:bgn-a:len)
    endif
endfun "}}}
"}}}
" Set "{{{
let s:sect_sep = g:riv_fold_section_mark
fun! s:set_obj_dict() "{{{
    " Set the b:riv_obj dict which contains structure infos.
    
    let stat = b:riv_state
    let mat = stat.matcher

    let sec_punc_list = []      " the punctuation list used by section

    let p_s_obj = stat.sect_root   " previous section object, init with root
    let sec_lv = 0              " the section level calced by punc_list
    let p_sec_lv = sec_lv       

    let lst_lv = 0              " current list_level
    let p_lst_lv = 0
    let p_l_obj = stat.list_root   " previous list object 
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
                " create the next older of last item.
                for i in range(p_sec_lv - sec_lv+1)
                    if p_s_obj.bgn == 'sect_root'
                        break
                    endif
                    let p_s_obj = s:get_parent(p_s_obj)
                endfor
                let brother = s:get_child(p_s_obj,-1)
                let sec_num = brother.sec_num+1
                let m.sec_num = sec_num
                call s:add_brother(brother, m)
            endif

            let p_s_obj = m
            let p_sec_lv = sec_lv
            let p_sec_num = sec_num
            
            " Get the section text like 1-1 1-2 1-2-1
            let t_obj = m
            let t_lst = []
            while !empty(t_obj) && t_obj.bgn != 'sect_root'
                call add(t_lst, t_obj['sec_num'])
                let t_obj = s:get_parent(t_obj)
            endwhile
            let m.txt = join(reverse(t_lst), s:sect_sep)
            let p_sec_txt = m.txt

            let b:riv_obj[m.bgn]   = m
            let b:riv_obj[m.bgn+1] = m
            if m['title_rows'] == 3
                let b:riv_obj[m.bgn+2] = m
            endif
            " End Sect Part "}}}
        elseif m.type== 'list'
            " The List Part "{{{
            let lst_lv = m.level
            
            if lst_lv > p_lst_lv
                call s:add_child(p_l_obj,m)
            elseif lst_lv == p_lst_lv  
                call s:add_brother(p_l_obj,m)
            elseif lst_lv < p_lst_lv 
                " create the next older
                for i in range(p_lst_lv - lst_lv + 1)
                    if p_l_obj.bgn == 'list_root'
                        break
                    endif
                    let p_l_obj = s:get_parent(p_l_obj)
                endfor
                let brother = s:get_child(p_l_obj,-1)
                call s:add_brother(brother, m)
            endif

            let m.td_stat = riv#todo#stat(b:lines[m.bgn])

            let p_l_obj = m
            let p_lst_lv = lst_lv
                
            let b:riv_obj[m.bgn] = m
            " End List Part "}}}
        elseif m.type == 'trans'
            let lst_lv = 0
            let b:riv_obj[m.bgn] = m
        else
            let f = 1
            let b:riv_obj[m.bgn] = m
        endif
        
        let m.fdl = sec_lv+lst_lv+f

    endfor
    
endfun "}}}
fun! s:set_sect_end() "{{{
    " Set the end line of each section.
    let stat = b:riv_state
    let smat = stat.sectmatcher
    for i in range(len(smat))
        let m = smat[i]
        let bgn = m.bgn
        let fdl = m.fdl
        
        " We should parse section level by level.
        " 1~2 ~3 
        "  ^1
        " 1.1~1.2~1.3 ~ 2
        "    ^:2      ^: should be level 1  
        " 1.1.1~1.1.2
        "      ^:3
        " if have brother, then to next brother
        " else parent's brother's bgn
        "
        let n_b = riv#fold#get_next_brother(m)
        let n_p = s:get_parent(m)
        while empty(n_b)
            if (n_p.bgn == 'sect_root' )
                break
            endif 
            let n_b = riv#fold#get_next_brother(n_p)
            let n_p = s:get_parent(n_p)
        endwhile
        if empty(n_b)
            let n_b = {'level':0,'bgn':line('$')+1}
        endif
        
        if m.level > n_b.level && g:riv_fold_blank ==0
            if n_b.bgn != line('$')+1
                let m.end = prevnonblank(n_b.bgn-1)+1
            else
                let m.end = line('$')
            endif
        elseif m.level > n_b.level && g:riv_fold_blank == 1
            if n_b.bgn != line('$')+1
                let m.end = n_b.bgn-2
            else
                let m.end = line('$')
            endif
        else
            let m.end = n_b.bgn-1
        endif

    endfor
endfun "}}}
fun! s:set_fdl_list() "{{{
    " Set folding list's bgn and end
    let stat = b:riv_state
    let mat = stat.matcher

    " fold_blank: 0,1,2 (default:0)
    " 0     fold one blank line at the most
    " 1     fold all but one blank line
    " 2     fold all blank line
    for m in mat
        let bgn = m.bgn
        let fdl = m.fdl
        let end = m.end
        if g:riv_fold_blank ==1 && b:lines[end] =~ '^\s*$'
            let end = end - 1
        elseif g:riv_fold_blank==0 && b:lines[end] =~ '^\s*$'
            let end = prevnonblank(end) + 1
        endif
        let  b:riv_flist[bgn : bgn] = map(b:riv_flist[bgn : bgn],'">".fdl')
        " if it's not a one line folding?
        if bgn+1 <= end
            let b:riv_flist[bgn+1 : end] = map(b:riv_flist[bgn+1 : end],'fdl')
        endif
    endfor
endfun "}}}
"}}}
" Check "{{{
fun! s:check(row) "{{{
    " check and set the state and return the value dict.
                
    if b:foldlevel < 0
        return
    endif

    let row = a:row
    let line = b:lines[row]

    if has_key(b:riv_state, 's_chk')  
        if  s:s_checker(row)
            return
        endif
    endif
    
    if line=~'^\s*$' && row != line('$')
        return
    endif

    if b:foldlevel > 2 && has_key(b:riv_state, 't_chk')
        if s:t_checker(row)
            return
        endif
    endif

    if b:foldlevel > 1 && !empty(b:riv_state.l_chk) && !has_key(b:riv_state, 'e_chk')
        call s:l_checker(row)
    endif

    if b:foldlevel > 2

        if has_key(b:riv_state, 'e_chk') 
            call s:e_checker(row)
        endif
        if has_key(b:riv_state, 'b_chk') 
            call s:b_checker(row)
        endif
        if has_key(b:riv_state, 'st_chk') 
            call s:st_checker(row)
        endif
        if has_key(b:riv_state, 'lb_chk') 
            call s:lb_checker(row)
        endif

        if !has_key(b:riv_state, 'e_chk') && !has_key(b:riv_state, 'b_chk')  
            \ && line=~s:p.literal_block && b:lines[a:row+1]=~ '^\s*$'
            if line=~s:p.exp_mark
                let b:riv_state.e_chk= {'type': 'exp', 'bgn':a:row,}
                return 1
            else
                let b:riv_state.b_chk = {'type': 'block', 'bgn': a:row, 
                            \ 'indent': riv#fold#indent(line)}
                " the block line may be other item, so not return
            endif
        endif

    endif

    if line=~'^\s*[[:alnum:]]\+%(\s|$)'
        return
    elseif b:foldlevel > 1 && !has_key(b:riv_state, 'e_chk')
                \ && line=~s:p.all_list

        let idt = riv#fold#indent(line)
        let l_item = {'type': 'list', 'bgn': a:row, 
                  \ 'indent': idt,
                  \ 'child': [], 'parent': 'list_root',
                  \ 'level': idt/2+1,
                  \}

        if row == line('$')
            let l_item.end = a:row
            call add(b:riv_state.matcher,l_item)
        else
            call insert(b:riv_state.l_chk, l_item, 0)
        endif
        return 1
    elseif line=~s:p.section  && line !~ '^\.\.%(\s|$)*$'
        let b:riv_state.s_chk =  {'type': 'sect' , 'bgn': row, 'attr': line[0]}
        return 1
    elseif line=~ '^__\s'
        " it's anonymous link
        let b:riv_state.e_chk= {'type': 'exp', 'bgn':a:row,}
        return 1
    elseif line=~'^\s*\w'
        return
    elseif b:foldlevel > 2 && (line =~ s:p.exp_mark )
        if  (line=~'^\.\.\s*$' && a:row!=line('$') 
                            \ && b:lines[a:row+1]=~'^\s*$')
            call add(b:riv_state.matcher,{'type': 'exp', 'mark': 'ignored', 
                    \ 'bgn': a:row, 'end': a:row})
        else
            let b:riv_state.e_chk= {'type': 'exp', 'bgn':a:row,}
        endif
        return 1
    elseif b:foldlevel > 2 && !has_key(b:riv_state, 'st_chk') && line =~ s:p.simple_table 
                \ && row != line('$') && b:lines[row+1] !~ '^\s*$'
        let b:riv_state.st_chk =  {'type': 'simple_table' , 'bgn': a:row, 'row': 0,
                    \ 'col': len(split(line)) }
        return 1
    elseif b:foldlevel > 2 && !has_key(b:riv_state, 'lb_chk') && line=~s:p.line_block 
        let b:riv_state.lb_chk= {'type': 'line_block' , 'bgn': a:row}
        return 1
    elseif b:foldlevel > 2 && !has_key(b:riv_state, 't_chk') 
                \ && line=~s:p.table
        let b:riv_state.t_chk= {'type': 'table' , 'bgn': a:row, 'row': 0,
                    \ 'col': len(split(line, '+',1)) - 2 }
        return 1
    elseif b:foldlevel > 2 && line=~'^'
        call add(b:riv_state.matcher,{'type':'trans', 'bgn':a:row,'end':a:row})
        return 1
    endif

endfun "}}}

fun! s:s_checker(row) "{{{
    let chk = b:riv_state.s_chk
    if a:row == chk.bgn+1
        let line = b:lines[a:row]
        let blank = '^\s*$'
        if line !~ blank  && b:lines[a:row-2] =~ blank  && a:row!=line('$')
            \ && b:lines[a:row+1] == b:lines[a:row-1]
            " 3 row title : blank ,section , noblank(cur) , section
            let chk.bgn = a:row-1
            let chk.title_rows = 3
            let chk.child = []
            let chk.parent = 'sect_root'
            call add(b:riv_state.matcher, chk)
            call add(b:riv_state.sectmatcher, chk)
            call remove(b:riv_state, 's_chk')
            return 1
        elseif line =~ blank && b:lines[a:row-2]=~ blank && len(b:lines[a:row-1])>=4
            " transition : blank, section ,blank(cur) ,len>4
            let chk.type = 'trans'
            let chk.bgn = a:row - 1
            let chk.end = a:row - 1
            call add(b:riv_state.matcher, chk)
            call remove(b:riv_state, 's_chk')
            return 
        elseif b:lines[a:row-2] !~ blank && b:lines[a:row-3] =~ blank
                    \ && b:lines[a:row-1] != b:lines[a:row-2]
            " 2 row title : blank , noblank , section , cur
            let chk.bgn = a:row - 2
            let chk.title_rows = 2
            let chk.child = []
            let chk.parent = 'sect_root'
            call add(b:riv_state.matcher, chk)
            call add(b:riv_state.sectmatcher, chk)
            call remove(b:riv_state, 's_chk')
            return 1
        endif
    endif
endfun "}}}
fun! s:l_checker(row) "{{{
    " a list contain all lists.
    " the final order should be sorted.
    " if empty(b:riv_state.l_chk) | return | endif
    " List can contain Explicit Markup items.
    " if has_key(b:riv_state, 'e_chk') | return | endif
    " NOTE: 
    " Field list 
    " list-item:
    "   
    "   list content
    "
    " are not folded
    let l = b:riv_state.l_chk
    let idt = riv#fold#indent(b:lines[a:row]) 
    let end = line('$')
    while !empty(l)
        if (idt <= l[0].indent ) 
            let l[0].end = a:row-1
            call add(b:riv_state.matcher,l[0])
            call remove(l , 0)
        elseif a:row==end
            let l[0].end = a:row
            call add(b:riv_state.matcher,l[0])
            call remove(l , 0)
        else
            break
        endif
    endwhile
endfun "}}}
fun! s:e_checker(row) "{{{
    " check end
    if (  b:lines[a:row] =~ '^\S' )
        let b:riv_state.e_chk.end = a:row-1
        call add(b:riv_state.matcher,b:riv_state.e_chk)
        call remove(b:riv_state, 'e_chk')
    elseif  a:row==line('$')
        let b:riv_state.e_chk.end = a:row
        call add(b:riv_state.matcher,b:riv_state.e_chk)
        call remove(b:riv_state, 'e_chk')
    endif
endfun "}}}
fun! s:b_checker(row) "{{{
    " block
    if (  riv#fold#indent(b:lines[a:row]) <= b:riv_state.b_chk.indent )
        let b:riv_state.b_chk.end = a:row-1
        call add(b:riv_state.matcher, b:riv_state.b_chk)
        call remove(b:riv_state, 'b_chk')
    elseif a:row==line('$') && b:riv_state.b_chk.bgn < a:row
        let b:riv_state.b_chk.end = a:row
        call add(b:riv_state.matcher, b:riv_state.b_chk)
        call remove(b:riv_state, 'b_chk')
    endif
endfun "}}}
fun! s:lb_checker(row) "{{{
    " line block
    if b:lines[a:row] !~ s:p.line_block && b:lines[a:row-1] =~ '^\s*$'
        let b:riv_state.lb_chk.end = a:row-1
        call add(b:riv_state.matcher, b:riv_state.lb_chk)
        call remove(b:riv_state, 'lb_chk')
    elseif a:row==line('$')
        let b:riv_state.t_chk.end = a:row
        call add(b:riv_state.matcher, b:riv_state.lb_chk)
        call remove(b:riv_state, 'lb_chk')
    endif
endfun "}}}
fun! s:t_checker(row) "{{{
    if b:lines[a:row] =~ g:_riv_p.table_fence
        let b:riv_state.t_chk.row += 1
        return 1
    elseif (b:lines[a:row] !~ s:p.table_line )
        let b:riv_state.t_chk.end = a:row-1
        call add(b:riv_state.matcher, b:riv_state.t_chk)
        call remove(b:riv_state, 't_chk')
        return 0
    elseif a:row==line('$')
        let b:riv_state.t_chk.end = a:row
        call add(b:riv_state.matcher, b:riv_state.t_chk)
        call remove(b:riv_state, 't_chk')
        return 0
    endif
endfun "}}}
fun! s:st_checker(row) "{{{
    if  b:lines[a:row] =~ s:p.simple_table
        if b:lines[a:row+1] =~ '^\s*$'
            let b:riv_state.st_chk.end = a:row
            call add(b:riv_state.matcher, b:riv_state.st_chk)
            call remove(b:riv_state, 'st_chk')
        endif
    elseif b:lines[a:row] !~ s:p.simple_table_span
        let b:riv_state.st_chk.row += 1
    endif
endfun "}}}

"}}}
" Relation "{{{
fun! s:add_child(p,o,...) "{{{
    call add(a:p.child, a:o.bgn )
    let a:o.parent = a:p.bgn
endfun "}}}
fun! s:add_brother(b,o,...) "{{{
    let dic = a:0 ? a:1 : b:riv_obj
    let a:o.parent = a:b.parent
    call add(dic[a:o.parent].child, a:o.bgn )
endfun "}}}
fun! s:get_child(o,i,...) "{{{
    let dic = a:0 ? a:1 : b:riv_obj
    return dic[a:o.child[a:i]]
endfun "}}}
fun! s:get_parent(o,...) "{{{
    let dic = a:0 ? a:1 : b:riv_obj
    return dic[a:o.parent]
endfun "}}}
fun! riv#fold#get_prev_brother(o) "{{{
    for i in range(len(b:riv_obj[a:o.parent].child))
        if b:riv_obj[a:o.parent].child[i] == a:o.bgn
            if exists("b:riv_obj[a:o.parent].child[i-1]") && i != 0
                return b:riv_obj[b:riv_obj[a:o.parent].child[i-1]]
            endif
        endif
    endfor
    return {}
endfun "}}}
fun! riv#fold#get_next_brother(o) "{{{
    for i in range(len(b:riv_obj[a:o.parent].child))
        if b:riv_obj[a:o.parent].child[i] == a:o.bgn
            if exists("b:riv_obj[a:o.parent].child[i+1]")
                return b:riv_obj[b:riv_obj[a:o.parent].child[i+1]]
            endif
        endif
    endfor
    return {}
endfun "}}}
fun! riv#fold#get_next_older(o) "{{{
    " try to get the next item of the same level. 
    " if not find. use it's parent's next item.
    let n_b = riv#fold#get_next_brother(a:o)
    let n_p = s:get_parent(a:o)
    while empty(n_b)
        if (n_p.bgn == 'sect_root' || n_p.bgn== 'list_root')
            break
        endif 
        let n_b = riv#fold#get_next_brother(n_p)
        let n_p = s:get_parent(n_p)
    endwhile
    return n_b
endfun "}}}
"}}}
" Help "{{{
fun! s:set_td_child(o) "{{{
    " Get All child's td_stat recursively
    " and update the td_child attr.
    let c_td = 0
    let len = 0
    for chd in a:o.child
        if empty(b:riv_obj[chd].child)
            if b:riv_obj[chd].td_stat != -1
                let c_td += b:riv_obj[chd].td_stat
                let len +=1
            endif
        else
            let d = s:set_td_child(b:riv_obj[chd])
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
fun! riv#fold#indent(line) "{{{
    return strdisplaywidth(matchstr(a:line,'^\s*'))
endfun "}}}
fun! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun "}}}
fun! riv#fold#SID() "{{{
    return '<SNR>'.s:SID().'_'
endfun "}}}
"}}}
" Main "{{{
fun! riv#fold#expr(row) "{{{
    if a:row == 1
        noa call s:init_stat()
    endif
    return b:riv_flist[a:row]
endfun "}}}
fun! riv#fold#text() "{{{
    let lnum = v:foldstart
    let line = getline(lnum)
    let cate = "    "
    if has_key(b:riv_obj,lnum)
        if b:riv_obj[lnum].type == 'sect'
            let cate = " ".b:riv_obj[lnum].txt
            if b:riv_obj[lnum].title_rows == 3
                let line = getline(lnum+1)
            endif
        elseif b:riv_obj[lnum].type == 'list'
            if exists("b:riv_obj[lnum].td_child")
                let cate = printf(" %-.0f%%", 100 * b:riv_obj[lnum].td_child)
            elseif b:riv_obj[lnum].td_stat != -1
                let cate = printf(" %-.0f%%", 100 * b:riv_obj[lnum].td_stat)
            endif
        elseif b:riv_obj[lnum].type == 'table'
            let cate = " " . b:riv_obj[lnum].row 
                        \  . 'x' . b:riv_obj[lnum].col." "
            let line = getline(lnum+1)
        elseif b:riv_obj[lnum].type == 'simple_table'
            let cate = " " . b:riv_obj[lnum].row . '+' 
                        \  . b:riv_obj[lnum].col . " "
            let line = getline(lnum+1)
        elseif b:riv_obj[lnum].type == 'exp'
            let cate = " .."
        elseif b:riv_obj[lnum].type == 'block'
            let cate = " ::"
            let line = getline(lnum)
        elseif b:riv_obj[lnum].type == 'line_block'
            let cate = " | "
        elseif b:riv_obj[lnum].type == 'trans'
            let cate = " --"
            let line = strtrans(line)
        endif
    endif
    let max_len = winwidth(0)-20
    " Fix east_asia_char display width in fold text
    let dis_len = strdisplaywidth(line)
    if dis_len > max_len
        " XXX we should find the screen idx of the wide str.
        " and want to get it in place.
        " WORKAROUND: truncate the string with max_len, 
        "             add balance for EastAsiaChar.
        let line = strpart(line, 0, byteidx(line, max_len-(strlen(line)-dis_len)))
        let dis_len = strdisplaywidth(line)
    endif
    let line = line."  ".repeat('-', max_len-dis_len)
    if g:riv_fold_info_pos == 'left'
        return printf("%-5s|%s  %4s+ ",cate,line,(v:foldend-lnum))
    else
        return printf("%s|%-5s  %4s+ ",line,cate,(v:foldend-lnum))
    endif

endfun "}}}
fun! riv#fold#update() "{{{
    if &filetype!='rst' || &fdm!='expr' || g:riv_fold_auto_update == 0
        return
    endif
    normal! zx
endfun "}}}
let s:modified = 0
fun! riv#fold#init() "{{{
    noa call s:init_stat()
endfun "}}}
"}}}
"
fun! s:parse_list() "{{{
    " setup list object in current section
    " should detect the indent if lines
    
    " check line by line, search a list or an line ,
    " if it's indent < prev list , then it's prev's child
    " else if it's indent == prev list , then end prev list ,
    " elseif indent > prev list, end list to that indent.
    " 
    " the tree is 
    " list_root => list_0_root( roots contain seperated 0 level list ) 
    "           => list_0  => list_1 ...
    
    let row = line('.')
    let savepos = getpos('.')
    " get the 0_root begin.
    " first search backward to find the begin
    " it's a non list start with '^\S'
    let root_obj = {'bgn':row ,'parent': 'None','child':[],'indent':0}
    let l_chk = []
    let l_match = []
    let end = line('$')
    let [row,col] = searchpos('^\S','bc',0,100)
    while getline(row) =~ g:_riv_p.b_e_list && row != 0
        let [row,col] = searchpos('^\S','b',0,100)
    endwhile
    if row 
        let root_obj.bgn = row
        let root = row
    endif
    
    " we parse from bgn and check every non empty line 
    while 1

        let row = nextnonblank(row+1)
        let idt = indent(row)

        " check
        while !empty(l_chk)
            if idt <= l_chk[-1].indent
                let l_chk[-1].end = row-1
                call add(l_match,l_chk[-1])
                call remove(l_chk , -1)
            elseif row == end
                let l_chk[-1].end = row
                call add(l_match,l_chk[-1])
                call remove(l_chk , -1)
            else
                break
            endif
        endwhile
        

        if row == end
            break
        endif

        " add
        if getline(row) =~ g:_riv_p.b_e_list
            let l_obj = {'bgn':row,'indent':idt,'parent':0,'child':[]}
            call add(l_chk, l_obj)
        else
            if idt ==  0 
                break
            endif
        endif
    endwhile
    let root_obj.end = row
    call sort(l_match,"s:sort_match")

    " set obj dict
    let obj_dic = { root : root_obj , 'root': root_obj}
    let p_obj = root_obj
 
    for m in l_match
        let idt = m.indent
        let end = m.end
        
        " when  idt < prev, we will find the paren tindent which <= idt
        if idt < p_obj.indent
            while idt < p_obj.indent && p_obj.parent != 'None'
                let p_obj = s:get_parent(p_obj, obj_dic)
            endwhile
        endif

        if idt > p_obj.indent
        " if it's idt > prev one, and end <= prev end 
        " then it's prev's child
            " find prev's parent and if end <= p_end , add child
            while end > p_obj.end && p_obj.parent != 'None'
                let p_obj = s:get_parent(p_obj, obj_dic)
            endwhile
            call s:add_child(p_obj, m, obj_dic)
        elseif idt == p_obj.indent
        " if it's idt == prev one, and end <= prev's parents end 
        " then it's prev's brother (prev's parent's child)
            let p_par = p_obj 
            while end > p_par.end && p_par.parent != 'None'
                let p_par = s:get_parent(p_par, obj_dic)
            endwhile
            let m.parent = p_par.bgn
            call s:add_child(p_par, m, obj_dic)
        endif

        let p_obj = m
            
        let obj_dic[m.bgn] = m
    endfor
    call setpos('.',savepos)
    
    let b:riv_l_dic = obj_dic
    return obj_dic

endfun "}}}
fun! s:dic2line(o) "{{{
    let lines = []
    let o = a:o
    let dic = b:riv_l_dic
    call add(lines, repeat(' ',dic[o].indent) . ':'. dic[o].bgn )
    if !empty(dic[o].child)
        for child in dic[o].child
            call extend(lines, s:dic2line(child))
        endfor
    endif
    return lines
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
