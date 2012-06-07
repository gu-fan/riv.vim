"=============================================
"    Name: restin.vim
"    File: restin.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-07
" Version: 0.1
"=============================================
let s:cpo_save = &cpo
set cpo-=C
if exists("g:restin_loaded")
    finish
endif
let g:restin_loaded = 1

fun! s:up_index() "{{{
    if filereadable("../index.rst")
        e ../index.rst
    elseif filereadable("index.rst") && expand('%') != "index.rst"
        call <SID>cindex("rst")
    else
        echo "You already reached the root level."
    endif
endfun "}}}

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

" TODO: a GUI setting and cache.
fun! s:default_opt(opt_dic) "{{{
    " OPT_NAME: OPT_VAL
    for [opt,var] in items(a:opt_dic)
        if !exists('g:restin_'.opt)
            let g:restin_{opt} = var
        endif
    endfor
endfun "}}}
fun! s:default_map(map_dic) "{{{
    let leader = g:restin_leader_map
    " NAME: [ com , map , mode  ]
    for [name,val] in items(a:map_dic)
        let [com,map,mode] = val
        exe "com! ".name." ".com
        if map!=""
            exe mode . "nor <script><Plug>".name." :".name."<CR>"
            exe mode . "map <unique><silent>".leader.map." <Plug>".name
        endif
    endfor
endfun "}}}
fun! s:set_proj(proj) "{{{
    let proj = g:restin_proj_temp
    for [key,var] in items(a:proj)
        let proj[key] = var
    endfor
    call insert(g:restin_project_list, proj)
    return proj
endfun "}}}
fun! s:exe_proj(index,action) "{{{
    if exists("g:restin_project_list[".a:index."]")
        let proj = g:restin_project_list[a:index]
    else
        let proj = g:restin_project_list[0]
    endif
    if a:action == 'index'
        let path = expand(proj["path"])
        if !isdirectory(path) 
                \ && input("'".path."' Does not exist. \nCreate?(Y/n):","Y")=~?'Y'
            call mkdir(path,'p')
        endif
        exe 'edit ' . path."/".proj["index"].'.rst'
    endif
endfun "}}}

fun! s:normlist(list) "{{{
    return map(a:list,'matchstr(v:val,''\w\+'')')
endfun "}}}

if !exists("g:RESTIN_Conf") "{{{
    let g:RESTIN_Conf = {}
    let g:RESTIN_Conf.plugin_path = expand('<sfile>:p:h')
    let g:RESTIN_Conf.autoload_path = fnamemodify(g:RESTIN_Conf.plugin_path,":h")
                \.'/autoload'

    if has("python") "{{{
        let g:RESTIN_Conf['py'] = "py "
        let g:RESTIN_Conf.has_py = 2
    elseif has("python3")
        let g:RESTIN_Conf['py'] = "py3 "
        let g:RESTIN_Conf.has_py = 3
    else
        let g:RESTIN_Conf['py'] = "echom "
        let g:RESTIN_Conf.has_py = 0
    endif "}}}
    if g:RESTIN_Conf.has_py && !exists("g:RESTIN_Conf.py_imported") "{{{
        exe g:RESTIN_Conf['py']."import sys"
        exe g:RESTIN_Conf['py']."import vim"
        exe g:RESTIN_Conf['py']."sys.path.append(vim.eval('g:RESTIN_Conf.autoload_path')  + '/restin/')"
        exe g:RESTIN_Conf['py']."from restinlib.table import GetTable,Add_Row"
        let g:RESTIN_Conf.py_imported = 1
    endif "}}}

    let g:RESTIN_Conf.tbl_ptn = '^\s*+[-=+]\++\s*$\|^\s*|\s.\{-}\s|\s*$'
    let g:RESTIN_Conf.sep_ptn = '^\s*+[-=+]\++\s*$'
    let g:RESTIN_Conf.con_ptn = '^\s*|\s.\{-}\s|\s*$'
    let g:RESTIN_Conf.cel_ptn = '\v%(^|\s)\|\s\zs|^\s*$'
    let g:RESTIN_Conf.cel0_ptn = '\v^\s*\|\s\zs'
    let g:restin_ext_ptn= exists("g:restin_ext_ptn") ? g:restin_ext_ptn :
                                \ ['vim','cpp','c','py','rb','lua','pl']

    let g:RESTIN_Conf.ext_ptn= join(s:normlist(g:restin_ext_ptn),'|')

    lockvar g:RESTIN_Conf
endif "}}}

let g:restin_proj_temp = {
            \ 'path': '~/Documents/RestIn',
            \ 'html_path': '~/Documents/RestIn/.html',
            \ 'template_path' : '~/Documents/RestIn/.template' ,
            \ 'index': 'index' }
let g:restin_project_list = [ ] 
let g:restin_project = !exists("g:restin_project") ? s:set_proj(g:restin_proj_temp) : 
            \ s:set_proj(g:restin_project)

let s:opts = {    
    \'no_space'   : 1 ,
    \'fix_idt'    : 1 ,
    \'leader_map' : '<leader>'
    \'bufleader_map' : '<leader>'
    \}
let s:maps = {
    \'RformatTable' : ['riv#table#format()', 'rf', ''],
    \'RaddRow'      : ['riv#table#newline()', '', 'n'],
    \'Rindex'       : ['call s:exe_proj(0,"index")', 'rr', 'n'],
    \}

call s:default_opt(s:opts)
call s:default_map(s:maps)


let &cpo = s:cpo_save
unlet s:cpo_save
