"=============================================
"    Name: test.vim
"    File: test.vim
" Summary: tests 
"  Author: Rykka G.F
"  Update: 2012-10-13
"=============================================
let s:cpo_save = &cpo
set cpo-=C

" DocTest {{{1
fun! s:is_cmd_line(line) "{{{
    return a:line =~ '^\s*"\s>>>\s' 
endfun "}}}
fun! s:is_expc_line(line) "{{{
    return a:line =~ '^\s*"\s*\S'
endfun "}}}
fun! s:is_end_line(line) "{{{
    return a:line =~ '\s*"\s*$' || a:line !~'^\s*"' 
endfun "}}}
fun! s:get_plain_cmd(cmd_line) "{{{
    return "    ". matchstr(a:cmd_line, '^\s*"\s>>>\s\zs.*')
endfun "}}}
fun! s:get_plain_expc(expc_line) "{{{
    return "    ". matchstr(a:expc_line, '^\s*"\s\zs.*')
endfun "}}}

fun! riv#test#doctest(...) "{{{
    " Test with the document.
    " a:1 input file or current buffer, % for current buffer
    " a:2 output file or message , % for messgae
    " a:3 verbose level (0,1,2)
    "
    " exception will only needs it's ErrorNumber if it's vim exception
    " exception will show when verbose level is 2
    "
    "
    "
    " Example " {{{3
    "
    " >>> echo 5+1
    " 6
    "
    " will return:
    " Try:
    "   1+1
    " Expected:
    "   2
    " ok
    "
    " ----------
    "
    " >>> echo 1+1*1.5
    " 2.5
    "
    " will return:
    " Try:
    "   1+1
    " Expected:
    "   3
    " Got: 
    "   2
    " failed
    " 
    " ----------
    "
    " >>> echom UNDEFINED_VARIABLE
    " E121
    "
    " Try:
    "   echo UNDEFINED_VARIABLE
    " ok
    " 
    " ----------
    "
    " >>> echo 1+1=3
    " 0
    "
    " Try:
    "   echo 1+1=3
    " Expected:
    "   0
    " Got:
    "   2
    "   E15
    " Fail!
    "
    " ----------
    "
    " >>> let a = 3
    " >>> let b = 4
    " >>> echo a+b
    " 7
    " 
    " Try:
    " let a = 3
    " let b = 4
    " echo a+b
    " OK!

    " Init "{{{3
    let input_file = a:0 ? a:1 : '%'
    let lines = input_file != '%' ? readfile(a:1) : getline(1,'$')

    let eof = len(lines)
    let [b_bgn, b_end] = [0, 0]
    let test_blocks = []
    let test_results = []
    let test_logs = []
    let in_block = 0
    let in_cmd = 0

    " Get the test block "{{{3
    " [[CMDS1, EXPCTS1],[CMDS2,EXPCTS2],...]
    let e_cmds =  []
    let e_expects = []
    for i in range(eof)
        let line = lines[i]
        if !in_block
            if s:is_cmd_line(line)
                let in_block = 1
                let in_cmd = 1
                call add(e_cmds, line)
            endif
        elseif in_block
            if s:is_cmd_line(line)
                if in_cmd
                    call add(e_cmds, line)
                else
                    " Not in cmd block. 
                    " save and start a new test_block
                    call add(test_blocks, [e_cmds, e_expects])
                    let in_cmd = 1
                    let e_cmds =  [line]
                    let e_expects = []
                endif
            elseif s:is_end_line(line)
                let in_cmd = 0
                let in_block = 0
                call add(test_blocks, [e_cmds, e_expects])
                let e_cmds =  []
                let e_expects = []
            else
                call add(e_expects, line)
                let in_cmd = 0
            endif
        endif
    endfor
    
    " Executing each Test Block and Redir the result "{{{3
    for [cmds, expects] in test_blocks
        let cmds = map(cmds, 's:get_plain_cmd(v:val)')
        let expects = map(expects, 's:get_plain_expc(v:val)')
        
        let result_str = ""
        let exception = ""
        let throwpoint = ""
        redir => result_str
        for cmd in cmds
            try
                sil exec cmd
            catch
                " To handle Exception easier
                let exception =  v:exception
                let e_num = matchstr(exception, '^Vim\%((\a\+)\)\=:\zsE\d\+\ze:')
                if e_num =~ 'E\d\+'
                    " vim ErrorNumber
                    sil echo e_num
                else
                    sil echo exception
                endif
                let throwpoint =  v:throwpoint
            endtry
        endfor
        redir END
        let results = map(split(result_str,'\n'),'"    ".v:val')
        call add(test_results, [cmds, expects, results, [exception, throwpoint]])
    endfor

    " Validate and store to log "{{{3
    for [cmds, expects, results;_] in test_results
        if len(expects) == len(results)
            let status = 1
            for i in range(len(expects))
                if expects[i] == results[i]
                    continue
                else
                    let status = 0
                    break
                endif
            endfor
        else
            let status = 0
        endif
        call add(test_logs, status)
    endfor

    " Show Test Log "{{{3
    let verbose = a:0>2 ? a:3 : 0
    let output = []
    let failed = 0
    let passed = 0
    for i in range(len(test_logs))
        if test_logs[i] == 1
            if verbose == 2
                call add(output, "Try:")
                call extend(output, test_results[i][0])
                call add(output, "Expected:")
                call extend(output, test_results[i][1])
                call add(output, "OK!")
                if test_results[i][3][0] =~ '\S'
                    call add(output, "Exception:")
                    call extend(output, test_results[i][3])
                endif
                call add(output, " ")
            elseif verbose == 1
                call add(output, "Try:")
                call extend(output, test_results[i][0])
                call add(output, "OK!")
                call add(output, " ")
            endif
            let passed += 1
        else
            if verbose == 2
                call add(output, "Try:")
                call extend(output, test_results[i][0])
                call add(output, "Expected:")
                call extend(output, test_results[i][1])
                call add(output, "Got:")
                call extend(output, test_results[i][2])
                call add(output, "Fail!")
                if test_results[i][3][0] =~ '\S'
                    call add(output, "Exception:")
                    call extend(output, test_results[i][3])
                endif
                call add(output, " ")
            elseif verbose == 1
                call add(output, "Try:")
                call extend(output, test_results[i][0])
                call add(output, "Got:")
                call extend(output, test_results[i][2])
                call add(output, "Fail!")
                if test_results[i][3][0] =~ '\S'
                    call add(output, "Exception:")
                    call extend(output, test_results[i][3])
                endif
                call add(output, " ")
            else
                call add(output, "Try:")
                call extend(output, test_results[i][0])
                call add(output, "Fail!")
                call add(output, " ")
            end
            let failed += 1
        endif
    endfor
    call add(output, "Total: ".len(test_logs)." tests.")
    call add(output, "Passed:".passed." tests.")
    call add(output, "Failed:".failed." tests.")
    
    " Output to file or message "{{{3
    if a:0 > 1 && a:2 != "%"
        call riv#publish#auto_mkdir(a:2)
        call writefile(output, a:2)
    else
        for out in output
            if out =~ '^\(Try:\|Expected:\|Got:\|Exception:\|OK!\)$'
                echohl Title
                echo out
                echohl Normal
            elseif out =~ '^Fail!$'
                echohl ErrorMsg
                echo out
                echohl Normal
            else
                echo out
            endif
        endfor
    endif

    return [test_results, test_logs]
    "}}}3

endfun "}}}

" UnitTest {{{1

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
function! riv#test#stub0() "{{{
endfunction "}}}

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
    if exists("b:riv_obj")
        echo b:riv_obj[line('.')]
    endif
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

" Testing "{{{1
if expand('<sfile>:p') == expand('%:p') "{{{
    call riv#test#doctest('%','%',2)
endif "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
