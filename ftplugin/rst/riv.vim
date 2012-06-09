"=============================================
"    Name: rstin.vim
"    File: rstin.vim
" Summary: ReST file plugin
"  Author: Rykka G.Forest
"  Update: 2012-06-09
" Version: 0.5
"=============================================

let g:rst_force = exists("g:rst_force") ? g:rst_force : 0
if exists("b:did_rstftplugin") && g:rst_force == 0 | finish | endif
let b:did_rstftplugin = 1
let s:cpo_save = &cpo
set cpo-=C
" settings {{{
setl foldmethod=expr foldexpr=riv#fold#expr() foldtext=riv#fold#text()
setl comments=fb:.. commentstring=..\ %s expandtab
setl formatoptions+=tcroql
let b:undo_ftplugin = "setl fdm< fde< fdt< com< cms< et< fo<"
            \ "| unlet! b:dyn_sec_list b:foldlevel b:fdl_before_exp b:fdl_cur_list"
            \ "| unlet! b:fdl_before_list b:rst_table"
            \ "| mapc <buffer>"
" for table init
let b:rst_table={}
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
endif "}}}
"
let s:maps = {
    \'RivLinkOpen'       : [['<CR>', '<KEnter>'],  'n',  'lo'],
    \'RivLinkForward'    : ['<TAB>',  'n',  'lf'],
    \'RivLinkBackward'   : ['<S-TAB>',  'n',  'lf'],
    \'RivLinkDBClick'    : ['<2-LeftMouse>',  '',  ''],
    \'RivListShiftFor'   : [['>', '<C-ScrollwheelUp>' ],  'mi',  'eu'],
    \'RivListShiftBack'  : [['<', '<C-ScrollwheelDown>'],  'mi',  'ed'],
    \'RivListTodo'       : ['',  'mi',  'ee'],
    \'RivListType1'      : ['',  'mi',  'e1'],
    \'RivListType2'      : ['',  'mi',  'e2'],
    \'RivListType3'      : ['',  'mi',  'e3'],
    \'RivListType0'      : ['',  'mi',  'e`'],
    \'RivCreateFootnote' : ['',  'mi',  'cf'],
    \'RivTableFormat'    : ['',  'n',   'tf'],
    \'RivTestReload'     : ['',  'm',   'TR'],
    \'RivTestFold'       : ['',  'm',   'TF'],
    \'RivTestInsert'     : ['',  'm',   'TI'],
    \}
let s:imaps = {
    \'<BS>'    : 'riv#action#ins_bs()',
    \'<CR>'    : 'riv#action#ins_enter()',
    \'<Tab>'   : 'riv#action#ins_tab()',
    \'<S-Tab>' : 'riv#action#ins_stab()',
    \}


call s:imap(s:imaps)
call s:map(s:maps)

if exists("g:riv_auto_format_table") "{{{
    au! InsertLeave <buffer> call riv#table#format_pos()
endif "}}}
if exists("g:riv_hover_link_hl") "{{{
    " cursor_link_highlight
    au! CursorMoved,CursorMovedI <buffer>  call riv#link#hi_cursor()
    " clear the highlight before bufwin/winleave
    au! WinLeave,BufWinLeave     <buffer>  2match none
endif "}}}

" tests 
"}}}
let &cpo = s:cpo_save
unlet s:cpo_save
