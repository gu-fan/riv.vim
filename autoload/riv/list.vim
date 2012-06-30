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
    let c_row = prevnonblank(a:row)
    if getline(c_row) =~ g:_riv_p.list_all       " it's list
        return c_row
    else
        let c_idt = indent(c_row)
        if c_idt == 0       " it's '^\S'
            return 0
        else
            let save_pos = getpos('.')
            let [row,col] = searchpos(g:_riv_p.list_all.'|^\S', 'wnb',0,100)
            let s_idt = indent(row)
            while c_idt <= s_idt        " find a list have less indent
                if getline(row) =~ '^\S'
                    let row = 0
                    break         " could not find a list.
                endif
                " goto prev line
                exe prevnonblank(row-1)
                let [row,col] = searchpos(g:_riv_p.list_all.'|^\S', 'wnb',0,100)
                let s_idt = indent(row)
            endwhile
            call setpos('.',save_pos)
            return row
        endif
    endif
endfun "}}}
fun! s:get_list(row) "{{{
    " To find if a row is in  a list's arrange. 
    " this list's indent should smaller than current line (when not list).
    " return 0 if break by none list '^\S'.

    let c_row = prevnonblank(a:row)
    if getline(c_row) =~ g:_riv_p.list_b_e       " it's list
        return c_row
    else
        let c_idt = indent(c_row)
        if c_idt == 0       " it's '^\S'
            return 0
        else
            let save_pos = getpos('.')
            let [row,col] = searchpos(g:_riv_p.list_b_e.'|^\S', 'wnb',0,100)
            let s_idt = indent(row)
            while c_idt <= s_idt        " find a list have less indent
                if getline(row) =~ '^\S'
                    let row = 0
                    break         " could not find a list.
                endif
                " goto prev line
                exe prevnonblank(row-1)
                let [row,col] = searchpos(g:_riv_p.list_b_e.'|^\S', 'wnb',0,100)
                let s_idt = indent(row)
            endwhile
            call setpos('.',save_pos)
            return row
        endif
    endif
endfun "}}}
fun! s:get_older(row) "{{{
    " check if a list item have an older .
    let c_row = s:get_list(a:row)
    if c_row == 0
        return 0
    else
        let save_pos = getpos('.')
        exe prevnonblank(c_row-1)
        let c_idt = indent(c_row)
        let [row,col] = searchpos(g:_riv_p.list_b_e.'|^\S', 'wnb',0,100)
        let s_idt = indent(row)
        while c_idt < s_idt    " find a list have 
                               " same list level           
            if getline(row) =~ '^\S'
                let row = 0
                break         " could not find a list.
            endif
            " goto prev line
            exe prevnonblank(row-1)
            let [row,col] = searchpos(g:_riv_p.list_b_e.'|^\S', 'wnb',0,100)
            let s_idt = indent(row)
        endwhile
        call setpos('.',save_pos)
        if s_idt == c_idt
            return getline(row) =~ '^\S' ? 0 : row
        else
            return 0
        endif
    endif
endfun "}}}
fun! s:get_parent(row) "{{{
    " check if a list item have an older .
    let c_row = s:get_list(a:row)
    if c_row == 0
        return 0
    else
        let c_idt = indent(c_row)
        if c_idt == 0
            return 0
        endif
        let save_pos = getpos('.')
        exe prevnonblank(c_row-1)
        let [row,col] = searchpos(g:_riv_p.list_b_e.'|^\S', 'wnb',0,100)
        let s_idt = indent(row)
        while c_idt <= s_idt  " find a list have 
                              " same list level           
            if getline(row) =~ '^\S'
                let row = 0
                break         " could not find a list.
            endif
            " goto prev line
            exe prevnonblank(row-1)
            let [row,col] = searchpos(g:_riv_p.list_b_e.'|^\S', 'wnb',0,100)
            let s_idt = indent(row)
        endwhile
        call setpos('.',save_pos)
        if s_idt < c_idt
            return row
        else
            return 0
        endif
    endif
endfun "}}}
fun! s:get_child(row) "{{{
    let child = []
    let c_row = s:get_list(a:row)
    if c_row == 0
        return child
    else
        let c_idt = indent(c_row)
        let save_pos = getpos('.')
        exe nextnonblank(c_row+1)
        let [row,col] = searchpos(g:_riv_p.list_b_e.'|^\S', 'wn',0,100)
        let s_idt = indent(row)
        while c_idt < s_idt
            if getline(row) =~ '^\S'
                break
            else 
                call add(child, row)
            endif
            " goto next line
            exe nextnonblank(row)
            let [row,col] = searchpos(g:_riv_p.list_b_e.'|^\S', 'wn',0,100)
            let s_idt = indent(row)
        endwhile
        call setpos('.',save_pos)
        return child
        endif
    endif
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
\ [2, '1', '.'], [4, 'A', '.'], [4, 'a', '.'], [6, 'I', '.'], [6, 'i', '.'], 
\ [2, '1', ')'], [4, 'A', ')'], [4, 'a', ')'], [6, 'I', ')'], [6, 'i', ')'], 
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

    " sub the line's indentation
    let line = substitute(line,'^\s*', repeat(' ',indent(a:row)),'g')
    if a:len>=0
        let act = 1
        let line = substitute(line,'^',repeat(' ',a:len),'')
    else
        let act = -1
        let line = substitute(line,'^\s\{,'.abs(a:len).'}','','')
    endif
    
    " when it's first and it's 'i', we should make sure it' roman.
    let is_roman = s:is_roman(a:row)
    let [type , idt , num , attr, space] =  riv#list#stat(line, is_roman)
    let nr = s:listnum2nr(num, is_roman)
    if type != -1
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
        let nr = s:listnum2nr(num, is_roman)
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
fun! riv#list#shift(direction) range "{{{
    " direction "+" or "-"
    " > to add indent, < to rmv indent 
    " if line is list then change bullet.
    let line = getline(a:firstline) 
    let [type , idt , num , attr, space] = riv#list#stat(line)
    if type == -1
        let ln = &shiftwidth
    else
        let ln = len(space) + len(num . attr)
    endif
    if a:direction=="-"
        let vec = -ln
    else
        let vec = ln
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
