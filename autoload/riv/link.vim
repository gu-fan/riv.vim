"=============================================
"    Name: link.vim
"    File: link.vim
" Summary: link ref and targets.
"  Author: Rykka G.Forest
"  Update: 2012-06-27
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

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

fun! s:normal_ptn(text) "{{{
    let text = substitute(a:text ,'\v(^__=|_=_$)','','g')
    let text = substitute(text ,'\v(^`|`$)','','g')
    let text = substitute(text ,'\v(^\[|\]$)','','g')
    let text = substitute(escape(text,'.^$*[]\'),'\s\+','\\s+','g')
    return text
endfun "}}}
fun! s:target_ptn(text) "{{{
    return '\v\c(_`\zs'. a:text .'`|\_^\.\.\s\zs\['.a:text.'\]|\_^\.\.\s\zs_'.a:text.':)'
endfun "}}}
fun! s:reference_ptn(text) "{{{
    return '\v\c(`'. a:text .'`_|\['.a:text.'\]_|'.a:text.'_)\ze'
endfun "}}}

fun! s:find_tar(text) "{{{

    if a:text =~ g:_riv_p.link_ref_anoymous
        let [a_row, a_col] = searchpos(g:_riv_p.link_tar_anonymous, 'wn', 0 , 100)
        return [a_row, a_col]
    endif

    let norm_ptn = s:normal_ptn(a:text)
    let [c_row,c_col] = getpos('.')[1:2]
    let row = s:find_sect('\v\c'.norm_ptn)
    if row > 0
        return [row, c_col]
    endif
    let tar_ptn = s:target_ptn(norm_ptn)
    let [a_row, a_col] = searchpos(tar_ptn, 'wn', 0 , 100)
    return [a_row, a_col]
endfun "}}}
fun! s:find_ref(text) "{{{

    if a:text =~ g:_riv_p.link_tar_anonymous
        let [a_row, a_col] = searchpos(g:_riv_p.link_ref_anoymous, 'wnb', 0 , 100)
        return [a_row, a_col]
    endif

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
            if getline(sect.bgn) =~ a:ptn
                return sect.bgn
            endif
        endfor
    endif
endfun "}}}

fun! riv#link#open() "{{{

    let idx = s:get_phase_idx()
    if idx == -1
        let idx = s:get_cWORD_idx()
    endif
    if idx == -1
        return 
    endif

    let [row,col] = getpos('.')[1:2]
    let line = getline(row)
    let mo = s:matchobject(line, g:_riv_p.all_link, idx)

    if empty(mo) || mo.start+1 > col || mo.end < col
        return
    endif

    if !empty(mo.groups[1])
        " at it's target , find it's referrence
        let [sr,sc] = s:find_ref(mo.str)
        if sr != 0
            call setpos("'`",getpos('.'))
            call setpos('.',[0,sr,sc,0])
            return 1
        endif
    elseif !empty(mo.groups[2])
        " check if it's embbed link
        let em = matchstr(mo.groups[2], '`[^`]*\s<\zs[^`]*\ze>`_')
        if empty(em)
            let [sr,sc] = s:find_tar(mo.str)
            if sr != 0
                call setpos("'`",getpos('.'))
                call setpos('.',[0,sr,sc,0])
            endif
        else
            sil! exe "!".g:riv_web_browser." ". escape(em,'#%')." &"
        endif
        return 2
    elseif !empty(mo.groups[3])
        if !empty(mo.groups[4])             " it's file://xxx
            if mo.str =~ '^file'
                update
                exe "edit ".expand(mo.groups[4])
                let b:riv_p_id = s:id()
            else
                " vim will expand the # and % , so escape it.
                sil! exe "!".g:riv_web_browser." ". escape(mo.groups[4],'#%')." &"
            endif
        else
            if mo.groups[3] =~ g:_riv_p.link_mail
                let mo.groups[3] = 'mailto:' . mo.groups[3]
            endif
            sil! exe "!".g:riv_web_browser." ". escape(mo.groups[3],'#%')." &"
        endif
        return 3
    elseif !empty(mo.groups[5])
        if g:riv_localfile_linktype == 2
            let mo.str = matchstr(mo.str, '^\[\zs.*\ze\]$')
        endif
        if s:is_relative(mo.str)
            let dir = expand('%:p:h').'/'
            let file = dir . mo.str
            if s:is_directory(file)
                let file = file . 'index.rst'
            elseif g:riv_localfile_linktype == 2 && fnamemodify(file, ':e') == ''
                let file = file . '.rst'
            endif
        else
            let file = expand(mo.str)
        endif
        update
        exe "edit ".file
        let b:riv_p_id = s:id()
        return 4
    endif
endfun "}}}

fun! s:is_relative(name) "{{{
    return a:name !~ '^\~\|^/\|^[a-zA-Z]:'
endfun "}}}
fun! s:is_directory(name) "{{{
    return a:name =~ '/$' 
endfun "}}}

fun! s:get_cWORD_idx() "{{{
    " if cursor is in a WORD ,return it's idx , else return -1
    let line = getline('.')
    let ptn = printf('\%%%dc.', col('.'))
    if matchstr(line, ptn)=~'\S'
        return match(line, '\S*'.ptn)
    else
        return -1
    endif
endfun "}}}
fun! s:get_phase_idx() "{{{
    " if cursor is in a phase ,return it's idx , else return -1
    let line = getline('.')
    let col = col('.')
    let ptn = printf('`[^`]*\%%%dc[^`]*`_\|\%%%dc`[^`]*`_', col, col)
    return match(line, ptn)
endfun "}}}
" highlight
fun! riv#link#hi_hover() "{{{
    
    let idx = s:get_phase_idx()
    if idx == -1
        let idx = s:get_cWORD_idx()
    endif
    
    if idx != -1
        let [l,c] = getpos('.')[1:2]
        let line = getline(l)
        let bgn = match(line, g:_riv_p.all_link, idx) + 1
        if bgn && bgn <= c
            let end = matchend(line, g:_riv_p.all_link, idx) +1
            if c <= end
                execute '2match' "DiffText".' /\%'.(l)
                            \.'l\%>'.(bgn-1) .'c\%<'.(end).'c/'
                return
            endif
        endif
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
fun! s:id() "{{{
    return exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
