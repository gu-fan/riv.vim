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

fun! riv#link#delete() "{{{
    " if we delete footnote. we need update all in buffer?
endfun "}}}
fun! riv#link#get_foot_by_id(id) "{{{
    
endfun "}}}
fun! riv#link#get_last_foot() "{{{
    " return  [ id , row]
    let pos = getpos('.')
    call setpos('.',getpos('$'))
    let [row,col] = searchpos(g:_riv_p.link_tar_footnote,'nWbc',0,100)
    call setpos('.',pos)
    if row == 0
        return [0,0]
    else
        return [matchlist(getline(row), g:_riv_p.link_tar_footnote)[1],row]
    endif
endfun "}}}

fun! riv#link#finder(dir) "{{{
    let flag = a:dir=="b" ? 'Wnb' : 'Wn'
    let [srow,scol] = searchpos(g:_riv_p.all_link,flag,0,100)
    if srow[0] != 0
        call setpos("'`",getpos('.'))
        call cursor(srow, scol)
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
    let tar_ptn = s:target_ptn(a:text)
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

fun! s:normal_ptn(text) "{{{
    return substitute(escape(a:text,'.^$*[]\'),'\s\+','\\s\\+','g')
endfun "}}}
fun! s:target_ptn(text) "{{{
    return '\c\(`\zs'. a:text .'`_\|\['.a:text.'\]\|'.a:text.'_\)\ze'
endfun "}}}
fun! s:reference_ptn(text) "{{{
    return '\c\(`\zs'. a:text .'`_\|\['.a:text.'\]\|'.a:text.'_\)\ze'
endfun "}}}

fun! s:find_tar(text) "{{{
    let norm_ptn = s:normal_ptn(a:text)
    let [c_row,c_col] = getpos('.')
    let row = s:find_sect(norm_ptn)
    if row > 0
        return [row, c_col]
    endif

    let tar_ptn = s:target_ptn(norm_ptn)
    let [a_row, a_col] = searchpos(tar_ptn, 'wn', 0 , 100)
    return [a_row, a_col]
endfun "}}}
fun! s:find_sect(ptn) "{{{
" Note:the Section Title is also targets.
    if exists("b:state.sectmatcher")
        for sect in b:state.sectmatcher
            if getline(b:sect.bgn) =~ a:ptn
                return b:sect.bgn
            endif
        endfor
    endif
endfun "}}}



fun! riv#link#open() "{{{
    let [row,col] = getpos('.')[1:2]
    let line = getline(row)
    let ptn = g:_riv_p.all_link
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
        let [sr,sc] = s:find_ref_tar(mo.str)
        if sr != 0
            call setpos("'`",getpos('.'))
            call setpos('.',[0,sr,sc,0])
            return 2
        endif
    elseif !empty(mo.groups[2])
        let [sr,sc] = s:find_ref_def(mo.str)
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

" highlight
fun! riv#link#hi_hover() "{{{
    let [l,c] = getpos('.')[1:2]
    let line = getline(l)
    let bgn = match(line, g:_riv_p.all_link)
    if bgn!=-1
        let end = matchend(line, g:_riv_p.all_link)
        while bgn!=-1 
            if c<= end && c>=bgn+1
                execute '2match' "rstLinkHover".' /\%'.(l)
                            \.'l\%>'.(bgn) .'c\%<'.(end+1).'c/'
                return
            elseif bgn >= c
                break
            else
                let end = matchend(line, g:_riv_p.all_link, bgn+1)
                let bgn = match(line, g:_riv_p.all_link, bgn+1)
            endif
        endwhile
    endif
    2match none
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
let &cpo = s:cpo_save
unlet s:cpo_save
