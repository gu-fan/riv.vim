
class RstBuff:
    '''  Return Current buff , contains dict of all objects 
    All Control through this will update the object

    lines: the vim.current.buf

    tables: all the tables and it's attr
    lists: ... 
    todos: ...

    schedules: ... 

    folds: ...
    indents: ... '''
    def __init__(self,buf):
        self.buf = buf
    pass

class Leafy:
    ''' Contains the global Leafy objects
    Modle:  a database/plain file(salted)
             record all the documents/works/projects path. 

    Control: the actions and exec .
            
    View: the template and interface
           schedules
           todo
    '''

    pass
