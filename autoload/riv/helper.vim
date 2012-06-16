"=============================================
"    Name: helper.vim
"    File: helper.vim
" Summary: helper to access file and lines
"  Author: Rykka G.Forest
"  Update: 2012-06-17
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C

if !exists("g:mathematic_user_dir")
    let g:mathematic_user_dir = ""
endif
if !exists("g:mathematic_fuzzy_match")
    let g:mathematic_fuzzy_match = 0
endif
fun! s:load_keymap() "{{{
    let files = [
                \"~/.vim/keymap/mathematic.vim",
                \"~/.vim/localbundle/keymap/mathematic.vim",
                \"~/.vim/bundle/mathematic.vim/keymap/mathematic.vim",
                \g:mathematic_user_dir,
                \]
    for file in files
        if filereadable(expand(file))
            let f = expand(file)
            break
        endif
    endfor
    if empty(f)
        return []
    endif
    return filter(readfile(f),'v:val=~''<char-0x''')
endfun "}}}
let s:key_cache = s:load_keymap()

let s:map = [['<Enter>' , 'Enter'     ] ,['q' , 'Exit'     ] ,]
fun! s:Enter()  "{{{
    let row = line('.')
    call s:helper.exit()
    if !empty(s:n_list)
        let [file, lnum] = g:_riv_td_path[0][s:n_list[row-1]]
        exe 'sp ' file
        call cursor(lnum+1, 1)
    endif
endfun "}}}
fun! s:Exit()  "{{{
    call s:helper.exit()
    wincmd p
endfun "}}}
let s:helper = { 'name' : '_TodoHelper_', 'title': 'Riv Todo',}
fun! s:helper.win(...) dict "{{{
    if !s:get_buf(self.name)
        exec 'noa keepa bot 5new  +setl\ nobl '.self.name
    endif
    let self.map_dic = a:0 ? a:1 : s:map
    let self.content_dic =  exists("self.content_dic") ? self.content_dic : s:key_cache
    call self.map()
    call self.set()
    let s:input = ""
    call self.render()

    let self.running = 1
    while self.running
        call s:helper.action()
    endwhile
endfun "}}}
fun! s:helper.action() "{{{
    let n = getchar()
    let c = nr2char(n)
    if c =~ '\w\|[ \\''`_]'
        let s:input .= c
    elseif n=="\<BS>"
        let s:input = s:input[:-2]
    elseif c=="\<C-W>"
        let s:input = join(split(s:input)[:-2])
    elseif c=="\<C-U>"
        let s:input = ""
    else
        let self.running = 0
    endif
    call self.render()
endfun "}}}
fun! s:helper.map() dict "{{{
    abcl <buffer>
    mapc <buffer>
    let cmd = 'nn <buffer><silent> %s :cal <SID>%s()<CR>'
    for [lhs,rhs] in self.map_dic
        exe printf(cmd,lhs,rhs)
    endfor
    " let cmd = 'nn <buffer><silent> %s :cal <SID>input("%s")'
endfun "}}}
fun! s:helper.set() "{{{
	setl noswf nonu nowrap nolist nospell nocuc wfh
	setl fdc=0 fdl=99 tw=0 bt=nofile bh=unload
	setl noma
	setl syn=rst
	if v:version > 702
		setl nornu noudf cc=0
	en
endfun "}}}
fun! s:helper.exit() dict "{{{
	cal s:get_buf(s:helper.name)
	try 
	    noa bun!
    catch 
	    noa close! 
    endtry
endfun "}}}
fun! s:helper.render() dict "{{{
    cal s:helper.content()
    cal s:helper.stats()
    cal s:helper.prompt()
endfun "}}}
fun! s:helper.stats() dict "{{{
    let &l:statusline="%3*KeyHelper%* Matching Numbers : %1*". len(s:cur_keys)."%*"
endfun "}}}
fun! s:helper.prompt() dict "{{{
    redraw
    echohl Keyword 
    if g:mathematic_fuzzy_match == 1
        echo "f:" 
    else
        echo "t:" 
    endif
    echohl Normal | echon s:input
endfun "}}}
fun! s:helper.content() dict "{{{
    if g:mathematic_fuzzy_match == 1
        let fuzzyinput = join(split(s:input,'.\zs'),'.*')
    else
        let fuzzyinput = s:input
    endif
    let fuzzyinput = escape(fuzzyinput,'\')
    let s:n_list = range(len(self.content_dic))
    call filter(s:n_list,'self.content_dic[v:val]=~?fuzzyinput')
    let s:cur_keys = map(copy(s:n_list), 'self.content_dic[v:val]')
    let len = len(s:cur_keys)
    if len==0
        resize 1
    elseif len <=4
        exe "resize " len
    elseif winheight(0)<=5
        resize 5
    endif
    setl ma
    1,$d_
    if len==0
        call setline(1,"=== No Match ===")
    else
        call setline(1,s:cur_keys)
    endif
    setl noma
endfun "}}}

fun! s:get_buf(name) "{{{
    """ if buffer exists , go to buffer and return 1
    """ else return 0
    let n = bufwinnr(bufnr(a:name))
    if  n != -1
        exe  n . "wincmd w"
        return n
    else
        return 0
    endif
endfun "}}}

fun! riv#helper#new()
    return s:helper
endfun
let &cpo = s:cpo_save
unlet s:cpo_save
