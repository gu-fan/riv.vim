"=============================================
"    Name: link.vim
"    File: link.vim
" Summary: link ref and targets.
"  Author: Rykka G.Forest
"  Update: 2012-06-08
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! riv#link#delte() "{{{
    " if we delete footnote. we need update all in buffer.
    if type == "footnote"
        let line = getline('.')
        let list = matchlist(getline(row), g:_RIV_p.exp_cur_footnote)
    
endfun "}}}
fun! riv#link#get_foot_by_id(id) "{{{
    
endfun "}}}
fun! riv#link#get_last_foot() "{{{
    " return  [ id , row]
    let pos = getpos('.')
    call setpos('.',getpos('$'))
    let [row,col] = searchpos(g:_RIV_p.exp_footnote,'nWbc',0,100)
    call setpos('.',pos)
    if row == 0
        return [0,0]
    else
        return [matchlist(getline(row), g:_RIV_p.exp_footnote)[1],row]
    endif
endfun "}}}

fun! riv#link#finder(dir) "{{{
    let cr = line('.')
    let cc = col('.')
    let smallest_r = 1000
    let smallest_c = 1000
    let best = [0,0]
    let flag = a:dir=="b" ? 'Wnb' : 'Wn'
    for ptn in g:_RIV_p.link_grp
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
fun! s:matchobject(str, ptn,...) "{{{
    if a:0
        let start = a:1
    else
        let start = 0
    endif
    let s = {}
    let idx = match(a:str,a:ptn,start)
    if idx == -1
        return s
    endif
    let s.start  = idx
    let s.groups = matchlist(a:str,a:ptn,start)
    let s.str    = s.groups[0]
    let s.end    = s.start + len(s.str)
    return s
endfun "}}}
fun! riv#link#open() "{{{
    let [row,col] = getpos('.')[1:2]
    let line = getline(row)
    let ptn = g:_RIV_p.all_link
    let mo = s:matchobject(line, ptn)
    while !empty(mo)
        if mo.end < col
            let mo = s:matchobject(line,ptn, mo.end)
        elseif mo.start <= col && mo.end >= col
            break
        elseif mo.start > col
            return 
        endif
    endwhile
    if empty(mo)
        return
    endif
    if !empty(mo.groups[1])
        let [sr,sc,type] = s:find_ref_tar(mo.str)
        if sr != 0
            call setpos("'`",getpos('.'))
            call setpos('.',[0,sr,sc,0])
            return 2
        endif
    elseif !empty(mo.groups[2])
        let [sr,sc,type] = s:find_ref_def(mo.str)
        if sr != 0
            call setpos("'`",getpos('.'))
            call setpos('.',[0,sr,sc,0])
            return 1
        endif
    elseif !empty(mo.groups[3])
        if !empty(mo.groups[4])
            if mo.str =~ '^file'
                exe "edit ".expand(mo.groups[4])
            else
                " vim will expand the # and % , so escape it.
                sil! exe "!".g:riv_web_browser." ". escape(mo.groups[4],'#%')." &"
            endif
        else
            sil! exe "!".g:riv_web_browser." ". escape(mo.groups[3],'#%')." &"
        endif
        return 3
    elseif !empty(mo.groups[5])
        " NOTE: link have used sub 1 and 2
        if mo.str !~ '^[/~]'
            let dir = expand('%:p:h')
            let file = dir . '/' . mo.str
            if file=~'/$'
                if !isdirectory(file) && input("Directory Not Exists , Create One?", 1)
                    call mkdir(file,"p",0755)
                endif
                let file = file."index.rst"
            endif
        else
            let file = expand(mo.str)
        endif
        exe "edit ".file
        return 4
    endif
endfun "}}}
fun! riv#link#openb() "{{{
    let [row,col] = getpos('.')[1:2]
    let ptn = g:_RIV_p.link_tar
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
    let ptn = g:_RIV_p.link_ref
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
    let ptn = g:_RIV_p.link_uri
    let links = matchlist(line,ptn)
    let idx = match(line,ptn)
    while !empty(links) 
        if col>=idx && col <=idx+len(links[0])
            if !empty(links[1])
            " match the link with file:// or http:// part.
                if links[1] =~ 'file'
                    exe "edit ".expand(links[2])
                else
                    " vim will expand the # and %
                    " NOTE: we should change the cmd with user defined browser
                    sil! exe "!firefox ". escape(links[2],'#%')." &"
                endif
            else
                sil! exe "!firefox ". escape(links[0],'#%')." &"
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
    let ptn = g:_RIV_p.link_file
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
" highlight
fun! riv#link#hi_hover() "{{{
    let [l,c] = getpos('.')[1:2]
    let line = getline(l)
    let bgn = match(line, g:_RIV_p.all_link)
    if bgn!=-1
        let end = matchend(line, g:_RIV_p.all_link)
        while bgn!=-1 
            if c<= end && c>=bgn+1
                execute '2match' "rstLinkHover".' /\%'.(l)
                            \.'l\%>'.(bgn) .'c\%<'.(end+1).'c/'
                return
            elseif bgn >= c
                break
            else
                let end = matchend(line, g:_RIV_p.all_link, bgn+1)
                let bgn = match(line, g:_RIV_p.all_link, bgn+1)
            endif
        endwhile
    endif
    2match none
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
