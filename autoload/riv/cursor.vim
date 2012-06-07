
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
fun! s:find_ref_tar(text) "{{{
    " substitute 2+ \s to a ' '
    let n_txt = tolower(substitute(a:text,'\s\{2,}',' ','g'))
    let tar_ptn = '\c\v(`\zs'. n_txt .'`_|\['.n_txt.'\]|'.n_txt.'_)\ze'
    
    let c_row = line('.')
    let [sr,sc] = searchpos(tar_ptn,'wn',0,100)
    let type = 1 " ref
    if sr==c_row || sr==0
        let [sr,sc] = searchpos(tar_ptn,'wn',0,100)
        let type = 0 " inline
        if sr == c_row
            return [0,0,0]
        endif
    endif
    return [sr,sc,type]
endfun "}}}
let s:ptn_lnk = '\v(%(file|https=|ftp|gopher)://|%(mailto|news):)([^[:space:]''\"<>]+[[:alnum:]/])'
let s:ptn_lnk2 ='\vwww[[:alnum:]_-]*\.[[:alnum:]_-]+\.[^[:space:]''\"<>]+[[:alnum:]/]'
let s:ptn_rst = '\v([~0-9a-zA-Z:./_-]+%(\.%(rst|'. g:RESTIN_Conf['ext_ptn'] .')|/))\S@!'
" let s:ptn_rst = '\v([~0-9a-zA-Z:./_-]+%(\.%(rst)|/))\S@!'
let s:ptn_ref = '\v\[=[0-9a-zA-Z]*\]=\zs_>'

" ref definition patterns
" .. _xxx :
" .. [xxx]
" _`xxx xxx`
let s:ptn_def = '\v_`\[=\zs[0-9a-zA-Z]*\ze\]=`|^\.\. (_\zs[0-9a-zA-Z]+|\[\zs[0-9a-zA-Z]+\ze\])'
" ref target patterns
" [xxx]_  xxx_ `xxx xx`_
let s:ptn_tar = '\v\ze%(\_s|^)%(\`[[:alnum:]. -]+`_|[[:alnum:].-_]+_|\[[[:alnum:].-_]+\]_)\ze%(\_s|$)'
" inline link patterns
" `xxxx  <URL>`
" standlone link patterns
" www.xxx-x.xxx/?xxx
" URI
" http://xxx.xxx.xxx file:///xxx/xxx/xx  
" mailto:xxx@xxx.xxx 
let s:ptn_grp = [s:ptn_lnk,s:ptn_rst,s:ptn_def,s:ptn_ref,s:ptn_lnk2]
fun! s:parse_cur() "{{{
    let [row,col] = getpos('.')[1:2]
    let ptn = s:ptn_tar
    let line = getline(row)
    let word = matchstr(line,ptn)
    let idx = match(line,ptn)
    " get ref def
    if !empty(word) &&  col<= idx+len(word) && col >= idx
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
        let [sr,sc,type] = s:find_ref_tar(word)
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
    let smallest_r = 1000
    let smallest_c = 1000
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
