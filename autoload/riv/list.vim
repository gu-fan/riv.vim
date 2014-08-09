"=============================================
"    Name: list.vim
"    File: list.vim
" Summary: bullet list and enum list
"  Author: Rykka G.F
"  Update: 2012-07-07
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:p = g:_riv_p
let s:e = g:_riv_e
" Search Relation: "{{{
" the searchpos and setpos version
" it's heavy though.
fun! s:get_all_list(row) "{{{
    " return the current list's row number
    " return 0 if not exists.
    
    let row = prevnonblank(a:row)

    let save_pos = getpos('.')
    call cursor(row,1)

    while getline(row) !~ s:p.all_list && row != 0
        let idt = indent(row)
        if idt == 0 
            let row = 0
            break
        endif
        let idt_ptn = '^\s\{,'.(idt-1).'}\S'
        let [row,col] = searchpos(idt_ptn, 'b',0,100)
    endwhile
    
    call setpos('.',save_pos)

    return row
endfun "}}}
fun! s:get_list(row) "{{{
    let row = prevnonblank(a:row)

    let save_pos = getpos('.')
    call cursor(row,1)

    while getline(row) !~ s:p.b_e_list && row != 0
        let idt = indent(row)
        if idt == 0 
            let row = 0
            break
        endif
        let idt_ptn = '^\s\{,'.(idt-1).'}\S'
        let [row, col] = searchpos(idt_ptn, 'b',0,100)
    endwhile
    
    call setpos('.',save_pos)

    return row
endfun "}}}
fun! s:get_older(row) "{{{
    " check if a list item have an older item, 
    " which have same indent with the list item ,
    " and no between line's indent < them
    let row = s:get_list(a:row)
    if row == 0
        return 0
    else

        let save_pos = getpos('.')
        call cursor(row,1)

        let c_idt = indent(row)

        let idt_ptn = '^\s\{,'.c_idt.'}\S'
        let [row,col] = searchpos(idt_ptn, 'b',0,100)
        let idt = indent(row)
        
        while getline(row) !~ s:p.b_e_list && row != 0
            if idt <= c_idt
                let row = 0
                break
            endif
            let idt_ptn = '^\s\{,'.idt.'}\S'
            let [row,col] = searchpos(idt_ptn, 'b',0,100)
            let idt = indent(row)
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
        if c_idt == 0 
            return 0
        endif
        let idt_ptn = '^\s\{,'.(c_idt-1).'}\S'

        call cursor(row,1)
        let [row,col] = searchpos(idt_ptn, 'b',0,100)
        let idt = indent(row)
        
        while getline(row) !~ s:p.b_e_list && row != 0
            if idt == 0 
                let row = 0
                break
            endif
            let idt_ptn = '^\s\{,'.idt.'}\S'
            let [row,col] = searchpos(idt_ptn, 'b',0,100)
            let idt = indent(row)
        endwhile

        call setpos('.',save_pos)

        return idt < c_idt ? row : 0
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

fun! riv#list#get_all_list(row) "{{{
    return s:get_all_list(a:row)
endfun "}}}
fun! riv#list#get_list(row) "{{{
    return s:get_list(a:row)
endfun "}}}
fun! riv#list#get_older(row) "{{{
    return s:get_older(a:row)
endfun "}}}
fun! riv#list#get_parent(row) "{{{
    return s:get_parent(a:row)
endfun "}}}
"}}}

" List: "{{{
fun! s:new_list_item(act) "{{{
    " create new list with act: 
    " '1'  : child 
    " '0'  : new
    " '-1' : parent
  
    let row = line('.')
    let cur_list = s:get_all_list(row)
    if cur_list == 0
        let list_str = s:list_str(1 , '', '' , "*", " ") 
    else
        let line = getline(cur_list)

        " if it's field list , then just use it's indent.
        if line =~ s:p.field_list
            let idt = repeat(' ', indent(cur_list))
            let line = getline('.')
            let line = substitute(line, '^\s*', idt, '')
            call setline(row, line)
            return
        endif

        let is_roman = s:is_roman(cur_list)
        let idt = ''

        let [type , idt , num , attr, space] = 
                    \ riv#list#stat(line, is_roman)
        if type == -1
            return s:list_str(1 , '', '' , "*", " ") 
        endif

        if a:act == 1
            " calc the child idt
            let idt = idt . space . repeat(' ',len(num.attr))

            let level = s:stat2level(type, num, attr) 
            let [type,num,attr] = s:level2stat(level+1)
        elseif a:act == -1
            let parent = s:get_parent(cur_list)
            if parent
                " use parent's attributes
                let is_roman = s:is_roman(parent)
                let [type , idt , num , attr, space] = 
                            \ riv#list#stat(getline(parent), is_roman)
                let num = s:next_list_num(num, is_roman)
            else
                let level = s:stat2level(type, num, attr) 
                let [type,num,attr] = s:level2stat(level-1)
                let idt = substitute(idt, repeat(' ',len(num.attr)+1),'','')
            endif
        else
            let num = s:next_list_num(num, is_roman)
        endif
        let list_str = s:list_str(type,idt,num,attr,space)
    endif
    let line = getline('.')
    let line = substitute(line, '^\s*', list_str, '')
    
    call setline(row, line)
endfun "}}}
fun! riv#list#new(act) "{{{
    " For Sub and Sup List, insert two line if it's not blank
    " Else check the blank line before.
    let row = line('.')
    let line_c = getline(row)
    let line_p = getline(row-1)
    let cmd = ''
    if a:act == 0
        if line_c =~ '\S'
            let cmd .= "\<CR>"
        endif
    else
        if line_c =~ '\S'
            let cmd .= "\<CR>\<CR>"
        elseif line_p =~ '\S' && line_c !~ '\S'
            let cmd .= "\<CR>"
        endif
    endif
    
    exe "norm! \<Esc>gi\<C-G>u".cmd

    call s:new_list_item(a:act)

    norm! $

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

fun! riv#list#stat(line,...) "{{{
    " return [type , idt , num , attr, space]
    " [1,' ', 1, '*', ' ']
    let is_roman = a:0 ? a:1 : 0
    let ma = matchlist(a:line, s:p.list_checker)
    let idt = matchstr(a:line,'^\s*')
    if empty(ma)
        return [-1,idt,0,0,0]
    endif
    if !empty(ma[1])
        return [1, idt, '' , ma[1], ma[8]]
    elseif !empty(ma[2])
        let len= len(ma[2])
        return [2,idt,ma[2][  : len-2], ma[2][len-1], ma[8]]
    elseif !empty(ma[3]) 
        let len= len(ma[3])
        return [3,idt,ma[3][1 : len-2], "()", ma[8]]
    elseif !empty(ma[4]) 
        " we should check if 'i. ... d.' is a roman numeral or alphabet
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
fun! s:list_str(type,idt,num,attr, space) "{{{
    if a:attr == "()"
        return a:idt ."(".a:num .")" . a:space
    else
        return a:idt . a:num .  a:attr . a:space
    endif
endfun "}}}

fun! s:num2nr(num,...) "{{{
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
fun! s:nr2num(n,type) "{{{
    " return alphabet are all '\u'
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
    if a:num == '' || a:num == '#'
        return a:num
    elseif a:num =~ '\d\+'
        return a:num+1
    elseif a:num =~ '^[A-Za-z]$' &&
            \ ( match(a:num, '\c[imlcxvd]') == -1 || is_roman == 0)
        if a:num=="z"
            return "z"
        elseif a:num=="Z"
            return "Z"
        else
            return nr2char(char2nr(a:num)+1)
        endif
    elseif a:num =~ '\c[imlcxvd]\+'
        let nr =riv#roman#to_nr(toupper(a:num))
        if a:num =~ '\U'
            return tolower(riv#roman#from_nr(nr+1))
        else
            return riv#roman#from_nr(nr+1)
        endif
    endif
endfun "}}}

" Level and stats "{{{
"    *   +   -             =>
"    1.  A.  a.  I.  i.    =>
"    1)  A)  a)  I)  i)    =>
"   (1) (A) (a) (I) (i)
fun! riv#list#level(line,...) "{{{
    let is_roman = a:0 ? a:1 : 0
    let [type , idt , num , attr, space] = riv#list#stat(a:line,is_roman)
    if type!=-1
        return s:stat2level(type,num,attr)
    else
        return -1
    endif
endfun "}}}
" type num attr
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
"}}}

fun! s:list_object(line) "{{{
    " groups: indent, attr , white
    return riv#ptn#match_object(a:line,s:p.list_white)
endfun "}}}
fun! s:rmv_list(line) "{{{
    return substitute(a:line,s:p.list_white, '\1','')
endfun "}}}

fun! riv#list#fix_col(col,item_end,sft) "{{{
    " fix col pos base on item_end and shift length.
    if a:col > a:item_end
        return a:col + a:sft
    elseif ( a:item_end + a:sft <= a:col && a:item_end >= a:col )
        return a:item_end + a:sft 
    else
        return a:col
    endif
endfun "}}}

fun! riv#list#delete() "{{{
    let [row, col] = [line('.'), col('.')]
    let line = getline(row)
    let prv_len = strwidth(line)
    let end = matchend(line, s:p.b_e_list)
    if end!= -1
        let line = s:rmv_list(line)
        call setline(row,line)
        call cursor(row, riv#list#fix_col(col, end, (strwidth(line) - prv_len)))
    else
        call riv#warning(s:e.NOT_LIST_ITEM)
    endif
endfun "}}}
" the type are '*' , '1.' , 'a.' , 'A)' ,'i)'
let s:change_levels = [0,3,5,9,12]
fun! riv#list#change(id) "{{{
    let [row, col] = [line('.'), col('.')]
    let line = getline(row)
    
    let prv_len = strwidth(line)
    let end = matchend(line, g:_riv_p.b_e_list)
    
    let id = a:id>=len(s:change_levels) ? len(s:change_levels)-1 : a:id
    let [type,num,attr] = s:level2stat(s:change_levels[id])
    let list_str = s:list_str(type,'',num,attr,'')
    if end == -1
        let line = substitute(line, '^\s*', '\0'.list_str.' ', '')
    else
        let line = substitute(line, s:p.list_white , '\1'.list_str.'\3', '')
    endif
    call setline(row, line)
    call cursor(row, riv#list#fix_col(col, end, (strwidth(line) - prv_len)))
endfun "}}}

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
        let prv_ls_end = matchend(line, s:p.b_e_list)
        let level = s:stat2level(type, num, attr) 
        if a:i == 0
            let list_str = idt
        else
            let [type,num,attr] = s:level2stat(level+a:i)
            let list_str = s:list_str(type,idt,num,attr,space)
        endif
        let line = substitute(line, s:p.b_e_list , list_str, '')
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

fun! riv#list#toggle() "{{{
    " toggle current list item
    let end = matchend(getline('.'), s:p.b_e_list)
    if end!= -1
        call riv#list#delete()
    else
        call riv#list#change(0)
    endif
endfun "}}}

fun! riv#list#fixed_col(row,col,sft) "{{{
    " add prev line idt
    " check block indent
    " if it's in list context
    "   if row is not list, use it's indent
    "   if row is list , use parent indent when "-" 
    "                    use older indent when "+"
    " else check exp mark
    let pnb_row = prevnonblank(a:row - 1)
    if pnb_row == 0
        return a:col + a:sft
    endif
    let f_idts = [indent(pnb_row)+1]
    
    let blk_row = riv#ptn#get(g:_riv_p.literal_block, a:row)
    if blk_row
        let f_idts += [indent(blk_row)+1+&sw]
    endif

    let lst_row = riv#list#get_all_list(a:row)
    if lst_row 
        if a:row != lst_row
            let lst_idt = indent(lst_row)+1
            let lst_cdt  =riv#list#get_con_idt(getline(lst_row))
            let f_idts += [lst_idt,lst_cdt]
        else
            if a:sft > 0 
                let old_row = riv#list#get_older(lst_row)
            elseif a:sft < 0
                let old_row = riv#list#get_parent(lst_row)
            endif
            if exists("old_row") && old_row
                let old_idt = indent(old_row)+1
                let old_cdt  =riv#list#get_con_idt(getline(old_row))
                let f_idts += [old_idt, old_cdt]
            endif
        endif
    else
        let exp_row = riv#ptn#get(g:_riv_p.exp_mark, a:row)
        if exp_row
            let exp_cdt = riv#ptn#exp_con_idt(getline(exp_row))
            let f_idts += [exp_cdt]
        endif
    endif

    return riv#ptn#fix_sfts(a:col,f_idts,a:sft)
endfun "}}}
fun! riv#list#fixed_sft(row,col,sft) "{{{
    return riv#list#fixed_col(a:row,a:col,a:sft) - a:col
endfun "}}}

fun! riv#list#shift(direction) range "{{{
    " direction "+" or "-" or "="
    let line = getline(a:firstline) 
    let [row,col]  = [a:firstline, indent(a:firstline)+1]

    " calculate shifting with a:firstline
    if a:direction == '+'
        let vec = riv#list#fixed_sft(row,col,&sw)
    elseif a:direction == "-"
        let vec = riv#list#fixed_sft(row,col,-&sw)
    else
        let vec = 0
    endif

    " A fix shift idt list
    " [0,fix1,fix2,....] 
    " each item's index is one indent level,
    " the value is for the line which > the indent.
    " so a line's fix is sft_fix[line-1]
    "
    " let c_idt = indent(line)
    " if c_idt > len
    "   add item to fill to sft_idt[c_idt]
    " if c_idt < len
    "   trunc sft_idt to sft_idt[c_idt]
    "   
    " apply sft_fix[c_idt-1] 
    " if it's a list , calc the new idt (sft_fix[c_idt-1] + n_item_len-p_item_len ) 
    
    let s:sft_fix = [0]
    if a:firstline == a:lastline
        call s:shift_vec(a:firstline, vec,0)
        call cursor(line('.'), col('.')+vec)
    else
        for line in range(a:firstline,a:lastline)
            call s:shift_vec(line, vec,1)
        endfor
        normal! gv
    endif
endfun "}}}
fun! s:shift_vec(row,vec,...) "{{{
    let line = getline(a:row)
    if line =~ '^\s*$' | return | endif

    let indent = indent(a:row)
    
    " change the sft_fix list length to current indent + 2
    " s:sft_fix[indent] is the fix indent for same indent with current row
    " s:sft_fix[indent+1] for indent > current row
    let len = len(s:sft_fix)
    if indent > len - 2 
        let l = map(range(indent-len+2), 's:sft_fix[-1]')
        call extend(s:sft_fix, l )
    elseif indent < len - 2 
        call remove(s:sft_fix, (indent+2), -1)
    endif
    " apply the indent fix
    let cur_indent = indent + a:vec + s:sft_fix[indent]
    let line = s:set_idt(line, cur_indent)

    let is_roman = s:is_roman(a:row)
    let [type , idt , num , attr, space] =  riv#list#stat(line, is_roman)
    let nr = s:num2nr(num, is_roman)

    if type != -1 && a:vec != 0
        if a:vec > 0
            let level = s:stat2level(type, num, attr) 
            let [type,num,attr] = s:level2stat(level+1)
        elseif a:vec < 0
            let level = s:stat2level(type, num, attr) 
            let [type,num,attr] = s:level2stat(level-1)
        endif
    
        let num = num=~'\U' ? tolower(s:nr2num(nr,type)) : s:nr2num(nr,type)

        let p_len = len(line)
        let line = substitute(line, s:p.b_e_list,
                    \ s:list_str(type,idt,num,attr,space), '')
        let s:sft_fix[indent+1] = s:sft_fix[indent] +  len(line) - p_len
    endif

    call setline(a:row,line)

    if type != -1
        call s:fix_nr(a:row,indent)
    endif
endfun "}}}
fun! s:fix_nr(row, indent) "{{{
    " fix list nr , based on previous list item if exists, else use 1
    let line = getline(a:row)
    let older = s:get_older(a:row)
    if older 
        let is_roman = s:is_roman(older)
        let [type , idt , num , attr, space] = riv#list#stat(getline(older),
                                                \is_roman)
        let nr = s:num2nr(num, is_roman) + 1
    else
        let [type , idt , num , attr, space] = riv#list#stat(line, s:is_roman(a:row))
        let nr = 1
    endif
    let num = num=~'\U' ? tolower(s:nr2num(nr,type)) : s:nr2num(nr,type)
    let p_len = len(line)
    let line = substitute(line, s:p.b_e_list,
                \ s:list_str(type,idt,num,attr,space), '')
    let s:sft_fix[a:indent+1] += len(line) - p_len
    call setline(a:row,line)
endfun "}}}
fun! s:set_idt(line, indent) "{{{
    if a:indent > 0
        return substitute(a:line, '^\s*', repeat(' ', a:indent), '')
    else
        return substitute(a:line, '^\s*', '', '')
    endif
endfun "}}}

fun! riv#list#get_con_idt(line) "{{{
    return matchend(a:line, s:p.all_list)+1  
endfun "}}}

fun! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun "}}}
fun! riv#list#SID() "{{{
    return '<SNR>'.s:SID().'_'
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
