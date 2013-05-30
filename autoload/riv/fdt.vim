"=============================================
"    Name: fdt.vim
"    File: fdt.vim
" Summary: fold test version
"  Author: Rykka G.F
"  Update: 2013-05-19
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:st = {}

fun! s:st.init() dict
    let s = deepcopy(self)
    let s.buf_len = line('$')
    let s.buf = getline(1, st.buf_len)
    return s
endfun

fun! s:st.run()
endfun






let &cpo = s:cpo_save
unlet s:cpo_save
