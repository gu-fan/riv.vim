"=============================================
"    Name: cursor.vim
"    File: cursor.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-07
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

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
fun! riv#cursor#parse() "{{{
    let [row,col] = getpos('.')[1:2]
    let ptn = g:_RIV_c.ptn.link_tar
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
    let ptn = g:_RIV_c.ptn.link_def
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
    let ptn = g:_RIV_c.ptn.lnk
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
    let ptn = g:_RIV_c.ptn.lnk2
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
    let ptn = g:_RIV_c.ptn.file
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

"}}}

let &cpo = s:cpo_save
unlet s:cpo_save
