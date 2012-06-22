Intro
=====

:Author: Rykka G.Forest
:Date:   2012-06-19T01:15:53
:Version: 0.62a
:Github: https://github.com/Rykka/riv.vim

**Riv** is a vim plugin for managing and writing ReST Documents.

It is short for 'ReST in Vim'.
in which **ReST** is short for reStructuredText_ .

.. _reStructuredText: http://docutils.sourceforge.net/rst.html

It is for people either want to manage documents in a personal wiki,
or writing documents with more html syntax support (than other markup language).

And you may need to see the `markup syntax of ReST documents`__ first.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html

Features
--------
    
* Folding : 
  
  Fold ReST file with sections, lists, and explicit mark, table, 
  literal-quotes...

* Sections: 
  
  Section levels are auto recongized.

  The section number will be showing when folded.

  Clicking on the section reference will bring you to the section title.
  
  Example: Features_ link will bring you to the `Feature` Section (in vim)

* Lists :

  Auto Numbered and auto leveled for bullet and enumerated list.

  The Sequence of the list level is:
   
  '* + - 1. A. a. I. i. 1) A) a) I) i) (1) (A) (a) (I) (i)'

  In Insert Mode: 

  + insert a new list of current list level: `<C-ENTER>`
  + insert a new list of child list level: `<S-ENTER>`
  + insert a new list of parent list level: `<C-S-ENTER>`
    

* Links : 
  
  Clicking on links will executing it's default behavior 
  (open browser/edit file/jump to internal target)

  <Tab>/<S-Tab> in Normal mode will jump to next/prev link.

* Table : 
  
  Auto Format Table. 
  (Currently require vim compiled with python. And Grid Table only.)

  To Create a table , just insert '\| xxx \|'

+-----------------+-----------------------------------------------------------+
| The Grid Table  |  Will be Auto Formatted after Leave Insert Mode           |
+=================+===========================================================+
| In Insert Mode  | - <Enter> in column to add a new line of column           |
|                 | - Line 2                                                  |
+-----------------+-----------------------------------------------------------+
|                 | <Enter> in seperator to add a new row                     |
+-----------------+-----------------------------------------------------------+
|                 | <Tab> and <S-Tab> in table will switch to next/prev cell  |
+-----------------+-----------------------------------------------------------+

* Project: 
  
  You can manage your ReST documents with a wiki style way.

  + Local File: 

    As ReST haven't define a pattern for local files currently.

    **Riv.vim**  provides two kinds of patterns to determine the local file
    in the rst documents. 
  
    1. 'xxx.rst' 'xxx.py' 'xxx.cpp' , directory is 'xxx/' .
       and you can add other extensions with `g:riv_file_link_ext`
    2. '[xxx] [xxx.vim]' , directory is '[xxx/]'

  + When Convert to html, all local file link will be converted to an embedded link.

    e.g. `xxx.rst <xxx.html>`_ `xxx.py <xxx.py>`_


* Scratch: 
  
  The scratches which is auto named by date,
  it is a place for writing diary or hold idea and thoughts.

  `:RivScratchCreate` `<C-E>cc`
  `:RivScratchView` `<C-E>cv`

* Todos : 
  
  You can add todo items , and it's datestamp.

  + [ ] this is a todo item of todo-box style.
  + Double Click on it or use '<C-E>ee' to switch the todo/done status.
  + [ ] 2012-06-23 this is a todo item with datestamp
  + Double Click on datestamp to change it's date.
  + [X] 2012-06-23 ~ 2012-06-23 a todo item of done.
  + DONE 2012-06-13 ~ 2012-06-23 a todo item of TODO/DONE keyword.
  + FIXED a todo item of FIXME/FIXED keyword.
  + You can add your own keyword group for todo items with 'g:riv_todo_keywords'
  + You can set the todo item timestamp style with 'g:riv_todo_timestamp'
  + `RivTodoType1` `<C-E>e1`... `RivTodoType4` `<C-E>e4` to change the keyword group. 
  + `RivTodoAsk` `<C-E>e`` will show an keyword group list to choose.

* Helpers: 
  
  A window to show something of the project.

  + Todo Helper: Check and jump to your All/Todo/Done todo items of the project.

    `:RivTodoHelper` or '<C-E>ht'

    Inside the window , you can use '/' to search , '<Enter>' to jump to. '<Esc>/q'
    to quit.
  
* Miscs : 
  
  Create sections, lists, links , and other stuffs.

  + Create Section Title:

  `:RivTitle1` `<C-E>s1` ...  `:RivTitle4` `<C-E>s4` 

  :NOTE: Although you can define a section title with most punctuations, 
         *Riv.vim* use following punctuations for titles **=-~"'`** , you
         can change it with 'g:riv_section_levels'

  + Create Lists:

  `:RivListTypeNext` `<C-E>l1`
  `:RivListTyePrev` `<C-E>l2`
  `:RivListTypeRemove` `<C-E>l``

  + Create Links:

  `:RivLinkCreate` `<C-E>cl`

  + Delete Rst File:

  `:RivDelete` `<C-E>cd`

* Convert: 
  
  some wrapper to convert rst files to html/xml/latex/odt/... 
  (require python docutils package )

  + `Riv2HtmlFile`  `<C-E>2hf`
  + `Riv2HtmlAndBrowse`  `<C-E>2hh`
  + `Riv2HtmlProject` `<C-E>2hp`
  + `Riv2Odt` `<C-E>2oo`  ... `Riv2Xml` `<C-E>2xx`
  + Open the build path: `Riv2Path` `<C-E>2e`

* Highlighting: 
  
  Improved and fixed default syntax file.

  +  Lists Highlighting added.
  +  Code Block syntax highlighting added.

     You can use `g:riv_highlight_code` to choose 
     which type of code to highlight.::
     
        .. code:: python
    
            # this is python highlighting
            # github does not support syntax highlighting for rst file yet.
            x = [0 for i in range(100)]
    
  +  The current links are highlighted.

* Indent: 
  
  Improved and fixed default indent file.

Install
-------
* Using Vundle_  (Recommend)

  Add this line to your vimrc::
 
    Bundle 'Rykka/riv.vim'

.. _Vundle: www.github.com/gmarik/vundle


* Using the zip file. 
  Just download the zipped file and extract to your `.vim` folder .

:NOTE: Make sure the your .vim folder in option 'runtimepath' 
       is before the $VIMRUNTIME. 

       Otherwise the syntax/indent files for rst file will using the vim built-in one.

* Recommened packages: 
    
  + Syntastic_  for syntax checking of rst files.
    (require python docutils package )

.. _Syntastic: https://github.com/scrooloose/syntastic


Issues
------

* Currently it's a development version. 
  Please Post issues at https://github.com/Rykka/riv.vim/issues

Todo
---------

* TODO add mapping/command/options section

