"=============================================
"    Name: file.vim
"    File: file.vim
" Summary: file operation
"          find /match/delete/
"  Author: Rykka G.F
"  Update: 2012-10-04
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:p = g:_riv_p

fun! riv#file#edit(file) "{{{
    " edit file with it's full absolute path.
    let file = a:file
    if riv#path#is_relative(file)
        let file = riv#path#join(expand('%:p:h'), file)
    endif
    exe "edit ".file
endfun "}}}
fun! riv#file#split(file) "{{{
    let file = a:file
    if riv#path#is_relative(file)
        let file = riv#path#join(expand('%:p:h'), file)
    endif
    exe "split " file
endfun "}}}

" Helper:  "{{{1
fun! riv#file#update() "{{{
    let s:prev = expand('%:p')
endfun "}}}

fun! riv#file#enter() "{{{
    let file = matchstr(getline('.'),  '\S\+$')
    let file = s:path.file
    if s:file.exit()
        call riv#file#edit(file)
    else
        call riv#file#split(file)
    endif
endfun "}}}
fun! riv#file#syn_hi() "{{{
    syn clear
    syn match rivFile '\S\+$'
    syn match rivType '^\u\+\s'
    hi link rivFile Function
    hi link rivType Include
endfun "}}}

if has("signs") "{{{
    sign define riv_root text=RT texthl=Question
    sign define riv_indx text=IN texthl=Question
    sign define riv_prev text=PR texthl=Question
    sign define riv_curr text=CR texthl=Question
endif "}}}

let s:prev = exists("s:prev") ? s:prev : ''
let s:curr = exists("s:curr") ? s:curr : ''
let s:path = exists("s:path") ? s:path : ''
fun! s:load_file() "{{{

    let file = expand('%:p')
    let s:curr=file
    let root = riv#path#root()
    let s:path = riv#path#directory(expand('%:p:h'))
    let dir = riv#path#directory(fnamemodify(file, ':h'))
    let has_sign =  has("signs") ? 1 : 0
    let signs = []
    try 
        if riv#path#is_rel_to(root, file )
            let files = split(glob(dir.'**/*'.riv#path#ext()),'\n')
            let index = riv#path#idx_file() 
            let index = has_sign ? index : printf("%s %s",'INDX',index)
            let root = riv#path#rel_to(dir,root)
                        \.riv#path#idx_file()
            let root =  has_sign ? root : printf("%s %s",'ROOT',root)
        else
            let files = split(glob(dir.'*'.riv#path#ext()),'\n')
        endif
        let cur = riv#path#rel_to(dir, file)
        let current = has_sign ? cur : printf("%s %s", 'CURR',cur)
        if has_sign
            let files =  map(files,'riv#path#rel_to(dir,v:val)')
            let files =  filter(files,'v:val!= cur')
        else
            let files =  map(files,'"     ".riv#path#rel_to(dir,v:val)')
            let files =  filter(files,'v:val!= "    ".cur')
        endif
        call insert(files,current)
        call insert(signs,'riv_curr')
        if !empty(s:prev)
            let prev = riv#path#rel_to(dir, s:prev)
            let prev = has_sign ? prev : printf("%s %s", 'PREV',prev)
            call insert(files,prev)
            call insert(signs,'riv_prev')
        endif
    catch 
        if v:exception == g:_riv_e.NOT_REL_PATH
        endif
    endtry
    if exists("index")
        call insert(files,index)
        call insert(signs,'riv_indx')
        call insert(files,root)
        call insert(signs,'riv_root')
    endif
    return [files,signs]
endfun "}}}
fun! riv#file#helper() "{{{
    if empty(&ft)
        call riv#warning(g:_riv_e.NOT_RST_FILE)
        return
    endif
    let [files,signs] = s:load_file()
    let s:file = riv#helper#new()
    let s:file.content_title = "Files"
    let s:file.contents = [files]
    let s:file.contents_name = ['files']

    let s:file.signs = signs

    let s:file.maps['<Enter>'] = ':cal riv#file#enter()<CR>'
    let s:file.maps['<KEnter>'] = ':cal riv#file#enter()<CR>'
    let s:file.maps['<2-leftmouse>'] = ':cal riv#file#enter()<CR>'
    let s:file.syntax_func  = 'riv#file#syn_hi'
    let s:file.input=""
    cal s:file.win('vI')
endfun "}}}

fun! s:find_sect(ptn) "{{{
    if exists("b:riv_state.sectmatcher")
        for sect in b:riv_state.sectmatcher
            let line = getline(sect.bgn) 
            if line =~ g:_riv_p.section
                let line = getline(sect.bgn+1)
            endif
            if line =~ a:ptn
                return sect.bgn
            endif
        endfor
    endif
endfun "}}}
fun! riv#file#s_enter() "{{{
    if foldclosed('.') != -1
        normal! zv
        return
    endif
    let sect = matchstr(getline('.'),  ':\s*\zs.*$')
    if s:sect.exit()
        let text = substitute(riv#ptn#escape(sect),'\s\+','\\s+','g')
        let ptn = '^\v\c\s*'.text.'\s*$'
        let row = s:find_sect(ptn)
        if row > 0
            call setpos("'`",getpos('.'))
            call cursor(row,0)
            normal! zvzt
        endif
    else
        call riv#warning(g:_riv_e.FILE_NOT_FOUND)
    endif
endfun "}}}
fun! riv#file#s_syn_hi() "{{{
    syn clear
    let punc = g:riv_fold_section_mark
    exe 'syn match rivNumber `^[0-9'.punc.']\+:`'
    syn match rivSection ':\@<=.*$'
    hi link rivSection Include
    hi link rivNumber Function
    
    setl foldmethod=expr fdl=0 foldexpr=riv#file#s_fold(v:lnum)
    setl foldtext=getline(v:foldstart)
endfun "}}}
function! riv#file#s_fold(row) "{{{
    let sect_txt = matchstr(getline(a:row),  '^\S*\ze:')
    let level = len(split(sect_txt, g:riv_fold_section_mark))
    return '>'.level
endfunction "}}}

fun! s:load_sect() "{{{
    if !exists("b:riv_state")
        return []
    endif
    let lines = []
    let s:curr=expand('%:p')
    for sect in b:riv_state.sectmatcher
        let line =  getline(sect.bgn) 
        if line =~ g:_riv_p.section
            let line = getline(sect.bgn+1)
        endif
        let line = printf("%-10s %s",sect.txt.':', line)
        call add(lines, line)
    endfor
    return lines
endfun "}}}

fun! riv#file#section_helper() "{{{
    if &ft!='rst'
        call riv#warning(g:_riv_e.NOT_RST_FILE)
        return
    endif

    let sects = s:load_sect()
    let s:sect = riv#helper#new()
    let s:sect.content_title = "Section"
    let s:sect.contents = [sects]
    let s:sect.contents_name = ['Section']
    let s:sect.signs = []

    let s:sect.maps['<Enter>'] = ':cal riv#file#s_enter()<CR>'
    let s:sect.maps['<KEnter>'] = ':cal riv#file#s_enter()<CR>'
    let s:sect.maps['<2-leftmouse>'] = ':cal riv#file#s_enter()<CR>'
    let s:sect.syntax_func  = "riv#file#s_syn_hi"
    let s:sect.input=""
    cal s:sect.win('vI')
    
endfun "}}}

if expand('<sfile>:p') == expand('%:p') "{{{
    call doctest#start()
endif "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
