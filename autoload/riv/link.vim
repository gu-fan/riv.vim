"=============================================
"    Name: link.vim
"    File: link.vim
" Summary: link ref and targets.
"  Author: Rykka G.Forest
"  Update: 2012-07-07
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
    let [srow,scol] = searchpos(g:_riv_p.link_all,flag,0,100)
    if srow[0] != 0
        call setpos("'`",getpos('.'))
        call cursor(srow, scol)
    endif
endfun "}}}
fun! s:escape(str) "{{{
    return escape(a:str, '.^$*[]\@+=~')
endfun "}}}
fun! s:normal_ptn(text) "{{{
    let text = substitute(a:text ,'\v(^__=|_=_$)','','g')
    let text = substitute(text ,'\v(^`|`$)','','g')
    let text = substitute(text ,'\v(^\[|\]$)','','g')
    let text = substitute(s:escape(text),'\s\+','\\s+','g')
    return text
endfun "}}}

fun! s:target_ptn(text) "{{{
    return '\v\c(_`\zs'. a:text .'`|\_^\.\.\s\zs\['.a:text.'\]|\_^\.\.\s\zs_'.a:text.':)'
endfun "}}}
fun! s:reference_ptn(text) "{{{
    return '\v\c(`'. a:text .'`_|\['.a:text.'\]_|'.a:text.'_)\ze'
endfun "}}}

fun! s:find_tar(text) "{{{

    if a:text =~ g:_riv_p.link_ref_anonymous
        let [a_row, a_col] = searchpos(g:_riv_p.link_tar_anonymous, 'wn', 0 , 100)
        return [a_row, a_col]
    endif

    let norm_ptn = s:normal_ptn(a:text)
    let [c_row,c_col] = getpos('.')[1:2]
    let row = s:find_sect('\v\c^'.norm_ptn.'$')
    if row > 0
        return [row, c_col]
    endif
    let tar_ptn = s:target_ptn(norm_ptn)
    let [a_row, a_col] = searchpos(tar_ptn, 'wn', 0 , 100)
    return [a_row, a_col]
endfun "}}}
fun! s:find_ref(text) "{{{

    if a:text =~ g:_riv_p.link_tar_anonymous
        let [a_row, a_col] = searchpos(g:_riv_p.link_ref_anonymous, 'wnb', 0 , 100)
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

    let [row,col] = getpos('.')[1:2]
    let line = getline(row)

    let idx = s:get_P_or_W_idx(line,col)

    if idx == -1
        return 
    endif

    let mo = riv#ptn#match_object(line, g:_riv_p.link_all, idx)

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
                call riv#file#edit(expand(mo.groups[4]))
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
        if riv#path#is_relative(mo.str)
            let dir = expand('%:p:h').'/'
            let file = dir . mo.str
            if riv#path#is_directory(file)
                let file = file . 'index.rst'
            elseif g:riv_localfile_linktype == 2 && fnamemodify(file, ':e') == ''
                let file = file . '.rst'
            endif
        else
            let file = expand(mo.str)
        endif
        update
        call riv#file#edit(file)
        return 4
    endif
endfun "}}}

fun! s:get_P_or_W_idx(line, col) "{{{
    let idx = riv#ptn#get_phase_idx(a:line, a:col)
    if idx == -1
        let idx = riv#ptn#get_WORD_idx(a:line, a:col)
    endif
    return idx
endfun "}}}

" highlight
let [s:hl_row, s:hl_bgn,s:hl_end] = [0, 0 , 0]
fun! riv#link#hi_hover() "{{{
    
    let [row,col] = getpos('.')[1:2]

    " if col have not move out prev hl region , skip
    if !&modified &&  row == s:hl_row && col >= s:hl_bgn && col <= s:hl_end
        return
    endif
    let [s:hl_row, s:hl_bgn,s:hl_end] = [row, 0 , 0]

    let line = getline(row)
    let idx = s:get_P_or_W_idx(line,col)
    
    if idx != -1
        let obj = riv#ptn#match_object(line, g:_riv_p.link_all , idx)
        if !empty(obj) && obj.start < col
            let bgn = obj.start + 1
            let end = obj.end
            if col <= end+1
                let [s:hl_row, s:hl_bgn,s:hl_end] = [row, bgn, end]
                if !empty(obj.groups[5]) 
                    let [file, is_dir] = riv#file#from_str(obj.str)
                    
                    " if link invalid
                    if (is_dir && !isdirectory(file) ) 
                        \ || (!is_dir && !filereadable(file) )
                        execute '2match' "DiffChange".' /\%'.(row)
                                    \.'l\%>'.(bgn-1) .'c\%<'.(end+1).'c/'
                        return
                    endif
                endif
                execute '2match' "DiffText".' /\%'.(row)
                            \.'l\%>'.(bgn-1) .'c\%<'.(end+1).'c/'
                return
            endif
        else
            let [is_in,bgn,end,obj] = riv#todo#col_item(line,col)
            if is_in>=2
                execute '2match' "DiffAdd".' /\%'.(row)
                            \.'l\%>'.(bgn-1) .'c\%<'.(end+1).'c/'
                return
            endif
        endif
    endif

    2match none
endfun "}}}

fun! s:id() "{{{
    return exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
