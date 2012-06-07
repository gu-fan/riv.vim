"=============================================
"    Name: rstin.vim
"    File: rstin.vim
" Summary: ReST file plugin
"  Author: Rykka G.Forest
"  Update: 2012-06-05
" Version: 0.5
"=============================================

let g:rst_force = exists("g:rst_force") ? g:rst_force : 0
if exists("b:did_rstftplugin") && g:rst_force == 0 | finish | endif
let b:did_rstftplugin = 1
let s:cpo_save = &cpo
set cpo-=C
" settings {{{
setl foldmethod=expr foldexpr=riv#fold#expr(v:lnum) foldtext=riv#fold#text()
setl comments=fb:.. commentstring=..\ %s expandtab
setl formatoptions+=tcroql
let b:undo_ftplugin = "setl fdm< fde< fdt< com< cms< et< fo<"
            \ "| unlet! b:dyn_sec_list b:foldlevel b:fdl_before_exp b:fdl_cur_list"
            \ "| unlet! b:fdl_before_list b:rst_table"
" for table init
let b:rst_table={}
"}}}
if !exists("*s:default_buf_map") "{{{
fun! s:default_buf_map(map_dic) "{{{
    " let bufleader = g:riv_bufleader_map
    " NAME: [ com , map , mode  ]
    for [name,val] in items(a:map_dic)
        let [com,map,mode] = val
        exe "com! -buffer ".name." ".com
        if map!=""
            " exe mode . "nor <buffer><script><Plug>".name." :".name."<CR>"
            " exe mode . "map <unique><buffer><silent>".bufleader.map." <Plug>".name
            exe mode . "map <unique><buffer><silent>".map." ".name."<CR>"
        endif
    endfor
endfun "}}}
endif "}}}

let s:buf_map_dic = {
        \ 'BRparseCur' : ['call <SID>parse_cur()<CR>', '<CR>', ]
        \}

" map and cmd {{{
" file jumper
exe 'let g:last_rst_file="'.expand('%:p').'"'
nno <silent><buffer><Leader>ri :call <SID>cindex("rst")<CR>


" link parser
nno <silent><buffer><CR> :call riv#cursor#parse()<CR>
nno <silent><buffer><Tab> :call riv#link#finder("n")<CR>
nno <silent><buffer><S-Tab> :call riv#link#finder("b")<CR>
nno <silent><buffer><Kenter> :call riv#cursor#parse()<CR>
nno <silent><buffer><2-leftmouse>  :call riv#action#db_click()<CR>

" list  and todo
no <silent><buffer><leader>ee :call riv#list#tog_box(line('.'))<CR>
no <silent><buffer><leader>e1 :call riv#list#tog_typ(line('.'),"* ")<CR>
no <silent><buffer><leader>e2 :call riv#list#tog_typ(line('.'),"#. ")<CR>
no <silent><buffer><leader>e3 :call riv#list#tog_typ(line('.'),"(#) ")<CR>
no <silent><buffer><leader>e4 :call riv#list#tog_typ(line('.'),"")<CR>

" indent
no <silent><buffer> > :call riv#list#shift_idt("")<CR>
no <silent><buffer> < :call riv#list#shift_idt("-")<CR>
no <silent><buffer> <c-scrollwheeldown> :call riv#list#shift_idt("")<CR>
no <silent><buffer> <c-scrollwheelup> :call riv#list#shift_idt("-")<CR>

" tables
ino <expr><silent><buffer> <BS> riv#action#ins_bs()
ino <expr><silent><buffer> <Enter>  riv#action#ins_enter()
ino <buffer><expr><TAB>   pumvisible() ? "\<C-n>" :  riv#action#ins_tab()
ino <buffer><expr><S-TAB> pumvisible() ? "\<C-p>" :  riv#action#ins_stab()

au! InsertLeave <buffer> call riv#table#format_pos()

" tests 
com! -buffer RstReload let g:rst_force=1 | set ft=rst | let g:rst_force=0
com! -buffer Force let g:rst_force=1 | set ft=rst | let g:rst_force=0
com! -buffer -nargs=? RstTestFold call riv#test#fold(<args>)
com! -buffer -nargs=? RstTestInsIndent call riv#test#insert_idt(<args>)
"}}}
let &cpo = s:cpo_save
unlet s:cpo_save
