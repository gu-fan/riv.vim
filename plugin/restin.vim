"=============================================
"    Name: restin.vim
"    File: restin.vim
"  Author: Rykka G.Forest
"  Update: 2012-05-19
" Version: 0.1
"=============================================

if exists("g:restin_loaded")
    finish
endif
let g:restin_loaded = 1

fun! s:up_index()
    if filereadable("../index.rst")
        e ../index.rst
    elseif filereadable("index.rst") && expand('%') != "index.rst"
        call <SID>cindex("rst")
    else
        echo "You already reached the root level."
    endif
endfun

fun! s:cindex(ftype) "{{{
    let idx = "index.".a:ftype
    if filereadable(idx)
        if expand('%') == idx
            edit #
        else
            exe "edit ". idx
        endif
    else
        echo "No index for current page"
    endif
endfun "}}}

if has("python")
    py import sys
    py import vim
    py sys.path.append(vim.eval("expand('<sfile>:p:h')")  + '/restin/')
    py from restin import *
    com! RestFormatTable py BufParse().format_table(int(vim.eval("line('.')")))
    nno <script><Plug>RestInFormatTable    :RestFormatTable<CR>
    map <unique><silent><leader>rt <Plug>RestInFormatTable
endif


com! RestInIndex    e ~/Dropbox/rst/index.rst
com! RestInUpIndex  call <SID>up_index()
com! RestInCIndex   call <SID>cindex("rst")
com! RestInLastRest exe "edit ".g:last_rst_file


nno <script><Plug>RestInIndex       :RestInIndex<CR>
nno <script><Plug>RestInUpIndex     :RestInUpIndex<CR>
nno <script><Plug>RestInCIndex      :RestInCIndex<CR>
nno <script><Plug>RestInLastRest    :RestInLastRest<CR>

map <unique><silent><leader>rr <Plug>RestInIndex
map <unique><silent><leader>ro <Plug>RestInLastRest
map <unique><silent><leader>ru <Plug>RestInUpIndex
map <unique><silent><leader>ri <Plug>RestInCIndex

