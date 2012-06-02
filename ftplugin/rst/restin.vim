"=============================================
"    Name: rstin.vim
"    File: rstin.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-02
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

let g:rst_force_reload = exists("g:rst_force_reload") ? g:rst_force_reload : 0
if exists("b:did_rstftplugin") && g:rst_force_reload == 0
    finish
endif
let b:undo_ftplugin = "setlocal fdm< fde< fdt< fdls< fdl<"
let b:did_rstftplugin = 1
let g:rst_debug = exists("g:rst_debug") ? g:rst_debug : 0
let g:restin_ext_ptn= exists("g:restin_ext_ptn") ? g:restin_ext_ptn : '|vim|cpp|c|py|rb|lua|pl'

if !exists("*s:find_ref_def") || g:rst_force_reload==1 "{{{
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
if !exists("s:ptn_lnk") || g:rst_force_reload==1 "{{{
    " let s:ptn_lnk = '\v(%(file|https=|ftp|gopher)://|%(mailto|news):)([0-9a-zA-Z#&?._-~/]*)'
    let s:ptn_lnk = '\v(%(file|https=|ftp|gopher)://|%(mailto|news):)([^[:space:]''\"<>]+[[:alnum:]/])'
    let s:ptn_lnk2 ='\vwww[[:alnum:]_-]*\.[[:alnum:]_-]+\.[^[:space:]''\"<>]+[[:alnum:]/]'
    " ext_ptn '|vim|cpp|c|py|rb'
    "
    let ext_ptn = g:restin_ext_ptn
    let s:ptn_rst = '\v([~0-9a-zA-Z:./_-]+%(\.%(rst'.ext_ptn.')|/))\S@!'
    let s:ptn_ref = '\v\[=[0-9a-zA-Z]*\]=\zs_>'
    let s:ptn_def = '\v_`\[=\zs[0-9a-zA-Z]*\ze\]=`|^\.\. (_\zs[0-9a-zA-Z]+|\[\zs[0-9a-zA-Z]+\ze\])'
    let s:ptn_grp = [s:ptn_lnk,s:ptn_rst,s:ptn_def,s:ptn_ref,s:ptn_lnk2]
endif "}}}
if !exists("*s:parse_cur")  || g:rst_force_reload==1 "{{{
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
endif "}}}
if !exists("*s:debug")  || g:rst_force_reload==1 "{{{
    fun! s:debug(msg)
        if g:rst_debug==1
            redraw
            exe "echom '".a:msg."'"
        endif
    endfun
endif "}}}
if !exists("*s:find_lnk")  || g:rst_force_reload==1 "{{{
    let s:table = []
    fun! s:find_lnk(dir)
        let cr = line('.')
        let cc = col('.')
        let smallest_r = 100000
        let smallest_c = 100000
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
if !exists("s:is_fold_defined")  || g:rst_force_reload==1 
    let s:is_fold_defined=1
    " valid: ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
    let s:exp_cluster_con_ptn = '^rst\%(Comment\|\%(Ex\)\=Directive\|HyperlinkTarget\)$'
fun! RstFoldExpr(row) "{{{

    " PSEUDO LANGUAGE: (section part)
    " if cur line fit title_ptn                 
    "     and next line not title_ptn 
    "     and next-over-next line is same as cur line
    "                                           // start of 3 row title
    "                                           // fold from here
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
    let c_line = getline(a:row)
    let n_match = matchstr(n_line,'^[#=~.-]\{4,}\s*$')
    let c_match = matchstr(c_line,'^[#=~.-]\{4,}\s*$')
    let p_line = getline(a:row-1)

    " NOTE: 'foldlevel' begins with 1: #:1 , =:2 ... .:5
    " using index(list,item) is a bit quicker than dict[item] here
    " 1.6x:1.7x sec at 100000 time
    let punc_list =  ['#','=','~','-','.']
    
    if !empty(c_match) && empty(n_match) && getline(a:row+2) == c_line
        let idx = index(punc_list,c_match[1])+1
        let b:rst_prv_foldlevel = idx
        return ">".idx
    elseif !empty(n_match) && c_line !~ '^\s*$'
        if p_line =~ '^\s*$'
            let idx = index(punc_list,n_match[1])+1
            let b:rst_prv_foldlevel = idx
            return ">".idx
        elseif p_line == n_line
            let idx = index(punc_list,n_match[1])+1
            let b:rst_prv_foldlevel = idx
            return idx
        endif
    endif
    
    "(ExplicitMarkup Fold)
    " The line start the ExplicitMarkup 
    " foldlevel 6
    " b:rst_before_exp_foldlevel : foldlevel of document before ExplicitMarkup
    " NOTE: as the line in exp_cluster_ptn syntax !~ '^\S', 
    "       we can use it to check for performance. 
    "       but only use it with lines next to exp_cluster_ptn.
    " NOTE: differece between synId and synstack:
    "       for an empty line in ExplicitMarkup's region. 
    "       synID  will return 0, 
    "       synstack will return the top syn item:[n].
    "       exp_cluster_ptn is always a top syn-item as defined in rst.vim.
    if c_line =~ '^\.\.\s.\+' 
            \ && n_line !~ '^\S'
            \ && synIDattr(synID(a:row,1,1),"name") =~ '^rstExplicitMarkup$'
        let b:rst_prv_foldlevel = exists("b:rst_prv_foldlevel") ?
                    \ b:rst_prv_foldlevel : 0
        let b:rst_before_exp_foldlevel = b:rst_prv_foldlevel
        let b:rst_prv_foldlevel = 6
        return ">6"
    endif
    
    " the line finish ExplicitMarkup (one blank line '\_^\s*\n\_^\S')
    " ( ExplicitMarkup ends with '^..\s' or '\_^\s*\n\_^\S')
    " NOTE: as we will leave one blank line. 
    "       so no 2-line-fold issue with blank line
    if (c_line =~ '^\s*$' && n_line =~ '^\S'
        \ && synIDattr(get(synstack(a:row,1),0),"name") =~ s:exp_cluster_con_ptn )
        " the line finish ExplicitMarkup (no blank line '^..\s')
        " NOTE:  check if prev-line is NOT a blank line to avoid two times check
        \ || ( c_line =~ '^\S' &&  p_line !~ '^\S' && p_line !~ '^\s*$'
        \ && synIDattr(get(synstack(a:row-1,1),0),"name") =~ s:exp_cluster_con_ptn )
            let b:rst_prv_foldlevel = exists("b:rst_before_exp_foldlevel") ?
                        \ b:rst_before_exp_foldlevel : 0
            let t = b:rst_prv_foldlevel
            if a:row == line('$')
                unlet! b:rst_before_exp_foldlevel
                unlet! b:rst_prv_foldlevel
            endif
            return t
    endif

    " NOTE: fold-expr will eval last line first , then eval from start.
    " NOTE: it is too slow to use "="
    " XXX:  could not using foldlevel cause it returns -1
    let t = exists("b:rst_prv_foldlevel") ?  b:rst_prv_foldlevel : 0
    if a:row == line('$')
        unlet! b:rst_prv_foldlevel
        unlet! b:rst_before_exp_foldlevel
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
    let dash = printf("%-4s",repeat("+",v:foldlevel))
    let num = printf("%4s",(v:foldend-v:foldstart))
    return line."[".num.dash."]"
endfun "}}}
fun! restin#testfold() "{{{ should in autoload
    let b:rst_debug=1
    let line=line('.')
    echo "row\texpr\tb:prv\tb:cmt"
    for i in range(1,line('$'))
        if i>= line-10 && i <= line+10
            echo i."\t".RstFoldExpr(i)
            if exists("b:rst_prv_foldlevel")
                echon " \t" b:rst_prv_foldlevel
            endif
            if exists("b:rst_before_exp_foldlevel")
                echon " \t" b:rst_before_exp_foldlevel
            endif
            if line == i
                echon " \t" ">> CursorLine"
            endif
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
if !exists("s:is_defined")  || g:rst_force_reload==1 "{{{
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

" tests 
com! -buffer ForceReload let g:rst_force_reload=1 | set ft=rst | let g:rst_force_reload=0
com! -buffer FoldTest call restin#testfold()
