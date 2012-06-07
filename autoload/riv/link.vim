
fun! riv#link#finder(dir) "{{{
    let cr = line('.')
    let cc = col('.')
    let smallest_r = 1000
    let smallest_c = 1000
    let best = [0,0]
    let flag = a:dir=="b" ? 'Wnb' : 'Wn'
    for ptn in g:_RIV_c.ptn.link_grp
        let [sr,sc] = searchpos(ptn,flag)
        if sr != 0
            let dis_r = abs(sr-cr)
            if smallest_r > dis_r
                let smallest_r = dis_r
                let best = [sr,sc] 
            elseif smallest_r == dis_r
                let dis_c = abs(sc-cc)
                if smallest_c > dis_c
                    let smallest_c = dis_c
                    let best = [sr,sc] 
                endif
            endif
        endif
    endfor
    if best[0] != 0
        call setpos("'`",getpos('.'))
        call setpos('.',[0,best[0],best[1],0])
    endif
endfun "}}}
