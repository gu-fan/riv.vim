"=============================================
"    Name: publish.vim
"    File: publish.vim
" Summary: publish to html/pdf.
"  Author: Rykka G.Forest
"  Update: 2012-06-27
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C
fun! s:repl_file_link(line) "{{{
    " File              Title   Path
    " index.rst     => `index <index.html>`_
    " test.rst      => `test <test.html>`_
    " test.py       => `test.py <test.py>`_
    " Html/         => `Html/   <Html/index.html>`_
    " /home/a.rst   => `/home/a.rst  </home/a.rst>`_    ?
    " ~/a.rst       => `~/a.rst  <~/a.rst>`_            ?
    " ./index.rst   => `./index  <./index.html>`_
    " ../           => `../      <../index.html>`_
    " index.rst#RIV => `index#RIV <index.html#RIV>`_     ToDo
    " [index]       => `[index] <index.html>`_
    " [index.rst]   => `[index] <index.html>`_
    " [index.vim]   => `[index.vim] <index.vim>`_
    " [index/]      => `[index/] <index/index.rst>`_
    " [/home/a.rst] => `[/home/a.rst]  </home/a.rst>`_    ?
    
    " Dont' convert links in table. which will made table malformed.
    "
    " Also links in same line of explicit mark are not converted.
    
    
    let line = a:line
    if line =~ g:_riv_p.table || line =~ g:_riv_p.exp_m
        return line
    endif


    let file = matchstr(a:line, g:_riv_p.link_file)
    let idx = matchend(a:line, g:_riv_p.link_file)
    while !empty(file)
        if g:riv_localfile_linktype == 2
            let file = matchstr(file, '^\[\zs.*\ze\]$')
        endif
        let file = s:escape(file)
        if !s:is_relative(file)
                let title = file
                let path = file
        elseif s:is_directory(file)
            let title = file
            let path = title . 'index.html'
        else
            if file =~ '\.rst$' 
                let title = matchstr(file, '.*\ze\.rst$')
                let path = title.'.html'
            elseif fnamemodify(file, ':e') == '' && g:riv_localfile_linktype == 2
                let title = file

                let path = title.'.html'
            else
                let title = file
                let path = file
            endif
        endif
        let line = substitute(line, s:escape_file_ptn(file), 
                    \s:gen_embed_link(title, path), 'g')
        let file = matchstr(line, g:_riv_p.link_file,idx)
        let idx = matchend(line, g:_riv_p.link_file,idx)
    endwhile
    return line
endfun "}}}
fun! s:escape_file_ptn(file) "{{{
    if g:riv_localfile_linktype == 2
        return   '\%(^\|\s\)\zs\[' . a:file . '\]\ze\%(\s\|$\)'
    else
        return   '\%(^\|\s\)\zs' . a:file . '\ze\%(\s\|$\)'
    endif
endfun "}}}
fun! s:escape(txt) "{{{
    return escape(a:txt, '~.*\[]^$')
endfun "}}}
fun! s:is_relative(name) "{{{
    return a:name !~ '^\~\|^/\|^[a-zA-Z]:'
endfun "}}}
fun! s:is_directory(name) "{{{
    return a:name =~ '/$' 
endfun "}}}
fun! s:gen_embed_link(title, path) "{{{
    if g:riv_localfile_linktype == 2
        return  '`['.a:title.'] <'.a:path.'>`_'
    else
        return  '`'.a:title.' <'.a:path.'>`_'
    endif
endfun "}}}

let s:slash = has('win32') || has('win64') ? '\' : '/'
fun! s:get_build_path_of(ft) "{{{
    return g:_riv_c.p[s:id()]._build_path . a:ft . s:slash
endfun "}}}
fun! s:get_root_path() "{{{
    return g:_riv_c.p[s:id()]._root_path
endfun "}}}
fun! s:get_rel_to_root(path) "{{{
    let root = s:get_root_path()
    if match(a:path, root) == -1
        throw 'Riv: Not Same Path with Project'
    endif
    let r_path = substitute(a:path, root , '' , '')
    let r_path = substitute(r_path, '^/', '' , '')
    return r_path
endfun "}}}

fun! s:rst_args(ft) "{{{
    return exists("g:riv_rst2".a:ft."_args") ? !empty(g:riv_rst2{a:ft}_args)
                \ ? g:riv_rst2{a:ft}_args : '' : ''
endfun "}}}
fun! s:auto_mkdir(path) "{{{
    if !isdirectory(fnamemodify(a:path,':h')) 
        call mkdir(fnamemodify(a:path,':h'),'p')
    endif
endfun "}}}

let s:tempfile = tempname()
fun! s:create_tmp(file) "{{{
    update
    let id =  s:id()
    let lines = map(readfile(a:file),'s:repl_file_link(v:val)')
    call writefile(lines, s:tempfile)       " not all system can pipe
    return s:tempfile
endfun "}}}

fun! riv#publish#copy2proj(file,html_path) abort "{{{
    let out_path = a:html_path . s:get_rel_to_root(expand(a:file))
    call s:auto_mkdir(out_path)
    call s:sys( 'cp -f '. a:file. ' '.  fnamemodify(out_path, ':h'))
endfun "}}}
fun! riv#publish#proj2(ft) abort "{{{
    let id =  exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
    let ft_path = s:get_build_path_of(a:ft)
    let root = s:get_root_path()
    let files = filter(split(glob(root.'**/*.rst')), 'v:val !~ ''_build''')
    echohl Function
    echon 'Convert: '
    for file in files
        call riv#publish#2(a:ft,file, ft_path, 0)
        echon '>'
    endfor
    echohl Normal
    let copy_ext = '{'.join(g:_riv_t.file_ext_lst,',').'}'
    if a:ft == "html" 
        \ && input("Copy all file of extension: ".copy_ext."\n(Y/n):")!~?'n'
        let files = filter(split(glob(root.'**/*'.copy_ext)), 'v:val !~ ''_build''')
        for file in files
            call riv#publish#copy2proj(file,html_path)
            echon '>'
        endfor
    endif
    echon ' Done.'
endfun "}}}

" ['s5', 'latex', 'odt', 'xml' , 'pseudoxml', 'html' ]
fun! riv#publish#file2(ft, browse) "{{{
    let file_path = expand('%:p')
    try 
        call s:get_rel_to_root(file_path)
        call riv#publish#2(a:ft , file_path, s:get_build_path_of(a:ft), a:browse)
    catch /Riv: Not Same Path with Project/
        call s:single2(a:ft, file_path, a:browse)
    endtry
endfun "}}}
fun! s:single2(ft, file, browse) "{{{
    " A file that is not in a project
    let file = expand(a:file)
    if g:riv_temp_path == ""
        let out_path = fnamemodify(file, ":r") . '.' . a:ft
    else
        let temp_path = s:is_directory(g:riv_temp_path) ? g:riv_temp_path 
                    \ : g:riv_temp_path . s:slash
        let out_path = g:riv_temp_path . fnamemodify(file, ":t:r") . "." . a:ft
    endif
    call s:convert(a:ft, file, out_path, s:rst_args(a:ft))
    if a:browse
        if a:ft == "latex"
            exe 'sp ' out_path
        elseif a:ft == "odt"
            call s:sys(g:riv_ft_browser . ' '. out_path . ' &')
        else
            call s:sys(g:riv_web_browser . ' '. out_path . ' &')
        endif
    endif
endfun "}}}
fun! riv#publish#2(ft, file, path, browse) "{{{
    let file = expand(a:file)
    let out_path = a:path . s:get_rel_to_root(file)
    let file_path = fnamemodify(out_path, ":r").'.'.a:ft
    call s:auto_mkdir(out_path)
    call s:convert(a:ft, s:create_tmp(file), file_path, s:rst_args(a:ft))
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
    call s:sys( exe." ". args .' '. a:input . " > " . a:output )
endfun "}}}

fun! riv#publish#browse() "{{{
    let path = s:get_build_path_of('html') .  'index.html'
    call s:sys(g:riv_web_browser . ' '. path . ' &')
endfun "}}}
fun! riv#publish#path() "{{{
    exe 'sp ' g:_riv_c.p[s:id()]._build_path
endfun "}}}

fun! s:id() "{{{
    return exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
endfun "}}}
fun! s:sys(arg) abort "{{{
    return system(a:arg)
endfun "}}}
fun! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun "}}}
fun! riv#publish#SID() "{{{
    return '<SNR>'.s:SID().'_'
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
