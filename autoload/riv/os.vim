
let s:is_unix = has('unix')
let s:is_windows = has('win16') || has('win32') || has('win64') || has('win95')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!isdirectory('/proc') && executable('sw_vers')))

let s:is_linux = s:is_unix && !s:is_mac && !s:is_cygwin
let s:is_ubuntu = s:is_linux && system("uname -a") =~? "ubuntu"
let s:is_arch = s:is_linux && system("uname -a") =~ "ARCH"


fun! riv#os#init() "{{{
    if !exists("s:OS")
        let s:OS = {
                \ "is_unix"     :  s:is_unix,
                \ "is_windows"  :  s:is_windows,
                \ "is_cygwin"   :  s:is_cygwin,
                \ "is_mac"      :  s:is_mac,
                \ "is_linux"    :  s:is_linux,
                \ "is_ubuntu"   :  s:is_ubuntu,
                \ "is_arch"     :  s:is_arch
                \}
    endif
    return s:OS
endfun "}}}
