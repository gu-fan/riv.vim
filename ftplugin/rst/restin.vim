"=============================================
"    Name: rstin.vim
"    File: rstin.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-01
" Version: 0.1
"=============================================
" vim:fdm=marker:
" link in and between rst files.
" Reference:
" example_ [EXAMPLE]_
"
" Targets:
" .. _example: file://~/Desktop/tmp
" .. _example: http://www.python.org
" .. [example]
" _`example`  http://www.python.org
"
" Files:
" xxx.rst  ~/xxx.rst  ../xxx.rst
setl fdls=1 fdl=1
setl foldmethod=expr
setl foldexpr=RstFoldExpr(v:lnum)
setl foldtext=RstFoldText()

if exists("b:did_rstftplugin")
    finish
endif
let b:undo_ftplugin = "setlocal fdm< fde< fdt< fdls< fdl<"
let b:did_rstftplugin = 1
let g:rst_debug = exists("g:rst_debug") ? g:rst_debug : 0
let g:restin_ext_ptn= exists("g:restin_ext_ptn") ? g:restin_ext_ptn : '|vim|cpp|c|py|rb|lua|pl'

if !exists("*s:find_ref_def") "{{{
    fun! s:find_ref_def(text) "{{{
        let n_txt = tolower(substitute(a:text,'\s\{2,}',' ','g'))
        " Hyperlinks, footnotes, and citations 
        " all share the same namespace for reference names. 
        let inline_ptn = '\c\v(_`\zs'. n_txt .'|\['.n_txt.'\])\ze`'
        let ref_ptn = '\c\v^\.\. \zs(_'. n_txt.'\ze:|\['.n_txt.'\])'
        call s:debug(n_txt)
        let c_row = line('.')
        let [sr,sc] = searchpos(ref_ptn,'wn')
        call s:debug(sr)
        let type = 1 " ref
        if sr==c_row || sr==0
            let [sr,sc] = searchpos(inline_ptn,'wn')
            call s:debug(sr)
            let type = 0 " inline
            if sr == c_row
                return [0,0,0]
            endif
        endif
        return [sr,sc,type]
    endfun "}}}
endif "}}}
if !exists("s:ptn_lnk") "{{{
    let s:ptn_lnk = '\v(%(file|https=|ftp|gopher)://|%(mailto|news):)([0-9a-zA-Z#&?._-~/]*)'
    " ext_ptn '|vim|cpp|c|py|rb'
    "
    let ext_ptn = g:restin_ext_ptn
    let s:ptn_rst = '\v([~0-9a-zA-Z:./-]+%(\.%(rst'.ext_ptn.')|/))\S@!'
    let s:ptn_ref = '\v\[=[0-9a-zA-Z]*\]=\zs_>'
    let s:ptn_def = '\v_`\[=\zs[0-9a-zA-Z]*\ze\]=`|^\.\. (_\zs[0-9a-zA-Z]+|\[\zs[0-9a-zA-Z]+\ze\])'
    let s:ptn_grp = [s:ptn_lnk,s:ptn_rst,s:ptn_def,s:ptn_ref]
endif "}}}
if !exists("*s:parse_cur") "{{{
fun! s:parse_cur() "{{{
    let [row,col] = getpos('.')[1:2]
    let ptn = '\[\=\zs[0-9a-zA-Z]*\%'.col.'c[0-9a-zA-Z]*\ze\]\=_'
    let line = getline(row)
    let word = matchstr(line,ptn)
    " get ref
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
                sil! exe "!firefox ". links[2]
            endif
            return 1
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
endif "}}}
if !exists("*s:debug") "{{{
    fun! s:debug(msg)
        if g:rst_debug==1
            redraw
            exe "echom '".a:msg."'"
        endif
    endfun
endif "}}}
if !exists("*s:find_lnk") "{{{
    let s:table = []
    fun! s:find_lnk(dir)
        let cr = line('.')
        let cc = col('.')
        let smallest_r = 1000
        let smallest_c = 1000
        let best = [0,0]
        let flag = a:dir=="b" ? 'Wnb' : 'Wn'
        for ptn in s:ptn_grp
            let [sr,sc] = searchpos(ptn,flag)
            if sr != 0
                call s:debug(string([sr,sc]).ptn)
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
        call s:debug(string(best)." Best")
        if best[0] != 0
            call setpos("'`",getpos('.'))
            call setpos('.',[0,best[0],best[1],0])
        endif
    endfun
endif "}}}
" fold "{{{
if !exists("s:is_fold_defined")
    let s:is_fold_defined=1
    " valid: ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
fun! RstFoldExpr(row) "{{{

    " PSEUDO LANGUAGE: (section part)
    " if cur line fit title_ptn                 // start of 3 row title
    "                                           // fold from here
    "     if next line not title_ptn and next-over-next line is same as cur line
    "         prv_foldlevel = n
    "         return  "<n"
    " elseif next line fit title_ptn and cur line not empty
    "     if prev line is empty
    "         prv_foldlevel = n
    "         return "<n"
    "     if prev line is same as next line     // second line of 3 row title.
    "                                           // so we should not return "<n"
    "                                           // which will start fold from here
    "         prv_foldlevel = n
    "         return n
    " else 
    "     return prv_foldlevel                  // we should unlet it if it's
    "                                           // last line
    
    let n_line = getline(a:row+1)
    let n_mlist = matchlist(n_line,'^\v([#=~.-]){4,}\s*$')
    let c_line = getline(a:row)
    let c_mlist = matchlist(c_line,'^\v([#=~.-]){4,}\s*$')

    " NOTE: 'foldlevel' begins with 1: #:1 , =:2 ... .:5
    " using index(list,item) is a bit quicker than dict[item] here
    " 1.6x:1.7x sec at 100000 time
    let punc_list =  ['#','=','~','-','.']
    
    if !empty(c_mlist)
        if empty(n_mlist) && getline(a:row+2) == c_line
            let idx = index(punc_list,c_mlist[1])+1
            let b:rst_prv_foldlevel = idx
            return ">".idx
        endif
    elseif !empty(n_mlist) && c_line !~ '^\s*$'
        let pline = getline(a:row-1)
        if pline =~ '^\s*$'
            let idx = index(punc_list,n_mlist[1])+1
            let b:rst_prv_foldlevel = idx
            return ">".idx
        elseif pline == n_line
            let idx = index(punc_list,n_mlist[1])+1
            let b:rst_prv_foldlevel = idx
            return idx
        endif
    endif

    " The line start the comment: using foldlevel 6
    " b:rst_before_cmt_foldlevel : foldlevel of previous section before comment
    " NOTE: only fold the lines that following more than 2 lines.
    " NOTE: the empty lines following an comment line  will be included 
    " NOTE: for an empty line in comment. 
    "       synID  will return 0, so use synstack, which will return [194].
    let c_synlist = synstack(a:row,1)
    let c_hlgrp = empty(c_synlist) ? "" : synIDattr(c_synlist[0],"name") 
    if c_hlgrp == "rstExplicitMarkup" 
        let n_synlist = synstack(a:row+1,1)
        let n_hlgrp = empty(n_synlist) ? "" : synIDattr(n_synlist[0],"name")
        let n2_synlist = synstack(a:row+2,1)
        let n2_hlgrp = empty(n2_synlist) ? "" : synIDattr(n2_synlist[0],"name")
        " the 4th char in c_line is rstComment already
        if synIDattr(synID(a:row,4,1),"name")=="rstComment" && 
                    \ n_hlgrp=="rstComment" &&  n2_hlgrp=="rstComment"
            let b:rst_before_cmt_foldlevel = b:rst_prv_foldlevel
            let b:rst_prv_foldlevel = 6
            return ">6"
        endif
    endif

    " The lines in the comment
    let p_synlist = synstack(a:row-1,1)
    let p_hlgrp = empty(p_synlist) ? "" : synIDattr(p_synlist[0],"name")
    if c_hlgrp == "rstComment" 
        let n_synlist = synstack(a:row+1,1)
        let n_hlgrp = empty(n_synlist) ? "" : synIDattr(n_synlist[0],"name")
        if n_hlgrp != "rstComment" && p_hlgrp == "rstComment"
            if a:row == line('$')
                unlet! b:rst_prv_foldlevel
                unlet! b:rst_before_cmt_foldlevel
            endif
            return "6"
        endif
    endif
    
    " The line finish the comment
    if p_hlgrp == "rstComment" && c_hlgrp != "rstComment"
        let p2_synlist = synstack(a:row-2,1)
        let p2_hlgrp = empty(p2_synlist) ? "" : synIDattr(p2_synlist[0],"name")
        if p2_hlgrp == "rstComment"
            if !exists("b:rst_before_cmt_foldlevel")  
                let b:rst_before_cmt_foldlevel = 0
            endif
            let b:rst_prv_foldlevel = b:rst_before_cmt_foldlevel
            if a:row == line('$')
                let t = b:rst_before_cmt_foldlevel
                unlet! b:rst_before_cmt_foldlevel
                unlet! b:rst_prv_foldlevel
                return t
            else
                return b:rst_before_cmt_foldlevel
            endif
        endif
    endif

    " NOTE: fold-expr will eval last line first , then eval from start.
    " NOTE: it is too slow to use "="
    " XXX:  could not using foldlevel cause it's return -1
    if !exists("b:rst_prv_foldlevel")  
        let b:rst_prv_foldlevel = 0
    endif
    if a:row == line('$')
        let t = b:rst_prv_foldlevel
        unlet! b:rst_prv_foldlevel
        unlet! b:rst_before_cmt_foldlevel
        return t
    else
        return b:rst_prv_foldlevel
    endif
    
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
    let dash = printf("%-4s",repeat("+",v:foldlevel))
    let num = printf("%4s",(v:foldend-v:foldstart))
    return line."[".num.dash."]"
endfun "}}}
fun! restin#testfold() "{{{
    let b:rst_debug=1
    echo "row\texpr\tb:prv\tb:cmt"
    for i in range(1,line('$'))
        echo i."\t".RstFoldExpr(i)
        if exists("b:rst_prv_foldlevel")
            echon " \t" b:rst_prv_foldlevel
        endif
        if exists("b:rst_before_cmt_foldlevel")
            echon " \t" b:rst_before_cmt_foldlevel
        endif
    endfor
    unlet! b:rst_debug
endfun "}}}
fun! s:debug(msg) "{{{
    if exists("b:rst_debug")
        echohl WarningMsg
        echom a:msg
        echohl Normal
    endif
endfun "}}}
endif "}}}
if !exists("s:is_defined") "{{{
    let s:is_defined=1

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

    " TODO: todo-list part
    " [ ] 
    " [.]  
    " [X] xxxx-xx-xx
    let s:todo_stats = [' ','.','X']

    let s:rx_timestamp = '\(\d\{6}\|\d\{4}-\d\{2}-\d\{2}\)'
    let s:fm_timestamp = "%Y-%m-%d"

    let s:enu_lst_ptn = '\v\c^\s*([-*+•‣⁃]|%(\d+|[a-z]|[imcxv]+)(\.|\)))'
    let s:def_lst_ptn = '\v\c^\s*\n([[:alnum:] _.-]+)\ze(:.*)*\n    \w'
    let s:fld_lst_ptn = '\v\c^:[[:alnum:]_.-]+: '
    let s:lst_ptns =  [s:enu_lst_ptn,s:def_lst_ptn,s:fld_lst_ptn]
    
    let s:todo_ptns = ['\[ \]','\[\.\]','\[X\]']
    let s:todo_expr = ['[ ]','[.]','[X]']

    fun! s:toggle_todo()
        
    endfun
    fun! s:add_todo()
        for lit_ptn in s:lst_ptns
        endfor
    endfun
    fun! s:del_todo()
        
    endfun
    fun! s:is_list()
        let line = getlin('.')
        
    endfun
    fun! s:is_bare_list()
        
    endfun
    fun! s:is_todo_list()
        
    endfun
function! s:sub_list(sym) "{{{
    let line=getline('.')
    if a:sym != " "
        let sym = a:sym
    else
        let sym = ""
    endif
    let m=substitute(line,'^\(\s*\)\%([*+-]\s\|\%(\d\.\)\+\s\)\=\ze.*',
                \'\1'.sym.' ','')
    if a:sym == " "
        let m =substitute(m,'^\s','','')
    endif
    call setline(line('.'),m)
endfunction "}}}
endif "}}}
nno <silent><buffer><leader>e1 :call <SID>sub_list('1.')<cr>
nno <silent><buffer><leader>e2 :call <SID>sub_list('*')<cr>
nno <silent><buffer><leader>e3 :call <SID>sub_list('+')<cr>
nno <silent><buffer><leader>e4 :call <SID>sub_list('-')<cr>
nno <silent><buffer><leader>e5 :call <SID>sub_list(' ')<cr>
exe 'let g:last_rst_file="'.expand('%:p').'"'
nno <silent><buffer><Leader>ri :call <SID>cindex("rst")<CR>

nno <silent><buffer><CR> :call <SID>parse_cur()<CR>
nno <silent><buffer>== :call <SID>get_same_level(line('.'))<CR>
nno <silent><buffer><Tab> :call <SID>find_lnk("n")<CR>
nno <silent><buffer><S-Tab> :call <SID>find_lnk("b")<CR>
nno <silent><buffer><Kenter> :call <SID>parse_cur()<CR>
nno <silent><buffer><2-leftmouse>  :call <SID>db_click()<CR>



