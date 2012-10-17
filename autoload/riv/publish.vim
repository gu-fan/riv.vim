"=============================================
"    Name: publish.vim
"    File: publish.vim
" Summary: publish to html/pdf...
"  Author: Rykka G.F
"  Update: 2012-09-17
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! s:escape_file_ptn(file) "{{{
    return  '\v%(^|\s|[''"([{<,;!?])\zs\[\[' . a:file . '\]\]\ze%($|\s|[''")\]}>:.,;!?])'
endfun "}}}
fun! s:escape(txt) "{{{
    return escape(a:txt, '~.*\[]^$')
endfun "}}}
fun! s:gen_embed_link(title, path) "{{{
    if riv#path#file_link_style() == 2
        return  '`['.a:title.'] <'.a:path.'>`_'
    else
        return  '`'.a:title.' <'.a:path.'>`_'
    endif
endfun "}}}

fun! riv#publish#path(str) "{{{
    " return the html path converted from string.
    " [[xxx]] => _build/xxx.html
    " [[xxx.vim]] => _build/xxx.vim
    " [[xxx/]] => _build/xxx/index.html
    " [[/xxx]]  => _build/DOC_ROOT/xxx.html
    " [[/xxx/]]  => _build/DOC_ROOT/xxx/index.html
    " [[~/xxx]] => ~/xxx

    let f = matchstr(a:str, '^\[\[\zs.*\ze\]\]$')
    " absolute path are files. no html link
    let t = f =~ '^([~]|[a-zA-Z]:)' ? 'file' : 'doc'

    if riv#path#is_relative(f)
        let file = f
    else
        " if it have '/' at start. 
        " it is the doc root for sphinx and moinmoin 
        if f =~ '^/'
            let file = riv#path#build_ft('html') . f[1:]
        else
            let file = expand(f)
            return file
        endif
    endif
    if riv#path#is_directory(file) && t == 'doc'
        let file = file . 'index.html'
    elseif fnamemodify(file, ':e') == '' && t == 'doc'
        let file = file . '.html'
    elseif fnamemodify(file, ':e') == riv#path#p_ext() && t == 'doc'
        let file = fnamemodify(file, ':r') . '.html'
    endif
    
    return file
endfun "}}}

fun! s:repl_file_link(line) "{{{
    " File              Title   Path
    " [[index]]       => `index <index.html>`_
    " [[index.rst]]   => `index <index.html>`_
    " [[index.vim]]   => `index.vim <index.vim>`_
    " [[index/]]      => `index/ <index/index.html>`_
    " [[/xxx/a.rst]]  => `/xxx/a.rst  <DOC_ROOT/xxx/a.rst>`_
    
    let line = a:line
    
    " we will get the idx and find the pattern from origin line.
    let o_line = line
    let pre_idx = 0           " for the inline markup column check
    let idx = matchend(o_line, riv#ptn#link_file())
    let str = matchstr(o_line, riv#ptn#link_file())
    while idx != -1
        let obj = riv#ptn#get_inline_markup_obj(o_line, idx+1, pre_idx)
        " it's not in a inline markup
        if empty(obj)
            " substitute process
            let title = s:escape(matchstr(str, '^\[\[\zs.*\ze\]\]$'))
            let path = riv#publish#path(str)
            let line = substitute(line, s:escape_file_ptn(title), 
                            \s:gen_embed_link(title, path), 'g')
        endif
        let idx = matchend(o_line, riv#ptn#link_file(),idx)
        let str = matchstr(o_line, riv#ptn#link_file(),idx)
        let pre_idx = idx
    endwhile
    return line
endfun "}}}

let s:tempfile = tempname()
let s:tempdir = riv#path#directory(fnamemodify(s:tempfile,':h'))
fun! s:create_tmp(file) "{{{
    update
    let lines = map(readfile(a:file),'s:repl_file_link(v:val)')
    call writefile(lines, s:tempfile)       " not all OS can pipe
    return s:tempfile
endfun "}}}

let s:css_default = g:_riv_c.riv_path.'html/default.css'
let s:css_emacs = g:_riv_c.riv_path.'html/emacs.css'
let s:css_friendly = g:_riv_c.riv_path.'html/friendly.css'
let s:css_html = g:_riv_c.riv_path.'html/html4css1.css'

fun! s:convert(ft, input, output, ...) "{{{
    " try 2 first , for py3 version should decode to 'bytes'.
    let exe = 'rst2'.a:ft.'2.py'
    if !executable(exe)
        let exe = 'rst2'.a:ft.'.py'
        if !executable(exe)
            call riv#error('Could not find '.exe)
            return -1
        endif
    endif
    let args = a:0 ? a:1 : ''
    let style = ''
    if a:ft == 'html' 
        if g:riv_html_code_hl_style == 'default'
            let style = ' --stylesheet='.s:css_html.','.s:css_default
        elseif g:riv_html_code_hl_style == 'emacs'
            let style = ' --stylesheet='.s:css_html.','.s:css_emacs
        elseif g:riv_html_code_hl_style == 'friendly'
            let style = ' --stylesheet='.s:css_html.','.s:css_friendly
        elseif filereadable(g:riv_html_code_hl_style)
            let style = ' --stylesheet='.g:riv_html_code_hl_style
        endif
    endif
    call s:sys( exe." ". style . args .' '. shellescape(a:input) . " > " . shellescape(a:output) )
endfun "}}}
fun! s:single2(ft, file, browse) "{{{
    " A file that is not in a project
    let file = expand(a:file)
    if empty(g:riv_temp_path)
        let out_path = riv#path#ext_to(file, a:ft)
    elseif g:riv_temp_path == 1
        let temp_path = s:tempdir
        let out_path = temp_path . riv#path#ext_tail(file, a:ft)
    else
        let temp_path = riv#path#directory(g:riv_temp_path)  
        let out_path = temp_path . riv#path#ext_tail(file, a:ft)
    endif

    call s:convert(a:ft, file, out_path, s:rst_args(a:ft))

    if a:browse
        if a:ft == "latex"
            exe 'sp ' out_path
        elseif a:ft == "odt"
            call s:sys(g:riv_ft_browser . ' '. shellescape(out_path) . ' &')
        else
            call s:sys(g:riv_web_browser . ' '. shellescape(out_path) . ' &')
        endif
    endif
endfun "}}}
" ['s5', 'latex', 'odt', 'xml' , 'pseudoxml', 'html' ]
fun! riv#publish#file2(ft, browse) "{{{
    let file = expand('%:p')
    echohl Function
    echo "Convert:"
    echohl Normal
    echon file
    if riv#path#is_rel_to_root(file)
        call riv#publish#2(a:ft , file, riv#path#build_ft(a:ft), a:browse)
    else
        call s:single2(a:ft, file, a:browse)
    endif
endfun "}}}
fun! riv#publish#2(ft, file, path, browse) "{{{
    let file = expand(a:file)
    let out_path = a:path . riv#path#rel_to_root(file)
    let file_path = riv#path#ext_to(out_path, a:ft)
    call riv#publish#auto_mkdir(out_path)
    if riv#path#file_link_style() == 1
        call s:convert(a:ft, s:create_tmp(file), file_path, s:rst_args(a:ft))
    else
        call s:convert(a:ft, file, file_path, s:rst_args(a:ft))
    endif
    if a:browse
        if a:ft == "latex"
            exe 'sp ' file_path
        elseif a:ft == "odt"
            call s:sys(g:riv_ft_browser . ' '. file_path . ' &')
        else
            call s:sys(g:riv_web_browser . ' '. file_path . ' &')
        endif
    endif
endfun "}}}

fun! riv#publish#browse() "{{{
    let path = riv#path#build_ft('html') .  'index.html'
    call s:sys(g:riv_web_browser . ' '. shellescape(path) . ' &')
endfun "}}}
fun! riv#publish#open_path() "{{{
    exe 'sp ' riv#path#build_path()
endfun "}}}

fun! riv#publish#copy2proj(file,html_path) abort "{{{
    let out_path = a:html_path . riv#path#rel_to_root(expand(a:file))
    call riv#publish#auto_mkdir(out_path)
    call s:sys( 'cp -f '. a:file. ' '.  fnamemodify(out_path, ':h'))
endfun "}}}
fun! s:get_proj_file_lists()
    return filter(split(glob(riv#path#root().'**/*'.riv#path#ext()),'\n'), 'v:val !~ '''.riv#path#p_build().'''')
endfun
fun! riv#publish#proj2(ft) abort "{{{
    let ft_path = riv#path#build_ft(a:ft)
    let files = s:get_proj_file_lists()
    for i in range(len(files))
        call riv#publish#2(a:ft,files[i], ft_path, 0)
        redraw
        echohl Function
        echo i.'/'.len(files) 
        echohl Normal
        echon files[i]
    endfor
    let copy_ext = '{'.join(g:_riv_t.file_ext_lst,',').'}'
    if a:ft == "html" 
        \ && input("Copy all file of extension: ".copy_ext."\n(Y/n):")!~?'n'
        let files = filter(split(glob(riv#path#root().'**/*'.copy_ext)), 'v:val !~ '''.riv#path#p_build().'''')
        for file in files
            call riv#publish#copy2proj(file, ft_path)
        endfor
    endif
endfun "}}}

fun! s:rst_args(ft) "{{{
    return exists("g:riv_rst2".a:ft."_args") ? !empty(g:riv_rst2{a:ft}_args)
                \ ? g:riv_rst2{a:ft}_args : '' : ''
endfun "}}}
fun! riv#publish#auto_mkdir(path) "{{{
    if !isdirectory(fnamemodify(a:path,':h')) 
        call mkdir(fnamemodify(a:path,':h'),'p')
    endif
endfun "}}}

fun! s:sys(arg) abort "{{{
    " XXX: error in windows tmp files
    return system(a:arg)
endfun "}}}
if expand('<sfile>:p') == expand('%:p') "{{{
    call riv#test#doctest('%','%',2)
endif "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
