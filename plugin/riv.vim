"=============================================
"    Name: restin.vim
"    File: restin.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-09
" Version: 0.1
"=============================================
let s:cpo_save = &cpo
set cpo-=C
if exists("g:_riv_loaded")
    if exists("g:_riv_debug") && g:_riv_debug==1
        unlet! g:_RIV_c
        unlockvar g:_RIV_c
    else
        finish
    endif
endif
let g:_riv_loaded = 1

fun! s:error(msg)
    echohl ErrorMsg
    redraw
    echo a:msg
    echohl Normal
endfun

" TODO: a GUI setting interface and cache.
fun! s:default_opt(opt_dic) "{{{
    for [opt,var] in items(a:opt_dic)
        if !exists('g:riv_'.opt)
            let g:riv_{opt} = var
        elseif type(g:riv_{opt}) != var
            call s:error("Wrong option type for 'g:riv_".opt."'! Use default.")
            unlet! g:riv_{opt}
            let g:riv_{opt} = var
        endif
        unlet! var
    endfor
endfun "}}}
fun! s:default_map(map_dic) "{{{
    for [name,action] in items(a:map_dic)
        sil! exe "map <silent> <Plug>".name." ".action
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
fun! s:exe_proj(action) "{{{
    if a:0
        let index = a:1
    else
        let index = 0
    endif
    if exists("g:riv_project_list[".index."]")
        let proj = g:riv_project_list[index]
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

fun! s:normlist(list,...) "{{{
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

" Options:
" fold_show_blank_line: 0,1,2,3 (default:2)
" 0     show no blank line
" 1     show one blank line
" 2     show all but one blank line
" 3     show all blank line

" fold_level: 0,1,2,3,4         (defualt:3)
" 0     no folding
" 1     section
" 2     section and list
" 3     section and list and explicit_mark and table
" 4     section and list and explicit_mark and table and simple table

" auto_format_table: 0,1        (default:1)
" 0     off
" 1     on
let s:default = {}
let s:default.opts = {
    \'leader'               : '<leader>',
    \'buf_leader'           : '<c-e>',
    \'buf_ins_leader'       : '<c-e>',
    \'ext_ptn'              : ['vim', 'cpp', 'c', 'py', 'rb', 'lua', 'pl'],
    \'hl_code'              : ["lua","python","cpp","c","javascript","vim","sh"],
    \'todo_levels'          : [' ','o','X'],
    \'todo_timestamp'       : 1,
    \'hover_link_hl'        : 1,
    \'auto_format_table'    : 1,
    \'fold_show_blank_line' : 2,
    \'fold_level'           : 3,
    \'list_toggle_type'     : "*,#.,(#)",
    \}
let s:default.maps = {
    \'RivIndex'          : ':call <SID>exe_proj("index")<CR>',
    \'RivLinkOpen'       : ':call riv#link#parse()<CR>',
    \'RivLinkForward'    : ':call riv#link#finder("f")<CR>',
    \'RivLinkBackward'   : ':call riv#link#finder("b")<CR>',
    \'RivLinkDBClick'    : ':call riv#action#db_click("b")<CR>',
    \'RivListShiftFor'      : ':call riv#list#shift("+")<CR>',
    \'RivListShiftBack'  : ':call riv#list#shift("-")<CR>',
    \'RivListTodo'       : ':call riv#list#tog_box()<CR>',
    \'RivListType1'      : ':call riv#list#tog_typ(0)<CR>',
    \'RivListType2'      : ':call riv#list#tog_typ(1)<CR>',
    \'RivListType3'      : ':call riv#list#tog_typ(2)<CR>',
    \'RivListType0'      : ':call riv#list#tog_typ(3)<CR>',
    \'RivCreateFootnote' : ':call riv#link#create("footnote",1)<CR>',
    \'RivTestReload'     : ':let g: rst_force=1 | set ft=rst | let g:rst_force=0<CR>',
    \'RivTestFold'       : ':call riv#test#fold(0)<CR>',
    \'RivTestInsert'     : ':call riv#test#insert_idt(0)<CR>',
    \'RivTableFormat'    : ':call riv#table#format()<CR>',
    \}
call s:default_opt(s:default.opts)
call s:default_map(s:default.maps)

exe "map <silent>". g:riv_leader . "rr <Plug>RivIndex"

map <silent> <leader>rr <Plug>RivIndex
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
            exe g:_RIV_c.py "from rivlib.table import GetTable"
            exe g:_RIV_c.py "from rivlib.buffer import RivBuf"
            let g:_RIV_c.py_imported = 1
        catch
            let g:_RIV_c.py_imported = 0
        endtry
    endif "}}}

    " The table
    " +--------+     \s*+[-=+]\++\s*
    " |  wfwef |     \s*|.\{-}|\s*
    " +====+===+
    " |    |   |
    " +----+   |     \s*+[=+-]\++.\{-}|\s*        \s*|.\{-}+[=+-]\++\s*
    " |    |   |
    " +----+---+
    let g:_RIV_p = {}
    let g:_RIV_p.tbl  = '^\s*+[-=+]\++\s*$'
                    \.'\|^\s*|\s.\{-}\s|\s*$'
                    \.'\|^\s*+[=+-]\++.*|\s*$'
                    \.'\|^\s*|.\{-}+[=+-]\++\s*$'
    let g:_RIV_p.tbl_sep  = '^\s*+[-=+]\++\s*$'
    let g:_RIV_p.tbl_con  = '^\s*|\s.\{-}\s|\s*$'
    let g:_RIV_p.cel  = '\v%(^|\s)\|\s\zs|^\s*$'
    let g:_RIV_p.cel0 = '\v^\s*\|\s\zs'

    " ======  ===============
    let g:_RIV_p.spl_tbl  = '^\s*=\+\s\+=[=[:space:]]\+\s*$'

    let g:_RIV_p.list = '\v\c^\s*%([-*+]'
                \.'|%(\d+|[#a-z]|[imcxv]+)[.)]'
                \.'|\(%(\d+|[#a-z]|[imcxv]+)\))\s+'
    let g:_RIV_p.field_list= '^\s*:[^:]\+:\s\+\ze\S.\+[^:]$'
    let g:_RIV_p.list_or_exp_or_S = g:_RIV_p.list.'|^\s*\.\.\s|^\S'

    " explicit_mark
    let g:_RIV_p.exp_m = '^\.\.\_s'
    let g:_RIV_p.s_exp = '^\s*\.\.\_s'
    let g:_RIV_p.s_or_exp = '^\S\@!\|^\.\.\s.'
    let g:_RIV_p.exp_footnote = '^\.\.\s\[\(\d\+\)\]\s\+:'

    let g:_RIV_p.blank = '^\s*$'
    let g:_RIV_p.indent = '^\_s\+'
    let g:_RIV_p.s_bgn = '^\_s\|^$'
    let g:_RIV_p.S_bgn = '^\S'

    let g:_RIV_p.literal_block= '[^:]::\s*$'

    let g:_RIV_p.section = '^\v([=`:.''"~^_*+#-])\1+\s*$'



    let g:_RIV_p.list_m1 = '\v('. g:_RIV_p.list .')'
    let g:_RIV_p.list_box = g:_RIV_p.list_m1 . '\[(.)\] '
    let g:_RIV_p.timestamp = '(\d{4}-\d{2}-\d{2})\_s'
    let g:_RIV_p.list_tms = g:_RIV_p.list_box . g:_RIV_p.timestamp

    let g:_RIV_p.fmt_time = "%Y-%m-%d"

    let g:_RIV_c.sec_punc = '!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~'
    let g:_RIV_c.list_lvs = ["*","+","-"]

    let s:ref_name = '[[:alnum:]]\+\%([_.-][[:alnum:]]\+\)'
    " URI
    " http://xxx.xxx.xxx file:///xxx/xxx/xx
    " mailto:xxx@xxx.xxx
    let g:_RIV_p.link = '\v(%(file|https=|ftp|gopher)://|%(mailto|news):)([^[:space:]''\"<>]+[[:alnum:]/])'
                \.'|www[[:alnum:]_-]*\.[[:alnum:]_-]+\.[^[:space:]''\"<>]+[[:alnum:]/]'
    " inline link patterns
    " `xxxx  <URL>`
    " standlone link patterns
    " www.xxx-x.xxx/?xxx

    let g:_RIV_p.file_ext= join(s:normlist(g:riv_ext_ptn),'|')
    let g:_RIV_p.link_file = '\v([[:alnum:]~:./_-]+'
                \.'%(\.%(rst|'. g:_RIV_p.file_ext .')|/))\S@!'
    " ref target patterns
    " [xxx]_  xxx_ `xxx xx`_
    let g:_RIV_p.link_tar= '\v%(\_s\zs|^)'
                \.'%(\`[[:alnum:]. -]+`_'
                \.'|[[:alnum:].-_]+_'
                \.'|\[[[:alnum:].-_]+\]_)'
                \.'\ze%(\_s|$)'
    " ref definition patterns
    " .. _xxx :
    " .. [xxx]
    " _`xxx xxx`
    let g:_RIV_p.link_def = '\v_`\[=\zs[0-9a-zA-Z]*\ze\]=`'
                \.'|^\.\.\s%(_\zs[[:alnum:]_.-]+\ze\s+:'
                \.'|\[\zs[[:alnum:]]+\ze\])'

    let g:_RIV_p.link_grp = [g:_RIV_p.link, g:_RIV_p.link_file, g:_RIV_p.link_def, g:_RIV_p.link_tar]

    let g:_RIV_p.all_link = g:_RIV_p.link . '|' . g:_RIV_p.link_file
                \ . '|' . g:_RIV_p.link_tar
                \ . '|' . g:_RIV_p.link_def

    let g:_RIV_t = {}
    " if g:riv_fold_show_blank_line == 1
    "     let eval_str = '(c_line =~ g:_RIV_p.blank && p_line =~ g:_RIV_p.blank && nnb_line=~g:_RIV_p.S_bgn ) || (c_line=~g:_RIV_p.S_bgn)'

    let g:_RIV_t.list_type = split(g:riv_list_toggle_type,',')
    " don't touch this
    lockvar 2 g:_RIV_c

endif "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
