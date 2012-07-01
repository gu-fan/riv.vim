"=============================================
"    Name: list.vim
"    File: list.vim
" Summary: the bullet list and enum list
"  Author: Rykka G.Forest
"  Update: 2012-06-30
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C


" Search Relation: "{{{
" the searchpos and setpos version
" it's heavy though.
fun! s:get_all_list(row) "{{{
    let row = prevnonblank(a:row)

    let save_pos = getpos('.')

    while getline(row) !~ g:_riv_p.list_all && row != 0
        let idt = indent(row)
        if idt == 0 
            let row = 0
            break
        endif
        let idt_ptn = '^\s\{,'.(idt-1).'}\S'
        call cursor(prevnonblank(row-1),1)
        let [row,col] = searchpos(idt_ptn, 'nbc',0,100)
    endwhile
    
    call setpos('.',save_pos)

    return row
endfun "}}}
fun! s:get_list(row) "{{{
    let row = prevnonblank(a:row)

    let save_pos = getpos('.')

    while getline(row) !~ g:_riv_p.list_b_e && row != 0
        let idt = indent(row)
        if idt == 0 
            let row = 0
            break
        endif
        let idt_ptn = '^\s\{,'.(idt-1).'}\S'
        call cursor(prevnonblank(row-1),1)
        let [row,col] = searchpos(idt_ptn, 'nbc',0,100)
    endwhile
    
    call setpos('.',save_pos)

    return row
endfun "}}}
fun! s:get_list_(row) "{{{
    " To find if a row is in  a list's range. 
    " this list's indent should smaller than current line (when not list).
    " return 0 if '^\S' or not find

    let c_row = prevnonblank(a:row)
    if getline(c_row) =~ g:_riv_p.list_b_e
        return c_row 
    else
        let c_idt = indent(c_row)
        if c_idt == 0 
            return 0
        endif
        let idt_ptn = '^\s{,'.(c_idt-1).'}\S'
        let ptn = g:_riv_p.list_b_e.'|'.idt_ptn
        let save_pos = getpos('.')

        let row = c_row
        let s_idt = c_idt + 1
        while ( getline(row) !~ g:_riv_p.list_b_e || s_idt>= c_idt ) && row!=0
            call cursor(prevnonblank(row-1),1)
            let [row,col] = searchpos(ptn, 'wnbc',0,100)
            if s_idt == 0
                let row =0
                break
            endif
            if s_idt < c_idt 
                let c_idt = s_idt
            endif
            let s_idt = indent(row)
        endwhile

        call setpos('.',save_pos)
        return row
    endif
endfun "}}}
fun! s:get_older(row) "{{{
    " check if a list item have an older item, 
    " which have same indent with it
    let row = s:get_list(a:row)
    if row == 0
        return 0
    else

        let save_pos = getpos('.')

        let c_idt = indent(row)
        let idt = c_idt

        let idt_ptn = '^\s\{,'.idt.'}\S'
        call cursor(prevnonblank(row-1),1)
        let [row,col] = searchpos(idt_ptn, 'nbc',0,100)
        
        while getline(row) !~ g:_riv_p.list_b_e && row != 0
            let idt = indent(row)
            if idt <= c_idt
                let row = 0
                break
            endif
            let idt_ptn = '^\s\{,'.idt.'}\S'
            call cursor(prevnonblank(row-1),1)
            let [row,col] = searchpos(idt_ptn, 'nbc',0,100)
        endwhile

        call setpos('.',save_pos)

        return idt == c_idt ? row : 0
    endif
endfun "}}}
fun! s:get_parent(row) "{{{
   
    let row = s:get_list(a:row)
    if row == 0
        return 0
    else

        let save_pos = getpos('.')

        let c_idt = indent(row)
        let idt = c_idt

        let idt_ptn = '^\s\{,'.(idt-1).'}\S'
        call cursor(prevnonblank(row-1),1)
        let [row,col] = searchpos(idt_ptn, 'nbc',0,100)
        
        while getline(row) !~ g:_riv_p.list_b_e && row != 0
            let idt = indent(row)
            let idt_ptn = '^\s\{,'.idt.'}\S'
            call cursor(prevnonblank(row-1),1)
            let [row,col] = searchpos(idt_ptn, 'nbc',0,100)
        endwhile

        call setpos('.',save_pos)

        return idt < c_idt ? row : 0
    endif
endfun "}}}
fun! s:get_tree(start,end) "{{{
    " create root and get children
    
endfun "}}}
fun! s:check_l() "{{{
    
endfun "}}}
fun! s:add_l() "{{{
    
endfun "}}}
fun! s:set_obj() "{{{
    
endfun "}}}

" the buf obj dict version.
" but should not rely on it.
" cause the buffer is always changing.
fun! s:buf_get_older(row) "{{{
    let c_row = s:get_list(a:row)
    if c_row == 0
        return 0
    else
        if !exists("b:riv_obj[c_row]")
            return s:get_older(c_row)
        endif
        let obj = b:riv_obj[c_row]
        let older = riv#fold#get_prev_brother(obj)

        if !empty(older) && nextnonblank(older.end+1) == obj.bgn
            return older.bgn
        endif
        return 0
    endif
endfun "}}}
fun! s:buf_get_parent(row) "{{{
    let c_row = s:get_list(a:row)
    if c_row == 0
        return 0
    else
        if !exists("b:riv_obj[c_row]")
            return s:get_parent(c_row)
        endif
        let parent = b:riv_obj[b:riv_obj[c_row].parent]
        if !empty(parent) && parent.bgn != 'list_root'
            return parent.bgn
        endif
        return 0
    endif
endfun "}}}
fun! s:buf_get_child(row) "{{{
    let c_row = s:get_list(a:row)
    if c_row == 0
        return 0
    else
        if !exists("b:riv_obj[c_row]")
            return s:get_child(c_row)
        endif
        return  b:riv_obj[c_row].child
    endif
    
endfun "}}}
"}}}

" List Level: "{{{
fun! riv#list#new(act) "{{{
    " change the list type of current line with act: '1' , '0' ,'-1'
    " used to create new list, child list, parent list
    let row = line('.')
    let cur_list = s:get_all_list(row)
    if cur_list == 0
        let list_str = s:list_str(1 , '', '' , "*", " ") 
    else
        let line = getline(cur_list)

        " if it's field list , then just use it's indent.
        if line =~ g:_riv_p.field_list_spl
            let idt = repeat(' ', indent(cur_list))
            let line = getline('.')
            let line = substitute(line, '^\s*', idt, '')
            call setline(row, line)
            return
        endif
        if line =~ '^\c\s*(\=[imlcxvd][).]'
            let is_roman = s:is_roman(cur_list)
        else
            let is_roman = 0
        endif
        let idt = ''
        " create a parent list , we should find the parent's indent
        if a:act == -1
            let parent = s:get_parent(cur_list)
            let idt = parent ? repeat(' ',indent(parent)) : ''
        endif
        let list_str = riv#list#line_str(line, a:act, idt, is_roman)
    endif
    let line = getline('.')
    let line = substitute(line, '^\s*', list_str, '')
    call setline(row, line)
endfun "}}}
fun! riv#list#line_str(line, act, idt,...) "{{{
    " create the next list item by line
    let is_roman = a:0 ? a:1 : 0
    let [type , idt , num , attr, space] = 
                \ riv#list#stat(a:line, is_roman)
    if type == -1
        return s:list_str(1 , '', '' , "*", " ") 
    endif
    if a:act == 1
        let level = s:stat2level(type, num, attr) 
        let [type,num,attr] = s:level2stat(level+1)

        let idt = idt.space. repeat(' ',len(num.attr))
    elseif a:act == -1
        let level = s:stat2level(type, num, attr) 
        let [type,num,attr] = s:level2stat(level-1)
        let idt = a:idt
    else
        let num = s:next_list_num(num, is_roman)
    endif
    return s:list_str(type,idt,num,attr,space)
endfun "}}}
fun! s:is_roman(row) "{{{
    let line = getline(a:row)
    if line =~ '^\c\s*(\=[imlcxvd][).]\s'
        let older = s:get_older(a:row)
        if older==0 
            " if no older , then 'i' is roman
            return line =~ '^\c\s*(\=i[).]\s'
        else
            " if has older , then when older is 'rr' is roman
            return getline(older) =~ '^\c\s*(\=[imlcxvd]\{2,}[).]\s'
        endif
    else
        return line =~ '^\c\s*(\=[imlcxvd]\{2,}[).]\s'
    endif
endfun "}}}
"    *   +   -            =>
"    1.  A.  a.  I.  i.    =>
"    1)  A)  a)  I)  i)    =>
"   (1) (A) (a) (I) (i)
fun! riv#list#stat(line,...) "{{{
    " return [type , idt , num , attr, space]
    let is_roman = a:0 ? a:1 : 0
    let ma = matchlist(a:line, g:_riv_p.list_checker)
    if empty(ma)
        return [-1,0,0,0,0]
    endif
    let idt = matchstr(a:line,'^\s*')       " max 9 sub match reached.
    if !empty(ma[1])
        return [1, idt, '' , ma[1], ma[8]]
    elseif !empty(ma[2])
        let len= len(ma[2])
        return [2,idt,ma[2][  : len-2], ma[2][len-1], ma[8]]
    elseif !empty(ma[3]) 
        let len= len(ma[3])
        return [3,idt,ma[3][1 : len-2], "()", ma[8]]
    elseif !empty(ma[4]) 
        " we should check if 'i.' have prev smaller item.
        if ( match(ma[4], '\c[imlcxvd]') == -1 || is_roman == 0)
            return [4,idt,ma[4][0], ma[4][1], ma[8]]
        else
            return [6,idt,ma[4][0], ma[4][1], ma[8]]
        endif
    elseif !empty(ma[5]) 
        if ( match(ma[5], '\c[imlcxvd]') == -1 || is_roman == 0)
            return [5,idt,ma[5][1], "()", ma[8]]
        else
            return [7,idt,ma[5][1], "()", ma[8]]
        endif
    elseif !empty(ma[6])
        let len= len(ma[6])
        return [6,idt,ma[6][  : len-2], ma[6][len-1], ma[8]]
    elseif !empty(ma[7])
        let len= len(ma[7])
        return [7,idt,ma[7][1 : len-2], "()", ma[8]]
    endif
endfun "}}}
fun! s:listnum2nr(num,...) "{{{
    let is_roman = a:0 ? a:1 : 0
    if a:num == ''
        return 0
    elseif a:num =~ '\d\+'
        return a:num
    elseif a:num =~ '^[A-Za-z]$' &&
            \ ( match(a:num, '\c[imlcxvd]') == -1 || is_roman == 0)
        if a:num =~ '\u'
            return char2nr(a:num)-64
        else
            return char2nr(a:num)-96
        endif
    elseif a:num =~ '\c[imlcxvd]\+'
        return riv#roman#to_nr(toupper(a:num))
    endif
endfun "}}}
fun! s:nr2listnum(n,type) "{{{
    if a:type=='1'
        return ''
    elseif a:type=='2' || a:type=='3'
        return a:n<=0 ? 1 : a:n
    elseif a:type=='4' || a:type=='5'
        return a:n > 26 ? 'Z' : a:n <= 0 ? 'A' : nr2char(a:n+64)
    elseif a:type=='6' || a:type=='7'
        return riv#roman#from_nr(a:n)
    endif
endfun "}}}
fun! s:next_list_num(num,...) "{{{
    let is_roman = a:0 ? a:1 : 0
    if a:num == ''
        return a:num
    elseif a:num =~ '\d\+'
        return a:num+1
    elseif a:num =~ '^[A-Za-z]$' &&
            \ ( match(a:num, '\c[imlcxvd]') == -1 || is_roman == 0)
        if a:num=="z"
            return "a"
        elseif a:num=="Z"
            return "A"
        else
            return nr2char(char2nr(a:num)+1)
        endif
    elseif a:num =~ '\c[imlcxvd]\+'
        let nr =riv#roman#to_nr(toupper(a:num))
        if a:num!~ '\u\+'
            return tolower(riv#roman#from_nr(nr+1))
        else
            return riv#roman#from_nr(nr+1)
        endif
    endif
endfun "}}}
fun! s:list_str(type,idt,num,attr, space) "{{{
    if a:attr == "()"
        return a:idt ."(".a:num .")" . a:space
    else
        return a:idt . a:num .  a:attr . a:space
    endif
endfun "}}}
fun! riv#list#level(line,...) "{{{
    let is_roman = a:0 ? a:1 : 0
    let [type , idt , num , attr, space] = riv#list#stat(a:line,is_roman)
    if type!=-1
        return s:stat2level(type,num,attr)
    else
        return -1
    endif
endfun "}}}
let s:list_stats= [
\ [1, '',  '*'],  [1, '',  '+'] , [1, '',   '-'],
\ [2, '1', '.'],  [4, 'A', '.'],  [4, 'a', '.'],  [6, 'I', '.'],  [6, 'i', '.'], 
\ [2, '1', ')'],  [4, 'A', ')'],  [4, 'a', ')'],  [6, 'I', ')'],  [6, 'i', ')'], 
\ [3, '1', '()'], [5, 'A', '()'], [5, 'a', '()'], [7, 'I', '()'], [7, 'i', '()'],
\]
fun! s:stat2level(type, num, attr) "{{{
    " return level
    if a:type == 1
        return stridx('*+-', a:attr)
    elseif a:type == 2
        return stridx('.)', a:attr)*5  + 3
    elseif a:type == 3
        return  13
    else
        let is_lower = match(a:num,'\U')!=-1
        if a:type == 4
            return  4 + stridx('.)', a:attr)*5  +  is_lower
        elseif a:type == 5
            return  14 +  is_lower
        elseif a:type == 6
            return  6 + stridx('.)', a:attr)*5  +  is_lower
        elseif a:type == 7
            return  16 +  is_lower
        endif
    endif
    return 0
endfun "}}}
fun! s:level2stat(level) "{{{
    " return type , num , attr
    if a:level >= len(s:list_stats)
        return s:list_stats[-1]
    elseif a:level < 0
        return s:list_stats[0]
    endif
    return s:list_stats[a:level]
endfun "}}}
"}}}

fun! riv#list#toggle_type(i) "{{{
    " Change current list type with different level type
    let [row, col]= [line('.'), col('.')]
    let line = getline('.')
    if line =~ '^\c\s*(\=[imlcxvd][).]'
        let is_roman = s:is_roman(row)
    else
        let is_roman = 0
    endif
    let idt = matchstr(line, '^\s*')
    let [type , idt , num , attr, space] = riv#list#stat(line, is_roman)
    let prv_len = strwidth(line)
    if type==-1
        let prv_ls_end = matchend(line, '^\s*')
        let list_str = s:list_str(1 , '', '' , "*", " ") 
        let line = substitute(line, '^\s*', list_str, '')
    else
        let prv_ls_end = matchend(line, g:_riv_p.list_b_e)
        let level = s:stat2level(type, num, attr) 
        if a:i == 0
            let list_str = idt
        else
            let [type,num,attr] = s:level2stat(level+a:i)
            let list_str = s:list_str(type,idt,num,attr,space)
        endif
        let line = substitute(line, g:_riv_p.list_b_e , list_str, '')
    endif
    call setline(row, line)
    let mod_len = strwidth(line)
    let mod_ls_end = prv_ls_end + mod_len - prv_len
    if col >= prv_ls_end
        let sft = mod_ls_end - prv_ls_end
        call cursor(row, col + sft )
    elseif col <= prv_ls_end && col >= mod_ls_end
        call cursor(row, mod_ls_end )
    endif
endfun "}}}
fun! s:list_shift_len(row,len) "{{{
    let line = getline(a:row)
    if line=~ '^\s*$'
        return
    endif

    " sub the line's indentation
    let line = substitute(line,'^\s*', repeat(' ',indent(a:row)),'g')
    if a:len>0
        let act = 1
        let line = substitute(line,'^',repeat(' ',a:len),'')
    elseif a:len< 0
        let act = -1
        let line = substitute(line,'^\s\{,'.abs(a:len).'}','','')
    else
        let act = 0
    endif
    
    " when it's first and it's 'i', we should make sure it' roman.
    let is_roman = s:is_roman(a:row)
    let [type , idt , num , attr, space] =  riv#list#stat(line, is_roman)
    let nr = s:listnum2nr(num, is_roman)
    if type != -1 && act != 0
        if act == 1
            let level = s:stat2level(type, num, attr) 
            let [type,num,attr] = s:level2stat(level+1)
        elseif act == -1
            let level = s:stat2level(type, num, attr) 
            let [type,num,attr] = s:level2stat(level-1)
        endif

        if num =~ '\u'
            let num = toupper(s:nr2listnum(nr,type))
        else
            let num = tolower(s:nr2listnum(nr,type))
        endif
        let list_str =  s:list_str(type,idt,num,attr,space)
        let line = substitute(line, g:_riv_p.list_b_e , list_str, '')
    endif

    call setline(a:row,line)

    if type != -1
        call s:fix_nr(a:row)
    else
        call s:fix_idt(a:row)
    endif
endfun "}}}
fun! s:fix_idt(row) "{{{
    " if it's not a list , then the indent should fixed based on current list
    let list = s:get_list(a:row-1)
    let line = getline(a:row)
    if list
        let f_idt = matchend(getline(list), g:_riv_p.list_all)
        let idt = matchend(line,'^\s*')
        " if the ident is between the fix + item len and indent
        if (idt > indent(list) && idt <= f_idt+s:get_item_length(list) )
            \ || (idt == indent(list) && list == a:row-1)
            let line = substitute(line, '^\s*', repeat(' ',f_idt), '')
            call setline(a:row,line)
        endif
    endif
endfun "}}}

fun! s:fix_nr(row) "{{{
    " nr are based on previous list item
    let line = getline(a:row)
    let older = s:get_older(a:row)
    if older 
        let is_roman = s:is_roman(older)
        let oline = getline(older)
        let [type , idt , num , attr, space] = riv#list#stat(oline, is_roman)
        let onr = s:listnum2nr(num, is_roman)
        let nr = onr + 1
    else
        let is_roman = s:is_roman(a:row)
        let [type , idt , num , attr, space] = riv#list#stat(line, is_roman)
        " let nr = s:listnum2nr(num, is_roman)
        let nr = 1
    endif
    if num =~ '\u'
        let num = toupper(s:nr2listnum(nr,type))
    else
        let num = tolower(s:nr2listnum(nr,type))
    endif
    let list_str =  s:list_str(type,idt,num,attr,space)
    let line = substitute(line, g:_riv_p.list_b_e , list_str, '')
    call setline(a:row,line)
endfun "}}}
fun! s:get_item_length(row) "{{{
    let end = matchend(getline(a:row), g:_riv_p.list_all)
    if end != -1
        return end - indent(a:row)
    else
        return 0
    endif
endfun "}}}
fun! riv#list#shift(direction) range "{{{
    " direction "+" or "-" or "="
    " if firstline is list then whole indent based on parent item
    " if it's not list, then whole indent based on shiftwidth
    " the list in it will change it's level and number
    let line = getline(a:firstline) 
    if a:direction !="="
        let end =  matchend(getline(a:firstline), g:_riv_p.list_all)
        if end != -1
            let ln = end - indent(a:firstline)
        else
            let ln = &shiftwidth
        endif
    endif
    if a:direction=='-'
        let prev = s:get_parent(a:firstline)
        " if has parent, and the sft is smaller or equal than idt
        " shift to parent
        if prev 
            let sft = indent(a:firstline) - indent(prev)
            if sft <= ln
                let ln = sft
            endif
        endif
    elseif a:direction == "+"
        let prev = s:get_older(a:firstline)
        if prev 
            " if has older , use older's item length
            let ln = matchend(getline(prev), g:_riv_p.list_all) - indent(prev)
        endif
    endif
    if a:direction=="-"
        let vec = -ln
    elseif a:direction =="+"
        let vec = ln
    else
        let vec = 0
    endif
    if a:firstline == a:lastline
        call s:list_shift_len(a:firstline, vec)
        call cursor(line('.'), col('.')+vec)
    else
        for line in range(a:firstline,a:lastline)
            call s:list_shift_len(line, vec)
        endfor
        normal! gv
    endif
endfun "}}}

fun! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun "}}}
fun! riv#list#SID() "{{{
    return '<SNR>'.s:SID().'_'
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
