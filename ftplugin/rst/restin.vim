"=============================================
"    Name: rstin.vim
"    File: rstin.vim
" Summary: ReST file plugin
"  Author: Rykka G.Forest
"  Update: 2012-06-05
" Version: 0.5
"=============================================

let g:rst_force = exists("g:rst_force") ? g:rst_force : 0
if exists("b:did_rstftplugin") && g:rst_force == 0 | finish | endif
let b:did_rstftplugin = 1
let s:cpo_save = &cpo
set cpo-=C
" settings {{{
setl foldmethod=expr
setl foldexpr=RstFoldExpr(v:lnum)
setl foldtext=RstFoldText()
setl comments=fb:.. commentstring=..\ %s expandtab
setl formatoptions+=tcroql
let b:undo_ftplugin = "setl fdm< fde< fdt< com< cms< et< fo<"
            \ . "| unlet! b:dyn_sec_list b:foldlevel b:fdl_before_exp b:fdl_cur_list"

let g:restin_ext_ptn= exists("g:restin_ext_ptn") ? g:restin_ext_ptn : '|vim|cpp|c|py|rb|lua|pl'
"}}}
" map and cmd {{{
exe 'let g:last_rst_file="'.expand('%:p').'"'
nno <silent><buffer><Leader>ri :call <SID>cindex("rst")<CR>

nno <silent><buffer><CR> :call <SID>parse_cur()<CR>
nno <silent><buffer>== :call <SID>get_same_level(line('.'))<CR>
nno <silent><buffer><Tab> :call <SID>find_lnk("n")<CR>
nno <silent><buffer><S-Tab> :call <SID>find_lnk("b")<CR>
nno <silent><buffer><Kenter> :call <SID>parse_cur()<CR>
nno <silent><buffer><2-leftmouse>  :call <SID>db_click()<CR>

no <silent><buffer><leader>ee :call <SID>list_tog_box(line('.'))<CR>
no <silent><buffer><leader>e1 :call <SID>list_tog_typ(line('.'),"* ")<CR>
no <silent><buffer><leader>e2 :call <SID>list_tog_typ(line('.'),"#. ")<CR>
no <silent><buffer><leader>e3 :call <SID>list_tog_typ(line('.'),"(#) ")<CR>
no <silent><buffer><leader>e4 :call <SID>list_tog_typ(line('.'),"")<CR>

no <silent><buffer> > :call <SID>list_shift_idt("")<CR>
no <silent><buffer> < :call <SID>list_shift_idt("-")<CR>
no <silent><buffer> <c-scrollwheeldown> :call <SID>list_shift_idt("")<CR>
no <silent><buffer> <c-scrollwheelup> :call <SID>list_shift_idt("-")<CR>
        
ino <expr><silent><buffer> <BS> restin#insert#bs_fix_indent()
" tests 
com! -buffer ForceReload let g:rst_force=1 | set ft=rst | let g:rst_force=0
com! -buffer -nargs=? FoldTest call restin#testfold(<args>)
"}}}
if exists("*s:find_ref_def") && g:rst_force==0 | finish | endif
"{{{ parsing cursor
fun! s:find_ref_def(text) "{{{
    " substitute 2+ \s to a ' '
    let n_txt = tolower(substitute(a:text,'\s\{2,}',' ','g'))
    " Hyperlinks, footnotes, and citations 
    " all share the same namespace for reference names. 
    let inline_ptn = '\c\v(_`\zs'. n_txt .'|\['.n_txt.'\])\ze`'
    let ref_ptn = '\c\v^\.\. \zs(_'. n_txt.'\ze:|\['.n_txt.'\])'
    let c_row = line('.')
    let [sr,sc] = searchpos(ref_ptn,'wn',0,100)
    let type = 1 " ref
    if sr==c_row || sr==0
        let [sr,sc] = searchpos(inline_ptn,'wn',0,100)
        let type = 0 " inline
        if sr == c_row
            return [0,0,0]
        endif
    endif
    return [sr,sc,type]
endfun "}}}

fun! s:find_ref(text) "{{{
    " substitute 2+ \s to a ' '
    let n_txt = tolower(substitute(a:text,'\s\{2,}',' ','g'))
    let inline_ptn = '\c\v(_`\zs'. n_txt .'|\['.n_txt.'\])\ze`'
    let ref_ptn = '\c\v^\.\. \zs(_'. n_txt.'\ze:|\['.n_txt.'\])'
    
endfun "}}}
let s:ptn_lnk = '\v(%(file|https=|ftp|gopher)://|%(mailto|news):)([^[:space:]''\"<>]+[[:alnum:]/])'
let s:ptn_lnk2 ='\vwww[[:alnum:]_-]*\.[[:alnum:]_-]+\.[^[:space:]''\"<>]+[[:alnum:]/]'
let s:ptn_rst = '\v([~0-9a-zA-Z:./_-]+%(\.%(rst'.g:restin_ext_ptn.')|/))\S@!'
let s:ptn_ref = '\v\[=[0-9a-zA-Z]*\]=\zs_>'
let s:ptn_def = '\v_`\[=\zs[0-9a-zA-Z]*\ze\]=`|^\.\. (_\zs[0-9a-zA-Z]+|\[\zs[0-9a-zA-Z]+\ze\])'
let s:ptn_grp = [s:ptn_lnk,s:ptn_rst,s:ptn_def,s:ptn_ref,s:ptn_lnk2]
fun! s:parse_cur() "{{{
    let [row,col] = getpos('.')[1:2]
    let ptn = '\[\=\zs[0-9a-zA-Z]*\%'.col.'c[0-9a-zA-Z]*\ze\]\=_'
    let line = getline(row)
    let word = matchstr(line,ptn)
    " get ref def
    if !empty(word)
        let [sr,sc,type] = s:find_ref_def(word)
        if sr != 0
            call setpos("'`",getpos('.'))
            call setpos('.',[0,sr,sc,0])
            return 1
        endif
    endif
    
    " get ref
    let ptn = s:ptn_def
    let links = matchlist(line,ptn)
    if !empty(word)
        let [sr,sc,type] = s:find_ref_def(word)
        if sr != 0
            call setpos("'`",getpos('.'))
            call setpos('.',[0,sr,sc,0])
            return 1
        endif
    endif
    
    
    " get link
    let ptn = s:ptn_lnk
    let links = matchlist(line,ptn)
    let idx = match(line,ptn)
    while !empty(links) 
        if col>=idx && col <=idx+len(links[0])
            if links[1] =~ 'file'
                exe "edit ".expand(links[2])
            else
                " vim will expand the # and %
                " NOTE: we should change the cmd with user defined browser
                sil! exe "!firefox ". escape(links[2],'#%')." &"
            endif
            return 1
        elseif idx >= col
            return 0
        else
            let links = matchlist(line,ptn,idx+1)
            let idx = match(line,ptn,idx+1)
        endif
    endwhile

    " get link2
    let ptn = s:ptn_lnk2
    let links = matchlist(line,ptn)
    let idx = match(line,ptn)
    while !empty(links) 
        if col>=idx && col <=idx+len(links[0])
            if links[1] =~ 'file'
                exe "edit ".expand(links[0])
            else
                sil! exe "!firefox ". links[0]
            endif
            return 1
        elseif idx >= col
            return 0
        else
            let links = matchlist(line,ptn,idx+1)
            let idx = match(line,ptn,idx+1)
        endif
    endwhile

    " get defined file 
    let ptn = s:ptn_rst
    let links = matchlist(line,ptn)
    let idx = match(line,ptn)
    while !empty(links) 
        if col>=idx && col <=idx+len(links[0])
            if links[1] !~ '^[/~]'
                let dir = expand('%:p:h')
                let file = dir.'/'.links[1]
                if file=~'/$'
                    " if !isdirectory(file)
                    "     call mkdir(file,"p",0755)
                    " endif
                    let file = file."index.rst"
                endif
            else
                let file = expand(links[1])
            endif
            exe "edit ".file
            return 1
        elseif idx >= col
            return 0
        else
            "let let
            let links = matchlist(line,ptn,idx+1)
            let idx = match(line,ptn,idx+1)
        endif
    endwhile

    return 0
endfun "}}}
fun! s:db_click() "{{{
    if !s:parse_cur()
        exe "normal! \<2-leftmouse>"
    endif
endfun "}}}

fun! s:find_lnk(dir) "{{{
    let cr = line('.')
    let cc = col('.')
    let smallest_r = 100000
    let smallest_c = 100000
    let best = [0,0]
    let flag = a:dir=="b" ? 'Wnb' : 'Wn'
    for ptn in s:ptn_grp
        let [sr,sc] = searchpos(ptn,flag)
        if sr != 0
            let dis_r = abs(sr-cr)
            if smallest_r > dis_r
                let smallest_r = dis_r
                let best = [sr,sc] 
            elseif smallest_r == dis_r
                let dis_c = abs(sc-cc)
                if smallest_c > dis_c
                    let smallest_c = dis_c
                    let best = [sr,sc] 
                endif
            endif
        endif
    endfor
    if best[0] != 0
        call setpos("'`",getpos('.'))
        call setpos('.',[0,best[0],best[1],0])
    endif
endfun "}}}
"}}}
"{{{ folding 
let s:is_fold_defined=1
let s:exp_cluster_con_ptn =
        \ '^rst\%(Comment\|\%(Ex\)\=Directive\|HyperlinkTarget\)'

" NOTE: 'foldlevel' begins with 1: #:1 , =:2 ... .:5
let s:punc_list =  ['#','=','~','-','.']
let s:punc_str = '!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~'
fun! RstFoldExpr(row) "{{{
    
    let b:singal = 0
    let p_line = getline(a:row-1)
    let c_line = getline(a:row)
    let n_line = getline(a:row+1)
    let c_match = matchstr(c_line,'^[#=~.-]\{4,}\s*$')
    let n_match = matchstr(n_line,'^[#=~.-]\{4,}\s*$')

    " using index(list,item) is a bit quicker than dict[item] here
    " 1.6x:1.7x sec at 100000 time
    if a:row == 0 || !exists("b:dyn_sec_list")
        let b:dyn_sec_list = []
    endif
    if !empty(c_match) && empty(n_match) && getline(a:row+2) == c_line
        let idx = index(b:dyn_sec_list, c_match[1])+1
        if idx == 0
            call add(b:dyn_sec_list,c_match[1])
            let idx = len(b:dyn_sec_list)
        endif
        let b:foldlevel = idx
        return ">".idx
    elseif !empty(n_match) && c_line !~ '^\s*$'
        if p_line =~ '^\s*$'
            let idx = index(b:dyn_sec_list,n_match[1])+1
            if idx == 0
                call add(b:dyn_sec_list,n_match[1])
                let idx = len(b:dyn_sec_list)
            endif
            let b:foldlevel = idx
            return ">".idx
        elseif p_line == n_line
            let idx = index(b:dyn_sec_list,n_match[1])+1
            if idx == 0
                call add(b:dyn_sec_list,n_match[1])
                let idx = len(b:dyn_sec_list)
            endif
            let b:foldlevel = idx
            return idx
        endif
    endif
    
    "(ExplicitMarkup Fold)
    " The line start the ExplicitMarkup 
    " b:fdl_before_exp : foldlevel of document before ExplicitMarkup
    " NOTE: as the line in exp_cluster_ptn syntax !~ '^\S', 
    "       we can use it to check for performance. 
    "       but only use it with lines next to exp_cluster_ptn.
    " NOTE: differece between synId and synstack:
    "       for an empty line in ExplicitMarkup's region. 
    "       synID  will return 0, 
    "       synstack will return the top syn item:[n].
    "       exp_cluster_ptn is always a top syn-item as defined in rst.vim.
    if c_line =~ '^\.\.\_s' && n_line !~ '^\S'
        let b:singal = 1
        let b:foldlevel = exists("b:foldlevel") ?
                    \ b:foldlevel : 0
        " NOTE: for continuous exp_markup line  
        "       can not get the last fdl before first one.
        "       it depends on whether the first exp_markup have
        "       an blank endline or not.
        "       so we will not change it if it's 7
        if b:foldlevel!= 7
            let b:fdl_before_exp = b:foldlevel 
        endif
        let b:foldlevel = 7
        return ">7"
    endif
    
    " the line finish ExplicitMarkup (one blank line '\_^\s*\n\_^\S')
    " ( ExplicitMarkup ends with '^..\_s' or '\_^\s*\n\_^\S')
    " NOTE: as we will leave one blank line. 
    "       so no 2-line-fold issue with blank line
    if c_line =~ '^\s*$' && n_line =~ '^\S' && p_line =~ '^\S\@!\|^\.\.\s.'
        let b:singal = 2
        if synIDattr(get(synstack(a:row,1),0),"name") =~ s:exp_cluster_con_ptn
            let b:foldlevel = exists("b:fdl_before_exp") ?
                        \ b:fdl_before_exp : 0
            let t = b:foldlevel
            if a:row == line('$')
                unlet! b:fdl_before_list
                unlet! b:fdl_before_exp
                unlet! b:foldlevel
                unlet! b:fdl_cur_list
            endif
            return t
        endif
    endif
    
    " fold list
    " fold level depend on indent
    " let s:list_ptn = '^\s*%([-*+]|%(\d+|[#a-z]|[imcxv]+)[.)])\s+'
    " let s:list_ptn2 = '^\s*\(%(\d+|[#a-z]|[imcxv]+)\)\s+'


    if c_line =~ '\v'.s:list_ptn.'|'.s:list_ptn2
                \ && indent(a:row) < indent(nextnonblank(a:row+1))
        " some are 2, some are 3..
        let t = indent(a:row)/2 + 8
        if !exists("b:fdl_cur_list") || b:fdl_cur_list==0
            let b:fdl_before_list = exists("b:foldlevel") ? b:foldlevel : 0
        endif
        let b:fdl_cur_list = 1
        let b:foldlevel = t
        if a:row == line('$')
            unlet! b:fdl_before_list
            unlet! b:foldlevel
            unlet! b:fdl_cur_list
            unlet! b:foldlevel
        endif
        return '>'.t
        " let t = b:foldlevel
    " elseif c_line !~  '\v'.s:list_ptn.'|'.s:list_ptn2.'|^\s*$'
    endif

    if n_line =~  '^\s*$' && (getline(a:row+2) =~ '^\S' || n_line=~'^\S')
        if exists("b:fdl_cur_list") && b:fdl_cur_list==1
            let t = indent(a:row) / 2 + 8
            let b:foldlevel = exists("b:fdl_before_list") ? b:fdl_before_list : 0
            if a:row == line('$')
                unlet! b:fdl_before_list
                unlet! b:fdl_before_exp
                unlet! b:foldlevel
                unlet! b:fdl_cur_list
            endif
            let b:fdl_cur_list=0
            return '<'.t
        endif
    endif

    " NOTE: fold-expr will eval last line first , then eval from start.
    " NOTE: it is too slow to use "="
    " XXX:  could not using foldlevel cause it returns -1
    let t = exists("b:foldlevel") ?  b:foldlevel : 0
    if a:row == line('$')
        unlet! b:fdl_before_list
        unlet! b:foldlevel
        unlet! b:fdl_cur_list
        unlet! b:foldlevel
    endif
    return t
    
endfun "}}}
fun! RstFoldText() "{{{
    " NOTE: if it's three row title. show the content of next line.
    let line = getline(v:foldstart)
    if line =~ '^\v([#=~.-])\1{3,}\s*$'
        let line = getline(v:foldstart+1)
    endif
    if len(line)<=50 
        let line = line."  ".repeat('-',50) 
    endif
    let line = printf("%-50.50s",line)
    if v:foldlevel <=3
        let dash = printf("%4s",repeat("<",v:foldlevel))
    else
        let dash = printf("%4s","<<+")
    endif
    let num = printf("%4s",(v:foldend-v:foldstart))
    return line."[".num.dash."]"
endfun "}}}
fun! restin#testfold(...) "{{{ should in autoload
    let b:rst_debug=1
    let line=line('.')
    let c = 1
    let d = 1
    echo "row\texpr\tb:p_ln\tb:p_ex"
    for i in range(1,line('$'))
        let fdl = RstFoldExpr(i)
        if i>= line-10 && i <= line+10
            echo i."\t".fdl
            if exists("b:foldlevel")
                echon " \t" b:foldlevel
            else
                echon " \tN/A"
            endif
            if exists("b:fdl_before_exp")
                echon " \t" b:fdl_before_exp
            else
                echon " \tN/A" 
            endif
            if line == i
                echon " \t" ">> CursorLine"
            endif
        endif
        if exists("b:singal") && a:0>0 && a:1>0
            if b:singal == 1
                echo  c "check .. " getline(i)
                let c = c+1
            elseif b:singal == 2
                echo  d "check \\s " getline(i+1)
                let d = d+1
            endif
        endif
    endfor
    echo "\\s check: " c
    echo ".. check: "  d
    echo "TOTAL check: " (c+d)
    unlet! b:rst_debug
endfun "}}}
"}}}
"{{{ file jump 
fun! s:cindex(ftype) "{{{
    let idx = "index.".a:ftype
    if filereadable(idx)
        if expand('%') == idx
            edit #
        else
            exe "edit ". idx
        endif
    else
        echo "No index for current page"
    endif
endfun "}}}
"}}}
"{{{ todo list

let s:fm_timestamp = "%Y-%m-%d"
let s:todo_lvs =  [' ','o','X']
let s:show_tms = exists("g:rst_show_tms") ? g:rst_show_tms : 1

let s:list_ptn = '^\s*%([-*+]|%(\d+|[#a-z]|[imcxv]+)[.)])\s+'
let s:list_ptn2 = '^\s*\(%(\d+|[#a-z]|[imcxv]+)\)\s+'
" it's \1 when match
let s:list_ptn_group =  '\v\c('.s:list_ptn.'|'.s:list_ptn2.')'
" the '.' is \2 when match
let s:todobox_ptn = s:list_ptn_group.'\[(.)\] '
" the rx_time is \3 when match
let s:timestamp_ptn = '(\d{6}|\d{4}-\d{2}-\d{2})\_s'
let s:tms_ptn = s:todobox_ptn.s:timestamp_ptn

fun! s:list_tog_box(row) "{{{
    " toggle list with s:todo_lvs ptn.
    " when idx get max, add an timestamp is show_tms is on
    let line = getline(a:row) 
    let idx = match(line,s:list_ptn_group)
    if idx == -1
        return -1
    endif
    let boxlist = matchlist(line,s:todobox_ptn,idx)
    if empty(boxlist)
        let line = substitute(line, s:list_ptn_group, '\0[ ] ','')
        call setline(a:row,line)
    else
        let t_idx = index(s:todo_lvs,boxlist[2])
        let max_i = len(s:todo_lvs)-1
        if  t_idx != -1 && t_idx < max_i-1
            let tstr = s:todo_lvs[t_idx+1]
        elseif t_idx == max_i-1
            let tstr = s:todo_lvs[max_i]
            if exists("*strftime") && s:show_tms==1
                let tms = strftime(s:fm_timestamp)." "
            else
                let tms = ""
            endif
        else
            let tstr = s:todo_lvs[0]
        endif
        if t_idx == max_i
            if match(line,s:tms_ptn)!=-1
                let line = substitute(line, s:tms_ptn, '\1','')
            else
                let line = substitute(line, s:todobox_ptn, '\1','')
            endif
        elseif t_idx ==max_i-1
            let line = substitute(line, s:todobox_ptn, '\1['.tstr.'] '.tms,'') 
        else
            let line = substitute(line, s:todobox_ptn, '\1['.tstr.'] ','')
        endif
        call setline(a:row,line)
    endif
endfun "}}}

let s:list_lvs = ["*","+","-"]
fun! s:list_shift_len(row,len) "{{{
    let line = getline(a:row)
    let m_str = matchstr(line,s:list_ptn_group)
    let l_str = matchstr(m_str,'[*+-]')
    " sub all \t to ' ' to avoid wrong indenting
    let line = substitute(line,'\t',repeat(" ",&sw),'g')
    " if l_str is empty , then we do not substitute the list_str
    if a:len>=0
        let line = substitute(line,'^',repeat(' ',a:len),'')
    else
        let line = substitute(line,'^\s\{,'.abs(a:len).'}','','')
    endif
    if !empty(m_str) && !empty(l_str)
        let l_idx = index(s:list_lvs,l_str)
        let max_i = len(s:list_lvs)-1
        if a:len>=0 && l_idx < max_i
            let line = substitute(line,'[*+-]',s:list_lvs[l_idx+1],'')
        elseif a:len<0 && l_idx > 0 && l_idx <= max_i
            let line = substitute(line,'[*+-]',s:list_lvs[l_idx-1],'')
        endif
    endif
    call setline(a:row,line)
endfun "}}}
fun! s:list_shift_idt(direction) range "{{{
    " > to add indent, < to rmv indent 
    " if line is list then change bullet.
    let line = getline(a:firstline) 
    let m_str = matchstr(line,s:list_ptn_group)
    if empty(m_str)
        let len = &shiftwidth
    else
        let len = len(m_str) - indent(a:firstline)
    endif
    if a:firstline == a:lastline
        call s:list_shift_len(a:firstline, a:direction.len)
    else
        for line in range(a:firstline,a:lastline)
            call s:list_shift_len(line, a:direction.len)
        endfor
        normal! gv
    endif
    
endfun "}}}

let s:list_typ = ["*","#.","(#)"]
let s:list_typ_ptn = ['[*+#-]','\(#\|\d\+\)\(\.\|)\)','(\(\d\+\|\.\))']
fun! s:list_tog_typ(row,typ) "{{{
    let line = getline(a:row) 
    if line=~'^\s*$'
        return -1
    endif
    let str = matchstr(line,s:list_ptn_group)
    let white = matchstr(line,'^\s*')
    if empty(str)
        let line = substitute(line,white, white.a:typ,'')
    else
        let line = substitute(line,escape(str,'*'),white,'')
        let line = substitute(line,white, white.a:typ,'')
    endif
    call setline(a:row,line)
endfun "}}}
"}}}
let &cpo = s:cpo_save
unlet s:cpo_save
