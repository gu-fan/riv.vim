#!/usr/bin/env python
# -*- coding: utf-8 -*-

import vim
import re

from rivlib.utils import wstr_len
from rivlib.pattern import riv_ptn


def balance_tbl_col(lst):
    balanced_lst = []

    # get max col_num of each row
    # and change the non list
    col_num = 0
    for row in lst:
        if isinstance(row,list):
            row_len = len(row)
            if row_len > col_num: col_num = row_len

    if col_num == 0:
        return balanced_lst             # []
    
    for i,row in enumerate(lst):
        if isinstance(row,list):
            row_len = len(row)
            tmp_row = row[:]
            if col_num > row_len:
                tmp_row.extend([" " for i in range(col_num - row_len)])
        else:
            tmp_row = [row]
            tmp_row.extend([" " for i in range(col_num - 1)])
        balanced_lst.append(tmp_row)

    return balanced_lst

class RestTable:

    def __init__(self, lst):
        '''
        receive a 2D list and init the table
        '''
        self.list = balance_tbl_col(lst)

        self.row = len(self.list)
        if self.row > 0:
            self.col = len(self.list[0])
        else:
            self.col = 0
        
        self.norm_col()
        self.parse_col_max_width()

    def __repr__(self):
        return "<RestTable: %d Row %d Col>" % (self.row, self.col)

    def norm_col(self):
        '''
        remove last space of each col,
        and add a preceding space if not exists
        '''
        for row in self.list:
            for i,col in enumerate(row):
                row[i] = col.rstrip()
                if not row[i].startswith(" "):
                    row[i] = " " + row[i]

    def parse_col_max_width(self):
        '''
        A list contains the max width of each column.
        e.g | e     | e   | ee |
            | eeeee | e   | e  |
            | ee    | eee | e  |
        will set col_max_w to  [5 , 3 ,2]
        '''
        v_tbl = zip(*self.list)
        col_max_w = []
        for v_cols in v_tbl:
            max_len = 0         # two space
            for col in v_cols:
                if re.match(' \|S| \|H',col):
                    continue
                c_len = wstr_len(col)
                if c_len > max_len:
                    max_len = c_len
            col_max_w.append(max_len)
        self.col_max_w = col_max_w

    def update(self):
        pass

    # def add_line(self,idx):
    #     ''' add a empty line in table with specified idx'''
    #     if idx< self.row:
    #         if self.list[idx][0] == "|S":
    #             self.list.insert(idx+1, ["|S"])
    #         self.list.insert(idx+1, [ " " for i in range(self.col)])
    #         # self.list = balance_tbl_col(self.list)
            
    def add_line(self,idx,typ):
        if typ == 'cont' or self.list[idx][0] == " |S" or self.list[idx][0] == " |H":
            c = idx+1
        else:
            c = idx+2
        if typ == 'sepr':
            self.list.insert(idx+1, [" |S"])
        elif typ == 'head':
            self.list.insert(idx+1, [" |H"])
        self.list.insert(c, [ " " for i in range(self.col)])
        
        
    def lines(self, indent=0):
        """
            indent: the number of preceding whitespace.

            return the lines of table.
        """
        # reverse the table and get the max_len of cols.
    
        idt = " " * indent
        s_sep = "".join(["+" + ("-" * (l + 1)) for l in self.col_max_w])
        line_sep = idt + s_sep + "+"
        line_head = re.sub('-','=',line_sep)

        lines = []
        for row in self.list:
            if row[0] == " |S":
                lines.append(line_sep)
            elif row[0] == " |H":
                lines.append(line_head)
            else:
                s_col = ""
                for i , cell in enumerate(row):
                    c = cell
                    s_col += "|" + c + (" " * (self.col_max_w[i] - wstr_len(c))) + " "
                line_con = idt + s_col + "|"
                lines.append(line_con)

        if lines:
            if lines[-1] != line_sep:
                lines.append(line_sep)
            if lines[0] != line_sep:
                lines.insert(0,line_sep)

        return lines


class GetTable:
    
    def __init__(self,lnum=0):
        '''
        --lnum :      the lnum of table
                default is vim.current.window.cursor[0]
        --buffer :    the buffer of table
                default is vim.current.buffer
        
        '''
        self.buf = vim.current.buffer
        if lnum == 0:
            lnum=vim.current.window.cursor[0]
        bgn, end = self.get_table_range(lnum)
        self.bgn, self.end = bgn, end
        if bgn == 0 and end == 0:
            self.table = None
        else:
            self.table = self.table_in_range(bgn, end)
            indent = riv_ptn.indent.match(self.buf[lnum - 1]).end()
            self.indent = indent

    def table_in_range(self, start, end):
        '''
        parse line from start to end
        +---------------------+---------------+-------------+
        | 1xxxxxxx            | xxxxx         | xxxxxasxasx |
        +=====================+===============+=============+
        | 2xxxxxxx            | xxxxxxaxsxasx | xxxxx       |
        | 3xxxxaxsaxsaxsaxxxx | xxxxx         | xxxxx       |
        +---------------------+---------------+-------------+
        | 4xxxxxxx            | xxxxx         |             |
        +---------------------+---------------+-------------+
        will be parse to a 2 dimension list.
        [   ["1xxx","xxx","xxxas"],
            ["2xxxx","xxxxx","xxxx"]
            ....
        ]
        and returns a 3 col and 3 row table

        to create a table with large cell
        we should get the line and it's sep's
        if have line and sep , then it's one row cell
        if it have continues lines, then it's multi cell

        if  we want to add multi col cell. we must record cell 's sep pos
        '''
        max_col = 0

        rows = []
        for i in range(start - 1, end):
            if riv_ptn.table_con.match(self.buf[i]):
                cols = [i.group() for i in riv_ptn.table_cel.finditer(self.buf[i])]
                c_len = len(cols)
                if max_col < c_len:
                    max_col = c_len
                rows.append(cols)
            elif riv_ptn.table_sepr.match(self.buf[i]) :
                # this will cause min col_len to 2
                rows.append(['|S'])      # A sep_str workround
            elif riv_ptn.table_head.match(self.buf[i]) :
                rows.append(['|H'])
        
        return RestTable(rows)

    def get_table_range(self, row):
        if riv_ptn.table_all.match(self.buf[row - 1]):
            bgn, end = [row, row]
        else:
            return [0, 0]
        for i in range(row, 0, -1):
            if riv_ptn.table_all.match(self.buf[i - 1]):
                bgn = i
            else:
                break
        for i in range(row, len(self.buf)):
            if riv_ptn.table_all.match(self.buf[i - 1]):
                end = i
            else:
                break
        return [bgn, end]

    def format_table(self):
        if self.table:
            lines = self.table.lines(self.indent)
            bgn,end = self.bgn, self.end
            buf = self.buf
            d_bgn = 0
            for row in range(bgn-1,end):
                if buf[row] != lines[0]:
                    buf[row] = lines[0]
                if lines:
                    del lines[0]
                elif riv_ptn.table_all.match(buf[row]):
                    d_bgn = row
            if d_bgn:
                del buf[d_bgn:end]
            if lines:
                buf.append(lines, end)
                           
    def add_line(self,typ="cont"):
        if self.table:
            idx = vim.current.window.cursor[0] - self.bgn
            # if row=="1":
            self.table.add_line(idx,typ)
            # else:
            #     self.table.add_line(idx,2)
            self.format_table()


if __name__ == "__main__":
    """
    +----------+-------+--------------------------+
    | 1xxxxx   | xxx   | xxx                      |
    +==========+=======+==========================+
    | 2xxxxxxx | xxasx | xxxxxfj ioejfioaw jijioj |
    +----------+-------+--------------------------+
    |          |       | 在                       |
    +----------+-------+--------------------------+
    |          |       |                          |
    +----------+-------+--------------------------+
    | 3xxxxa   | xxxxx | xxxxx                    |
    +----------+-------+--------------------------+
    |          |       |                          |
    +----------+-------+--------------------------+
    """
    buftable = GetTable(259)
    buftable.table.add_line(3)
    print buftable.table
    print "\n".join(buftable.table.lines())
    # GetTable().add_row()
    # string = '当当当当当当'
    # print wstr_len(string)
