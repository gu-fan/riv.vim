"=============================================
"    Name: test.vim
"    File: test.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-06
" Version: 0.1
"=============================================

function! s:time() "{{{
    if has("reltime")
        return str2float(reltimestr(reltime()))
    else
        return localtime()
    endif
endfunction "}}}
function! riv#test#timer(func,...) "{{{
    if !exists("*".a:func)
        call s:debug("[TIMER]: ".a:func." does not exists. stopped")
        return
    endif
    let num  = a:0 ? a:1 : 1
    let farg = a:0>1 ? a:2 : []

    let o_t = s:time()

    for i in range(num)
        sil! let rtn = call(a:func,farg)
    endfor
    let e_t = s:time()
    let time = printf("%.4f",(e_t-o_t))
    echom "[TIMER]: " . time . " seconds for exec" a:func num "times. "

    return rtn
endfunction "}}}

fun! riv#test#fold(...) "{{{
    let line=line('.')
    let c = 1
    let d = 1
    let o_t = s:time()
    if a:0>0 && a:1==0
        for i in range(1,line('$'))
            let fdl = riv#fold#expr_t(i)
        endfor
        echo "Total time: " (s:time()-o_t)
    else
        echo "row\texpr\tb:fdl\tb:bef_ex\tb:in_exp\tb:in_lst\tb:bef_lst"
        for i in range(1,line('$'))
            let fdl = riv#fold#expr_t(i)
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
                    echon " \t" ">> CursorLine"
                endif
            endif
            if exists("b:signal") && a:0>0 && a:1>0
                if b:signal == 1
                    echo  c "check .. " getline(i)
                    let c = c+1
                elseif b:signal == 2
                    echo  d "check \\s " getline(i+1)
                    let d = d+1
                endif
                echo i ": " (s:time()-o_t)
            endif
            if a:0>0 && a:1>1
                echo i ":" (s:time()-o_t)
            endif
        endfor
        echo "\\s check: " c
        echo ".. check: "  d
        echo "TOTAL check: " (c+d)
        echo "Total time: " (s:time()-o_t)
    endif
endfun "}}}
fun! riv#test#buf()
    
    let o_t = s:time()
    call riv#fold#parse()
    echo "Total time: " (s:time()-o_t)
endfun
fun! riv#test#insert_idt() "{{{
    " breakadd func riv#insert#indent
    echo riv#insert#indent(line('.'))
endfun "}}}
