"=============================================
"    Name: path.vim
"    File: path.vim
" Summary: calc the path of files
"  Author: Rykka G.F
"  Update: 2012-07-07
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:slash = g:_riv_c.slash


let s:c = g:_riv_c
let s:id = function("riv#id")

fun! riv#path#root(...) "{{{
    return s:c.p[a:0 ? a:1 : s:id()]._root_path
endfun "}}}
fun! riv#path#root_index(...) "{{{
    let id = a:0 ? a:1 : s:id()
    return riv#path#root(id) . riv#path#idx_file(id)
endfun "}}}

fun! riv#path#build_ft(ft,...) "{{{
    " return the build's filetype path
    return s:c.p[a:0 ? a:1 : s:id()]._build_path . a:ft . s:slash
endfun "}}}
fun! riv#path#p_build(...) "{{{
    " >>> echo riv#path#p_build()
    " _build
    return s:c.p[a:0 ? a:1 : s:id()].build_path
endfun "}}}
fun! riv#path#build_path(...) "{{{
    return s:c.p[a:0 ? a:1 : s:id()]._build_path
endfun "}}}
fun! riv#path#scratch_path(...) "{{{
    return s:c.p[a:0 ? a:1 : s:id()]._scratch_path
endfun "}}}
fun! riv#path#file_link_style(...) "{{{
    return s:c.p[a:0 ? a:1 : s:id()].file_link_style
endfun "}}}

fun! riv#path#ext(...) "{{{
    " file suffix 
    " >>> echo riv#path#ext()
    " .rst
    return s:c.p[a:0 ? a:1 : s:id()].source_suffix
endfun "}}}
fun! riv#path#idx(...) "{{{
    " project master doc.
    " >>> echo riv#path#idx()
    " index
    return s:c.p[a:0 ? a:1 : s:id()].master_doc
endfun "}}}
fun! riv#path#idx_file(...) "{{{
    " >>> echo riv#path#idx_file()
    " index.rst
    return call('riv#path#idx',a:000) . call('riv#path#ext',a:000)  
endfun "}}}

fun! riv#path#p_ext(...) "{{{
    return s:c.p[a:0 ? a:1 : s:id()]._source_suffix
endfun "}}}

fun! riv#path#is_ext(file) "{{{
    " >>> echo riv#path#is_ext('aaa.rst')
    " 1
    " >>> echo riv#path#is_ext('aa.arst')
    " 0
    return fnamemodify(a:file,':e') == riv#path#p_ext()
endfun "}}}

fun! riv#path#directory(path) "{{{
    return riv#path#is_directory(a:path) ? a:path : a:path . s:slash
endfun "}}}
fun! riv#path#rel_to(dir, path) "{{{
    " return the relative path to 'dir', 
    "
    " >>> echom riv#path#rel_to('/etc/X11/', '/etc/X11/home')
    " home
    " >>> echom riv#path#rel_to('/etc/X11/', '/etc/home')
    " ../home
    " >>> echom riv#path#rel_to('/etc/X11/', '/tc/home')
    " Riv: Note a related path
    
    let dir = riv#path#is_directory(a:dir) ? a:dir : fnamemodify(a:dir,':h') . '/'
    let dir = fnamemodify(dir, ':gs?\?/?') 
    let path = fnamemodify(a:path, ':gs?\?/?') 
    if match(path, dir) == -1
        let p = riv#path#is_directory(path) ? path : fnamemodify(path,':h') . '/'
        let tail = fnamemodify(path,':t')
        if match(dir, p) == -1
            throw g:_riv_e.NOT_REL_PATH
        endif
        let f = substitute(dir, p, '','')
        let dot = substitute(f,'[^/]\+/','../','g')
        return dot.tail
    endif
    return substitute(path, dir, '', '')
endfun "}}}
fun! riv#path#is_rel_to(dir, path) "{{{
    " check if path is relatetive to dir
    "
    let dir = riv#path#is_directory(a:dir) ? a:dir : a:dir.'/'
    let dir = fnamemodify(dir, ':gs?\?/?') 
    let path = fnamemodify(a:path, ':gs?\?/?') 
    if match(path, dir) == -1
        return 0
    else
        return 1
    endif
endfun "}}}
fun! riv#path#rel_to_root(path) "{{{
    return riv#path#rel_to(riv#path#root(), a:path)
endfun "}}}
fun! riv#path#is_rel_to_root(path) "{{{
    return riv#path#is_rel_to(riv#path#root(), a:path)
endfun "}}}

fun! riv#path#par_to(dir,path) "{{{
    let dir = riv#path#is_directory(a:dir) ? a:dir : a:dir.'/'
    let dir = fnamemodify(dir, ':gs?\?/?') 
    let path = fnamemodify(a:path, ':gs?\?/?') 
    if match(dir, path) == -1
        throw g:_riv_e.NOT_REL_PATH
    endif
    let f = substitute(dir, path, '','')
    let dot = substitute(f,'[^/]\+/','../','g')
    return dot
endfun "}}}

fun! riv#path#is_relative(name) "{{{
    return a:name !~ '^[~/]\|^[a-zA-Z]:'
endfun "}}}
fun! riv#path#is_directory(name) "{{{
    return a:name =~ '\w[\\/]$' 
endfun "}}}

fun! riv#path#ext_with(file, ft) "{{{
    return fnamemodify(a:file, ":r") . '.' . a:ft
endfun "}}}
fun! riv#path#ext_tail(file, ft) "{{{
    return fnamemodify(a:file, ":t:r") . '.' . a:ft
endfun "}}}

fun! riv#path#join(a, ...)
    " python2.7/posixpath.py
    "
    " Join two or more pathname componentes,
    " inserting '/' as needed.
    " If any component is an absolute path, all previous path components
    " will be discarded.
    "
    let path = a:a
    for b in a:000
        if !riv#path#is_relative(b)
            let path = b
        elseif  path == '' ||  path =~ '[/\]$'
            let path .= b
        else 
            let path .= s:slash . b
        endif
    endfor
    return path
endfun

if expand('<sfile>:p') == expand('%:p') "{{{
    " call doctest#start()
endif "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
