"=============================================
"    Name: test.vim
"    File: test.vim
" Summary: 
"  Author: Rykka G.Forest
"  Update: 2012-06-11
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

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
fun! riv#test#log(msg) "{{{
    
    let log =  "Time:". strftime("%Y-%m-%d %H:%M")
    " write time to log.
    let file = expand("~/Desktop/test.log")
    if filereadable(file)
        let lines = readfile(file)
    else
        let lines = []
    endif
    call add(lines, log)
    if type(a:msg) == type([])
        call extend(lines, a:msg)
    else
        call add(lines, a:msg)
    endif
    call writefile(lines, file)
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
fun! riv#test#buf() "{{{
    
    let o_t = s:time()
    call riv#fold#parse()
    echo "Total time: " (s:time()-o_t)
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
    echo b:fdl_list[line('.')]
    if exists("b:obj_dict")
        echo b:obj_dict[line('.')]
    endif
endfun "}}}
fun! riv#test#link() "{{{
    echo riv#publish#repl_file_link("1122334 ewe.rst 3243.*.rst 234/2.2342.rst   ")
    echo riv#publish#repl_file_link("1122334 index.rst ")
    echo riv#publish#repl_file_link("1122334  fejfoj/ ")
    echo riv#publish#repl_file_link("1122334  _fejfoj/ c:ewfwe.wef.rst ")
    echo riv#publish#repl_file_link("1122334  [_fejfoj/] ")
    echo riv#publish#repl_file_link(" wjaoifjw index.rst index.py ")
    echo riv#publish#repl_file_link(" wjaoifjw  ../  / /home/etc/rr.rst ")
    echo riv#publish#repl_file_link(" wjaoifjw  ~/ee.rst  ./ /home/etc/rr.rst ")
    
endfun "}}}
fun! riv#test#link2()
    
endfun
fun! riv#test#list_item() "{{{
    echo riv#list#level("   # 233" )     '-1'
    echo riv#list#level("   * 233" )     
    echo riv#list#level("   + 233" )     
    echo riv#list#level("   - 233" )     
    echo riv#list#level("   1. 233" )    
    echo riv#list#level("   1) 233" )
    echo riv#list#level("   (1) 233" )
    echo riv#list#level("   A. 233" )    
    echo riv#list#level("   A) 233" )
    echo riv#list#level("   (A) 233" )
    echo riv#list#level("   a. 233" )    
    echo riv#list#level("   a) 233" )
    echo riv#list#level("   (a) 233" )
    echo riv#list#level("   II. 233" )    
    echo riv#list#level("   II) 233" )
    echo riv#list#level("   (II) 233" )
    echo riv#list#level("   ii. 233" )    
    echo riv#list#level("   ii) 233" )
    echo riv#list#level("   (ii) 233" )
    echo riv#list#level("   (I) 233" , 0)   14
    echo riv#list#level("   (I) 233" , 1)   8
endfun "}}}
fun! riv#test#list_str() "{{{
    let act = -1
    let prev = 0
    let idt = '     '
    echo riv#list#act_line("   # 233"     ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   * 233"     ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   + 233"     ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   - 233"     ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   1. 233"    ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   1) 233"    ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (1) 233"   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   A. 233"    ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   A) 233"    ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (A) 233"   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   a. 233"    ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   a) 233"    ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (a) 233"   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   II. 233"   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   II) 233"   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (II) 233"  ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   ii. 233"   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   ii) 233"   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (ii) 233"  ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (I) 233"   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (I) 233"   ,act ,idt ,prev ).'|'
endfun "}}}
fun! riv#test#list_buf()
    call riv#publish#2html()
endfun

" Test
" call riv#test#list_str()
" call riv#test#link()
call riv#test#list_buf()
map <leader>tt :call riv#test#list_buf()


let &cpo = s:cpo_save
unlet s:cpo_save
