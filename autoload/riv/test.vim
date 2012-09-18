"=============================================
"    Name: test.vim
"    File: test.vim
" Summary: test 
"  Author: Rykka G.F
"  Update: 2012-09-19
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
    let farg = a:0 ? a:1 : []
    let num  = a:0>1 ? a:2 : 1

    let o_t = s:time()

    for i in range(num)
        sil! let rtn = call(a:func,farg)
    endfor
    let e_t = s:time()
    let time = printf("%.4f",(e_t-o_t))
    echom "[TIMER]: " . time . " seconds for exec" a:func num "times. "

    return rtn
endfunction "}}}
let s:tempname = tempname()
fun! riv#test#log(msg) "{{{
    
    let log =  "Time:". strftime("%Y-%m-%d %H:%M")
    " write time to log.
    let file = s:tempname
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
fun! riv#test#view_log() "{{{
    exe 'sp ' s:tempname
endfun "}}}

fun! riv#test#assert(val1, val2) "{{{
    if a:val1 == a:val2
        echo '1'
    else
        echo '0 $' a:val1
        echo '  >' a:val2
    endif
endfun "}}}
fun! riv#test#func_args(func,arg_list) "{{{
    call s:test_func(a:func,a:arg_list)
endfun "}}}
fun! s:test_func(func,arg_list) "{{{
    echo "Func:" a:func 
    for arg in a:arg_list
        echo "Arg:" arg
        if type(arg) == type([])
            echon "\t>" call(a:func, arg)
        else
            echon "\t>" call(a:func, [arg])
        endif
        unlet arg
    endfor
endfun "}}}

function! riv#test#compare(func1,func2,num,...) "{{{
    if a:0==1
        echom riv#test#timer(a:func1,a:1,a:num)
        echom riv#test#timer(a:func2,a:1,a:num)
    elseif a:0==2
        echom riv#test#timer(a:func1,a:1,a:num)
        echom riv#test#timer(a:func2,a:2,a:num)
    else
        echom riv#test#timer(a:func1,[],a:num)
        echom riv#test#timer(a:func2,[],a:num)
    endif
    echom riv#test#timer("riv#test#stub0",[],a:num)
endfunction "}}}
function! riv#test#stub0()
endfunction

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
    if exists("b:riv_obj"g
        echo b:riv_obj[line('.')]
    endif
endfun "}}}
fun! riv#test#repl_link() "{{{
    let SID = riv#publish#SID()
    let func = SID ."repl_file_link"
    let arg_list  = [
                \'rst.vim' ,
                \'index.rst ' ,
                \' test/rst ' ,
                \'index ' ,
                \'/home/index ' ,
                \'index/ ',
                \' index.rst2  ' ,
                \'[index/]  ',
                \'[index.rst2] ',
                \' [index.py] ' ,
                \'[index] ' ,
                \'[/home/index] ' ,
                \]
    let g:_riv_debug=1
    " let g:riv_file_link_style = 1
    call riv#init()
    call s:test_func(func, arg_list)
    " let g:riv_file_link_style = 2
    call riv#init()
    call s:test_func(func, arg_list)
endfun "}}}
fun! riv#test#list_item() "{{{
    let func = "riv#list#level"
    let arg_list  = [
                \ "   #    list -1 " ,
                \ "   *    list 00 " ,
                \ "   +    list 01 " ,
                \ "   -    list 02 " ,
                \ "   1.   list 03 " ,
                \ "   A.   list 04 " ,
                \ "   a.   list 05 " ,
                \ "   II.  list 06 " ,
                \ "   ii.  list 07 " ,
                \ "   1)   list 08 " ,
                \ "   A)   list 09 " ,
                \ "   a)   list 10 " ,
                \ "   II)  list 11 " ,
                \ "   ii)  list 12 " ,
                \ "   (1)  list 13 " ,
                \ "   (A)  list 14 " ,
                \ "   (a)  list 15 " ,
                \ "   (II) list 16 " ,
                \ "   (ii) list 17 " ,
                \["   I)   list 11 " , 0],
                \["   I)   list 09 ", 1],
                \]
    cal s:test_func(func,arg_list)
endfun "}}}
fun! riv#test#list_str() "{{{
    let act = -1
    let prev = 0
    let idt = '     '
    echo riv#list#act_line("   # 233     ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   * 233     ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   + 233     ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   - 233     ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   1. 233    ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   1) 233    ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (1) 233   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   A. 233    ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   A) 233    ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (A) 233   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   a. 233    ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   a) 233    ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (a) 233   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   II. 233   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   II) 233   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (II) 233  ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   ii. 233   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   ii) 233   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (ii) 233  ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (I) 233   ,act ,idt ,prev ).'|'
    echo riv#list#act_line("   (I) 233   ,act ,idt ,prev ).'|'
endfun "}}}

fun! riv#test#link_expand() "{{{
    let func = riv#create#SID()."expand_to_link"
    let func = riv#create#SID()."expand_link"
    let arg_list  = [
                \ "aaaa", "aaaa.rst", "aaaa.py", "[aaaa.rst]", "[aaaa]",
                \ "[aaaa.py]", "[/efe/aaaa.py]", "aaaa/aaa/aa.rst",
                \ "/aaaa/aaa/aa.rst", "~/aaaa/aaa/aa.rst", "../aaaa/aaa/aa.rst",
                \]
    " let g:riv_file_link_style = 1
    call riv#init()
    call s:test_func(func, arg_list)
    " let g:riv_file_link_style = 2
    call riv#init()
    call s:test_func(func, arg_list)
endfun "}}}
fun! s:test_list_parse() "{{{
    let func1 = riv#fold#SID()."parse_list"
    let func = riv#fold#SID()."dic2line"
    echo call(func1,[])
    let lines = call(func,['root'])
    for line in lines
        echo line
    endfor
endfun "}}}
fun! s:test_path() "{{{
    let func = "riv#path#rel_to"
    let arg_list  = [
                \['/a/c','/a/c/b'],
                \["/a/c","/a/c/b"],
                \['\a\c','\a\c\f'],
                \["\a\c","\a\c\f"],
                \]
    call s:test_func(func, arg_list)
    
endfun "}}}
fun! riv#test#test() "{{{

endfun "}}}
fun! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun "}}}
fun! riv#test#SID() "{{{
    return '<SNR>'.s:SID().'_'
endfun "}}}

function! riv#test#stub1() "{{{
endfunction "}}}
function! riv#test#stub2() "{{{
endfunction "}}}
" Testing 
if expand('<sfile>:p') == expand('%:p') "{{{

    let func1 = "riv#test#stub1"
    let func2 = "riv#test#stub2"
    call riv#test#compare(func1,func2,1000)
endif "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
