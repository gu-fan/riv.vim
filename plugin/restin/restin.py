#!/usr/bin/env python
# -*- coding: utf-8 -*-

import vim
import re

class RestTable:
    def __init__(self,lst):
        self.table = [[col for col in row ] for row in lst]
        self.row = len(lst)
        # only for table that cols are equal
        if self.row > 0:
            self.col = len(lst[0])
        else:
            self.col = 0

    def __repr__(self):
        return "<RestTable: %d Row %d Col>" % (self.row,self.col)

    def create_table(self,indent):
        # reverse the table and get the max_len of cols.
        v_tbl = zip(*self.table)
        c_max = []
        for v_cols in v_tbl:
            max_len = 0         # two space
            for col in v_cols:
                c_len = len(col.strip())
                if c_len>max_len:
                    max_len = c_len
            c_max.append(max_len)

        line_sep = " "*indent
        line_head = " "*indent
        for i in c_max:
            # we should use join here.
            line_sep += "+"+"-"*(i+2)
            line_head += "+"+"="*(i+2)
        line_sep += "+"
        line_head += "+"

        lines = []
        for rows in self.table:
            line_con = " "*indent
            i = 0
            for col in rows:
                line_con += "|"
                col =col.strip()
                c_len = len(col)
                max_len = c_max[i]
                if c_len<max_len:
                    col += " "*(max_len-c_len)
                line_con += " "+col+" "
                i += 1
            line_con += "|"
            lines.append(line_sep)
            lines.append(line_con)
        lines.append(line_sep)
        if len(lines)>=5:
            lines[2] = line_head
        return lines
class BufParse:
    def __init__(self):
        self.buf = vim.current.buffer

    def parse_range_to_table(self,start,end):
        '''
        parse line from start to end 
            |1xxxxxxx|xxxxx|xxxxxasxasx|
            |2xxxxxxx|xxxxxxaxsxasx|xxxxx|
            |3xxxxaxsaxsaxsaxxxx|xxxxx|xxxxx|
            |4xxxxxxx|xxxxx|     |
        returns a 3 col and 4 row table
        ''' 
        rows = []
        max_col = 0
        for i in range(start-1,end):
            con_ptn = '^\s*\|.*\|\s*$'
            if re.match(con_ptn,self.buf[i]):
                col = re.finditer('(?<=\|)([^|]+)(?=\|)',self.buf[i])
                cols = [i.group() for i in col]
                c_len = len(cols)
                if max_col < c_len:
                    max_col = c_len
                rows.append(cols)

        # balance each row with same num of column.
        for row in rows:
            for i in range(max_col-len(row)):
                row.append(" ")         # we could append to row directly.

        return RestTable(rows)

    def get_table_range(self,row):
        # row is the 
        ptn ='^\s*\|.*\|\s*$|^\s*\+[-=+]+\+\s*$'
        if re.match(ptn,self.buf[row-1]):
            bgn,end = [row,row]
        else:
            return [0,0]
        for i in range(row,0,-1):
            if re.match(ptn,self.buf[i-1]):
                bgn = i
            else:
                break
        for i in range(row,len(self.buf)):
            if re.match(ptn,self.buf[i-1]):
                end = i
            else:
                break
        return [bgn,end]

    def format_table(self,row):
        bgn,end = self.get_table_range(row)
        if bgn==0 and end==0:
            return -1
        indent =  len(re.match('^\s*(?=\S)',self.buf[row-1]).group())
        table = self.parse_range_to_table(bgn,end).create_table(indent)
        del self.buf[bgn-1:end]
        self.buf.append(table,bgn-1)
    

if __name__ == "__main__":
    """
    +----------+-------+--------------------------+
    | 1xxxxx   | xxx   | xxx                      |
    +----------+-------+--------------------------+
    | 2xxxxxxx | xxasx | xxxxxfj ioejfioaw jijioj |
    +----------+-------+--------------------------+
    | 3xxxxa   | xxxxx | xxxxx                    |
    +----------+-------+--------------------------+
    |          |       |                          |
    +----------+-------+--------------------------+
    """
    BufParse().format_table(119)




