"=============================================
"    Name: roman.vim
"    File: roman.vim
" Summary: convert from roman.py
"  Author: Rykka G.Forest
"  Update: 2012-06-14
"=============================================
let s:cpo_save = &cpo
set cpo-=C


"""Convert to and from Roman numerals"""
" __author__ = "Mark Pilgrim (f8dy@diveintopython.org)"
" __version__ = "1.4"
" __date__ = "8 August 2001"
" __copyright__ = """Copyright (c) 2001 Mark Pilgrim

let s:roman_num_map = [['M',1000],
                    \['CM', 900 ],
                    \['D',  500 ],
                    \['CD', 400 ],
                    \['C',  100 ],
                    \['XC', 90  ],
                    \['L',  50  ],
                    \['XL', 40  ],
                    \['X',  10  ],
                    \['IX', 9   ],
                    \['V',  5   ],
                    \['IV', 4   ],
                    \['I',  1   ]]

fun! riv#roman#from_nr(n) "{{{
    if 0 > a:n || a:n > 5000
        echohl ErrorMsg
        echo "RIV: Roman number out of Range"
        echohl Normal
        return ""
    endif
    let n = a:n
    let result = ""
    for [numeral, integer] in s:roman_num_map
        while n >= integer
            let result .= numeral
            let n -= integer
        endwhile
    endfor
    return result
endfun "}}}
"thousands - 0 to 4 M's                              
"hundreds - 900 (CM), 400 (CD), 0-300 (0 to 3 C's),  
"           or 500-800 (D, followed by 0 to 3 C's)   
"tens - 90 (XC), 40 (XL), 0-30 (0 to 3 X's),         
"       or 50-80 (L, followed by 0 to 3 X's)         
"ones - 9 (IX), 4 (IV), 0-3 (0 to 3 I's),            
"       or 5-8 (V, followed by 0 to 3 I's)           
"end of string                                       
let s:roman_num_ptn = '\v^M{0,4}'           
                    \.'(CM|CD|D?C{0,3})'   
                    \.'(XC|XL|L?X{0,3})'   
                    \.'(IX|IV|V?I{0,3})'   
                    \.'$'                  
fun! riv#roman#to_nr(s) "{{{
    if a:s!~s:roman_num_ptn
        echohl ErrorMsg
        echo "RIV: Not a Roman numeral "
        echohl Normal
        return -1
    endif
    let result = 0
    let index = 0
    for [numeral, integer] in s:roman_num_map
        while a:s[index : index+len(numeral)-1] == numeral
            let result += integer
            let index += len(numeral)
        endwhile
    endfor
    return result
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
