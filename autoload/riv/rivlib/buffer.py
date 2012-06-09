from __future__ import print_function
import vim
from vim import eval as veval
# from vim import command as vcmd

import re

from rivlib.pattern import riv_ptn,Struct

# TODO:
# class Componets:
# class Parser:


class RivBuf:
    '''  Return Current buff , contains dict of all objects 
    All Control through this will update the object

    lines: the vim.current.buf

    tables: all the tables and it's attr
    lists: ... 
    todos: ...

    schedules: ... 

    folds: ...
    indents: ... '''
    def __init__(self):
        self.buf = vim.current.buffer
        self.buf_num = vim.current.buffer.number
        self.shiftwidth = int(veval('&sw'))

    def parse(self):
        ''' parse buf line by line and return a document object'''
        doc_obj=Struct()
        doc_obj.sect  = []
        doc_obj.lists = []
        doc_obj.exp   = []
        doc_obj.tables= []
        doc_obj.block = []
        doc_order_lst = []
        buf = self.buf
        
        in_sect, in_list, in_table ,in_exp , in_block = [0,0,0,0,0]
        foldlevel, fdl_pre_list, fdl_pre_exp, fdl_pre_table, fdl_pre_block = [
                0,0,0,0,0]

        for i in range(0,len(buf)):
            c_line = buf[i]
            n_line = buf[i+1] if i+1 in buf else ""
            n2_line = buf[i+2] if i+2 in buf else ""
            p_line = buf[i-1] if i-1 in buf else ""
            nnb_i = int(veval("nextnonblank("+ str(i+2) +")"))-1
            if riv_ptn.blank.match(c_line):
                # obj = {'typ':'blk','bgn':i}
                # doc_order_lst.append(obj)
                pass
            elif ( c_line==".." and riv_ptn.blank.match(n_line) ):
                # can stop 
                obj = {'typ':'i_exp','bgn':i}
                doc_order_lst.append(obj)
            # sect
            elif riv_ptn.section.match(c_line) \
                    and riv_ptn.section.match(n2_line) \
                    and riv_ptn.nonblank.match(n_line):
                sect = {'typ':'sec','bgn':i,'title_row':3,'title_type':c_line[0]}
                doc_obj.sect.append(sect)
                doc_order_lst.append(sect)
            elif riv_ptn.section.match(n_line) \
                    and riv_ptn.nonblank.match(c_line)\
                    and c_line != n_line    \
                    and len(c_line) <= len(n_line):
                # parse next line here?
                obj = {'typ':'sec','bgn':i,'title_row':2,'title_type':c_line[0]}
                doc_obj.sect.append(obj)
                doc_order_lst.append(obj)
            # lists
            elif riv_ptn.lists.match(c_line) \
                    and in_exp == 0:
                c_idt = self.indent(i)
                # nnb_idt = self.indent(nnb_i)
                # if c_idt < nnb_idt:
                #     if in_list==0:
                #         in_list = 1
                obj = {'typ':'lst','bgn':i, 'indent':c_idt }
                doc_obj.lists.append(obj)
                doc_order_lst.append(obj)
            elif riv_ptn.exp_m.match(c_line) \
                    and riv_ptn.s_bgn.match(n_line) \
                    and riv_ptn.s_bgn.match(n2_line):
                obj = {'type':'exp','bgn':i }
                doc_obj.exp.append(obj)
                doc_order_lst.append(obj)
            elif riv_ptn.blank.match(c_line) and riv_ptn.blank.match(p_line) \
                    and riv_ptn.S_bgn.match(buf[nnb_i]):
                if in_exp ==1:
                    obj = {'typ':'exp','end':i }
                    doc_obj.exp.append(obj)
                    doc_order_lst.append(obj)
                    in_exp = 0
                if in_list == 1:
                    obj = {'typ':'lst','end':i }
                    in_exp = 0
                    in_list = 0
                    doc_obj.lists.append(obj)
                    doc_order_lst.append(obj)
            elif riv_ptn.table_all.match(c_line) and in_table==0:
                obj = {'typ':'tbl','bgn':i}
                in_table=1
                doc_order_lst.append(obj)
            else: 
                # obj = {'bgn':i}
                # doc_order_lst.append(obj)
                pass
        return [doc_obj,doc_order_lst]
                
        
    def indent(self,i):
        line = re.sub('\t',' ' * self.shiftwidth ,self.buf[i])
        idt = riv_ptn.s_bgn.match(line)
        if idt:
            return idt.end()
        else:
            return 0


if __name__ == "__main__":
    Rbuf = RivBuf()
    print(r"\n".join(Rbuf.parse()[1]))
