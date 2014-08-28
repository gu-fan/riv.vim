"=============================================
"    Name: table.vim
"    File: table.vim
" Summary: Grid table
"  Author: Rykka G.F
"  Update: 2012-07-16
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:p = g:_riv_p

fun! riv#table#format() "{{{
    " if g:_riv_c.has_py
        " exe g:_riv_c.py ."GetTable().format_table()"
    " else
        call s:get_table().format_table()
    " endif
endfun "}}}
fun! riv#table#newline(type) "{{{
    " if g:_riv_c.has_py
        " exe g:_riv_c.py ."GetTable().add_line(typ='".a:type."')"
    " else
        call s:get_table().add_line(a:type)
    " endif
endfun "}}}

fun! riv#table#create() "{{{

    let row = str2nr(input('Input row number of table:'))
    let col = str2nr(input('Input column number of table:'))
    let cont = map(range(col),'" "')
    let sep = ['|S']

    let list = map(range(2*row),'cont')
    for i in range(len(list))
        if i % 2 == 0
            let list[i] = sep
        endif
    endfor
    
    let table = s:grid_table.new(list)
    
    let lines = table.lines(0) 
    if getline('.') !~ '^\s*$'
        let lines = [""] + lines
    endif
    if getline(line('.')+1) !~ '^\s*$'
        let lines = lines + [""]
    endif
    call append(line('.'),lines)

endfun "}}}

fun! riv#table#format_pos() "{{{
    let pos = getpos('.')
    if getline('.') =~ s:p.table
        noa call riv#table#format()
        call setpos('.',pos)
        " It may get folded after formating.
        if foldclosed(pos[1])!=-1
            foldopen!
        endif
    endif
endfun "}}}

fun! riv#table#nextcell() "{{{
    if getline('.') =~ s:p.table
        return searchpos(s:p.cell.'|^\s*$' ,'Wn')   
    endif
    return [0,0]
endfun "}}}
fun! riv#table#prevcell() "{{{
    if getline('.') =~ s:p.table
        return searchpos(s:p.cell.'|^\s*$','Wbn')   
    endif
    return [0,0]
endfun "}}}

function! riv#table#prevline() "{{{
    let row = line('.')-1
    call cursor(row, col('.'))
    if getline('.') =~ s:p.table
        return searchpos(s:p.cell.'|^\s*$' ,'Wbnc')
    elseif getline('.') =~ s:p.table_fence
        call cursor(row-1, col('.'))
        return searchpos(s:p.cell.'|^\s*$' ,'Wbnc')
    else
        return [0,0]
    endif
endfunction "}}}
function! riv#table#nextline() "{{{
    let row = line('.')+1
    call cursor(row, col('.'))
    if getline('.') =~ s:p.table_line
        return searchpos(s:p.cell.'|^\s*$' ,'Wbnc')
    elseif getline('.') =~ s:p.table_fence
        call cursor(row+1, col('.'))
        return searchpos(s:p.cell.'|^\s*$' ,'Wbnc')
    else
        return [0,0]
    endif
endfunction "}}}

" table parse "{{{

fun! s:get_table_range(row) "{{{
    let row = a:row
    if getline(row) !~ s:p.table
        return [0, 0]
    endif

    let [bgn,end] = [row, row]

    for i in range(row,1,-1)
        if getline(i) =~ s:p.table
            let bgn = i
        else
            break
        endif
    endfor
    
    for i in range(row,line('$'))
        if getline(i) =~ s:p.table
            let end = i
        else
            break
        endif
    endfor
    return [bgn,end]
endfun "}}}
fun! s:table_in_range(bgn,end) "{{{
    " first get a list of columns of each row
    " then convert the list to a table object.

    let max_col = 0
    let rows = []
    for i in range(a:bgn,a:end)
        let line = getline(i)
        if line =~ s:p.table_mline
            let cols = map(riv#ptn#match_obj_list(line, s:p.table_cell),'v:val.str')
            let c_len = len(cols)
            if max_col < c_len
                let max_col = c_len
            endif
            call add(rows,cols)
        elseif line =~ s:p.table_sepr
            call add(rows,['|S'])
        elseif line =~ s:p.table_head
            call add(rows,['|H'])
        endif
    endfor
    
    return s:grid_table(rows)
endfun "}}}

let s:get_table = {}
fun! s:get_table(...) "{{{
    return a:0 ? s:get_table.new(a:1) : s:get_table.new()
endfun "}}}
fun! s:get_table.new(...)  dict "{{{
    " get the table object of row
    
    let row = a:0 ? a:1 : line('.')
    let [bgn, end] = s:get_table_range(row)
    if bgn == 0
        let self.table = {}
    else
        let self.table = s:table_in_range(bgn,end)
        let self.indent = indent(row)
    endif
    let [self.bgn, self.end] = [bgn, end]
    return self
endfun "}}}
fun! s:get_table.format_table() dict "{{{
    if empty(self.table) | return -1 | endif

    let lines = self.table.lines(self.indent)

    if empty(lines) | return -2 | endif
    let [bgn,end] = [self.bgn, self.end]
    let d_bgn = 0

    " only change the different lines for speed
    for i in range(bgn, end)
        if !empty(lines)
            if getline(i) != lines[0]
                call setline(i, lines[0])
            endif
            call remove(lines, 0)
        elseif getline(i) =~ s:p.table
            " no lines in new table , 
            " should del the following lines in buffer
            let d_bgn = i
            break
        endif
    endfor
    if d_bgn
        exe i.",".end."del"
    endif
    " still lines in new table,
    " append it to end
    if !empty(lines)
        call append(end, lines)
    endif
endfun "}}}
fun! s:get_table.add_line(type) dict "{{{
    if empty(self.table) | return -1 | endif
    let idx =  line('.') - self.bgn
    call self.table.add_line(idx, a:type)
    call self.format_table()
endfun "}}}
"}}}

" grid table object. "{{{
let s:grid_table = {}
fun! s:grid_table(list) "{{{
    return s:grid_table.new(a:list)
endfun "}}}
fun! s:grid_table.new(list) dict "{{{

   let self.list = s:balance_table_col(a:list)
   let self.row = len(self.list)
   if self.row > 0
       let self.col = len(self.list[0])
   else
       let self.col = 0
   endif
    
   call self.norm_col()
   call self.parse_col_max_width()
    
   return self
endfun "}}}
fun! s:grid_table.norm_col() dict "{{{
    for row in self.list
        for i in range(len(row))
            let row[i] = s:rstrip(row[i])
            if row[i] !~ '^\s'
                let row[i] = " ".row[i]
            endif
        endfor
    endfor
endfun "}}}
fun! s:grid_table.parse_col_max_width() dict "{{{
    let v_tbl = s:zip(self.list)
    let col_max_w = []
    for v_cols in v_tbl
        let max_len = 0
        for col in v_cols
            if col =~ '^ |S\|^ |H'
                continue
            endif
            let c_len = strwidth(col)
            if c_len > max_len
                let max_len = c_len
            endif
        endfor
        call add(col_max_w, max_len)
    endfor
    let self.col_max_w = col_max_w
endfun "}}}
fun! s:grid_table.lines(indent) dict "{{{
    let idt = repeat(" ", a:indent)
    let sepr = idt . "+" . join(map(copy(self.col_max_w),' repeat("-", v:val+1)'),"+") . "+"
    let head = substitute(sepr, '-','=','g')
    let lines = []
    for row in self.list
        if row[0] == ' |S'
            call add(lines, sepr)
        elseif row[0] == ' |H'
            call add(lines, head)
        else
            let s_col = ""
            for i in range(len(row))
                let c = row[i]
                let s_col .= "|".c.repeat(" ", self.col_max_w[i]-strwidth(c))." "
            endfor
            let cont = idt . s_col . "|"
            call add(lines, cont)
        endif
    endfor

    " add missing sepr at bgn/end
    if !empty(lines)
        if lines[-1] != sepr
            call add(lines, sepr)
        endif
        if lines[0] != sepr
            call insert(lines, sepr, 0)
        endif
    endif

    return lines
endfun "}}}
fun! s:grid_table.add_line(idx, type) dict "{{{
    if a:type == 'cont' || self.list[a:idx][0] == ' |S' || self.list[a:idx][0] == ' |H'
        " when prev is sepr , idx+1 will insert it befor the sepr line
        let c = a:idx + 1
    else
        let c = a:idx + 2
    endif

    if a:type == 'sepr'
        call insert(self.list, [" |S"], a:idx+1)
    elseif a:type == "head"
        call insert(self.list, [" |H"], a:idx+1)
    endif
    call insert(self.list, map(range(self.col), '" "'), c)
    
endfun "}}}
"}}}

fun! s:balance_table_col(list) "{{{
    let balanced_list = []
    let max_cols = 0

    " get the max max_cols of the list
    for row in a:list "{{{
        if type(row) == type([])
            let row_len = len(row)
            if row_len > max_cols 
                let max_cols = row_len
            endif
        endif
    endfor "}}}

    if max_cols == 0
        return balanced_list
    endif
    
    " add a ' ' to each row
    for i in range(len(a:list)) "{{{
        let row = a:list[i]
        if type(row) == type([])
            let row_len = len(row)
            let tmp = row[:]
            if max_cols > row_len
                call extend(tmp, map(range(max_cols - row_len), '" "'))
            endif
        else
            let tmp = [row]
            call extend(tmp, map(range(max_cols - 1), '" "'))
        endif
        call add(balanced_list, tmp)
    endfor "}}}
    return balanced_list
endfun "}}}
fun! s:rstrip(str) "{{{
    return matchstr(a:str, '.\{-}\ze\s*$')
endfun "}}}
fun! s:zip(list) "{{{
    " return a zipped list
    " [1,2,3],[4,5,6] to [1,4] ,[2,5] ,[3,6]
    let zipped = []
    
    for row in a:list
        for i in range(len(row))
            if i >= len(zipped)
                let list = []
                call add(zipped, list)
            else
                let list = zipped[i]
            endif
            call add(list, row[i])
        endfor
    endfor
    return zipped
endfun "}}}


fun! riv#table#newline(type) "{{{
    " TODO: break a line in a table
    call riv#breakundo()
    let [row,col] = getpos('.')[1:2]
    call s:get_table().add_line(a:type)
    if a:type == 'cont'
        call cursor(row+1,col)
    else
        call cursor(row+2,col)
    endif
    call search(g:_riv_p.cell.'|^\s*$' ,'Wbc')
endfun "}}}

if expand('<sfile>:p') == expand('%:p') "{{{
    echo s:zip([[1,2,3],[4,5,6],[7,8]])
endif "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
