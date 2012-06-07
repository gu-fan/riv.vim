#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import unicodedata


def wstr_len(wstr):
    if hasattr(unicodedata, 'east_asian_width'):
        east_asian_width = unicodedata.east_asian_width
    else:
        raise NameError("No east asian width")         # new in Python 2.4
    if not isinstance(wstr, unicode):
        wstr = wstr.decode('utf-8')
    num = 0
    for char in wstr:
        if east_asian_width(char) in 'WF':             # 'W'ide & 'F'ull-width
            num += 1
    return len(wstr)+num

if __name__ == "__main__":
    pass
