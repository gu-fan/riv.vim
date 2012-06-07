fun! s:up_index() "{{{
    if filereadable("../index.rst")
        e ../index.rst
    elseif filereadable("index.rst") && expand('%') != "index.rst"
        call <SID>cindex("rst")
    else
        echo "You already reached the root level."
    endif
endfun "}}}


"{{{ file jump 
fun! s:cindex(ftype) "{{{
    let idx = "index.".a:ftype
    if filereadable(idx)
        if expand('%') == idx
            edit #
        else
            exe "edit ". idx
        endif
    else
        echo "No index for current page"
    endif
endfun "}}}
"}}}
