"=============================================
"    Name: riv.vim
"    File: riv.vim
" Summary: Riv autoload main
"  Author: Rykka G.F
"  Update: 2012-10-05
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:autoload_path = expand('<sfile>:p:h')
let g:riv_version = '0.74'
let g:riv_p_id = 0

" Miscs "{{{1
fun! s:error(msg) "{{{
    echohl WarningMsg
    redraw
    echo a:msg
    echohl Normal
endfun "}}}
fun! riv#error(msg) "{{{
    echohl ErrorMsg
    echo '[Error:]'
    echon a:msg
    echohl Normal
endfun "}}}
fun! riv#warning(msg) "{{{
    echohl WarningMsg
    echo '[Warning]'
    echon a:msg
    echohl Normal
endfun "}}}
fun! riv#breakundo() "{{{
    let &ul=&ul
endfun "}}}
fun! riv#id() "{{{
    return exists('b:riv_p_id') ? b:riv_p_id : g:riv_p_id
endfun "}}}
fun! riv#get_latest() "{{{
    echohl Statement
    echo "Get Latest Verion at https://github.com/Rykka/riv.vim"
    echohl Normal
endfun "}}}
"}}}
"{{{ Loading Functions
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
fun! riv#show_menu() "{{{
    sil! menu disable Riv.*
    if &ft != 'rst'
        sil! menu enable Riv.Project
        sil! menu enable Riv.Project.*
        sil! menu enable Riv.Scratch
        sil! menu enable Riv.Scratch.*
        sil! menu enable Riv.Helper
        sil! menu enable Riv.Helper.*
        sil! menu enable Riv.About
        sil! menu enable Riv.About.*
    else
        sil! menu enable Riv.*
    endif
endfun "}}}
"}}}
"{{{ Options:
let s:default = {'version': g:riv_version}
let s:default.options = {
    \'default'            : s:default,
    \'global_leader'      : '<C-E>',
    \'file_link_ext'      : 'vim,cpp,c,py,rb,lua,pl',
    \'file_ext_link_hl'   : 1,
    \'file_link_invalid_hl' : 'ErrorMsg',
    \'file_link_style'    : 1,
    \'highlight_code'     : "lua,python,cpp,javascript,vim,sh",
    \'code_indicator'     : 1, 
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
    \'fold_auto_update'   : 1,
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
    \'python_rst_hl'      : 0,
    \'build_path'         : '_build',
    \'scratch_path'       : 'Scratch',
    \'source_suffix'      : '.rst',
    \'master_doc'         : 'index',
    \}
"}}}

" project options " {{{
fun! s:set_proj_conf(proj) "{{{
    let proj = copy(g:_riv_c.p_basic)
    for [key,var] in items(a:proj)
        let proj[key] = var
        unlet var
    endfor
    return proj
endfun "}}}
fun! riv#index(...) "{{{
    let id = a:0 ? a:1 : g:riv_p_id
    if exists("g:_riv_c.p[id]")
        " >>> echo riv#path#idx_file()
        " index.rst
        exe "edit +let\\ b:riv_p_id=".id riv#path#root(id).riv#path#idx_file(id)
    else
        call riv#error("No such Project ID in g:riv_projects.")
    endif
endfun "}}}
fun! riv#index_list() "{{{
    " if len(g:_riv_c.p) == 1
    "     call riv#error('You have NOT set any project in g:riv_projects.')
    "     return
    " endif
    let id = inputlist(["Please Select One Project ID:"]+
                \map(range(len(g:_riv_c.p)),'v:val+1. "." . g:_riv_c.p[v:val].path') )
    if id != 0
        call riv#index(id-1)
    endif
endfun "}}}
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
        \'path'               : '~/Documents/Riv' ,
        \'build_path'         : g:riv_build_path ,
        \'scratch_path'       : g:riv_scratch_path ,
        \'source_suffix'      : g:riv_source_suffix ,
        \'master_doc'         : g:riv_master_doc ,
        \'file_link_style'    : g:riv_file_link_style,
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
        call insert(s:c.p, s:c.p_basic)
    endif
    
    let s:t.doc_exts = 'rst|txt'
    let s:c.doc_ext_list = ['txt']
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
        " the plain one
        " >>> echo matchstr('.rst', '^\.\zs.*$')
        " rst
        let proj._source_suffix = matchstr(proj.source_suffix,'^\.\zs.*$') 
        if proj._source_suffix !~ '\v'.s:t.doc_exts
            " >>> echo g:_riv_t.doc_exts
            " rst|txt
            let s:t.doc_exts .= '|'.proj._source_suffix
            call add(s:c.doc_ext_list, proj._source_suffix)
        endif
    endfor
    "}}}
    
    " Patterns:
    let s:t.prior_str = g:riv_todo_priorities

    call riv#ptn#init()

    " Configs: "{{{
    let s:t.time_fmt  = "%Y-%m-%d"
    let s:t.sect_punc = '!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~'
    let s:t.list_lvs  =  ["*","+","-"]
    let s:t.highlight_code = riv#ptn#norm_list(split(g:riv_highlight_code,','))
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
fun! riv#load_aug() "{{{
    " Load the global auto group 
    aug RIV_GLOBAL
        au!
        au WinEnter,BufWinEnter * call riv#show_menu()
        
        " We only want to set the filetype for the files in
        " the project which has that option.
        for p in g:_riv_c.p
            if p.source_suffix != '.rst'
                exe 'au BufEnter '.p._root_path.'*'.p.source_suffix.'  setl ft=rst'
            endif
        endfor
        au! FileType rst call riv#buf_load_syn()  
    aug END
    
endfun "}}}
fun! riv#init() "{{{
    " for init autoload
    call riv#load_opt(s:default.options)
    call riv#cmd#init()
    call riv#load_conf()
    call riv#load_aug()
endfun "}}}

fun! riv#buf_load_aug() "{{{
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
endfun "}}}
fun! riv#buf_load_syn() "{{{
    if &ft=='rst' && riv#path#file_link_style() != 0
        exe 'syn match rstFileLink &'.riv#ptn#rstFileLink().'&'
        exe 'syn match rstFileLinkEmbed +<\zs[^>]*\ze>+ contained'
            \ 'containedin=rstFileLink'
        syn cluster rstCruft add=rstFileLink
        hi link rstFileLinkEmbed Number
    endif
endfun "}}}
fun! riv#buf_init() "{{{
    " for the rst buffer
    setl foldmethod=expr foldexpr=riv#fold#expr(v:lnum) 
    setl foldtext=riv#fold#text()
    setl comments=fb:.. commentstring=..\ %s 
    setl formatoptions+=tcroql expandtab
    let b:undo_ftplugin = "setl fdm< fde< fdt< com< cms< et< fo<"
                \ "| sil! unlet! "
                \ "b:riv_state b:riv_obj b:riv_flist"
                \ "| mapc <buffer>"
                \ "| au! RIV_BUFFER"
    call riv#cmd#init_maps()
    call riv#buf_load_aug()
endfun "}}}

if expand('<sfile>:p') == expand('%:p') "{{{
    call riv#init()
    call riv#test#doctest('%','%',2)
endif "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
