"=============================================
"    Name: publish.vim
"    File: publish.vim
" Summary: publish to html/pdf.
"  Author: Rykka G.Forest
"  Update: 2012-06-09
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C
fun! s:repl_file_link(line) "{{{
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

    
    let id =  exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
    let index = g:_riv_c.p[id].index
    let rst_ext = g:_riv_c.p[id].rst_ext
    
    let line = a:line
    let file = matchstr(a:line, g:_riv_p.link_file)
    let idx = matchend(a:line, g:_riv_p.link_file)
    while !empty(file)
        if g:riv_localfile_linktype == 2
            let file = matchstr(file, '^\[\zs.*\ze\]$')
        endif
        let file = s:norm(file)
        if !s:is_relative(file)
                let title = file
                let path = file
        elseif s:is_directory(file)
            let title = file
            let path = title .index . '.html'
        else
            if file =~ '\.'.rst_ext.'$' 
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
fun! s:norm(txt) "{{{
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
fun! s:create_tmp(file) "{{{
    update
    let lines = map(readfile(a:file),'s:repl_file_link(v:val)')
    call writefile(lines, s:tempfile)       " not all system can pipe
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
fun! s:rst_args(ft)
    return !exists("g:riv_rst2".a:ft."_args") ? !empty(g:riv_rst2{a:ft}_args)
                \ ? g:riv_rst2{a:ft}_args : '' : ''
endfun
fun! riv#publish#2html(file,html_path,browse) "{{{
    let file = expand(a:file)
    let out_path = a:html_path . s:get_rel_to_root(file)
    if !isdirectory(fnamemodify(out_path,':h')) 
        call mkdir(fnamemodify(out_path,':h'),'p')
    endif
    let file_path = fnamemodify(out_path, ":r").'.html'

    call s:create_tmp(file)
    call s:to('html',file_path,s:rst_args('html'))
    if a:browse
        call s:sys(g:riv_web_browser . ' '. file_path . ' &')
    endif
endfun "}}}


fun! riv#publish#copy2proj(file,html_path) abort "{{{
    let out_path = a:html_path . s:get_rel_to_root(expand(a:file))
    if !isdirectory(fnamemodify(out_path,':h')) 
        call mkdir(fnamemodify(out_path,':h'),'p')
    endif
    call s:sys( 'cp -f '. a:file. ' '.  fnamemodify(out_path, ':h'))
endfun "}}}

fun! riv#publish#file2html(browse) "{{{
    call riv#publish#2html(expand('%:p'), s:get_path('html'), a:browse)
endfun "}}}
fun! riv#publish#proj2html() abort "{{{
    let id =  exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
    let ext = g:_riv_c.p[id].rst_ext
    let html_path = s:get_path('html')
    let root = s:get_root_path()
    let files = filter(split(glob(root.'**/*.'.ext)), 'v:val !~ ''_build''')
    echohl Function
    echon 'Convert: '
    for file in files
        call riv#publish#2html(file, html_path, 0)
        echon '>'
    endfor
    let copy_ext = '{'.join(g:_riv_t.file_ext_lst,',').'}'
    let files = filter(split(glob(root.'**/*'.copy_ext)), 'v:val !~ ''_build''')
    for file in files
        call riv#publish#copy2proj(file,html_path)
        echon '>'
    endfor
    echon ' Done.'
    echohl Normal
endfun "}}}
let s:tempfile = tempname()

" ['s5', 'latex', 'odt', 'xml' , 'pseudoxml', 'html' ]
fun! riv#publish#file2(ft, browse) "{{{
    call riv#publish#2(a:ft , expand('%:p'), s:get_path(a:ft), a:browse)
endfun "}}}
let g:riv_ft_browser = 'xdg-open'
fun! riv#publish#2(ft, file, path, browse) "{{{
    let file = expand(a:file)
    let out_path = a:path . s:get_rel_to_root(file)
    if !isdirectory(fnamemodify(out_path,':h')) 
        call mkdir(fnamemodify(out_path,':h'),'p')
    endif
    let file_path = fnamemodify(out_path, ":r").'.'.a:ft

    call s:create_tmp(file)
    call s:to(a:ft,file_path,s:rst_args(a:ft))
    if a:browse
        call s:sys(g:riv_ft_browser . ' '. file_path . ' &')
    endif
endfun "}}}

fun! s:to(ft,path,...) "{{{
    let exe = 'rst2'.a:ft.'2.py'
    if !executable(exe)
        let exe = 'rst2'.a:ft.'.py'
        if !executable(exe)
            call riv#error('Could not find '.exe)
            return -1
        endif
    endif
    let args = a:0 ? a:1 : ''
    call s:sys( exe." ". args .' '. s:tempfile. " > " . a:path )
endfun "}}}

fun! s:get_build_path() "{{{
    let build_path = g:_riv_c.p[s:id()].build_path
    if s:is_relative(build_path)
        let build_path =  s:get_root_path().build_path
    endif
    return s:is_directory(build_path) ?  build_path : build_path.'/'
endfun "}}}
fun! s:id() "{{{
    return exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
endfun "}}}
fun! s:get_path(ft) "{{{
    return s:get_build_path().a:ft.'/'
endfun "}}}
fun! s:get_root_path() "{{{
    let root = expand(g:_riv_c.p[s:id()].path)
    return s:is_directory(root) ? root : root.'/'
endfun "}}}
fun! s:sys(arg) abort "{{{
    return system(a:arg)
endfun "}}}

fun! riv#publish#browse() "{{{
    let index = g:_riv_c.p[s:id()].index
    let path = s:get_path('html') . index . '.html'
    call  s:sys(g:riv_web_browser . ' '. path . ' &')
endfun "}}}
fun! riv#publish#path() "{{{
    exe 'sp ' s:get_build_path()
endfun "}}}
fun! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun "}}}
fun! riv#publish#SID() "{{{
    return '<SNR>'.s:SID().'_'
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
