"=============================================
"    Name: test.vim
"    File: test.vim
" Summary: tests 
"  Author: Rykka F
"  Update: 2014-08-09
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! riv#test#echo(l) "{{{
    if type(a:l) == type({})
        for [key,val] in items(a:l)
            echohl Question | echo key.':' | echohl Normal | echon  val
            unlet val
        endfor
    elseif type(a:l) == type([])
        for item in a:l
            echo item
            unlet item
        endfor
    else
        echo a:l
    endif
endfun "}}}
fun! riv#test#buf() "{{{
    
    let o_t = s:time()
    call riv#fold#parse()
    echo "Total time: " (s:time()-o_t)
endfun "}}}
fun! riv#test#todo() "{{{
    call riv#todo#test()
endfun "}}}
fun! riv#test#insert_idt() "{{{
    " breakadd func riv#insert#indent
    echo riv#insert#indent(line('.'))
endfun "}}}
fun! riv#test#reload() "{{{
    let g:riv_force=1 | set ft=rst | let g:riv_force=0
    sil! runtime! autoload/riv/*.vim
    let g:_riv_debug=1
    call riv#init()
    " unlet! g:_riv_debug
    echo "Riv Reloaded."
endfun "}}}
fun! riv#test#show_obj() "{{{
    echo b:riv_flist[line('.')]
    if exists("b:riv_obj")
        echo b:riv_obj[line('.')]
    endif
endfun "}}}
fun! riv#test#fold(...) "{{{
    let line=line('.')
    let o_t = s:time()
    if a:0>0 && a:1==0
        for i in range(1,line('$'))
            let fdl = riv#fold#expr(i)
        endfor
        echo "Total time: " (s:time()-o_t)
        let t = "1"
    else
        echo "row\texpr\tb:fdl\tb:bef_ex\tb:in_exp\tb:in_lst\tb:bef_lst"
        for i in range(1,line('$'))
            let fdl = riv#fold#expr(i)
            if i>= line-10 && i <= line+10
                echo i."\t".fdl
                if exists("b:foldlevel")
                    echon " \t     " b:foldlevel
                else
                    echon " \tN/A      " 
                endif
                if exists("b:fdl_before_exp")
                    echon " \t    " b:fdl_before_exp
                else
                    echon " \tN/A      " 
                endif
                if exists("b:is_in_exp")
                    echon " \t      " b:is_in_exp
                else
                    echon " \tN/A      " 
                endif
                if exists("b:is_in_lst")
                    echon "     \t    " b:is_in_lst
                else
                    echon "     \tN/A       " 
                endif
                if exists("b:fdl_before_listlst")
                    echon "    \t     " b:fdl_before_listlst
                else
                    echon " \tN/A      " 
                endif
                if line == i
                    echon " \t" ">> cur"
                endif
            endif
            if a:0>0 && a:1>1
                echo i ":" (s:time()-o_t)
            endif
        endfor
        echo "Total time: " (s:time()-o_t)
        let t = "2"
    endif

    let log =   [" File:" . expand('%:p') . "  TestFold :".t, 
               \ " Total time: " . string((s:time()-o_t)) 
               \]
    call riv#test#log(log)
endfun "}}}

" Testing "{{{1
if expand('<sfile>:p') == expand('%:p') "{{{
    call doctest#start()
endif "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
