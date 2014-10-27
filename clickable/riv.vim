let s:p = g:_riv_p
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

fun! s:is_file(file) "{{{
    return filereadable(a:file)
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
function! s:init_clickable() "{{{
    let Class = clickable#class#init()
    let Basic = clickable#class#basic#init()
    let File = clickable#class#file#init()
    let Link = clickable#class#link#init()

    let config = {}

    let config.riv_tar = Class('riv_tar',Link, {
        \ 'name': 'riv_tar',
        \ 'pattern': g:_riv_p.link_tar,
        \ 'tooltip': 'riv tar:',
        \ 'syn_sep': '~',
        \ 'filetype': 'rst',
        \ 'syn_args': 'containedin=ALLBUT,'.clickable#get_opt('prefix').'.* contained',
        \})

    function! config.riv_tar.trigger(...) dict "{{{

        let [row,col] = getpos('.')[1:2]
        let line = getline(row)

        let mo = riv#ptn#match_object(line, riv#ptn#get_ptn('link_line_target'), 0)
        let [sr,sc] = s:find_ref(mo.str)

        if sr != 0
            call s:cursor(sr, sc)
            return 1
        else
            call riv#warning(g:_riv_e.REF_NOT_FOUND)
            return -1
        endif
    endfunction "}}}

    let config.riv_ref = Class('riv_ref',Link, {
        \ 'name': 'riv_ref',
        \ 'pattern': g:_riv_p.link_ref,
        \ 'tooltip': 'riv ref:',
        \ 'syn_sep': '~',
        \ 'filetype': 'rst',
        \})
    function! config.riv_ref.trigger(...) dict "{{{
        let [row,col] = getpos('.')[1:2]
        let line = getline(row)

        let mo = riv#ptn#match_object(line, riv#ptn#get_ptn('link_ref'), 0)

        " check if it's embbed link
        let loc = matchstr(mo.groups[2], s:p.loc_embed)
        let [sr, sc] = [0, 0]
        if empty(loc)
            let [sr,sc] = s:find_tar(mo.str)
            if sr != 0

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
                call clickable#util#browse(loc, self.browser)
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
    endfunction "}}}

    call clickable#export(config)
endfunction "}}}

call s:init_clickable()
