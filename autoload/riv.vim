"=============================================
"    Name: riv.vim
"    File: riv.vim
" Summary: Riv autoload main
"  Author: Rykka G.F
"  Update: 2012-09-19
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
    echo '[Error:]'
    echon a:msg
    echohl Normal
endfun "}}}
fun! riv#warning(msg) "{{{
    echohl WarningMsg
    echo '[Warnging]'
    echon a:msg
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
    if expand('%:e') != 'rst'
        sil! menu disable Riv.*
        sil! menu enable Riv.Index
    else
        sil! menu enable Riv.*
    endif
endfun "}}}
"}}}
"{{{ Options:
let s:default = {}
let s:default.options = {
    \'default'            : s:default,
    \'global_leader'      : '<C-E>',
    \'buf_leader'         : '<C-E>',
    \'buf_ins_leader'     : '<C-E>',
    \'file_link_ext'      : 'vim,cpp,c,py,rb,lua,pl',
    \'file_ext_link_hl'   : 1,
    \'file_link_invalid_hl' : 'ErrorMsg',
    \'file_link_style'    : 1,
    \'file_link_convert'  : 1,
    \'highlight_code'     : "lua,python,cpp,javascript,vim,sh",
    \'link_cursor_hl'     : 1,
    \'create_link_pos'    : '$',
    \'todo_levels'        : " ,o,X",
    \'todo_priorities'    : "ABC",
    \'todo_default_group' : 0,
    \'todo_datestamp'     : 1,
    \'todo_keywords'      : "TODO,DONE;FIXME,FIXED;START,PROCESS,STOP",
    \'fold_blank'         : 2,
    \'fold_level'         : 3,
    \'fold_section_mark'  : ".",
    \'content_format'     : '%i%l%n %t',
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
    \'html_code_hl_style' : 'default',
    \'fuzzy_help'         : 0,
    \'auto_format_table'  : 1,
    \'fold_info_pos'      : 'right',
    \'temp_path'          : 1,
    \'i_tab_pum_next'     : 1,
    \'i_tab_user_cmd'     : "",
    \'i_stab_user_cmd'    : "",
    \'ignored_imaps'      : "",
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
    \'RivLinkEnter'      : 'call riv#action#db_click(0)',
    \'RivShiftRight'     : 'call riv#list#shift("+")',
    \'RivShiftLeft'      : 'call riv#list#shift("-")',
    \'RivListFormat'     : 'call riv#list#shift("=")',
    \'RivListNewList'    : 'call riv#list#new(0)',
    \'RivListSubList'    : 'call riv#list#new(1)',
    \'RivListSupList'    : 'call riv#list#new(-1)',
    \'RivListDelete'     : 'call riv#list#delete()',
    \'RivListType0'      : 'call riv#list#change(0)',
    \'RivListType1'      : 'call riv#list#change(1)',
    \'RivListType2'      : 'call riv#list#change(2)',
    \'RivListType3'      : 'call riv#list#change(3)',
    \'RivListType4'      : 'call riv#list#change(4)',
    \'RivTodoToggle'     : 'call riv#todo#toggle()',
    \'RivTodoDel'        : 'call riv#todo#delete()',
    \'RivTodoDate'       : 'call riv#todo#change_datestamp()',
    \'RivTodoPrior'      : 'call riv#todo#toggle_prior(1)',
    \'RivTodoAsk'        : 'call riv#todo#todo_ask()',
    \'RivTodoType1'      : 'call riv#todo#change(0)',
    \'RivTodoType2'      : 'call riv#todo#change(1)',
    \'RivTodoType3'      : 'call riv#todo#change(2)',
    \'RivTodoType4'      : 'call riv#todo#change(3)',
    \'RivViewScratch'    : 'call riv#create#view_scr()',
    \'RivTitle1'         : 'call riv#section#title(1)',
    \'RivTitle2'         : 'call riv#section#title(2)',
    \'RivTitle3'         : 'call riv#section#title(3)',
    \'RivTitle4'         : 'call riv#section#title(4)',
    \'RivTitle5'         : 'call riv#section#title(5)',
    \'RivTitle6'         : 'call riv#section#title(6)',
    \'RivTitle0'         : 'call riv#section#title(0)',
    \'RivTestReload'     : 'call riv#test#reload()',
    \'RivTestFold0'      : 'call riv#test#fold(0)',
    \'RivTestFold1'      : 'call riv#test#fold(1)',
    \'RivTestTest'       : 'call riv#test#test()',
    \'RivTestObj'        : 'call riv#test#show_obj()',
    \'RivTableFormat'    : 'call riv#table#format()',
    \'RivTableCreate'    : 'call riv#table#create()',
    \'RivTableNextCell'  : 'call cursor(riv#table#nextcell())',
    \'RivTablePrevCell'  : 'call cursor(riv#table#prevcell())',
    \'Riv2HtmlIndex'     : 'call riv#publish#browse()',
    \'Riv2HtmlAndBrowse' : 'call riv#publish#file2("html",1)',
    \'Riv2HtmlFile'      : 'call riv#publish#file2("html",0)',
    \'Riv2HtmlProject'   : 'call riv#publish#proj2("html")',
    \'Riv2Odt'           : 'call riv#publish#file2("odt",1)',
    \'Riv2S5'            : 'call riv#publish#file2("s5",1)',
    \'Riv2Xml'           : 'call riv#publish#file2("xml",1)',
    \'Riv2Latex'         : 'call riv#publish#file2("latex",1)',
    \'Riv2BuildPath'     : 'call riv#publish#open_path()',
    \'RivDelete'         : 'call riv#create#delete()',
    \'RivHelpTodo'       : 'call riv#todo#todo_helper()',
    \'RivTodoUpdateCache': 'call riv#todo#force_update()',
    \'RivHelpFile'       : 'call riv#file#helper()',
    \'RivHelpSection'    : 'call riv#file#section_helper()',
    \'RivCreateLink'     : 'call riv#create#link()',
    \'RivCreateGitLink'  : 'call riv#create#git_commit_url()',
    \'RivCreateFoot'     : 'call riv#create#foot()',
    \'RivCreateDate'     : 'call riv#create#date()',
    \'RivCreateTime'     : 'call riv#create#date(1)',
    \'RivScratchCreate'  : 'call riv#create#scratch()',
    \'RivScratchView'    : 'call riv#create#view_scr()',
    \'RivQuickStart'     : 'call riv#action#quick_start()',
    \'RivCreateContent'  : 'call riv#section#content()',
    \}
"}}}

let s:default.g_maps = {
    \'RivIndex'          : ['ww', '<C-W><C-W>'] ,
    \'Riv2HtmlIndex'     : ['wi', '<C-W><C-I>'] ,
    \'RivAsk'            : ['wa', '<C-W><C-A>'] ,
    \'RivScratchCreate'  : ['sc', '<C-C><C-C>'] ,
    \'RivScratchView'    : ['cv', '<C-C><C-V>'] ,
    \'RivHelpTodo'       : ['ht', '<C-h><C-t>'] ,
    \'RivHelpFile'       : ['hf', '<C-h><C-f>'] ,
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
    \'RivLinkDBClick'    : [['<2-LeftMouse>'],  '',  ''],
    \'RivLinkEnter'      : [['<CR>', '<KEnter>'],  '',  ''],
    \'RivLinkOpen'       : ['',  'n',  'ko'],
    \'RivLinkNext'       : ['<TAB>',    'n',  'kn'],
    \'RivLinkPrev'       : ['<S-TAB>',  'n',  'kp'],
    \'RivShiftRight'     : [['>', '<C-ScrollwheelDown>' ],  'mi',  'll'],
    \'RivShiftLeft'      : [['<', '<C-ScrollwheelUp>'],  'mi',  'lh'],
    \'RivListFormat'     : [['='],  'mi',  'l='],
    \'RivListType0'      : ['',  'mi',  'l1'],
    \'RivListType1'      : ['',  'mi',  'l2'],
    \'RivListType2'      : ['',  'mi',  'l3'],
    \'RivListType3'      : ['',  'mi',  'l4'],
    \'RivListType4'      : ['',  'mi',  'l5'],
    \'RivListDelete'     : ['',  'mi',  'lx'],
    \'RivHelpTodo'     : ['',  'm' ,  'ht'],
    \'RivTodoUpdateCache': ['',  'm' ,  'uc'],
    \'RivTodoToggle'     : ['',  'mi',  'ee'],
    \'RivTodoPrior'      : ['',  'mi',  'ep'],
    \'RivTodoDel'        : ['',  'mi',  'ex'],
    \'RivTodoDate'       : ['',  'mi',  'ed'],
    \'RivTodoAsk'        : ['',  'mi',  'e`'],
    \'RivTodoType1'      : ['',  'mi',  'e1'],
    \'RivTodoType2'      : ['',  'mi',  'e2'],
    \'RivTodoType3'      : ['',  'mi',  'e3'],
    \'RivTodoType4'      : ['',  'mi',  'e4'],
    \'RivTitle0'         : ['',  'mi',  's0'],
    \'RivTitle1'         : ['',  'mi',  's1'],
    \'RivTitle2'         : ['',  'mi',  's2'],
    \'RivTitle3'         : ['',  'mi',  's3'],
    \'RivTitle4'         : ['',  'mi',  's4'],
    \'RivTitle5'         : ['',  'mi',  's5'],
    \'RivTitle6'         : ['',  'mi',  's6'],
    \'RivTableFormat'    : ['',  'mi',  'tf'],
    \'RivTableCreate'    : ['',  'mi',  'tc'],
    \'RivTableNextCell'  : ['',  'mi',  'tn'],
    \'RivTablePrevCell'  : ['',  'mi',  'tp'],
    \'Riv2HtmlFile'      : ['',  'm',   '2hf'],
    \'Riv2HtmlProject'   : ['',  'm',   '2hp'],
    \'Riv2HtmlAndBrowse' : ['',  'm',   '2hh'],
    \'Riv2Odt'           : ['',  'm',   '2oo'],
    \'Riv2Latex'         : ['',  'm',   '2ll'],
    \'Riv2S5'            : ['',  'm',   '2ss'],
    \'Riv2Xml'           : ['',  'm',   '2xx'],
    \'Riv2BuildPath'     : ['',  'm',   '2b'],
    \'RivDelete'         : ['',  'm',   'df'],
    \'RivCreateLink'     : ['',  'mi',  'il'],
    \'RivCreateDate'     : ['',  'mi',  'id'],
    \'RivCreateFoot'     : ['',  'mi',  'if'],
    \'RivCreateTime'     : ['',  'mi',  'it'],
    \'RivCreateContent'  : ['',  'mi',  'ic'],
    \'RivTestReload'     : ['',  'm',   't`'],
    \'RivTestFold0'      : ['',  'm',   't1'],
    \'RivTestFold1'      : ['',  'm',   't2'],
    \'RivTestObj'        : ['',  'm',   't3'],
    \'RivTestTest'       : ['',  'm',   't4'],
    \'RivTestInsert'     : ['',  'm',   'ti'],
    \'RivCreateGitLink'  : ['',  'm',   'tg'],
    \'RivHelpFile'       : ['',  'm',   'hf'],
    \'RivHelpSection'    : ['',  'm',   'hs'],
    \'RivQuickStart'     : ['',  'm',   'hq'],
    \}
let s:default.buf_imaps = {
    \'<BS>'         : 'riv#action#ins_backspace()',
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

let s:default.buf_nmaps = {
    \'<C-E><'         : '<',
    \'<C-E>>'         : '>',
    \'<C-E>='         : '=',
    \'<S-ScrollwheelDown>' : '>',
    \'<S-ScrollwheelUp>'   : '<',
    \}
let s:default.buf_vmaps = {
    \'<S-ScrollwheelDown>' : '>gv',
    \'<S-ScrollwheelUp>'   : '<gv',
    \}
"}}}
" menus "{{{
let s:default.menus = [
    \['Index'                             , 'ww'                     , 'RivIndex'          ]   ,
    \['Choose\ Index'                     , 'wa'                     , 'RivAsk'            ]   ,
    \['Helper.File\ Helper'               , 'hf'                     , 'RivHelpFile'       ]   ,
    \['Helper.Todo\ Helper'               , 'ht'                     , 'RivHelpTodo'     ]   ,
    \['Helper.Update\ Todo\ Cache'        , 'uc'                     , 'RivTodoUpdateCache']   ,
    \['Scratch.Create\ Scratch'           , 'sc'                     , 'RivScratchCreate'  ]   ,
    \['Scratch.View\ Index'               , 'cv'                     , 'RivScratchView'    ]   ,
    \['--Action--'                        , '  '                     , '  '                ]   ,
    \['Title.Create\ level0\ Title'       , 's0'                     , 'RivTitle0'         ]   ,
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
    \['List.Shift\ Right'                 , 'lu\ or\ >'              , 'RivShiftRight' ]   ,
    \['List.Shift\ Left'                  , 'ld\ or\ <'              , 'RivShiftLeft'  ]   ,
    \['List.\ Type0'                      , 'l1'                     , 'RivListType0'      ]   ,
    \['List.\ Type1'                      , 'l2'                     , 'RivListType1'      ]   ,
    \['List.\ Type2'                      , 'l3'                     , 'RivListType2'      ]   ,
    \['List.\ Type3'                      , 'l4'                     , 'RivListType3'      ]   ,
    \['List.\ Type4'                      , 'l5'                     , 'RivListType4'      ]   ,
    \['List.Delte\ List\ Symbol'          , 'lx'                     , 'RivListDelete'     ]   ,
    \['Todo.Toggle\ Todo'                 , 'ee'                     , 'RivTodoToggle'     ]   ,
    \['Todo.Delete\ Todo'                 , 'ex'                     , 'RivTodoDel'        ]   ,
    \['Todo.Toggle\ Prior'                , 'ep'                     , 'RivTodoPrior'      ]   ,
    \['Todo.Change\ Date'                 , 'ed'                     , 'RivTodoDate'       ]   ,
    \['Todo.Todo\ Type0'                  , 'e`'                     , 'RivTodoType0'      ]   ,
    \['Todo.Todo\ Type1'                  , 'e1'                     , 'RivTodoType1'      ]   ,
    \['Todo.Todo\ Type2'                  , 'e2'                     , 'RivTodoType2'      ]   ,
    \['Todo.Todo\ Type3'                  , 'e3'                     , 'RivTodoType3'      ]   ,
    \['Create.Datestamp'                  , 'id'                     , 'RivCreateDate'     ]   ,
    \['Create.Timestamp'                  , 'it'                     , 'RivCreateTime'     ]   ,
    \['Create.Content\ Table'             , 'it'                     , 'RivCreateContent'     ]   ,
    \['Delete.Delete\ Current\ File'      , 'df'                     , 'RivDelete'         ]   ,
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
    \['--Format---'                       , '  '                     , '  '                ]   ,
    \['Table.Create'                      , 'tc'                     , 'RivTableCreate'    ]   ,
    \['Table.Format'                      , 'tf'                     , 'RivTableFormat'    ]   ,
    \['Table.NextCell'                    , 'tp\ or\ i_<Tab>'        , 'RivTableNextCell'  ]   ,
    \['Table.PrevCell'                    , 'tn\ or\ i_<S-Tab>'      , 'RivTablePrevCell'  ]   ,
    \['--Fold---'                         , '  '                     , '  '                ]   ,
    \['Folding.Update'                    , '<Space>j\ or\ zx'       , 'RivFoldUpdate'     ]   ,
    \['Folding.Toggle'                    , '<Space><Space>\ or\ za' , 'RivFoldToggle'     ]   ,
    \['Folding.All'                       , '<Space>m\ or\ zA'       , 'RivFoldAll'        ]   ,
    \]
"}}}
" project options " {{{
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

    let g:_riv_c = {}
    let g:_riv_p = {}
    let g:_riv_t = {}
    let g:_riv_e = {}
    let g:_riv_s = {}

    let s:c = g:_riv_c
    let s:p = g:_riv_p
    let s:t = g:_riv_t
    let s:e = g:_riv_e

    let s:c.riv_path = s:autoload_path . '/riv/'
    let s:c.doc_pat  = fnamemodify(s:autoload_path ,':h').'/doc/'

    " Python:
    if has("python") "{{{
        let s:c['py'] = "py "
        let s:c.has_py = 2
    elseif has("python3")
        let s:c['py'] = "py3 "
        let s:c.has_py = 3
    else
        let s:c['py'] = "echom 'No Python: ' "
        let s:c.has_py = 0
    endif "}}}
    if s:c.has_py && !exists("s:c.py_imported") "{{{
        try
            exe s:c.py "import sys"
            exe s:c.py "import vim"
            exe s:c.py "sys.path.append(vim.eval('s:c.riv_path'))"
            exe s:c.py "from rivlib.table import GetTable"
            exe s:c.py "from rivlib.buffer import RivBuf"
            let s:c.py_imported = 1
        catch
            let s:c.py_imported = 0
        endtry
    endif "}}}
    
    " Project: "{{{
    let s:c.p_basic = {
        \'path'               : '~/Documents/Riv',
        \'build_path'         : '_build',
        \'scratch_path'       : 'Scratch' ,
        \}
    let s:c.p = []
    if exists("g:riv_projects") && type(g:riv_projects) == type([])
        for project in g:riv_projects
            if type(project) == type({})
                call add(s:c.p, s:set_proj_conf(project))
            endif
        endfor
    elseif exists("g:riv_project") && type(g:riv_project) == type({})
        call add(s:c.p, s:set_proj_conf(g:riv_project))
    endif
    if empty(s:c.p)
        call add(s:c.p, s:c.p_basic)
    endif

    for proj in s:c.p
        let root = expand(proj.path)
        let proj._root_path = riv#path#directory(root)
        if riv#path#is_relative(proj.build_path)
            let b_path =  proj._root_path . proj.build_path
        else
            let b_path =  expand(proj.build_path)
        endif
        let proj._build_path =  riv#path#directory(b_path)
        if riv#path#is_relative(proj.scratch_path)
            let s_path =  proj._root_path . proj.scratch_path
        else
            let s_path =   expand(proj.scratch_path)
        endif
        let proj._scratch_path =  riv#path#directory(s_path)
    endfor
    "}}}
    
    " Patterns:
    let s:t.prior_str = g:riv_todo_priorities

    call riv#ptn#init()

    " Configs: "{{{
    let s:t.time_fmt  = "%Y-%m-%d"
    let s:t.sect_punc = '!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~'
    let s:t.list_lvs  =  ["*","+","-"]
    let s:t.highlight_code = s:normlist(split(g:riv_highlight_code,','))
    let s:t.month_names = split(g:riv_month_names,',')
    
    let s:c.sect_lvs = split(g:riv_section_levels,'\zs')
    let s:c.sect_lvs_b = split('#*+:.^','\zs')
    let s:c.sect_lvs_style = [[3,'#']]
    for s in s:c.sect_lvs
        call add(s:c.sect_lvs_style,[2,s])
    endfor

    if !empty(g:riv_i_tab_user_cmd) && g:riv_i_tab_user_cmd =~ '\\<'
        " it's literal string and is '\<xx>'
        exe 'let s:c.i_tab_user_cmd = "' . g:riv_i_tab_user_cmd . '"'
    else
        let s:c.i_tab_user_cmd = g:riv_i_tab_user_cmd
    endif
    
    if !empty(g:riv_i_stab_user_cmd) && g:riv_i_stab_user_cmd =~ '\\<'
        " it's not literal string
        exe 'let s:c.i_stab_user_cmd = "' . g:riv_i_stab_user_cmd . '"'
    else
        let s:c.i_stab_user_cmd = g:riv_i_stab_user_cmd
    endif
    
    for key in split(g:riv_ignored_imaps,',')
        call remove(g:riv_default.buf_imaps, key)
    endfor

    if empty(g:riv_ft_browser) "{{{
        if has('win32') || has('win64')
            let g:riv_ft_browser = 'start'
        else
            let g:riv_ft_browser = 'xdg-open'
        endif
    endif "}}}
    "}}}
    
    " Errors:
    let s:e.NOT_REL_PATH = "Riv: Not a related path"
    let s:e.INVALID_TODO_GROUP = "Riv: Not a valid Todo Group"
    let s:e.NOT_TODO_ITEM = "Riv: Not a Todo Item"
    let s:e.NOT_LIST_ITEM = "Riv: Not a List Item"
    let s:e.NOT_DATESTAMP = "Riv: Not a Datestamp"
    let s:e.NOT_RST_FILE  = "Riv: NOT A RST FILE"
    let s:e.FILE_NOT_FOUND = "Riv: Could not find the file"
    let s:e.REF_NOT_FOUND = "Riv: Could not find the reference"

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

if expand('<sfile>:p') == expand('%:p') 
    call riv#init()
endif
let &cpo = s:cpo_save
unlet s:cpo_save
