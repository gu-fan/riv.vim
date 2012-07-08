"=============================================
"    Name: file.vim
"    File: file.vim
" Summary: file operation
"          find /match/delete/
"  Author: Rykka G.Forest
"  Update: 2012-07-07
"=============================================
let s:cpo_save = &cpo
set cpo-=C



fun! riv#file#from_str(str) "{{{
    " parse file name from string
    " return [file , is_dir]
    let file = a:str
    if g:riv_localfile_linktype == 2
        let file = matchstr(file, '^\[\zs.*\ze\]$')
    endif
    if !riv#path#is_relative(file)
        if riv#path#is_directory(file)
            return [expand(file), 1]
        else
            return [expand(file) , 0]
        endif
    elseif riv#path#is_directory(file)
        return [file.'index.rst' , 0]
    else
        let f = matchstr(file, '.*\ze\.rst$')
        if !empty(f)
            return [file, 0]
        elseif  g:riv_localfile_linktype == 2 && fnamemodify(file, ':e') == ''
            return [file.'.rst', 0]
        else
            return [file, 0]
        endif
    endif
endfun "}}}

fun! riv#file#edit(file) "{{{
    let id = s:id()
    exe "edit ".a:file
    let b:riv_p_id = id
endfun "}}}
fun! riv#file#split(file) "{{{
    let id = s:id()
    exe "split ".a:file
    let b:riv_p_id = id
endfun "}}}



" Helper:  "{{{1
fun! riv#file#update() "{{{
    let s:prev = expand('%:p')
endfun "}}}

" Helper Mod: "{{{2
fun! riv#file#enter() "{{{
    let file = matchstr(getline('.'),  '\S\+$')
    call s:file.exit()
    let file = s:path.file
    let win = bufwinnr(s:curr)  
    if win != -1
        exe win. 'wincmd w'
    else
        exe 'wincmd p'
    endif
    call riv#file#edit(file)
endfun "}}}
fun! riv#file#syn_hi() "{{{
    syn match rivFile '\S\+$'
    syn match rivType '^\u\+\s'
    hi link rivFile Function
    hi link rivType Include
endfun "}}}
"}}}
"
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
            let files = split(glob(dir.'**/*.rst'),'\n')
            let index = 'index.rst'
            let index = has_sign ? index : printf("%s %s",'INDX',index)
            let root = riv#path#rel_to(dir,root).'index.rst'
            let root =  has_sign ? root : printf("%s %s",'ROOT',root)
        else
            let files = split(glob(dir.'*.rst'),'\n')
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

    let s:file.maps['<Enter>'] = 'riv#file#enter'
    let s:file.maps['<KEnter>'] = 'riv#file#enter'
    let s:file.maps['<2-leftmouse>'] = 'riv#file#enter'
    let s:file.syntax_func  = "riv#file#syn_hi"
    let s:file.input=""
    cal s:file.win('vI')
endfun "}}}


fun! s:id() "{{{
    return exists("b:riv_p_id") ? b:riv_p_id : g:riv_p_id
endfun "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
