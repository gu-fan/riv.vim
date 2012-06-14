"=============================================
"    Name: link.vim
"    File: link.vim
" Summary: link ref and targets.
"  Author: Rykka G.Forest
"  Update: 2012-06-15
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C


fun! riv#link#finder(dir) "{{{
    let flag = a:dir=="b" ? 'Wnb' : 'Wn'
    let [srow,scol] = searchpos(g:_riv_p.all_link,flag,0,100)
    if srow[0] != 0
        call setpos("'`",getpos('.'))
        call cursor(srow, scol)
    endif
endfun "}}}

fun! s:normal_ptn(text) "{{{
    let text = substitute(a:text ,'\v(^__=|_=_$)','','g')
    let text = substitute(text ,'\v(^`|`$)','','g')
    let text = substitute(text ,'\v(^\[|\]$)','','g')
    let text = substitute(escape(text,'.^$*[]\'),'\s\+','\\s+','g')
    return text
endfun "}}}
fun! s:target_ptn(text) "{{{
    return '\v\c(_`\zs'. a:text .'`|\_^\.\.\s\zs\['.a:text.'\]|\_^\.\.\s\zs_'.a:text.')'
endfun "}}}
fun! s:reference_ptn(text) "{{{
    return '\v\c(`'. a:text .'`_|\['.a:text.'\]_|'.a:text.'_)\ze'
endfun "}}}

fun! s:find_tar(text) "{{{
    let norm_ptn = s:normal_ptn(a:text)
    let [c_row,c_col] = getpos('.')[1:2]
    let row = s:find_sect(norm_ptn)
    if row > 0
        return [row, c_col]
    endif

    let tar_ptn = s:target_ptn(norm_ptn)
    let [a_row, a_col] = searchpos(tar_ptn, 'wn', 0 , 100)
    return [a_row, a_col]
endfun "}}}
fun! s:find_ref(text) "{{{
    let norm_ptn = s:normal_ptn(a:text)
    let [c_row,c_col] = getpos('.')[1:2]

    let ref_ptn = s:reference_ptn(norm_ptn)
    let [a_row, a_col] = searchpos(ref_ptn, 'wnb', 0 , 100)
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
        let [sr,sc] = s:find_ref(mo.str)
        if sr != 0
            call setpos("'`",getpos('.'))
            call setpos('.',[0,sr,sc,0])
            return 2
        endif
    elseif !empty(mo.groups[2])
        let [sr,sc] = s:find_tar(mo.str)
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
