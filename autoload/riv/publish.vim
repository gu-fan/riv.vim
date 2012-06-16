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
    let id =  exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
    let root = expand(g:_riv_c.p[id].path)
    if match(a:path, root) == -1
        throw 'Riv: Not Same Path with Project'
    endif
    let r_path = substitute(a:path, root , '' , '')
    let r_path = substitute(r_path, '^/', '' , '')
    return r_path
endfun "}}}
fun! riv#publish#2html(file,html_path,browse) "{{{
    let id =  exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
    let file = expand(a:file)
    let out_path = a:html_path . s:get_rel_to_root(file)
    if !isdirectory(fnamemodify(out_path,':h')) 
        call mkdir(fnamemodify(out_path,':h'),'p')
    endif
    let file_path = fnamemodify(out_path, ":r").'.html'
    call s:create_tmp(file)
    call s:to_html(file_path)
    if a:browse
        exe '!'.g:riv_web_browser . ' '. file_path . ' &'
    endif
endfun "}}}
fun! riv#publish#copy2proj(file,html_path) abort "{{{
    let out_path = a:html_path . s:get_rel_to_root(expand(a:file))
    if !isdirectory(fnamemodify(out_path,':h')) 
        call mkdir(fnamemodify(out_path,':h'),'p')
    endif
    call system( 'cp -f '. a:file. ' '.  fnamemodify(out_path, ':h'))
endfun "}}}
fun! riv#publish#browse() "{{{
    let id =  exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
    let index = g:_riv_c.p[id].index
    let path = s:get_html_path() . index . '.html'
    exe '!'.g:riv_web_browser . ' '. path . ' &'
    
endfun "}}}
fun! s:get_html_path() "{{{
    let id =  exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id

    let build_path = g:_riv_c.p[id].build_path
    let root = expand(g:_riv_c.p[id].path)
    let root = s:is_directory(root) ? root : root.'/'
    if s:is_relative(build_path)
        let build_path =  root.build_path
    endif
    let html_path = s:is_directory(build_path) ? 
                \ build_path.'html/' : build_path.'/html/'
    return html_path   
endfun "}}}
fun! riv#publish#file2html(browse) "{{{
    let id =  exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
    let ext = g:_riv_c.p[id].rst_ext
    let html_path = s:get_html_path()
    call riv#publish#2html(expand('%:p'), html_path, a:browse)
endfun "}}}
fun! riv#publish#proj2html() abort "{{{
    let id =  exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
    let ext = g:_riv_c.p[id].rst_ext
    let html_path = s:get_html_path()
    let root = expand(g:_riv_c.p[id].path)
    let root = s:is_directory(root) ? root : root.'/'
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
fun! s:to_html(path) abort "{{{
    if !executable('rst2html.py')
        echohl WarningMsg
        echo 'Could not find rst2html.py'
        echohl Normal
        return -1
    endif
    let style = g:_riv_c.riv_path.'style.css '
    let args = g:riv_rst2html_args.' '
    call system( "rst2html.py ". args . s:tempfile. " > " . a:path )
endfun "}}}


fun! s:to_pdf()
    
endfun
fun! s:to_odt()
    
endfun

fun! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun "}}}
fun! riv#publish#SID() "{{{
    return '<SNR>'.s:SID().'_'
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
