"=============================================
"    Name: autoload/restin.vim
"    File: autoload/restin.vim
"  Author: Rykka G.Forest
"  Update: 2012-05-17
" Version: 0.5
"=============================================

if exists("g:_riv_debug") && g:_riv_debug==1
    unlet! g:_RIV_c
    unlockvar g:_RIV_c
endif
let s:autoload_path = expand('<sfile>:p:h')
" Helper "{{{1
fun! s:error(msg) "{{{
    echohl WarningMsg
    redraw
    echo a:msg
    echohl Normal
endfun "}}}
fun! s:normlist(list,...) "{{{
    return map(a:list,'matchstr(v:val,''\w\+'')')
endfun "}}}
"}}}
"{{{ Loading Functions
" TODO: a GUI setting interface and cache.
fun! riv#load_opt(opt_dic) "{{{
    for [opt,var] in items(a:opt_dic)
        if !exists('g:riv_'.opt)
            let g:riv_{opt} = var
        elseif type(g:riv_{opt}) != type(var)
            call s:error("RIV: Wrong type for Option:'g:riv_".opt."'! Use default.")
            unlet! g:riv_{opt}
            let g:riv_{opt} = var
        endif
        unlet! var
    endfor
endfun "}}}
fun! riv#load_map(map_dic) "{{{
    for [name,action] in items(a:map_dic)
        sil! exe "com! ".name." ".action
        sil! exe "map <silent> <Plug>".name." :".action."<CR>"
    endfor
endfun "}}}
fun! riv#load_menu(menu_list) "{{{
    for [name ,short, action] in a:menu_list
        let short  = short =~'  ' ? short : "<tab>".g:riv_buf_leader.short
        let action = action=~'  ' ? ' :' : '  <Plug>'.action
        exe "75 amenu RIV.".  name . short. action
    endfor
endfun "}}}
fun! riv#show_menu(t) "{{{
    if a:t == 0
        menu disable RIV.*
        menu enable RIV.Index
    else
        menu enable RIV.*
    endif
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
"}}}
"{{{ Options
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
    \'leader'               : '<C-E>',
    \'buf_leader'           : '<C-E>',
    \'buf_ins_leader'       : '<C-E>',
    \'ext_ptn'              : ['vim', 'cpp', 'c', 'py', 'rb', 'lua', 'pl'],
    \'hl_code'              : ["lua","python","cpp","c","javascript","vim","sh"],
    \'todo_levels'          : [' ','o','X'],
    \'todo_timestamp'       : 1,
    \'hover_link_hl'        : 1,
    \'auto_format_table'    : 1,
    \'fold_show_blank_line' : 2,
    \'fold_level'           : 3,
    \'list_toggle_type'     : "*,#.,(#)",
    \'localfile_linktype'   : 1,
    \'web_browser'          : "firefox",
    \'options'              : s:default,
    \'usr_syn_dir'          : "",
    \}
" maps "{{{
let s:default.maps = {
    \'RivIndex'          : 'call <SID>exe_proj("index")',
    \'RivLinkOpen'       : 'call riv#link#open()',
    \'RivLinkForward'    : 'call riv#link#finder("f")',
    \'RivLinkBackward'   : 'call riv#link#finder("b")',
    \'RivLinkDBClick'    : 'call riv#action#db_click()',
    \'RivListShiftFor'   : 'call riv#list#shift("+")',
    \'RivListShiftBack'  : 'call riv#list#shift("-")',
    \'RivListTodo'       : 'call riv#list#tog_box()',
    \'RivListType1'      : 'call riv#list#tog_typ(0)',
    \'RivListType2'      : 'call riv#list#tog_typ(1)',
    \'RivListType3'      : 'call riv#list#tog_typ(2)',
    \'RivListType0'      : 'call riv#list#tog_typ(3)',
    \'RivCreateFootnote' : 'call riv#create#link("footnote",1)',
    \'RivTestReload'     : 'call riv#test#reload()',
    \'RivTestFold0'      : 'call riv#test#fold(0)',
    \'RivTestFold1'      : 'call riv#test#fold(1)',
    \'RivTestInsert'     : 'call riv#test#insert_idt(0)',
    \'RivTableFormat'    : 'call riv#table#format()',
    \}
"}}}
" buf maps "{{{
let s:default.buf_maps = {
    \'RivLinkOpen'       : [['<CR>', '<KEnter>'],  'n',  'lo'],
    \'RivLinkForward'    : ['<TAB>',  'n',  'lf'],
    \'RivLinkBackward'   : ['<S-TAB>',  'n',  'lb'],
    \'RivLinkDBClick'    : ['<2-LeftMouse>',  '',  ''],
    \'RivListShiftFor'   : [['>', '<C-ScrollwheelDown>' ],  'mi',  'eu'],
    \'RivListShiftBack'  : [['<', '<C-ScrollwheelUp>'],  'mi',  'ed'],
    \'RivListTodo'       : ['',  'mi',  'ee'],
    \'RivListType1'      : ['',  'mi',  'e1'],
    \'RivListType2'      : ['',  'mi',  'e2'],
    \'RivListType3'      : ['',  'mi',  'e3'],
    \'RivListType0'      : ['',  'mi',  'e`'],
    \'RivCreateFootnote' : ['',  'mi',  'cf'],
    \'RivTableFormat'    : ['',  'n',   'tf'],
    \'RivTestReload'     : ['',  'm',   't`'],
    \'RivTestFold0'      : ['',  'm',   't1'],
    \'RivTestFold1'      : ['',  'm',   't2'],
    \'RivTestInsert'     : ['',  'm',   'ti'],
    \}
let s:default.buf_imaps = {
    \'<BS>'    : 'riv#action#ins_bs()',
    \'<CR>'    : 'riv#action#ins_enter()',
    \'<Tab>'   : 'riv#action#ins_tab()',
    \'<S-Tab>' : 'riv#action#ins_stab()',
    \} 
"}}}
"menus "{{{
let s:default.menus = [
    \['Index'           ,  'ww',   'RivIndex'],
    \['--Action--'      ,  '  ',   '  '],
    \['Link.Open'       ,  'lo',  'RivLinkOpen'],
    \['Link.Forward'    ,  'lf',  'RivLinkForward'],
    \['Link.Backward'   ,  'lb',  'RivLinkBackward'],
    \['Link.DBClick'    ,  '  ',  'RivLinkDBClick'],
    \['List.ShiftFor'   ,  'eu',   'RivListShiftFor'],
    \['List.ShiftBack'  ,  'ed',   'RivListShiftBack'],
    \['List.Todo'       ,  'ee',   'RivListTodo'],
    \['List.Type1'      ,  'e1',   'RivListType1'],
    \['List.Type2'      ,  'e2',   'RivListType2'],
    \['List.Type3'      ,  'e3',   'RivListType3'],
    \['List.Type0'      ,  'e`',   'RivListType0'],
    \['Create.Footnote' ,  'cf',   'RivCreateFootnote'],
    \['Table.Format'    ,  'tf',   'RivTableFormat'],
    \['--Test---'       ,  '  ',    '  '],
    \['Test.Reload'     ,  't`',   'RivTestReload'],
    \['Test.Fold0'      ,  't1',   'RivTestFold0'],
    \['Test.Fold1'      ,  't2',   'RivTestFold1'],
    \['Test.Insert'     ,  't3',   'RivTestInsert'],
    \]
"}}}
"{{{ project options
let g:riv_proj_temp = {
            \ 'path'          : '~/Documents/RIV',
            \ 'html_path'     : '~/Documents/RIV/.html',
            \ 'template_path' : '~/Documents/RIV/.template' ,
            \ 'index'         : 'index' }
let g:riv_project_list = [ ]
let g:riv_project = !exists("g:riv_project") ? s:set_proj(g:riv_proj_temp) :
            \ s:set_proj(g:riv_project)
"}}}
"}}}
fun! riv#load_conf() "{{{
" Constants "{{{
if !exists("g:_RIV_c")
    let g:_RIV_c = {'path':{}}

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
            exe g:_RIV_c.py "sys.path.append(vim.eval('s:autoload_path')  + '/riv/')"
            exe g:_RIV_c.py "from rivlib.table import GetTable"
            exe g:_RIV_c.py "from rivlib.buffer import RivBuf"
            let g:_RIV_c.py_imported = 1
        catch
            let g:_RIV_c.py_imported = 0
        endtry
    endif "}}}

    " The table
    " +--------+     \s*+\%([-=]\++\)\+\s*
    " |  wfwef |     \s*|.\{-}|\s*
    " +====+===+
    " |    |   |
    " +----+   |     \s*+\%([-=]\++\)\+.\{-}|\s*        \s*|.\{-}+\%([-=]\++\)\+\s*
    " |    |   |
    " +----+---+
    "   ^\s*\%(|\s.\{-}\)\=+\%([-=]\++\)\+\%(.\{-}\s|\)\=\s*$
    let g:_RIV_p = {}
    let g:_RIV_p.tbl_sep  = '^\s*\%(|\s.\{-}\)\=+\%([-=]\++\)\+\%(.\{-}\s|\)\=\s*$'
    let g:_RIV_p.tbl_con  = '^\s*|\s.\{-}\s|\s*$'
    let g:_RIV_p.table  =  g:_RIV_p.tbl_sep . '\|' . g:_RIV_p.tbl_con
    let g:_RIV_p.cel  = '\v%(^|\s)\|\s\zs|^\s*$'
    " the first cell
    let g:_RIV_p.cel0 = '\v^\s*\|\s\zs'

    " ======  ===============
    let g:_RIV_p.spl_tbl  = '^\s*=\+\s\+=[=[:space:]]\+\s*$'

    let g:_RIV_p.list = '\v\c^\s*%([-*+]'
                \.'|%(\d+|[#a-z]|[imcxv]+)[.)]'
                \.'|\(%(\d+|[#a-z]|[imcxv]+)\))\s+'
    let g:_RIV_p.list_sym = '\v\c^\s*\zs%([-*+]'
                \.'|%(\d+|[#a-z]|[imcxv]+)[.)]'
                \.'|\(%(\d+|[#a-z]|[imcxv]+)\))\ze\s+'
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
    " standlone link patterns
    " www.xxx-x.xxx/?xxx
    let g:_RIV_p.link_uri = '\v(%(%(file|https=|ftp|gopher)://|%(mailto|news):)([^[:space:]''\"<>]+[[:alnum:]/])'
                \.'|www[[:alnum:]_-]*\.[[:alnum:]_-]+\.[^[:space:]''\"<>]+[[:alnum:]/])'


    " inline link patterns
    " `xxxx  <URL>`

    let g:_RIV_p.file_ext= join(s:normlist(g:riv_ext_ptn),'|')
    if g:riv_localfile_linktype == 1
        let g:_RIV_p.link_file = '\v\S@<!([[:alnum:]~:./_-]+'
                    \.'%(\.%(rst|'. g:_RIV_p.file_ext .')|/))\S@!'
    elseif g:riv_localfile_linktype == 2
        let g:_RIV_p.link_file = '\v\S@<!\[([[:alnum:]~:./_-]+'
                    \.'%(\.%(rst|'. g:_RIV_p.file_ext .')|/))\]\S@!'
    else
        let g:_RIV_p.link_file = ''
    endif
    " ref reference
    " [xxx]_  xxx_ `xxx xx`_
    let g:_RIV_p.link_ref = '\v%(\_s\zs|^)'
                \.'(\`[[:alnum:]. -]+`_'
                \.'|[[:alnum:].-_]+_'
                \.'|\[[[:alnum:].-_]+\]_)'
                \.'\ze%(\_s|$)'
    " ref target patterns
    " .. _xxx :
    " .. [xxx]
    " _`xxx xxx`
    let g:_RIV_p.link_tar = '\v(_`\[=\zs[0-9a-zA-Z]*\ze\]=`'
            \.'|^\.\.\s%(_\zs[[:alnum:]_.-]+\ze\s+:|\[\zs[[:alnum:]]+\ze\]))'

    let g:_RIV_p.link_grp = [g:_RIV_p.link_uri, g:_RIV_p.link_file, g:_RIV_p.link_ref, g:_RIV_p.link_tar]

    " sub match for all_link:
    " 1 link_tar
    " 2 link_def
    " 3 link_uri
    "   4 link_uri_body
    " 5 link_file
    let g:_RIV_p.all_link = g:_RIV_p.link_tar . '|' . g:_RIV_p.link_ref
                 \ . '|' .  g:_RIV_p.link_uri . '|' . g:_RIV_p.link_file

    let g:_RIV_t = {}

    let g:_RIV_t.list_type = split(g:riv_list_toggle_type,',')
    " don't touch this
    lockvar 2 g:_RIV_c
    lockvar 2 g:_RIV_p

endif "}}}
endfun "}}}
fun! riv#init() "{{{
    " for init autoload
    call riv#load_opt(s:default.opts)
    call riv#load_map(s:default.maps)
    call riv#load_menu(s:default.menus)
    call riv#load_conf()
    call riv#show_menu(0)
    exe 'map <unique>'. g:riv_leader . 'ww <Plug>RivIndex'
endfun "}}}
