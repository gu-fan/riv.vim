"=============================================
"    Name: path.vim
"    File: path.vim
" Summary: calc the path of files
"  Author: Rykka G.Forest
"  Update: 2012-07-07
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:slash = has('win32') || has('win64') ? '\' : '/'
let s:win =  has('win32') || has('win64') ? 1 : 0

" check 'ssl' ?
let s:c = g:_riv_c
fun! riv#path#root() "{{{
    return g:_riv_c.p[s:id()]._root_path
endfun "}}}

fun! riv#path#build_ft(ft) "{{{
    return g:_riv_c.p[s:id()]._build_path . a:ft . s:slash
endfun "}}}
fun! riv#path#build_path() "{{{
    return g:_riv_c.p[s:id()]._build_path
endfun "}}}
fun! riv#path#scratch_path() "{{{
    return g:_riv_c.p[s:id()]._scratch_path
endfun "}}}

fun! riv#path#directory(path) "{{{
    return riv#path#is_directory(a:path) ? a:path : a:path . s:slash
endfun "}}}
fun! riv#path#rel_to(dir, path) "{{{
    " return the related path to 'dir', default is current file's dir
    
    let dir = riv#path#is_directory(a:dir) ? a:dir : a:dir.'/'
    let dir = fnamemodify(dir, ':gs?\?/?') 
 
    let path = fnamemodify(a:path, ':gs?\?/?') 
    if match(path, dir) == -1
        throw g:_riv_e.NOT_REL_PATH
    endif
    return substitute(path, dir, '','')
endfun "}}}

fun! riv#path#is_rel_to(dir, path) "{{{
    
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

fun! riv#path#is_relative(name) "{{{
    return a:name !~ '^[~/]\|^[a-zA-Z]:'
endfun "}}}
fun! riv#path#is_directory(name) "{{{
    return a:name =~ '[\\/]$' 
endfun "}}}

fun! riv#path#ext_to(file, ft) "{{{
    return fnamemodify(a:file, ":r") . '.' . a:ft
endfun "}}}
fun! riv#path#ext_tail(file, ft) "{{{
    return fnamemodify(a:file, ":t:r") . '.' . a:ft
endfun "}}}

fun! s:id() "{{{
    return exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
