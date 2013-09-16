"=============================================
"    Name: publish.vim
"    File: publish.vim
" Summary: publish to html/pdf...
"  Author: Rykka G.F
"  Update: 2013-04-23
"=============================================
let s:cpo_save = &cpo
set cpo-=C

if has('win32') || has('win64')
    let s:os = 'win'
else
    let s:os = 'unix'
endif
fun! s:escape_file_ptn(file) "{{{
    return  '\v%(^|\s|[''"([{<,;!?])\zs\[\[' . a:file . '\]\]\ze%($|\s|[''")\]}>:.,;!?])'
endfun "}}}
fun! s:escape(txt) "{{{
    return escape(a:txt, '~.*\[]^$')
endfun "}}}
fun! s:gen_embed_link(title, path) "{{{
    if riv#path#file_link_style() == 2
        return  '`['.a:title.'] <'.a:path.'>`_'
    else
        return  '`'.a:title.' <'.a:path.'>`_'
    endif
endfun "}}}

fun! riv#publish#path(str) "{{{
    " return the html path converted from string.
    " [[xxx]] => _build/xxx.html
    " [[xxx.vim]] => _build/xxx.vim
    " [[xxx/]] => _build/xxx/index.html
    " [[/xxx]]  => _build/DOC_ROOT/xxx.html
    " [[/xxx/]]  => _build/DOC_ROOT/xxx/index.html
    " [[~/xxx]] => ~/xxx

    let f = matchstr(a:str, '^\[\[\zs.*\ze\]\]$')
    " absolute path are files. no html link
    let t = f =~ '^([~]|[a-zA-Z]:)' ? 'file' : 'doc'

    if riv#path#is_relative(f)
        let file = f
    else
        " if it have '/' at start. 
        " it is the doc root for sphinx and moinmoin 
        if f =~ '^/'
            let file = riv#path#build_ft('html') . f[1:]
        else
            let file = expand(f)
            return file
        endif
    endif
    if riv#path#is_directory(file) && t == 'doc'
        let file = file . 'index.html'
    elseif fnamemodify(file, ':e') == '' && t == 'doc'
        let file = file . '.html'
    elseif fnamemodify(file, ':e') == riv#path#p_ext() && t == 'doc'
        let file = fnamemodify(file, ':r') . '.html'
    endif
    
    return file
endfun "}}}

fun! s:repl_file_link(line) "{{{
    " File              Title   Path
    " [[index]]       => `index <index.html>`_
    " [[index.rst]]   => `index <index.html>`_
    " [[index.vim]]   => `index.vim <index.vim>`_
    " [[index/]]      => `index/ <index/index.html>`_
    " [[/xxx/a.rst]]  => `/xxx/a.rst  <DOC_ROOT/xxx/a.rst>`_
    
    let line = a:line
    
    " we will get the idx and find the pattern from origin line.
    let o_line = line
    let pre_idx = 0           " for the inline markup column check
    let idx = matchend(o_line, riv#ptn#link_file())
    let str = matchstr(o_line, riv#ptn#link_file())
    while idx != -1
        let obj = riv#ptn#get_inline_markup_obj(o_line, idx+1, pre_idx)
        " it's not in a inline markup
        if empty(obj)
            " substitute process
            let title = s:escape(matchstr(str, '^\[\[\zs.*\ze\]\]$'))
            let path = riv#publish#path(str)
            let line = substitute(line, s:escape_file_ptn(title), 
                            \s:gen_embed_link(title, path), 'g')
        endif
        let idx = matchend(o_line, riv#ptn#link_file(),idx)
        let str = matchstr(o_line, riv#ptn#link_file(),idx)
        let pre_idx = idx
    endwhile
    return line
endfun "}}}

let s:tempfile = tempname()
let s:tempdir = riv#path#directory(fnamemodify(s:tempfile,':h'))
fun! s:create_tmp(file) "{{{
    update
    let lines = map(readfile(a:file),'s:repl_file_link(v:val)')
    call writefile(lines, s:tempfile)       " not all OS can pipe
    return s:tempfile
endfun "}}}

let s:css_default = g:_riv_c.riv_path.'html/default.css'
let s:css_emacs = g:_riv_c.riv_path.'html/emacs.css'
let s:css_friendly = g:_riv_c.riv_path.'html/friendly.css'
let s:css_html = g:_riv_c.riv_path.'html/html4css1.css'
let s:tex_default = g:_riv_c.riv_path.'latex/default.tex'
let s:tex_cjk = g:_riv_c.riv_path.'latex/cjk.tex'

fun! s:convert(options) "{{{
    " options {
    "   filetype: 'html',
    "   input: 'tmp/xxx.rst',
    "   output: 'html/xxx.html',
    "   real_file: 'rst/xxx.rst' or input,
    " }
    
    let ft =   get(a:options, 'filetype', 'html')
    let o_ft = ''
    let input = get(a:options, 'input', '')
    let output = get(a:options, 'output', '')
    let real_file = get(a:options, 'real_file', input)
    let style = ''
    let args = s:rst_args(ft) 
    
    " For PDF file , we should try rst2latex and rst2xetex.
    if ft=='pdf'
        let ft='latex'
        let out_path = fnamemodify(output, ':p:h')
        let file =  fnamemodify(output, ':p:t:r').'.xetex'
        let o_file = output
        let output = out_path.'/'.file
        let o_ft = 'pdf'
    endif


    let exe = 'rst2'.ft.'2.py'
    if !executable(exe)
        let exe = 'rst2'.ft.'.py'
        if !executable(exe)
            " try whitout .py extension. Compatibility with some
            " python-docutils packages (Ubuntu 12.04 at least)
            let exe = 'rst2'.ft.''
            if !executable(exe)
                call riv#error('Could not find '.exe)
                return -1
            endif
        endif
    endif
    

    " try 2 first , for py3 version should decode to 'bytes'.
    if ft == 'html' 
        if g:riv_html_code_hl_style =~ '^\(default\|emacs\|friendly\)$'
            let style = ' --stylesheet='.s:css_html.','
                        \.s:css_{g:riv_html_code_hl_style}
        elseif filereadable(g:riv_html_code_hl_style)
            let style = ' --stylesheet='.g:riv_html_code_hl_style
        endif

        " Copy the images for figure and image directives.
        call s:copy_img(real_file, output)
    elseif ft == 'latex'
        " let style = ' --stylesheet='.s:tex_cjk
        call s:copy_img(input, output)
    endif
    call s:sys( exe." ". style ." ". args ." "
                \.shellescape(input) 
                \." > ".shellescape(output) )
    if o_ft=='pdf'
        " See :Man pdflatex for option details
        if executable('pdflatex')
            call s:sys( 'pdflatex -interaction batchmode -output-directory '.out_path.' '.shellescape(output) )
            " call s:sys( 'xelatex '.shellescape(output) )
        else
            call riv#error('Could not find pdflatex. Please Install texlive package.')
            return -1
        endif
    endif
endfun "}}}

fun! s:copy_img(input, output) "{{{
    if !exists("*mkdir")
        call riv#error('No mkdir().')
        return
    endif
    let out_path = fnamemodify(a:output, ':p:h')
    let old_path = fnamemodify(a:input, ':p:h')
    let file = readfile(a:input)
    for line in file
        if line =~ '^.. \(figure\|image\)::'
            let img = matchstr(line, '^.. \(figure\|image\):: \s*\zs.*\ze\s*$')
            if riv#path#is_relative(img)
                let old_file = riv#path#join(old_path, img) 
                let new_file = riv#path#join(out_path, img) 
                let new_path = fnamemodify(new_file, ":p:h")
                if !isdirectory(new_path)
                    call mkdir(new_path, 'p')
                endif
                if s:os == 'win'
                    " /c : Ignores errors.
                    " /q : Suppresses messages.
                    " /i : Creates new directory.
                    " /e : Copies all subdirectories.
                    " /y : Suppresses prompting to confirm.
                    let cmd = 'xcopy /E /Y /C /I '
                                \.shellescape(old_file).' '
                                \.new_file
                else
                    let cmd = 'cp -rf '.old_file.' '.new_file
                endif
                call s:sys(cmd) 
            endif
        endif
    endfor
endfun "}}}
fun! s:single2(ft, file, browse) "{{{
    " A file that is not in a project
    let file = expand(a:file)

    " put it in same dir if temp_path is 0 or '',
    " if it's 1 put in tempdir
    " else if it's a dir, put it in that dir.
    if empty(g:riv_temp_path)
        let out_file = riv#path#ext_to(file, a:ft)
    elseif g:riv_temp_path == 1
        let temp_path = s:tempdir
        let out_file = temp_path . riv#path#ext_tail(file, a:ft)
    else
        let temp_path = riv#path#directory(g:riv_temp_path)  
        let out_file = temp_path . riv#path#ext_tail(file, a:ft)
    endif

    call s:convert({'filetype':a:ft,
                   \'input': file,
                   \'output': out_file,
                   \})

    if a:browse
        if a:ft == "latex"
            exe 'sp ' out_file
        elseif a:ft == "odt"
            call s:sys(g:riv_ft_browser . ' '. shellescape(out_file) . ' &')
        else
            call s:sys(g:riv_web_browser . ' '. shellescape(out_file) . ' &')
        endif
    endif
endfun "}}}
" ['s5', 'latex', 'odt', 'xml' , 'pseudoxml', 'html' ]
fun! riv#publish#file2(ft, browse) "{{{
    let file = expand('%:p')
    echohl Function
    echo "Convert:"
    echohl Normal
    echon file
    if riv#path#is_rel_to_root(file)
        call riv#publish#2(a:ft , file, riv#path#build_ft(a:ft), a:browse)
    else
        call s:single2(a:ft, file, a:browse)
    endif
endfun "}}}
fun! riv#publish#2(ft, file, path, browse) "{{{
    let file = expand(a:file)
    let out_path = a:path . riv#path#rel_to_root(file)
    let file_path = riv#path#ext_to(out_path, a:ft)
    call riv#publish#auto_mkdir(out_path)
    if riv#path#file_link_style() == 1

        call s:convert({'filetype': a:ft,
                    \'input': s:create_tmp(file),
                    \'real_file': file,
                    \'output': file_path,
                    \})

    else
        call s:convert({'filetype': a:ft,
                    \'input': file,
                    \'output': file_path,
                    \})

    endif
    if a:browse
        if a:ft == "latex"
            exe 'sp ' file_path
        elseif a:ft == "odt"
            call s:sys(g:riv_ft_browser . ' '. file_path . ' &')
        else
            let escaped_path = substitute(file_path, ' ', '\\ ', 'g')
            call s:sys(g:riv_web_browser . ' '. escaped_path . ' &')
        endif
    endif
endfun "}}}

fun! riv#publish#browse() "{{{
    let path = riv#path#build_ft('html') .  'index.html'
    call s:sys(g:riv_web_browser . ' '. shellescape(path) . ' &')
endfun "}}}
fun! riv#publish#open_path() "{{{
    exe 'sp ' riv#path#build_path()
endfun "}}}

fun! riv#publish#copy2proj(file,html_path) abort "{{{
    let out_path = a:html_path . riv#path#rel_to_root(expand(a:file))
    call riv#publish#auto_mkdir(out_path)
    call s:sys( 'cp -f '. a:file. ' '.  fnamemodify(out_path, ':h'))
endfun "}}}
fun! s:get_proj_file_lists() "{{{
    return filter(split(glob(riv#path#root().'**/*'.riv#path#ext()),'\n'), 'v:val !~ '''.riv#path#p_build().'''')
endfun "}}}
fun! riv#publish#proj2(ft) abort "{{{
    let ft_path = riv#path#build_ft(a:ft)
    let files = s:get_proj_file_lists()
    for i in range(len(files))
        call riv#publish#2(a:ft,files[i], ft_path, 0)
        redraw
        echohl Function
        echo i.'/'.len(files) 
        echohl Normal
        echon files[i]
    endfor
    let copy_ext = '{'.join(g:_riv_t.file_ext_lst,',').'}'
    if a:ft == "html" 
        \ && input("Copy all file of extension: ".copy_ext."\n(Y/n):")!~?'n'
        let files = filter(split(glob(riv#path#root().'**/*'.copy_ext)), 'v:val !~ '''.riv#path#p_build().'''')
        for file in files
            call riv#publish#copy2proj(file, ft_path)
        endfor
    endif
endfun "}}}

fun! s:rst_args(ft) "{{{
    return exists("g:riv_rst2".a:ft."_args") ? 
                \ !empty(g:riv_rst2{a:ft}_args)
                \ ? g:riv_rst2{a:ft}_args : '' : ''
endfun "}}}
fun! riv#publish#auto_mkdir(path) "{{{
    if !isdirectory(fnamemodify(a:path,':h')) 
        call mkdir(fnamemodify(a:path,':h'),'p')
    endif
endfun "}}}

fun! s:sys(arg) abort "{{{
    " XXX: error in windows tmp files
    return system(a:arg)
endfun "}}}
if expand('<sfile>:p') == expand('%:p') "{{{
    call riv#test#doctest('%','%',2)
endif "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
