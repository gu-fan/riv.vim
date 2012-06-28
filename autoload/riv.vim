"=============================================
"    Name: riv.vim
"    File: riv.vim
" Summary: Riv autoload main
"  Author: Rykka G.Forest
"  Update: 2012-06-27
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C


let s:autoload_path = expand('<sfile>:p:h')
" Helper "{{{1
fun! s:error(msg) "{{{
    echohl WarningMsg
    redraw
    echo a:msg
    echohl Normal
endfun "}}}
fun! s:normlist(list,...) "{{{
    " return list with words
    return filter(map(a:list,'matchstr(v:val,''\w\+'')'), ' v:val!=""')
endfun "}}}
fun! riv#error(msg) "{{{
    echohl ErrorMsg
    echo a:msg
    echohl Normal
endfun "}}}
fun! riv#warning(msg) "{{{
    echohl WarningMsg
    echo a:msg
    echohl Normal
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
        sil! exe "nor <silent> <Plug>".name." :".action."<CR>"
    endfor
endfun "}}}
fun! riv#set_g_map(map_dic) "{{{
    for [name,acts] in items(a:map_dic)
        if type(acts) == type([])
            for act in acts
                sil! exe "map <silent>  ". g:riv_global_leader . act."  <Plug>".name
            endfor
        else
            sil! exe "map <silent>  ". g:riv_global_leader . acts."  <Plug>".name
        endif
        unlet acts
    endfor
endfun "}}}
fun! riv#load_menu(menu_list) "{{{
    for [name ,short, action] in a:menu_list
        let short  = short =~'  ' ? short : "<tab>".g:riv_buf_leader.short
        let action = action=~'  ' ? ' :' : '  <Plug>'.action
        exe "75 amenu Riv.".  name . short. action
    endfor
endfun "}}}
fun! riv#show_menu() "{{{
    if !exists("b:current_syntax") || b:current_syntax != 'rst'
        menu disable Riv.*
        menu enable Riv.Index
    else
        menu enable Riv.*
    endif
endfun "}}}
"}}}
"{{{ Options
" Options:
" fold_blank: 0,1,2 (default:2)
" 0     fold one blank line at the most and leave the rest.
" 1     fold all but leave one blank line
" 2     fold all blank line

" fold_level: 0,1,2,3          (defualt:3)
" 0     no folding
" 1     section
" 2     section and list
" 3     section and list and explicit_mark and table and quote. (All)

" auto_format_table: 0,1        (default:1)
" 0     off
" 1     on
let s:default = {}
let s:default.options = {
    \'default'            : s:default,
    \'global_leader'      : '<C-E>',
    \'buf_leader'         : '<C-E>',
    \'buf_ins_leader'     : '<C-E>',
    \'file_link_ext'      : 'vim,cpp,c,py,rb,lua,pl',
    \'localfile_linktype' : 1,
    \'highlight_code'     : "lua,python,cpp,javascript,vim,sh",
    \'hover_link_hl'      : 1,
    \'usr_syn_dir'        : "",
    \'todo_levels'        : " ,o,X",
    \'todo_timestamp'     : 1,
    \'todo_keywords'      : "TODO,DONE;FIXME,FIXED;START,PROCESS,STOP",
    \'fold_blank'         : 2,
    \'fold_level'         : 3,
    \'fold_section_mark'  : "-",
    \'auto_fold_force'    : 1,
    \'auto_fold1_lines'   : 5000,
    \'auto_fold2_lines'   : 3000,
    \'web_browser'        : "firefox",
    \'ft_browser'         : "",
    \'rst2html_args'      : "",
    \'rst2odt_args'       : "",
    \'rst2xml_args'       : "",
    \'rst2s5_args'        : "",
    \'rst2latex_args'     : "",
    \'section_levels'     : '=-~"''`',
    \'fuzzy_help'         : 0,
    \'auto_format_table'  : 1,
    \'fold_text_align'    : 'right',
    \'ins_super_tab'      : 1,
    \'month_names'        : 'January,February,March,April,May,June,July,'
                          \.'August,September,October,November,December',
    \}
" maps "{{{
let s:default.maps = {
    \'RivIndex'          : 'call riv#index()',
    \'RivAsk'            : 'call riv#ask_index()',
    \'RivLinkOpen'       : 'call riv#link#open()',
    \'RivLinkNext'       : 'call riv#link#finder("f")',
    \'RivLinkPrev'       : 'call riv#link#finder("b")',
    \'RivLinkDBClick'    : 'call riv#action#db_click(1)',
    \'RivListShiftRight' : 'call riv#list#shift("+")',
    \'RivListShiftLeft'  : 'call riv#list#shift("-")',
    \'RivListNewList'    : 'call riv#list#act(0)',
    \'RivListSubList'    : 'call riv#list#act(1)',
    \'RivListSupList'    : 'call riv#list#act(-1)',
    \'RivListTypeRemove' : 'call riv#list#toggle_type(0)',
    \'RivListTypeNext'   : 'call riv#list#toggle_type(1)',
    \'RivListTypePrev'   : 'call riv#list#toggle_type(-1)',
    \'RivTodoToggle'     : 'call riv#list#toggle_todo()',
    \'RivTodoDel'        : 'call riv#list#del_todo()',
    \'RivTodoDate'       : 'call riv#list#change_date()',
    \'RivTodoAsk'        : 'call riv#list#todo_ask()',
    \'RivTodoType1'      : 'call riv#list#todo_change_type(0)',
    \'RivTodoType2'      : 'call riv#list#todo_change_type(1)',
    \'RivTodoType3'      : 'call riv#list#todo_change_type(2)',
    \'RivTodoType4'      : 'call riv#list#todo_change_type(3)',
    \'RivViewScratch'    : 'call riv#create#view_scr()',
    \'RivTitle1'         : 'call riv#create#title(1)',
    \'RivTitle2'         : 'call riv#create#title(2)',
    \'RivTitle3'         : 'call riv#create#title(3)',
    \'RivTitle4'         : 'call riv#create#title(4)',
    \'RivTitle5'         : 'call riv#create#title(5)',
    \'RivTitle6'         : 'call riv#create#title(6)',
    \'RivTestReload'     : 'call riv#test#reload()',
    \'RivTestFold0'      : 'call riv#test#fold(0)',
    \'RivTestFold1'      : 'call riv#test#fold(1)',
    \'RivTestTest'       : 'call riv#test#test()',
    \'RivTestObj'        : 'call riv#test#show_obj()',
    \'RivTableFormat'    : 'call riv#table#format()',
    \'Riv2HtmlIndex'     : 'call riv#publish#browse()',
    \'Riv2HtmlAndBrowse' : 'call riv#publish#file2html(1)',
    \'Riv2HtmlFile'      : 'call riv#publish#file2html(0)',
    \'Riv2HtmlProject'   : 'call riv#publish#proj2html()',
    \'Riv2Odt'           : 'call riv#publish#file2("odt",1)',
    \'Riv2S5'            : 'call riv#publish#file2("s5",0)',
    \'Riv2Xml'           : 'call riv#publish#file2("xml",1)',
    \'Riv2Latex'         : 'call riv#publish#file2("latex",1)',
    \'Riv2BuildPath'     : 'call riv#publish#path()',
    \'RivDelete'         : 'call riv#create#delete()',
    \'RivTodoHelper'     : 'call riv#create#todo_helper()',
    \'RivTodoUpdateCache': 'call riv#create#force_update()',
    \'RivCreateLink'     : 'call riv#create#link()',
    \'RivCreateFoot'     : 'call riv#create#foot()',
    \'RivCreateDate'     : 'call riv#create#date()',
    \'RivCreateTime'     : 'call riv#create#date(1)',
    \'RivScratchCreate'  : 'call riv#create#scratch()',
    \'RivScratchView'    : 'call riv#create#view_scr()',
    \}
"}}}
"
let s:default.g_maps = {
    \'RivIndex'          : ['ww', '<C-W><C-W>'] ,
    \'Riv2HtmlIndex'     : ['wi', '<C-W><C-I>'] ,
    \'RivAsk'            : ['wa', '<C-W><C-A>'] ,
    \'RivScratchCreate'  : ['cc', '<C-C><C-C>'] ,
    \'RivTodoHelper'     : ['ht', '<C-h><C-t>'] ,
    \}
let s:default.fold_maps = { 
    \'RivFoldUpdate'     : ['zx', '<Space>j'],
    \'RivFoldToggle'     : ['@=(foldclosed(".")>0?"zv":"zc")<CR>', '<Space><Space>'],
    \'RivFoldAll'        : ['@=(foldclosed(".")>0?"zR":"zM")<CR>', '<Space>m'],
    \}
" buf maps "{{{
" s => section
" e => todo
" l => list
" i => create misc
" c => scratch
" 2 => convert
let s:default.buf_maps = {
    \'RivLinkDBClick'    : [['<CR>', '<KEnter>', '<2-LeftMouse>'],  '',  ''],
    \'RivLinkOpen'       : ['',  'n',  'ko'],
    \'RivLinkNext'       : ['<TAB>',    'n',  'kn'],
    \'RivLinkPrev'       : ['<S-TAB>',  'n',  'kp'],
    \'RivListShiftRight' : [['>', '<C-ScrollwheelDown>' ],  'mi',  'lu'],
    \'RivListShiftLeft'  : [['<', '<C-ScrollwheelUp>'],  'mi',  'ld'],
    \'RivListTypeNext'   : ['',  'mi',  'l1'],
    \'RivListTypePrev'   : ['',  'mi',  'l2'],
    \'RivListTypeRemove' : ['',  'mi',  'l`'],
    \'RivTodoHelper'     : ['',  'm' ,  'ht'],
    \'RivTodoUpdateCache': ['',  'm' ,  'uc'],
    \'RivTodoToggle'     : ['',  'mi',  'ee'],
    \'RivTodoDel'        : ['',  'mi',  'ex'],
    \'RivTodoDate'       : ['',  'mi',  'ed'],
    \'RivTodoAsk'        : ['',  'mi',  'e`'],
    \'RivTodoType1'      : ['',  'mi',  'e1'],
    \'RivTodoType2'      : ['',  'mi',  'e2'],
    \'RivTodoType3'      : ['',  'mi',  'e3'],
    \'RivTodoType4'      : ['',  'mi',  'e4'],
    \'RivTitle1'         : ['',  'mi',  's1'],
    \'RivTitle2'         : ['',  'mi',  's2'],
    \'RivTitle3'         : ['',  'mi',  's3'],
    \'RivTitle4'         : ['',  'mi',  's4'],
    \'RivTitle5'         : ['',  'mi',  's5'],
    \'RivTitle6'         : ['',  'mi',  's6'],
    \'RivTableFormat'    : ['',  'n',   'ft'],
    \'Riv2HtmlFile'      : ['',  'm',   '2hf'],
    \'Riv2HtmlProject'   : ['',  'm',   '2hp'],
    \'Riv2HtmlAndBrowse' : ['',  'm',   '2hh'],
    \'Riv2Odt'           : ['',  'm',   '2oo'],
    \'Riv2Latex'         : ['',  'm',   '2ll'],
    \'Riv2S5'            : ['',  'm',   '2ss'],
    \'Riv2Xml'           : ['',  'm',   '2xx'],
    \'Riv2BuildPath'     : ['',  'm',   '2b'],
    \'RivScratchView'    : ['',  'm',   'cv'],
    \'RivScratchCreate'  : ['',  'm',   'cc'],
    \'RivDeleteFile'     : ['',  'm',   'df'],
    \'RivCreateLink'     : ['',  'mi',  'il'],
    \'RivCreateDate'     : ['',  'mi',  'id'],
    \'RivCreateFoot'     : ['',  'mi',  'if'],
    \'RivCreateTime'     : ['',  'mi',  'it'],
    \'RivTestReload'     : ['',  'm',   't`'],
    \'RivTestFold0'      : ['',  'm',   't1'],
    \'RivTestFold1'      : ['',  'm',   't2'],
    \'RivTestObj'        : ['',  'm',   't3'],
    \'RivTestTest'       : ['',  'm',   't4'],
    \'RivTestInsert'     : ['',  'm',   'ti'],
    \}
let s:default.buf_imaps = {
    \'<BS>'         : 'riv#action#ins_bs()'      ,
    \'<CR>'         : 'riv#action#ins_enter()'   ,
    \'<KEnter>'     : 'riv#action#ins_enter()'   ,
    \'<C-CR>'       : 'riv#action#ins_c_enter()' ,
    \'<C-KEnter>'   : 'riv#action#ins_c_enter()' ,
    \'<S-CR>'       : 'riv#action#ins_s_enter()' ,
    \'<S-KEnter>'   : 'riv#action#ins_s_enter()' ,
    \'<C-S-CR>'     : 'riv#action#ins_m_enter()' ,
    \'<C-S-KEnter>' : 'riv#action#ins_m_enter()' ,
    \'<Tab>'        : 'riv#action#ins_tab()'     ,
    \'<S-Tab>'      : 'riv#action#ins_stab()'    ,
    \} 
"}}}
"menus "{{{
let s:default.menus = [
    \['Index'                             , 'ww'                     , 'RivIndex'          ]   ,
    \['Choose\ Index'                     , 'wa'                     , 'RivAsk'            ]   ,
    \['Helper.Todo\ Helper'               , 'th'                     , 'RivTodoHelper'     ]   ,
    \['Helper.Update\ Todo\ Cache'        , 'uc'                     , 'RivTodoUpdateCache']   ,
    \['--Action--'                        , '  '                     , '  '                ]   ,
    \['Title.Create\ level1\ Title'       , 's1'                     , 'RivTitle1'         ]   ,
    \['Title.Create\ level2\ Title'       , 's2'                     , 'RivTitle2'         ]   ,
    \['Title.Create\ level3\ Title'       , 's3'                     , 'RivTitle3'         ]   ,
    \['Title.Create\ level4\ Title'       , 's4'                     , 'RivTitle4'         ]   ,
    \['Title.Create\ level5\ Title'       , 's5'                     , 'RivTitle5'         ]   ,
    \['Title.Create\ level6\ Title'       , 's6'                     , 'RivTitle6'         ]   ,
    \['Link.Open\ Link'                   , 'ko\ or\ <Enter>'        , 'RivLinkOpen'       ]   ,
    \['Link.Next\ Link'                   , 'kn\ or\ \<Tab>'         , 'RivLinkNext'       ]   ,
    \['Link.Previous\ Link'               , 'kp\ or\ <S-Tab>'        , 'RivLinkPrev'       ]   ,
    \['Link.-------'                      , '  '                     , '  '                ]   ,
    \['Link.Create\ Link'                 , 'il'                     , 'RivCreateLink'     ]   ,
    \['Link.Create\ Footnote'             , 'if'                     , 'RivCreateFoot'     ]   ,
    \['List.Shift\ Right'                 , 'lu\ or\ >'              , 'RivListShiftRight' ]   ,
    \['List.Shift\ Left'                  , 'ld\ or\ <'              , 'RivListShiftLeft'  ]   ,
    \['List.Next\ Type'                   , 'l1'                     , 'RivListTypeNext'   ]   ,
    \['List.Previous\ Type'               , 'l2'                     , 'RivListTypePrev'   ]   ,
    \['List.Remove\ List\ Symbol'         , 'l`'                     , 'RivListTypeRemove' ]   ,
    \['Todo.Toggle\ Todo'                 , 'ee'                     , 'RivTodoToggle'     ]   ,
    \['Todo.Del\ Todo'                    , 'ex'                     , 'RivTodoDel'        ]   ,
    \['Todo.Change\ Date'                 , 'ed'                     , 'RivTodoDate'       ]   ,
    \['Todo.Todo\ Type0'                  , 'e`'                     , 'RivTodoType0'      ]   ,
    \['Todo.Todo\ Type1'                  , 'e1'                     , 'RivTodoType1'      ]   ,
    \['Todo.Todo\ Type2'                  , 'e2'                     , 'RivTodoType2'      ]   ,
    \['Todo.Todo\ Type3'                  , 'e3'                     , 'RivTodoType3'      ]   ,
    \['Create.Datestamp'                  , 'id'                     , 'RivCreateDate'     ]   ,
    \['Create.Timestamp'                  , 'it'                     , 'RivCreateTime'     ]   ,
    \['--Convert---'                      , '  '                     , '  '                ]   ,
    \['Convert.Open\ Build\ Path'         , '2b'                     , 'Riv2BuildPath'     ]   ,
    \['Convert.to\ Html.Browse\ Current'  , '2hh'                    , 'Riv2HtmlAndBrowse' ]   ,
    \['Convert.to\ Html.Convert\ Current' , '2hf'                    , 'Riv2HtmlFile'      ]   ,
    \['Convert.to\ Html.Browse\ index'    , '2hf'                    , 'Riv2HtmlIndex'     ]   ,
    \['Convert.to\ Html.Convert\ Project' , '2hp'                    , 'Riv2HtmlProject'   ]   ,
    \['Convert.to\ Odt'                   , '2oo'                    , 'Riv2Odt'           ]   ,
    \['Convert.to\ Latex'                 , '2ll'                    , 'Riv2Latex'         ]   ,
    \['Convert.to\ S5'                    , '2ss'                    , 'Riv2S5'            ]   ,
    \['Convert.to\ Xml'                   , '2xx'                    , 'Riv2Xml'           ]   ,
    \['Scratch.Create\ Scratch'           , 'cc'                     , 'RivScratchCreate'  ]   ,
    \['Scratch.View\ Index'               , 'cv'                     , 'RivScratchView'    ]   ,
    \['Delete.Delete\ Current'            , 'df'                     , 'RivDelete'         ]   ,
    \['--Format---'                       , '  '                     , '  '                ]   ,
    \['Table.Format'                      , 'ft'                     , 'RivTableFormat'    ]   ,
    \['--Fold---'                         , '  '                     , '  '                ]   ,
    \['Folding.Update'                    , '<Space>j\ or\ zx'       , 'RivFoldUpdate'     ]   ,
    \['Folding.Toggle'                    , '<Space><Space>\ or\ za' , 'RivFoldToggle'     ]   ,
    \['Folding.All'                       , '<Space>m\ or\ zA'       , 'RivFoldAll'        ]   ,
    \]
"}}}
"{{{ project options
let g:riv_proj_temp = {}
let g:riv_project_list = [ ]
let g:riv_p_id = 0
fun! riv#index(...) "{{{
    let id = a:0 ? a:1 : 0
    if exists("g:_riv_c.p[id]")
        let path = g:_riv_c.p[id]._root_path
        exe 'edit ' . path.'index.rst'
        let g:riv_p_id = id
        let b:riv_p_id = id
    else
        echohl ErrorMsg | echo "No such Project ID" | echohl Normal
    endif
endfun "}}}
fun! riv#ask_index() "{{{
    let id = inputlist(["Please Select One Project ID:"]+
                \map(range(len(g:_riv_c.p)),'v:val+1. "." . g:_riv_c.p[v:val].path') )
    if id != 0
        call riv#index((id-1))
    endif
endfun "}}}
fun! s:set_proj_conf(proj) "{{{
    let proj = copy(g:_riv_c.p_basic)
    for [key,var] in items(a:proj)
        let proj[key] = var
    endfor
    return proj
endfun "}}}
"}}}
"}}}

fun! riv#load_conf() "{{{1
let g:_riv_debug = exists("g:_riv_debug") ? g:_riv_debug : 0
if g:_riv_debug==1
    unlet! g:_riv_c
    unlockvar g:_riv_c
    unlockvar g:_riv_p
endif

if !exists("g:_riv_c")
    let g:_riv_c = {}
    let g:_riv_p = {}
    let g:_riv_t = {}
    let g:_riv_c.riv_path = s:autoload_path . '/riv/'
        if has("python") "{{{
            let g:_riv_c['py'] = "py "
            let g:_riv_c.has_py = 2
        elseif has("python3")
            let g:_riv_c['py'] = "py3 "
            let g:_riv_c.has_py = 3
        else
            let g:_riv_c['py'] = "echom 'No Python: ' "
            let g:_riv_c.has_py = 0
        endif "}}}
    if g:_riv_c.has_py && !exists("g:_riv_c.py_imported") "{{{
        try
            exe g:_riv_c.py "import sys"
            exe g:_riv_c.py "import vim"
            exe g:_riv_c.py "sys.path.append(vim.eval('g:_riv_c.riv_path'))"
            exe g:_riv_c.py "from rivlib.table import GetTable"
            exe g:_riv_c.py "from rivlib.buffer import RivBuf"
            let g:_riv_c.py_imported = 1
        catch
            let g:_riv_c.py_imported = 0
        endtry
    endif "}}}
    
    " Project option Setup "{{{
    let g:_riv_c.p_basic = {
        \'path'               : '~/Documents/Riv',
        \'build_path'         : '_build',
        \'scratch_path'       : 'scratch' ,
        \}
    let g:_riv_c.p = []
    if exists("g:riv_projects") && type(g:riv_projects) == type([])
        for project in g:riv_projects
            if type(project) == type({})
                call add(g:_riv_c.p, s:set_proj_conf(project))
            endif
        endfor
    elseif exists("g:riv_project") && type(g:riv_project) == type({})
        call add(g:_riv_c.p, s:set_proj_conf(g:riv_project))
    endif
    if empty(g:_riv_c.p)
        call add(g:_riv_c.p, g:_riv_c.p_basic)
    endif

    fun! s:is_relative(name) "{{{
        return a:name !~ '^\~\|^/\|^[a-zA-Z]:'
    endfun "}}}
    fun! s:is_directory(name) "{{{
        return a:name =~ '/$' 
    endfun "}}}

    for proj in g:_riv_c.p
        let root = expand(proj.path)
        let slash = has('win32') || has('win64') ? '\' : '/'
        let proj._root_path = s:is_directory(root) ? root : root . slash
        if s:is_relative(proj.build_path)
            let b_path =  proj._root_path . proj.build_path
            let proj._build_path =  s:is_directory(b_path) ?  b_path : b_path . slash
        else
            let b_path =   expand(proj.build_path)
            let proj._build_path =  s:is_directory(b_path) ?  b_path : b_path . slash
        endif
        if s:is_relative(proj.scratch_path)
            let s_path =  proj._root_path . proj.scratch_path
            let proj._scratch_path =  s:is_directory(s_path) ?  s_path : s_path . slash
        else
            let s_path =   expand(proj.scratch_path)
            let proj._scratch_path =  s:is_directory(s_path) ?  s_path : s_path . slash
        endif
    endfor
    "}}}
    
    if empty(g:riv_ft_browser) "{{{
        if has('win32') || has('win64')
            let g:riv_ft_browser = 'start'
        else
            let g:riv_ft_browser = 'xdg-open'
        endif
    endif "}}}

    " Patterns: "{{{2
    
    " Basic: "{{{3
    let g:_riv_p.blank = '^\s*$'
    let g:_riv_p.indent = '^\_s\+'
    let g:_riv_p.s_bgn = '^\_s\|^$'
    let g:_riv_p.S_bgn = '^\S'

    " Section: "{{{3
    " Note: Most puncutation can be used, but we choose some of them.
    let g:_riv_p.section = '^\v([=`:.''"~^_*+#-])\1+\s*$'


    " Table: "{{{3
    " The grid table
    " +--------+     \s*+\%([-=]\++\)\+\s*
    " |  wfwef |     \s*|.\{-}|\s*
    " +====+===+
    " |    |   |
    " +----+   |     \s*+\%([-=]\++\)\+.\{-}|\s*        \s*|.\{-}+\%([-=]\++\)\+\s*
    " |    |   |
    " +----+---+
    "                ^\s*\%(|\s.\{-}\)\=+\%([-=]\++\)\+\%(.\{-}\s|\)\=\s*$
    let g:_riv_p.table_fence  = '\v^\s*%(\|\s.{-})=\+%([-=]+\+)+%(.{-}\s\|)=\s*$'
    let g:_riv_p.table_line  = '\v^\s*\|\s.{-}\s\|\s*$'
    let g:_riv_p.table  =  g:_riv_p.table_fence . '|' . g:_riv_p.table_line
    let g:_riv_p.cell  = '\v%(^|\s)\|\s\zs|^\s*$'
    let g:_riv_p.cell0 = '\v^\s*\|\s\zs'

    " ======  ===============
    let g:_riv_p.simple_table  = '^\s*=\+\s\+=[=[:space:]]\+\s*$'
    


    " List: "{{{3
    
    let g:_riv_p.bullet_list = '\v^\s*[-*+]\s+'
    let g:_riv_p.enumerate_list1 = '\v\c^\s*%(\d+|[#a-z]|[imlcxvd]+)[.)]\s+'
    let g:_riv_p.enumerate_list2 = '\v\c^\s*\(%(\d+|[#a-z]|[imlcxvd]+)\)\s+'
    let g:_riv_p.list_all = g:_riv_p.bullet_list.'|'.g:_riv_p.enumerate_list1
                \.'|'.g:_riv_p.enumerate_list2
    
    
    let g:_riv_p.field_list= '^\s*:[^:]\+:\s\+\ze\S.\+[^:]$'

    " sub1 (indent)
    " sub2 bullet
    " sub3 #. \d. \d)
    " sub4 a. z. a)
    " sub5 ii.
    " sub6 (#)
    " sub7 (a)
    " sub8 (ii)
    " sub9 (space)
    let g:_riv_p.list_checker =  '\v\c^\s*%('
                    \.'([-*+])'
                    \.'|(%(#|\d+)[.)])'
                    \.'|([(]%(#|\d+)[)])'
                    \.'|([a-z][.)])'
                    \.'|([(][a-z][)])'
                    \.'|([imlcxvd]+[.)])'
                    \.'|([(][imlcxvd]+[)])'
                    \.')(\s+)'

    " Todo Items: "{{{3
    " - [x] 2012-03-04 ~ 2012-05-06 The Todo Timestamp with start and end.
    " - TODO 2012-01-01
    " - DONE 2012-01-01 ~ 2012-01-02 

    let td_key_list  = split(g:riv_todo_keywords,';')
    let g:_riv_t.td_ask_keywords = ["Choosing a keyword group:"] +
                \  map(range(len(td_key_list)), 
                \ '(v:val+1).".". td_key_list[v:val]')
    let g:_riv_t.td_keyword_groups = map(td_key_list, 
                \ 's:normlist(split(v:val,'',''))')
    let g:_riv_p.td_keywords = '\v%('.join(s:normlist(split(g:riv_todo_keywords,'[,;]')),'|').')'

    let g:_riv_t.time_fmt  = "%Y-%m-%d"

    let g:_riv_p.todo_box = '\v('. g:_riv_p.list_all .')(\[.\] )'
    let g:_riv_p.todo_key = '\v('. g:_riv_p.list_all .')(' 
                            \ . g:_riv_p.td_keywords.' )'
    " sub1 list sub2 todo box sub3 todo key 
    let g:_riv_p.todo_all = '\v('. g:_riv_p.list_all .')%((\[.\] )'
                         \ .'|('. g:_riv_p.td_keywords.' ))'
    " sub4 timestamp
    let g:_riv_p.timestamp = '(\d{4}-\d{2}-\d{2}%( |$))'
    let g:_riv_p.todo_tm_bgn  = g:_riv_p.todo_all . g:_riv_p.timestamp
    " sub5 timestamp end
    let g:_riv_p.todo_tm_end  = g:_riv_p.todo_tm_bgn .'\~ '. g:_riv_p.timestamp

    let g:_riv_t.todo_levels = split(g:riv_todo_levels,',')
    let g:_riv_t.todo_all_group = insert(copy(g:_riv_t.td_keyword_groups), 
                \  split(g:riv_todo_levels,',') , 0 )

    let g:_riv_t.todo_done_key = join(map(copy(g:_riv_t.td_keyword_groups),
                \'v:val[-1]'),'|')
    let g:_riv_p.todo_done_ptn = '%((\[['.g:_riv_t.todo_levels[-1].']\])'
                \.'|('.g:_riv_t.todo_done_key.'))'
    let g:_riv_p.todo_done_list_ptn = '\v('. g:_riv_p.list_all .')'.g:_riv_p.todo_done_ptn


    " Explicit_mark: "{{{3
    " We only support the exp without padding space for convenience
    let g:_riv_p.exp_m = '^\.\.\%(\_s\|$\)'

    " Block: "{{{3
    " NOTE: The literal block should not be matched with the
    " directives like '.. xxx::'
    let g:_riv_p.literal_block = '::\s*$'
    let g:_riv_p.line_block = '^\s*|.*[^|]\s*$'
    let g:_riv_p.doctest_block = '^\s*>>> '
    
    " Links: "{{{3
    "
    " URI: " http://xxx.xxx.xxx file:///xxx/xxx/xx
    "        mailto:xxx@xxx.xxx
    "       submatch with uri body.
    "standlone link patterns: www.xxx-x.xxx/?xxx
    let g:_riv_p.link_uri = '\v%(%(file|https=|ftp|gopher)://|%(mailto|news):)([^[:space:]''\"<>]+[[:alnum:]/])'
            \.'|www[[:alnum:]_-]*\.[[:alnum:]_-]+\.[^[:space:]''\"<>]+[[:alnum:]/]'


    " File:
    let s:file_end = '%($|\s)'
    let g:_riv_t.file_ext_lst = s:normlist(split(g:riv_file_link_ext,','))
    if g:riv_localfile_linktype == 1
        " *.rst *.vim xxx/
        let s:file_name = '[[:alnum:]~./][[:alnum:]~:./\\_-]*'
        let s:file_start = '%(\_^|\s)'
        let g:_riv_p.file_ext_ptn = 'rst|'.join(g:_riv_t.file_ext_lst,'|')
        let g:_riv_p.link_file = '\v' . s:file_start . '\zs' . s:file_name
                    \.'%(\.%('. g:_riv_p.file_ext_ptn .')|/)\ze'. s:file_end
    elseif g:riv_localfile_linktype == 2
        " [*]  [xxx/] [*.vim]
        let g:_riv_p.file_ext_ptn = join(g:_riv_t.file_ext_lst,'|')
        " we should make sure it's not citation, footnote (with preceding '..')
        " and not a todo box. (a single char)
        let s:file_name = '[[:alnum:]~./][[:alnum:]~:./\\_-]+'
        let s:file_start = '%(\_^|(\_^\.\.)@<!\s)'
        let g:_riv_p.link_file = '\v'.s:file_start.'\zs\['. s:file_name .'\]\ze'. s:file_end
    else
        " NONE
        let g:_riv_t.file_ext_lst = s:normlist(split(g:riv_file_link_ext,','))
        let g:_riv_p.link_file = '^^'
    endif

    " Reference:
    let s:ref_name = '[[:alnum:]]+%([_.-][[:alnum:]]+)*'
    let s:ref_end = '%($|\s|[''")\]}>/:.,;!?\\-])'
    let g:_riv_p.ref_name = s:ref_name
    "  xxx_
    let g:_riv_p.link_ref_normal = '\v<'.s:ref_name.'_\ze'.s:ref_end
    " `xxx xx`_
    let g:_riv_p.link_ref_phase  = '\v`[^`\\]*%(\\.[^`\\]*)*`_\ze'.s:ref_end
    "  xxx__
    let g:_riv_p.link_ref_anoymous = '\v<'.s:ref_name.'__\ze'.s:ref_end
    " [#]_ [*]_  [#xxx]_  [3]_    and citation [xxxx]_
    let g:_riv_p.link_ref_footnote = '\v\[%(\d+|#|\*|#='.s:ref_name.')\]_\ze'.s:ref_end

    let g:_riv_p.link_reference = g:_riv_p.link_ref_normal
                \ . '|' . g:_riv_p.link_ref_phase
                \ . '|' . g:_riv_p.link_ref_anoymous
                \ . '|' . g:_riv_p.link_ref_footnote

    " Target:
    " .. [xxx]  or  [#xxx]  or  [1] with one space
    let g:_riv_p.link_tar_footnote = '\v^\.\.\s\zs\[%(\d+|#|#='.s:ref_name .')\]\ze\_s'
    " _`xxx xxx`
    let g:_riv_p.link_tar_inline = '\v%(\s|\_^)\zs_`[^:\\]+\ze:\_s`'
    " .. _xxx:
    let g:_riv_p.link_tar_normal = 'v^\.\.\s\zs_[^:\\]+\ze:\_s'
    " .. __:   or   __
    let g:_riv_p.link_tar_anonymous = '\v^\.\.\s__:\_s\zs|^__\_s\zs'
    " `xxx  <xxx>`
    let g:_riv_p.link_tar_embed  = '\v^%(\s|\_^)_`.+\s<\zs.+\ze>`'

    let g:_riv_p.link_target = g:_riv_p.link_tar_normal
            \.'|'. g:_riv_p.link_tar_inline
            \.'|'. g:_riv_p.link_tar_footnote
            \.'|'. g:_riv_p.link_tar_anonymous


    " sub match for all_link:
    " 1 link_tar
    " 2 link_ref
    " 3 link_uri
    "   4 link_uri_body
    " 5 link_file
    let g:_riv_p.all_link = '\v('. g:_riv_p.link_target 
                \ . ')|(' . g:_riv_p.link_reference
                \ . ')|(' . g:_riv_p.link_uri 
                \ . ')|(' . g:_riv_p.link_file . ')'

    " Miscs:
    " indent.vim
    let g:_riv_p.indent_stoper = g:_riv_p.list_all.'|^\s*\.\.\s|^\S'

    "}}}2
    
    let g:_riv_t.sect_punc = '!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~'
    let g:_riv_t.list_lvs  =  ["*","+","-"]
    let g:_riv_c.sect_lvs = split(g:riv_section_levels,'\zs')
    let g:_riv_c.sect_lvs_b = split('#*+:.^','\zs')
    let g:_riv_t.highlight_code = s:normlist(split(g:riv_highlight_code,','))
    let g:_riv_t.month_names = split(g:riv_month_names,',')

    lockvar 2 g:_riv_c
    lockvar 2 g:_riv_p
endif

endfun "}}}
fun! riv#init() "{{{
    " for init autoload
    call riv#load_opt(s:default.options)
    call riv#load_map(s:default.maps)
    call riv#load_menu(s:default.menus)
    call riv#load_conf()
    call riv#set_g_map(s:default.g_maps)
    call riv#show_menu()
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
