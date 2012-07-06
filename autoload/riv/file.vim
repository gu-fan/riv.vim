"=============================================
"    Name: file.vim
"    File: file.vim
" Summary: file operation
"          find /match/delete/
"  Author: Rykka G.Forest
"  Update: 2012-07-07
"=============================================
let s:cpo_save = &cpo
set cpo-=C



fun! riv#file#from_str(str) "{{{
    " parse file name from string
    " return [file , is_dir]
    let file = a:str
    if g:riv_localfile_linktype == 2
        let file = matchstr(file, '^\[\zs.*\ze\]$')
    endif
    if !riv#path#is_relative(file)
        if riv#path#is_directory(file)
            return [expand(file), 1]
        else
            return [expand(file) , 0]
        endif
    elseif riv#path#is_directory(file)
        return [file.'index.rst' , 0]
    else
        let f = matchstr(file, '.*\ze\.rst$')
        if !empty(f)
            return [file, 0]
        elseif  g:riv_localfile_linktype == 2 && fnamemodify(file, ':e') == ''
            return [file.'.rst', 0]
        else
            return [file, 0]
        endif
    endif
endfun "}}}

fun! riv#file#edit(file) "{{{
    let id = s:id()
    exe "edit ".a:file
    let b:riv_p_id = id
endfun "}}}
fun! riv#file#split(file) "{{{
    let id = s:id()
    exe "split ".a:file
    let b:riv_p_id = id
endfun "}}}


let &cpo = s:cpo_save
unlet s:cpo_save
