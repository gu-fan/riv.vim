"=============================================
"    Name: restin.vim
"    File: restin.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-07
" Version: 0.1
"=============================================
let s:cpo_save = &cpo
set cpo-=C
if exists("g:_riv_loaded")
    finish
endif
let g:_riv_loaded = 1


" TODO: a GUI setting and cache.
fun! s:default_opt(opt_dic) "{{{
    " OPT_NAME: OPT_VAL
    for [opt,var] in items(a:opt_dic)
        if !exists('g:riv_'.opt)
            let g:riv_{opt} = var
        endif
        unlet! var
    endfor
endfun "}}}
fun! s:default_map(map_dic) "{{{
    let leader = g:riv_leader_map
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
    let proj = g:riv_proj_temp
    for [key,var] in items(a:proj)
        let proj[key] = var
    endfor
    call insert(g:riv_project_list, proj)
    return proj
endfun "}}}
fun! s:exe_proj(index,action) "{{{
    if exists("g:riv_project_list[".a:index."]")
        let proj = g:riv_project_list[a:index]
    else
        let proj = g:riv_project_list[0]
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


let g:riv_proj_temp = {
            \ 'path'          : '~/Documents/RIV',
            \ 'html_path'     : '~/Documents/RIV/.html',
            \ 'template_path' : '~/Documents/RIV/.template' ,
            \ 'index'         : 'index' }
let g:riv_project_list = [ ] 
let g:riv_project = !exists("g:riv_project") ? s:set_proj(g:riv_proj_temp) : 
            \ s:set_proj(g:riv_project)

let s:opts = {    
    \'no_space'   : 1 ,
    \'fix_idt'    : 1 ,
    \'leader_map' : '<leader>',
    \'bufleader_map' : '<leader>',
    \'ext_ptn'    : ['vim', 'cpp', 'c', 'py', 'rb', 'lua', 'pl'],
    \'hl_code'    : ["lua","python","cpp","c","javascript","vim","sh"],
    \'todo_levels': [' ','o','X'],
    \'todo_timestamp': 1,
    \}
let s:maps = {
    \'RformatTable' : ['riv#table#format()', 'rf', ''],
    \'RaddRow'      : ['riv#table#newline()', '', 'n'],
    \'Rindex'       : ['call s:exe_proj(0,"index")', 'rr', 'n'],
    \}

call s:default_opt(s:opts)
call s:default_map(s:maps)


if !exists("g:_RIV_c") "{{{
    let g:_RIV_c = {'path':{},'ptn':{}}
    let g:_RIV_c.path.plugin = expand('<sfile>:p:h')
    let g:_RIV_c.path.autoload = fnamemodify(g:_RIV_c.path.plugin,":h")
                \.'/autoload'

    if has("python") "{{{
        let g:_RIV_c['py'] = "py "
        let g:_RIV_c.has_py = 2
    elseif has("python3")
        let g:_RIV_c['py'] = "py3 "
        let g:_RIV_c.has_py = 3
    else
        let g:_RIV_c['py'] = "echom "
        let g:_RIV_c.has_py = 0
    endif "}}}
    if g:_RIV_c.has_py && !exists("g:_RIV_c.py_imported") "{{{
        try 
            exe g:_RIV_c.py "import sys"
            exe g:_RIV_c.py "import vim"
            exe g:_RIV_c.py "sys.path.append(vim.eval('g:_RIV_c.path.autoload')  + '/riv/')"
            exe g:_RIV_c.py "from rivlib.table import GetTable,Add_Row"
            let g:_RIV_c.py_imported = 1
        catch 
            let g:_RIV_c.py_imported = 0
        endtry
    endif "}}}
    
    let g:_RIV_c.ptn.tbl  = '^\s*+[-=+]\++\s*$\|^\s*|\s.\{-}\s|\s*$'
    let g:_RIV_c.ptn.tbl_sep  = '^\s*+[-=+]\++\s*$'
    let g:_RIV_c.ptn.tbl_con  = '^\s*|\s.\{-}\s|\s*$'
    let g:_RIV_c.ptn.cel  = '\v%(^|\s)\|\s\zs|^\s*$'
    let g:_RIV_c.ptn.cel0 = '\v^\s*\|\s\zs'


    let g:_RIV_c.ptn.list = '\v\c^\s*%([-*+]|%(\d+|[#a-z]|[imcxv]+)[.)]|\(%(\d+|[#a-z]|[imcxv]+)\))\s+'
    let g:_RIV_c.ptn.field_list= '^\s*:[^:]\+:\s\+\ze\S.\+[^:]$'
    let g:_RIV_c.ptn.list_or_exp_or_S = g:_RIV_c.ptn.list.'|^\s*\.\.\s|^\S'

    let g:_RIV_c.ptn.exp = '^\.\.\_s'
    let g:_RIV_c.ptn.s_exp = '^\s*\.\.\_s'
    let g:_RIV_c.ptn.s_or_exp = '^\S\@!\|^\.\.\s.'

    let g:_RIV_c.ptn.blank = '^\s*$'
    let g:_RIV_c.ptn.indent = '^\s*'
    let g:_RIV_c.ptn.S_bgn = '^\S'

    let g:_RIV_c.ptn.literal_block= '[^:]::\s*$'

    let g:_RIV_c.ptn.section = '^\v([=`:.''"~^_*+#-])\1+\s*$'

    let g:_RIV_c.ptn.exp_cluster = '^rst\%(Comment\|\%(Ex\)\=Directive\|HyperlinkTarget\)'
    

    let g:_RIV_c.ptn.list_m1 = '\v('. g:_RIV_c.ptn.list .')'
    let g:_RIV_c.ptn.list_box = g:_RIV_c.ptn.list_m1 . '\[(.)\] '
    let g:_RIV_c.ptn.timestamp = '(\d{4}-\d{2}-\d{2})\_s'
    let g:_RIV_c.ptn.list_tms = g:_RIV_c.ptn.list_box . g:_RIV_c.ptn.timestamp

    let g:_RIV_c.ptn.fmt_time = "%Y-%m-%d"

    let g:_RIV_c.sec_punc = '!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~'
    let g:_RIV_c.list_lvs = ["*","+","-"]
    " URI
    " http://xxx.xxx.xxx file:///xxx/xxx/xx  
    " mailto:xxx@xxx.xxx 
    let g:_RIV_c.ptn.lnk = '\v(%(file|https=|ftp|gopher)://|%(mailto|news):)([^[:space:]''\"<>]+[[:alnum:]/])'
    " inline link patterns
    " `xxxx  <URL>`
    " standlone link patterns
    " www.xxx-x.xxx/?xxx
    let g:_RIV_c.ptn.lnk2 = '\vwww[[:alnum:]_-]*\.[[:alnum:]_-]+\.[^[:space:]''\"<>]+[[:alnum:]/]'

    let g:_RIV_c.ptn.file_ext= join(s:normlist(g:riv_ext_ptn),'|')
    let g:_RIV_c.ptn.file= '\v([~0-9a-zA-Z:./_-]+%(\.%(rst|'. g:_RIV_c.ptn.file_ext .')|/))\S@!'
    " ref target patterns
    " [xxx]_  xxx_ `xxx xx`_
    let g:_RIV_c.ptn.link_tar= '\v\ze%(\_s|^)%(\`[[:alnum:]. -]+`_|[[:alnum:].-_]+_|\[[[:alnum:].-_]+\]_)\ze%(\_s|$)'
    " ref definition patterns
    " .. _xxx :
    " .. [xxx]
    " _`xxx xxx`
    let g:_RIV_c.ptn.link_def = '\v_`\[=\zs[0-9a-zA-Z]*\ze\]=`|^\.\. (_\zs[0-9a-zA-Z]+|\[\zs[0-9a-zA-Z]+\ze\])'

    let g:_RIV_c.ptn.link_grp = [g:_RIV_c.ptn.lnk,g:_RIV_c.ptn.file,g:_RIV_c.ptn.link_def,g:_RIV_c.ptn.link_tar,g:_RIV_c.ptn.lnk2]



    " don't modify it anymore
    lockvar 2 g:_RIV_c
endif "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
