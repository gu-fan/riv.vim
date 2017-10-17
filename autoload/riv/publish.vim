"=============================================
"    Name: publish.vim
"    File: publish.vim
" Summary: publish to html/pdf...
"  Author: Rykka G.F
"  Update: 2014-08-15
"=============================================
let s:cpo_save = &cpo
set cpo-=C


let s:sys = function("riv#system")
let s:is_windows = g:_riv_c.is_windows
let s:p = g:_riv_p

fun! s:init() "{{{
    let s:c = g:_riv_c
    let s:temp_file = tempname()
    let s:tempdir = riv#path#directory(fnamemodify(s:temp_file,':h'))
    let s:css_html = g:_riv_c.riv_path.'html/rhythm.css'
    let s:tex_default = g:_riv_c.riv_path.'latex/default.tex'
    let s:tex_cjk = g:_riv_c.riv_path.'latex/cjk.tex'
    let s:css_theme_dir = join([g:_riv_c.riv_path.'html/themes/',
                \g:riv_css_theme_dir], ',')

    let theme_paths = split(globpath(s:css_theme_dir, '*.css'),'\n')
    let s:themes = []
    for theme_path in theme_paths
        let theme = matchstr(theme_path, '\w*\ze\.css')
        let s:css_{theme} = theme_path
        call add(s:themes, theme)
    endfor
    let g:_riv_c.themes = s:themes
endfun "}}}

fun! riv#publish#path(str) "{{{
    " return the html path converted from string.
    " [[xxx]] => _build/xxx.html
    " [[xxx.vim]] => _build/xxx.vim
    " [[xxx/]] => _build/xxx/index.html
    " [[/xxx]]  => _build/DOC_ROOT/xxx.html
    " [[/xxx/]]  => _build/DOC_ROOT/xxx/index.html
    " [[~/xxx]] => ~/xxx
    "
    " :doc:`xxx` => _build/xxx.html
    " :doc:`xxx.vim` => _buld/xxx.vim
    " :doc:`/xxx` => _build/DOC_ROOT/xxx.html
    "
   
    let [f, t] = riv#ptn#get_file(a:str)

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

    return [file, f]
endfun "}}}
fun! s:escape_file_ptn(file) "{{{
    return  '\v%(^|\s|[''"([{<,;!?])\zs\[\[' . a:file . '\]\]\ze%($|\s|[''")\]}>:.,;!?])|'
            \ .'%(^|\s|[''"([{<,;!?])\zs:doc:`' . a:file . '`\ze%($|\s|[''")\]}>:.,;!?])'
endfun "}}}
fun! s:escape(txt) "{{{
    return escape(a:txt, '~.*\[]^$')
endfun "}}}
fun! s:gen_embed_link(title, path) "{{{
    return  '`'.a:title.' <'.a:path.'>`_'
endfun "}}}


fun! s:repl_file_link(line) "{{{
    " File              Title   Path
    " [[index]]       => `index <index.html>`_
    " [[index.rst]]   => `index <index.html>`_
    " [[index.vim]]   => `index.vim <index.vim>`_
    " [[index/]]      => `index/ <index/index.html>`_
    " [[/xxx/a.rst]]  => `/xxx/a.rst  <DOC_ROOT/xxx/a.rst>`_
    "
    " :doc:`index`      => `index <index.html>`_
    " :doc:`index.rst`  => `index <index.html>`_
    " :doc:`index.vim`  => `index.vim <index.vim>`_
    " :doc:`/xxx/a.rst` => `/xxx/a.rst <DOC_ROOT>/xxx/a.rst`_
    " >>> echom s:repl_file_link(":doc:`/xxx/a.rst`") 
    " /xxx/a.rst <DOC_ROOT>/xxx/a.rst`_

    let line = a:line
    
    " we will get the idx and find the pattern from origin_file line.
    let o_line = line
    let pre_idx = 0           " for the inline markup column check
    let idx = matchend(o_line, riv#ptn#link_file())
    let str = matchstr(o_line, riv#ptn#link_file())

    " get all the object
    while idx != -1
        let obj = riv#ptn#get_inline_markup_obj(o_line, idx+1, pre_idx)
        " it's not in a inline markup
        if empty(obj)
            " substitute process
            let [path, f] = riv#publish#path(str)
            let title = s:escape(f)
            let line = substitute(line, s:escape_file_ptn(title),
                            \s:gen_embed_link(title, path), 'g')
        endif
        let idx = matchend(o_line, riv#ptn#link_file(),idx)
        let str = matchstr(o_line, riv#ptn#link_file(),idx)
        let pre_idx = idx
    endwhile
    return line
endfun "}}}
fun! s:sub_ext2html(line) "{{{
    " sub the .. xxx.rst: xxx.rst 
    " to      .. xxx.rst: xxx.html
    let line = a:line
    let str = matchstr(line, s:p.loc_normal)
    " >>> echo '.rst' =~ '\'.riv#path#ext().'$'
    " >>> echo riv#path#ext()
    if str != '' && str =~  '\'.riv#path#ext().'$'
        let line = substitute(line, '\'.riv#path#ext().'\s*$','.html','')
    endif
    return line
endfun "}}}


fun! s:convert(options) "{{{
    " TODO
    "
    " This should rewrite to match sphinx

    " options {
    "   filetype: 'html',
    "   input: 'tmp/xxx.rst',
    "   output: 'html/xxx.html',
    "   real_file: 'rst/xxx.rst' or input,
    " }
    
    let ft = get(a:options, 'filetype', 'html')
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
        if index(s:themes, g:riv_html_code_hl_style)            
            let st = g:riv_html_code_hl_style
            let style = ' --stylesheet='
                        \.s:css_html.','
                        \.s:css_{st}.','
        elseif filereadable(g:riv_html_code_hl_style)
            let style = ' --stylesheet='.g:riv_html_code_hl_style
        else
            let style = ' --stylesheet='
                        \.s:css_html.','
                        \.s:css_murphy.','
        endif

        " Copy the images for figure and image directives.
        call s:copy_img(real_file, output)
    elseif ft == 'latex'
        " let style = ' --stylesheet='.s:tex_cjk
        call s:copy_img(input, output)
    endif

    " the syntax css are short format
    let syn = '--syntax-highlight=short'

    call s:sys( exe." ". style ." " . syn . "  " . args . " "
                \.shellescape(input) 
                \." ".shellescape(output) )
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
    let origin_path = fnamemodify(a:input, ':p:h')
    let file = readfile(a:input)
    for line in file
        let img = matchstr(line, '^.. \(figure\|image\):: \s*\zs.*\ze\s*$')
        if img != '' && riv#path#is_relative(img)
            let origin_file = riv#path#join(origin_path, img) 
            let new_file = riv#path#join(out_path, img) 

            if filereadable(origin_file)
                let new_path = fnamemodify(new_file, ":p:h")
                if !isdirectory(new_path)
                    call mkdir(new_path, 'p')
                endif
            endi

            if s:is_windows
                " /c : Ignores errors.
                " /q : Suppresses messages.
                " /i : Creates new directory.
                " /e : Copies all subdirectories.
                " /y : Suppresses prompting to confirm.
                let cmd = 'xcopy /E /Y /C /I '
                            \.shellescape(origin_file).' '
                            \.new_file
            else
                let cmd = 'cp -rf '.origin_file.' '.new_file
            endif
            call s:sys(cmd) 
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
        let out_file = riv#path#ext_with(file, a:ft)
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
            " call s:sys(g:riv_ft_browser . ' '. shellescape(out_file) . ' &')
            call riv#util#open(out_file)
        else
            " call s:sys(g:riv_web_browser . ' '. shellescape(out_file) . ' &')
            call riv#util#open(out_file)
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
    let lines = readfile(file)
    let out_path = a:path . riv#path#rel_to_root(file)
    let out_file = riv#path#ext_with(out_path, a:ft)



    " Do the preparing work
    update
    call riv#publish#auto_mkdir(out_path)

    " XXX
    " here we can use append line with link
    " repl the file link
    " [[xxxx]] to `xxxx<xxxx.html>`_
    " :doc:`xxxx` to `xxxx<xxxx.html>`_

    let lines = map(lines, 's:repl_file_link(v:val)')

    call map(lines , 's:sub_ext2html(v:val)')
    call writefile(lines, s:temp_file)       " not all OS can pipe



    " Convert with rst2xxx
    call s:convert({'filetype': a:ft,
                \'input': s:temp_file,
                \'real_file': file,
                \'output': out_file,
                \})


    let ft_path = riv#path#build_ft(a:ft)
    let out_path = ft_path . riv#path#rel_to_root(file)
    call riv#publish#auto_mkdir(out_path)
    for line in lines
        " Copy all exists file under directory.
        let file = matchstr(line, '^\s*\.\. image::\s\zs.*')
        if file == ''  
            let file = matchstr(line, s:p.loc_normal)
        endif
        if file == '' | continue | endif
        " Here we have not check file outside or inside 
        " folder.
        if filereadable(file)
            call s:sys( 'cp -f '. file. ' '.  fnamemodify(out_path, ':h'))
        endif
    endfor


    if a:browse
        if a:ft == "latex"
            exe 'sp ' out_file
        elseif a:ft == "odt"
            " call s:sys(g:riv_ft_browser . ' '. out_file . ' &')
            call riv#util#open(out_file)
        else
            let escaped_path = substitute(out_file, ' ', '\\ ', 'g')
            " call s:sys(g:riv_web_browser . ' '. escaped_path . ' &')
            call riv#util#open(escaped_path)
        endif
    endif
endfun "}}}

fun! riv#publish#browse() "{{{
    let path = riv#path#build_ft('html') .  'index.html'
    " call s:sys(g:riv_web_browser . ' '. shellescape(path) . ' &')
    call riv#util#open(shellescape(path))
endfun "}}}
fun! riv#publish#open_path() "{{{
    exe 'sp ' riv#path#build_path()
endfun "}}}

fun! riv#publish#copy2proj(file,ft_path) abort "{{{
    let out_path = a:ft_path . riv#path#rel_to_root(expand(a:file))
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

call s:init()

if expand('<sfile>:p') == expand('%:p') "{{{
    call doctest#start()
endif "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
