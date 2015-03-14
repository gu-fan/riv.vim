"=============================================
"    Name: link.vim
"    File: link.vim
" Summary: link ref and targets.
"  Author: Rykka G.F
"  Update: 2014-08-28
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:p = g:_riv_p
let s:sys = function('riv#system')

fun! riv#link#browse(link) "{{{
    " use browser to open link
    " add 'mailto:' to 'mail@example.com', otherwise browser will open 
    " example.com
    let link = a:link
    if link =~ s:p.link_mail
        let link = 'mailto:' . link
    endif
    " call s:sys(g:riv_web_browser." ". escape(link,'#%')." &")
    echom link
    call riv#util#open(link)
endfun "}}}
fun! s:cursor(row, col) "{{{
    " Move to cursor with jumplist changed.
    
    if a:row == 0 | return  | endif

    " add to jumplist
    norm! m'
    call cursor(a:row, a:col)

    " sometime column is not moved to, so use this.
    " FIXED: maybe caused by `norm! z.`
    " if getpos('.')[2] != a:col
    "     exe 'norm! 0'.a:col. 'l'
    " endif

    " openfold, put center and redraw
    normal! zvzz

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
    let [srow,scol] = searchpos(riv#ptn#link_all(),flag,0,100)
    call s:cursor(srow, scol)
endfun "}}}
fun! s:normal_ptn(text) "{{{
    let text = substitute(a:text ,'\v(^__=|_=_$)','','g')
    let text = substitute(text ,'\v(^`|`$)','','g')
    let text = substitute(text ,':$','','g')
    let text = substitute(text ,'\v(^\[|\]$)','','g')
    let text = substitute(riv#ptn#escape(text),'\s\+','\\s+','g')
    return text
endfun "}}}

fun! s:target_ptn(text) "{{{
    return '\v\c(_`\zs'. a:text .'`|\_^\.\.\s\zs\['.a:text.'\]|\_^\.\.\s\zs_'.a:text.':)'
endfun "}}}
fun! s:reference_ptn(text) "{{{
    return '\v\c(`'. a:text .'`_|\['.a:text.'\]_|'.a:text.'_)'
        \. '%($|\s|[''")\]}>/:.,;!?\\-])'
endfun "}}}

fun! s:find_tar(text) "{{{
    " XXX
    " THIS function may should rewrite
    " norm_ptn 
    " with create.vim 's norm_ref and norm_tar

    if a:text =~ g:_riv_p.link_ref_anonymous
        let [a_row, a_col] = searchpos(g:_riv_p.link_tar_anonymous, 'wn', 0 , 100)
        return [a_row, a_col]
    endif

    let norm_ptn = s:normal_ptn(a:text)

    " The section title are implicit targets.
    let [row, col]  = s:find_sect('\v\c^\s*'.norm_ptn.'\s*$')
    if row > 0
        return [row, col]
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
    if exists("b:riv_state.sectmatcher")
        for sect in b:riv_state.sectmatcher
            let line = getline(sect.bgn) 
            if line =~ g:_riv_p.section
                let line = getline(sect.bgn+1)
            endif
            if line =~ a:ptn
                let col = match(line, '\v\S') + 1
                return [sect.bgn, col]
            endif
        endfor
    endif
    return [0, 0]
endfun "}}}

fun! s:is_file(file) "{{{
    return filereadable(a:file)
endfun "}}}

fun! riv#link#open(...) "{{{

    let [row,col] = getpos('.')[1:2]
    let line = getline(row)
    
    let idx = s:get_link_idx(line,col)

    if idx == -1
        return
    endif

    let mo = riv#ptn#match_object(line, riv#ptn#link_all(), idx)

    if empty(mo) || mo.start+1 > col || mo.end < col
        return
    endif
    " s:p['link_all'.i] =
    "             \  '\v('. link_target 
    "             \ . ')|(' . link_reference
    "             \ . ')|(' . link_uri 
    "             \ . ')|(' . link_file{i}
    "             \ . ')|(' . ext_file_link
    "             \. ')'
    " Link_target
    if !empty(mo.groups[1])
        " at it's target , find it's referrence
        let [sr,sc] = s:find_ref(mo.str)
        if sr != 0
            call s:cursor(sr, sc)
            return 1
        else
            call riv#warning(g:_riv_e.REF_NOT_FOUND)
            return -1
        endif
    " Link Reference
    elseif !empty(mo.groups[2])
        " check if it's embbed link
        let loc = matchstr(mo.groups[2], s:p.loc_embed)
        let [sr, sc] = [0, 0]
        if empty(loc)
            let [sr,sc] = s:find_tar(mo.str)
            if sr != 0

                " let norm_ptn = s:normal_ptn(a:text)
                " let tar_ptn = s:target_ptn(norm_ptn)
                " >>> echo mo
                " >>> echo s:p.location

                let loc = matchstr(getline(sr), s:p.location)

                if empty(loc)
                    let [srx, scx] = searchpos('\S', 'n', 0 , 100)
                    if srx == 0
                        call riv#warning(g:_riv_e.TAR_NOT_FOUND)
                        return -2
                    endif
                    call s:cursor(sr, sc)
                    return 2
                else
                    let sc = match(getline(sr), s:p.location)
                endif

            else
                call riv#warning(g:_riv_e.TAR_NOT_FOUND)
                return -2
            endif
        endif

        let pwd = expand('%:p')

        let move_only = a:0 ? a:1 : 0
        if move_only != 1 && g:riv_open_link_location == 1 
            " Open file have extenstins or exists
            if loc =~ s:p.link_uri
                call riv#link#browse(loc)
                " call riv#echo("Use :RivLinkShow <C-E>ks to move to link's location.")
                return 2
            else
                if fnamemodify(loc, ":e") == 'html'
                    let loc = fnamemodify(loc, ":s?html?rst?")
                endif
                if s:is_file(loc) || loc =~ s:p.ext_file_link
                    call riv#file#edit(loc)
                    " call riv#echo("Use :RivLinkShow <C-E>ks to move to link's location.")
                    return 2
              endif
            endif
        endif
        " put cursor on location
        call s:cursor(sr, sc+1)

        return 2

    elseif !empty(mo.groups[3])
        if !empty(mo.groups[4])             " it's file://xxx
            if mo.str =~ '^file'
                update
                call riv#file#edit(expand(mo.groups[4]))
            else
                " vim will expand the # and % , so escape it.
                " XXX: the groups[4] will remove the http/https , so use entire
                call riv#link#browse(mo.groups[0])
            endif
        else
            if mo.groups[3] =~ s:p.link_mail
                let mo.groups[3] = 'mailto:' . mo.groups[3]
            endif
            call riv#link#browse(mo.groups[3])
        endif
        return 3
    elseif !empty(mo.groups[5])
        call riv#file#edit(riv#link#path(mo.groups[5]))
        return 4
    elseif !empty(mo.groups[6])
        if riv#path#is_relative(mo.str)
            let dir = expand('%:p:h').'/'
            let file = dir . mo.str
            if riv#path#is_directory(file) &&
                \ riv#path#is_rel_to_root(file)
                let file = file . riv#path#idx_file()
            endif
        else
            let file = expand(mo.str)
        endif
        update
        call riv#file#edit(file)
        return 5
    endif
endfun "}}}

fun! riv#link#path(str) "{{{
    " return the local file path contained in the string.
    
    ">>>> let g:_temp = riv#path#file_link_style() 
    ">>>> let riv#path#file_link_style() = 1
    ">>>> echo riv#link#path('[[xxx]]')
    ">xxx.rst
    ">>>> echo riv#link#path('[[xxx.vim]]')
    ">xxx.vim
    ">>>> echo riv#link#path('[[xxx/]]')
    ">xxx/index.rst
    ">>>> echo riv#link#path('[[/xxx]]')
    ">ROOT/xxx.rst
    ">>>> echo riv#link#path('[[~/xxx]]')
    ">~/xxx
    ">>>> let riv#path#file_link_style() = 2
    ">>>> echo riv#link#path(':doc:`xxx`')
    ">xxx.rst
    ">>>> echo riv#link#path(':doc:`xxx.vim`')
    ">xxx.vim
    ">>>> echo riv#link#path(':doc:`xxx/`')
    ">xxx/index.vim
    ">>>> echo riv#link#path(':doc:`/xxx`')
    ">ROOT/xxx.rst
    ">>>> echo riv#link#path(':doc:`~/xxx`')
    ">~/xxx
    ">>>> let riv#path#file_link_style() = g:_temp

    let [f,t] = riv#ptn#get_file(a:str)
    if riv#path#is_relative(f)
        let file = riv#path#join(expand('%:p:h'), f)
    else
        " if it have '/' at start. 
        " it is the doc root for sphinx and moinmoin 
        if f =~ '^/'
            let file = riv#path#root() . f[1:]
        else
            let file = expand(f)
            return file
        endif
    endif
    if riv#path#is_directory(file) && t == 'doc'
        let file = file .riv#path#idx_file() 
    elseif fnamemodify(file, ':e') =~ '^$' && t == 'doc'
        let file = file . riv#path#ext() 
    endif
    
    return file
endfun "}}}

fun! s:get_link_idx(line, col) "{{{
    let idx = riv#ptn#get_tar_idx(a:line, a:col)
    let idx = idx==-1 ? riv#ptn#get_role_idx(a:line, a:col) : idx
    let idx = idx==-1 ? riv#ptn#get_phase_idx(a:line, a:col) : idx
    let idx = idx==-1 ? riv#ptn#get_WORD_idx(a:line, a:col) : idx
    return idx
endfun "}}}

" highlight
let [s:hl_row, s:hl_bgn,s:hl_end] = [0, 0 , 0]
fun! riv#link#hi_hover() "{{{
    
    let [row,col] = getpos('.')[1:2]

    " if col have not move out prev hl region , skip
    if !&modified && row == s:hl_row && col >= s:hl_bgn && col <= s:hl_end
        return
    endif
    let [s:hl_row, s:hl_bgn,s:hl_end] = [row, 0 , 0]

    let line = getline(row)
    let idx = s:get_link_idx(line, col)
    
    if idx != -1
        let obj = riv#ptn#match_object(line, riv#ptn#link_all(), idx)
        if !empty(obj) && obj.start < col
            let bgn = obj.start + 1
            let end = obj.end
            if col <= end+1
                let [s:hl_row, s:hl_bgn,s:hl_end] = [row, bgn, end]
                if !empty(obj.groups[5]) || !empty(obj.groups[6]) 
                    if !empty(obj.groups[5]) 
                        let file = riv#link#path(obj.str)
                    else
                        let file = expand(obj.str)
                    endif
                    " if link invalid
                    if ( riv#path#is_directory(file) && !isdirectory(file) ) 
                        \ ||( !riv#path#is_directory(file) && !filereadable(file) )
                        execute '2match '.g:riv_file_link_invalid_hl.' /\%'.(row)
                                    \.'l\%>'.(bgn-1) .'c\%<'.(end+1).'c/'
                        return
                    endif
                endif
                execute '2match' "IncSearch".' /\%'.(row)
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

if expand('<sfile>:p') == expand('%:p') "{{{
    " call doctest#start()
endif "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
