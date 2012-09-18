"=============================================
"    Name: riv.vim
"    File: riv.vim
" Summary: rst filetype plugin
"  Author: Rykka G.F
"  Update: 2012-09-19
"=============================================

let g:riv_force = exists("g:riv_force") ? g:riv_force : 0
if exists("b:did_rstftplugin") && g:riv_force == 0 | finish | endif
let b:did_rstftplugin = 1
let s:cpo_save = &cpo
set cpo-=C
" settings {{{
setl foldmethod=expr foldexpr=riv#fold#expr(v:lnum) foldtext=riv#fold#text()
setl comments=fb:.. commentstring=..\ %s 
setl formatoptions+=tcroql
setl expandtab
let b:undo_ftplugin = "setl fdm< fde< fdt< com< cms< et< fo<"
            \ "| sil! unlet! b:riv_state b:riv_obj b:riv_flist"
            \ "| mapc <buffer>"
            \ "| sil! menu disable Riv.*"
            \ "| sil! menu enable Riv.Index"
            \ "| au! RIV_BUFFER"
" for table init
let b:riv={}
"}}}
if !exists("*s:map") "{{{
fun! s:imap(map_dic) "{{{
    for [name, act] in items(a:map_dic)
        exe "ino <buffer><expr><silent> ".name." ".act
    endfor
endfun "}}}
fun! s:map(map_dic) "{{{
    let leader = g:riv_buf_leader
    for [name, act] in items(a:map_dic)
        let [nmap,mode,lmap] = act
        if type(nmap) == type([])
            for m in nmap
                exe "map <silent><buffer> ".m." <Plug>".name
            endfor
        elseif nmap!=''
            exe "map <silent><buffer> ".nmap." <Plug>".name
        endif
        if mode =~ 'm'
            exe "map <silent><buffer> ". leader . lmap ." <Plug>".name
        endif
        if mode =~ 'n'
            exe "nma <silent><buffer> ". leader . lmap ." <Plug>".name
        endif
        if mode =~ 'i'
            exe "ima <silent><buffer> ". leader . lmap ." <C-O><Plug>".name
        endif

        unlet! nmap
    endfor
endfun "}}}
fun! s:fold_map(map_dic) "{{{
    let leader = g:riv_buf_leader
    for [name,acts] in items(a:map_dic)
         exe "nor <silent> <buffer> <Plug>".name." ".acts[0]
       exe "map <silent> <buffer> ". leader . acts[1] ." ". acts[0]
    endfor
endfun "}}}
endif "}}}

call s:imap(g:riv_default.buf_imaps)
call s:map(g:riv_default.buf_maps)
call s:fold_map(g:riv_default.fold_maps)
call riv#show_menu()
aug RIV_BUFFER "{{{
    if exists("g:riv_auto_format_table") "{{{
        au! InsertLeave <buffer> call riv#table#format_pos()
    endif "}}}
    if exists("g:riv_link_cursor_hl") "{{{
        " cursor_link_highlight
        au! CursorMoved,CursorMovedI <buffer>  call riv#link#hi_hover()
        " clear the highlight before bufwin/winleave
        au! WinLeave,BufWinLeave     <buffer>  2match none
    endif "}}}
    au  WinLeave,BufWinLeave     <buffer>  call riv#file#update()
    au! BufWritePost <buffer>  call riv#fold#update() 
    au  BufWritePost <buffer>  call riv#todo#update()
    au! BufWritePre  <buffer>  call riv#create#auto_mkdir()
aug END "}}}

" tests 
"}}}
let &cpo = s:cpo_save
unlet s:cpo_save
