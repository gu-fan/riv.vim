"=============================================
"    Name: riv.vim
"    File: riv.vim
" Summary: Riv autoload main
"  Author: Rykka G.F
"  Update: 2014-08-06
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:autoload_path = expand('<sfile>:p:h')
let g:riv_version = '0.77'
let s:tempdir = fnamemodify(tempname(),':p')

" Miscs "{{{1
fun! riv#echo(msg) "{{{
    redraw
    echohl Type
    echo '[RIV]'
    echohl Normal
    echon a:msg
endfun "}}}
fun! riv#error(msg) "{{{
    redraw
    echohl ErrorMsg
    echo '[RIV]'
    echohl Normal
    echon a:msg
endfun "}}}
fun! riv#warning(msg) "{{{
    redraw
    echohl WarningMsg
    echo '[RIV]'
    echohl Normal
    echon a:msg
endfun "}}}
fun! riv#debug(msg) "{{{
    redraw
    if g:riv_debug
        echohl KeyWord
        echom "[RIV]"
        echohl Normal
        echon a:msg
    endif
endfun "}}}
fun! riv#breakundo() "{{{
    let &ul=&ul
endfun "}}}
fun! riv#id() "{{{
    " loop over the project root list and check if match,
    "
    " @return
    " -1 if not in project, which proj[-1] is the Temp Proj dir.
    " else the project's id in list g:_riv_c.p

    if !exists('b:riv_id')
        let b:riv_id = -1

        let f = expand('%:p')
        for proj in g:_riv_c.p
            if  riv#path#is_rel_to( proj._root_path, f)
                let b:riv_id = proj.id
                break
            endif
        endfor
    endif

    return b:riv_id
endfun "}}}
fun! riv#get_latest() "{{{
    echohl Statement
    echo "Get Latest Verion at https://github.com/Rykka/riv.vim"
    echohl Normal
endfun "}}}
fun! riv#get_opt(name) "{{{
    if exists("g:riv_".a:name)
        return g:riv_{a:name}
    else
        return ''
    endif
endfun "}}}
fun! riv#system(arg) abort "{{{
    " XXX: error in windows tmp files
    if exists("*vimproc#system")
        return vimproc#system(a:arg)
    else
        return system(a:arg)
    endif
endfun "}}}
"}}}
"{{{ Loading Functions
fun! riv#load_opt(...) "{{{
    let opts = get(a:000, 0, s:default.options)
    for [opt,var] in items(opts)
        if !exists('g:riv_'.opt)
            let g:riv_{opt} = var
        else
			let opt_type = type(g:riv_{opt})
			let alt_types = get(s:default.options_alternative_types, opt, [])
			if opt_type != type(var) && index(alt_types, opt_type) == -1
				" The option type is neither the type of the default value
				" nor is it in the alternative value list
            	call riv#error("RIV: Wrong type for Option:'g:riv_".opt."'! Default used.")
            	unlet! g:riv_{opt}
            	let g:riv_{opt} = var
			endif
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
    \'debug'              : 0,
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
    \'disable_folding'    : 0,
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
    \'html_code_hl_style' : 'molokai',
    \'fuzzy_help'         : 0,
    \'auto_format_table'  : 1,
    \'fold_info_pos'      : 'right',
    \'temp_path'          : 1,
    \'disable_indent'     : 0,
    \'i_tab_pum_next'     : 1,
    \'i_tab_user_cmd'     : "",
    \'i_stab_user_cmd'    : "",
    \'ignored_imaps'      : "",
    \'ignored_nmaps'      : "",
    \'ignored_vmaps'      : "",
    \'ignored_maps'       : "",
    \'month_names'        : 'January,February,March,April,May,June,July,'
                          \.'August,September,October,November,December',
    \'python_rst_hl'      : 0,
    \'default_path'         : '~/Documents/Riv',
    \'build_path'         : '_build',
    \'scratch_path'       : 'Scratch',
    \'source_suffix'      : '.rst',
    \'master_doc'         : 'index',
    \'auto_rst2html'      :  0,
    \'open_link_location' :  1,
    \'css_theme_dir'      :  '',
    \'unicode_ref_name'   :  0,
    \'use_calendar'       :  1,
    \'diary_rel_path'     : 'diary',
    \}
" Some options might accept different types of values.
" This is a dict relating all the possible types for each such option.
" Options that accept values of a single type are not listed.
let s:default.options_alternative_types = {
    \'temp_path'          : [type(0), type("")],
    \}
"}}}

" project options " {{{
fun! riv#index_list() "{{{
    " NOTE:
    " We may care about using of map,
    " which may change your item here.
    " like the g:_riv_c.p
    let id = inputlist(["Please Select One Project ID:"]+
                \map(copy(g:_riv_c.p), 'v:val.id+1. "  " . v:val._name . " : " . v:val.path') )
    if id == '' || id == 0 | return | endif
    if id != 0
        let g:_riv_c.main_idx = id
        call riv#index(id-1)
    endif
endfun "}}}
fun! riv#index(...) "{{{
    if exists("g:_riv_c.main_idx") 
        let id = g:_riv_c.main_idx
    else
        let id = a:0 ? a:1 : 0
    endif
    if exists("g:_riv_c.p[id]")
        " >>> echo riv#path#root_index()
        " index.rst
        exe "edit " . riv#path#root_index(id)
        " e g:_riv_c.p[id]._root_path
    else
        call riv#error("No such Project ID in g:riv_projects.")
    endif
endfun "}}}
"}}}

fun! s:set_proj_conf(proj) "{{{
    " XXX
    " We can skip this step, just use p_basic's option as an back up
    let proj = copy(g:_riv_c.p_basic)
    for [key,var] in items(a:proj)
        let proj[key] = copy(var)
        unlet var
    endfor
    let proj._name = printf('%-15s', proj.name)
    return proj
endfun "}}}
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
    let s:c.doc_path  = fnamemodify(s:autoload_path ,':h').'/doc/'

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


    " XXX:
    " For using one rst both in windows and linux.
    " This will cause things different, though vim will handle it.
    "
    " Is this correct way to define slash?
    " can 'shellslash' be used?

    let s:c.is_windows = has('win16') || has('win32') || has('win64') || has('win95')
    let s:c.is_cygwin = has('win32unix')
    let s:c.is_mac = !s:c.is_windows && !s:c.is_cygwin
    \ && (has('mac') || has('macunix') || has('gui_macvim') ||
    \ (!isdirectory('/proc') && executable('sw_vers')))

    let s:c.slash =  s:c.is_windows ? '\' : '/'

    " Project: "{{{
    let s:c.p_basic = {
        \'name'               : "My Note" ,
        \'path'               : g:riv_default_path ,
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
                call add(s:c.p, project)
            endif
        endfor
    elseif exists("g:riv_project") && type(g:riv_project) == type({})
        call add(s:c.p, g:riv_project)
    endif

    if empty(s:c.p)
        call add(s:c.p, s:c.p_basic)
    endif
    " insert a temp file path at last one
    " >>> echo fnamemodify(tempname(), ':h')
    call add(s:c.p, {'path': fnamemodify(tempname(), ':h'),
                   \ 'name': 'TEMP'})

    for i in range(len(s:c.p))
        let s:c.p[i].id = i
    endfor

    call map(s:c.p, "s:set_proj_conf(v:val)")

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
        if proj.name == 'TEMP'
            let s_path =  s:c.p[0]._root_path . s:c.p[0].scratch_path
        elseif riv#path#is_relative(proj.scratch_path)
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
    let s:t.highlight_code = split(g:riv_highlight_code,',')
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

    " This is Invalid Now!!
    " for key in split(g:riv_ignored_imaps,',')
    "     call (g:riv_default.buf_imaps, key)
    " endfor
    let g:riv_default.ignored_imaps = split(g:riv_ignored_imaps,',')
    let g:riv_default.ignored_nmaps = split(g:riv_ignored_nmaps,',')
    let g:riv_default.ignored_vmaps = split(g:riv_ignored_vmaps,',')
    let g:riv_default.ignored_maps = split(g:riv_ignored_maps,',')

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
    let s:e.REF_NOT_FOUND = "Riv: Could not find the link reference"
    let s:e.TAR_NOT_FOUND = "Riv: Could not find the link targets"

    if g:riv_use_calendar
        let g:calendar_action = 'riv#diary#calendar_action'
        let g:calendar_sign = 'riv#diary#calendar_sign'
    endif

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
    call riv#load_opt()
    call riv#cmd#init()
    call riv#load_conf()
    call riv#load_aug()
endfun "}}}

fun! riv#buf_load_aug() "{{{
    aug RIV_BUFFER "{{{
        " NOTE:
        " We should take care of the buffer loading here.
        " use au! in each group to clear to avoid
        " duplicated loading
        au! BufWritePost <buffer>  call riv#fold#update()
        au  BufWritePost <buffer>  call riv#todo#update()
        au!  BufWritePre  <buffer>  call riv#create#auto_mkdir()
        au!  WinLeave,BufWinLeave     <buffer>  call riv#file#update()
        if exists("g:riv_auto_format_table") && g:riv_auto_format_table == 1 "{{{
            au! InsertLeave <buffer> call riv#table#format_pos()
        endif "}}}
        if exists("g:riv_auto_rst2html") && g:riv_auto_rst2html == 1 "{{{
            au BufWritePost <buffer> sil! Riv2HtmlFile
        endif "}}}
        if exists("g:riv_link_cursor_hl")  && g:riv_link_cursor_hl == 1 "{{{
            " cursor_link_highlight
            au! CursorMoved <buffer>  call riv#link#hi_hover()
            " clear the highlight before bufwin/winleave
            au WinLeave,BufWinLeave     <buffer>  2match none
        endif "}}}
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
    call riv#id()
    " for the rst buffer
    if exists("g:riv_disable_folding") && g:riv_disable_folding != 0
        " Do nothing
    else
        setl foldmethod=expr foldexpr=riv#fold#expr(v:lnum)
        setl foldtext=riv#fold#text()
    endif

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
    call doctest#start()
endif "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
