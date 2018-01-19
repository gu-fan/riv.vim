"=============================================
"    Name: diary.vim
"    File: diary.vim
" Summary: diary support
"          integrate with calendar.vim
"  Author: Mark Wallace
"  Update: 2015-02-25
"=============================================

" Load only once {{{
if exists("g:loaded_riv_diary_auto")
    finish
endif
let g:loaded_riv_diary_auto = 1
" }}}

" Helpers {{{
function! s:prefix_zero(num) "{{{
  if a:num < 10
    return '0'.a:num
  endif
  return a:num
endfunction "}}}

" Helpers }}}

" make directory if not exist
" optional argument 'confirm' == 1 is provided
" most codes are copied from vimwiki#base#mkdir
function riv#diary#auto_mkdir(path, ...) "{{{
    let path = expand(a:path)
    if !isdirectory(path) && exists("*mkdir")
        let path = riv#path#directory(path)
        if a:0 && a:1 && tolower(input("Riv: Make new directory: ".path."\n [Y]es/[n]o? ")) !~ "y"
            return 0
        endif
        call mkdir(path, "p")
    endif
    return 1
endfunction "}}}

function! riv#diary#get_diary_dir(wnum) "{{{
    " riv have a default project.
    if a:wnum > len(g:_riv_c.p)-1
        riv#error("Project ".a:wnum."is not registered in g:riv_projects")
        return
    endif

    if a:wnum > 0
        let idx = a:wnum-1
    else
        let idx = 0
    endif

    " ensure that dairy directory exits.
    return riv#path#directory(riv#path#root(idx).g:riv_diary_rel_path)
endfunction "}}}

function! riv#diary#get_diary_link(wnum, day, month, year) "{{{
    let diary_dir = riv#diary#get_diary_dir(a:wnum)
    call riv#diary#auto_mkdir(diary_dir)

    if a:wnum > len(g:_riv_c.p)-1
        riv#error("Project ".a:wnum."is not registered in g:riv_projects")
        return
    endif

    if a:wnum > 0
        let idx = a:wnum-1
    else
        let idx = 0
    endif

    let day = s:prefix_zero(a:day)
    let month = s:prefix_zero(a:month)
    let link = a:year.'-'.month.'-'.day

    return riv#path#ext_with(diary_dir . link, riv#path#p_ext(idx))
endfunction "}}}

" Calendar.vim {{{
" Callback function.
function! riv#diary#calendar_action(day, month, year, week, dir) "{{{

    if winnr('#') == 0
        if a:dir == 'V'
            vsplit
        else
            split
        endif
    else
        wincmd p
        if !&hidden && &modified
            new
        endif
    endif

    " create diary note for selected date in default project.
    let diary_link = riv#diary#get_diary_link(1, a:day, a:month, a:year)
    call riv#file#edit(diary_link)
endfunction "}}}

" Sign function
function riv#diary#calendar_sign(day, month, year) "{{{
    let diary_link = riv#diary#get_diary_link(1, a:day, a:month, a:year)
    return filereadable(expand(diary_link))
    return 1
endfunction "}}}
" }}}
