"=============================================
"    Name: test.vim
"    File: test.vim
"  Author: Rykka G.Forest
"  Update: 2012-06-06
" Version: 0.1
"=============================================

fun! restin#test#fold(...) "{{{
    let line=line('.')
    let c = 1
    let d = 1
    echo "row\texpr\tb:p_ln\tb:p_ex"
    for i in range(1,line('$'))
        let fdl = RstFoldExpr(i)
        if i>= line-10 && i <= line+10
            echo i."\t".fdl
            if exists("b:foldlevel")
                echon " \t" b:foldlevel
            else
                echon " \tN/A"
            endif
            if exists("b:fdl_before_exp")
                echon " \t" b:fdl_before_exp
            else
                echon " \tN/A" 
            endif
            if line == i
                echon " \t" ">> CursorLine"
            endif
        endif
        if exists("b:singal") && a:0>0 && a:1>0
            if b:singal == 1
                echo  c "check .. " getline(i)
                let c = c+1
            elseif b:singal == 2
                echo  d "check \\s " getline(i+1)
                let d = d+1
            endif
        endif
    endfor
    echo "\\s check: " c
    echo ".. check: "  d
    echo "TOTAL check: " (c+d)
endfun "}}}
