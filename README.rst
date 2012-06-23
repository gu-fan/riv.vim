Riv Instruction
===============

:Author: Rykka G.Forest
:Date:   2012-06-23 18:47:58
:Version: 0.64 
:Github: https://github.com/Rykka/riv.vim

**Riv** is a vim plugin for managing and writing reStructuredText_ Documents.
Short for 'reStructuredText in Vim'. 

.. _reStructuredText: http://docutils.sourceforge.net/rst.html

It is for people either want to manage documents in a wiki way,
or writing reStructuredText documents.


Features
--------
 
These features are for all reStructuredText files.

:Folding_:  Fold document by documents structures (Section/List/Block).
:Sections_: Section level and section number auto detected. 
:Lists_:    Auto Numbered and auto leveled bullet and enumerated list.
:Links_:    Jumping with links.
:Table_:    Auto formatted table.
:Indent_:   Improved indentation 
:Highlighting_: Improved syntax file. 

These features are for the Riv Project. 

:Project_:  Manage your reStructuredText documents in a wiki way.
:File_:     Links to local file in rst documents. 
:Scratch_:  A place for writing diary or hold idea and thoughts.
:Todos_:    Writing todo lists in reStructuredText documents .
:Helpers_:  A help window for showing and doing something.

  :Todo Helper: Managing todo items of project.

:Publish_:  some wrapper to convert rst files to html/xml/latex/odt/... 
            (require python docutils package )


* Take a glance

.. image::  http://i.minus.com/jCFTijpr6oqYt.jpg

* To Start: see `Instruction Details`_

Install
-------
* Using Vundle_  (Recommend)

  Add this line to your vimrc::
 
    Bundle 'Rykka/riv.vim'

.. _Vundle: www.github.com/gmarik/vundle

* Using downloaded file. 
  Just extract to your ``.vim`` folder .

:NOTE: Make sure the your .vim folder in option ``runtimepath`` 
       is before the $VIMRUNTIME. 

       Otherwise the syntax/indent files for rst file will using the vim built-in one.

* Recommend plugins: 

  + Syntastic_  for syntax checking of rst files.
    (require python docutils package )

    .. _Syntastic: https://github.com/scrooloose/syntastic

  + Calendar_ setting datestamp easier.

    .. _Calendar: https://github.com/mattn/calendar-vim

Issues
------

* Currently it's a developing version. So things may change quickly.
  keep up-to-date.

* Both bug reports and feature request are welcome. 
  Please Post issues at https://github.com/Rykka/riv.vim/issues


Todo
---------

This
~~~~~

Things todo in this version.

* 0.64:

  + DONE 2012-06-23  README : rewrite intro/feature part
  + DONE 2012-06-24  Doc  : Help document from README.
  + DONE 2012-06-24  Menu : add and fix.
  + DONE 2012-06-24  A shortcut to add date and time.
  + FIXED 2012-06-23 Fold : table should not show an empty line in folding of lists.
    (nothing wrong, just indent it with the list.)
  + DONE 2012-06-23  Fold : the fold text should showing correct line while editing.
  + FIXED 2012-06-24 Fold : wrong end of section when fold_blank is 0.
    

Next 
~~~~~

Things todo in next versions.

* Helper: An option Helper and option cache. 
  let people use it even without touching ``.vimrc`` .
* Helper: A command helper?
* Doc: Detail option parts
* Scratch: show Scratch sign in Calendar.
* Publish: support the reStructuredText document not in a project.


Instruction Details
-------------------

* How to use?

  When editing an reStructuredText document (``*.rst`` ), 
  these settings will be automatically on. 
  (make sure ``filetype on`` in your vimrc)

  To manage documents in a wiki way, see Project_.

* About the mapping

  Default leader map for Riv is ``<C-E>``.
  You can change it by following options.
  
  + ``g:riv_global_leader`` : leader map for Riv global mapping.
  + ``g:riv_buf_leader`` : leader map for reStructuredText buffers.
  + ``g:riv_buf_ins_leader`` : leader map for reStructuredText buffers's insert mode.


Folding 
~~~~~~~~

Fold reStructuredText file with sections, lists, and blocks automatically.

When folded, some info of the item will be shown at the foldline.

Folding will be updated after you write buffer to file.

Pressing ``<Enter>`` or double clicking on folded lines will open that fold.

* Update Folding: use ``zx`` or ``<C-E><Space>j``
* Toggle Folding: use ``<C-E><Space><Space>`` 
* Toggle all Folding: use ``<C-E><Space>m``

To show the blank lines in the end of a folding, use ``g:riv_fold_blank``.

 + when set to 2 , will fold all blank lines.
 + when set to 1 , will fold all blank lines,
   but showing one blank line if there are some.
 + when set to 0 , will fold one blank line , 
   but will showing the rest.
 + default is 2

For large files. calculate folding may cost time. 
So there are some options about it.

* ``g:riv_fold_level`` set which structures to be fold. 

  + when set to 3 , means 'sections,lists and blocks'.
  + when set to 2 , means 'sections and lists'
  + when set to 1 , means 'sections'
  + when set to 0 , means 'None'
  + default is 3.

* ``g:riv_auto_fold_force``, enable reducing fold level when editing large files.

  + when set to 1 , means 'On'.
  + default is 1.

* ``g:riv_auto_fold1_lines``, the minimum lines file containing,
  to force set fold_level to section only.

  default is 5000.

* ``g:riv_auto_fold2_lines``, the minimum lines file containing,
  to force set fold_level to section and list only.

  default is 3000.

To set an initial folding level for a file . you can use ``modeline``::

    ..  vim: fdl=0 fdm=manual :

Sections 
~~~~~~~~~

Section levels and numbers are auto detected.

The section number will be shown when folded.

Pressing ``<Enter>`` or double clicking on section title will toggle the folding
of the section.

Clicking on the section reference will bring you to the section title.

    e.g. Features_ link will bring you to the `Feature` Section (in vim)

* Create Section Title:

  Normal and Insert:

  + Use ``:RivTitle1`` ``<C-E>s1`` ...  ``:RivTitle6`` ``<C-E>s6`` ,
    To create level 1 to level 6 section title from current word.

    If it's empty, you will be asked to input one.

:NOTE: Although you can define a section title with most punctuations. 

       Riv use following punctuations for titles: 

       **=-~"'`** , you can change it with ``g:riv_section_levels``

Lists
~~~~~

Auto numbered and auto leveled bullet and enumerated list.

The Sequence of the list level is:

    ``* + - 1. A. a. I. i. 1) A) a) I) i) (1) (A) (a) (I) (i)``

* Editing Lists:

  Normal and Visual:

  + ``>`` or ``<C-ScrollWheelDown>`` 
    Add Indentation, And add a level for list.

    if the first item is a list , the indentation is based on the list item.
    otherwise the indentation is based on ``'shiftwidth'``.

  + ``<`` or ``<C-ScrollWheelUp>`` 
    Remove Indentation, And remove a level for list.

  Insert Mode Only: 
  
  + ``<CR>\<KEnter>`` (enter key and keypad enter key)
    Insert the content of this list.

    To insert content in new line of this list item. add a blank line before it.

  + ``<C-CR>\<C-KEnter>`` 
    Insert a new list of current list level
  + ``<S-CR>\<S-KEnter>`` 
    Insert a new list of current child list level
  + ``<C-S-CR>\<C-S-KEnter>`` 
    Insert a new list of current parent list level
  
  Normal and Insert:
  
  + ``:RivListTypeNext`` ``<C-E>l1``
    Change current list item symbol to next type
  + ``:RivListTyePrev`` ``<C-E>l2``
    Change current list item symbol to prev type
  + ``:RivListTypeRemove`` ``<C-E>l```
    Delete current list item symbol

:NOTE: To contain a second paragraph (or blocks) in a list , you should make the left edge 
       lines up with the main paragraph.

       See `reStructuredText Bullet Lists`__

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#bullet-lists

Links
~~~~~

  
Clicking on links will executing it's default behavior 
(open browser/edit file/jump to internal target)

``<Tab>/<S-Tab>`` in Normal mode will jump to next/prev link.

* Create Links:

  Normal Mode Only :

  + ``:RivCreateLink`` ``<C-E>il``
    create a link from current word. 

    If it's empty, you will be asked to input one.

  + ``:RivCreateFoot`` ``<C-E>if``
    create a auto numbered footnote. 
    And append the footnote target to the end of file.

Table
~~~~~
  
Auto Format Table (Grid Table Only).
(Currently require vim compiled with python. )

When folded, the numbers of rows and columns will be shown.

Currently only Support the Grid Table with equal columns each row .

Insert Mode Only:

To create a table , just insert ``| xxx |`` and press ``<Enter>``.

+-----------------+-----------------------------------------------------------+
| The Grid Table  |  Will be Auto Formatted after Leave Insert Mode           |
+=================+===========================================================+
| Lines           | - <Enter> in column to add a new line of column           |
|                 | - This is the second line of in same row of table.        |
+-----------------+-----------------------------------------------------------+
| Rows            | <Enter> in seperator to add a new row                     |
+-----------------+-----------------------------------------------------------+
| Cells           | <Tab> and <S-Tab> in table will switch to next/prev cell  |
+-----------------+-----------------------------------------------------------+

Highlighting
~~~~~~~~~~~~

Improved syntax file. 

*  Lists Highlightings 
*  Code Block syntax highlighting::
 
     .. code:: python
     
         # python highlighting
         # github does not support syntax highlighting for rst file yet.
         x = [0 for i in range(100)]

   You can use ``g:riv_highlight_code`` to set which type of code to highlight.
   default is ``lua,python,cpp,javascript,vim,sh``

*  The links under cursor are highlighted. 
   Disable it by set ``g:riv_hover_link_hl`` to 0

Indent
~~~~~~

Improved indent file.

In Insert mode , when starting a newline or press ``<BS>`` (BackSpace key).
the cursor will be put at the calculated position.

Project
~~~~~~~

Manage your reStructuredText documents in a wiki way.

* By default. the path of project is at '~/Documents/Riv',
  you can set it by adding project to ``g:riv_projects`` in your vimrc.::

    let project1 = { 'path': '~/Dropbox/rst',}
    let g:riv_projects = [project1]

    " You could add multi project either.
    let project2 = { 'path': '~/Dropbox/rst2',}
    let g:riv_projects = [project1, project2]

* Use ``:RivIndex`` ``<C-E>ww`` to open the project index.
* Use ``:RivAsk`` ``<C-E>wa`` to choose one project to open.

File
~~~~


As reStructuredText haven't define a pattern for local files currently.

**Riv**  provides two kinds of style to determine the local file
in the rst documents. 

The ``bare extension style`` and ``square bracket style``

* You can switch the style with ``g:riv_localfile_linktype``

  + when set to 1, use bare extension style:

    words like ``xxx.rst`` ``xxx.py`` ``xxx.cpp`` will be detected as file link.

    words like ``xxx/`` will be considered as directory , 
    and link to ``xxx/index.rst``

    words like ``/xxxx/xxx.rst`` ``~/xxx/xxx.rst`` 
    will be considered as external file links

    words like ``/xxxx/xxx/`` ``~/xxx/xxx/`` 
    will be considered as external directory links, 
    and link to the directory.

    You can add other extensions with ``g:riv_file_link_ext``.
    which default is ``vim,cpp,c,py,rb,lua,pl`` ,
    meaning these files will be recongized.

  + when set to 2, square bracket style: 
    
    words like ``[xxx]`` ``[xxx.vim]`` will be detected as file link. 

    words like ``[xxx/]' will link to ``xxx/index.rst``

    words like ``[/xxxx/xxx.rst]`` ``[~/xxx/xxx.rst]`` 
    will be considered as external file links

    words like ``[/xxxx/xxx/]`` ``[~/xxx/xxx/]`` 
    will be considered as external directory links, 
    and link to the directory.

  + when set to 0, no local file link.
  + default is 1.

* When Publish to html, all detected local file link will be converted to an embedded link.

    e.g. `xxx.rst <xxx.html>`_ `xxx.py <xxx.py>`_

* To delete a local file in project.

  ``:RivDelete`` ``<C-E>df``
  it will also delete all reference to this file in ``index.rst`` of the directory.

Scratch
~~~~~~~
  
The scratches is created auto named by date,
It is a place for writing diary or hold idea and thoughts.

Scratches will be put in 'scratch' folder in project directory.

* ``:RivScratchCreate`` ``<C-E>cc``
  Create or jump to the scratch of today.
* ``:RivScratchView`` ``<C-E>cv``
  View Scratch index.

Todos
~~~~~

Writing todo lists in reStructuredText documents .

Todo items are bullet/enumerated lists with todo-box or todo-keywords.
Datestamps are supported.

The statistics of the progress (include child items) will be shown When folded. 

A todo-box item:

* [ ] this is a todo item of todo-box style.
* Double Click  or ``<Enter>`` in the box or use ``<C-E>ee`` 
  to switch the todo/done status.

Datestamps:

* [X] 2012-06-23 This is a todo item with finish datestamp
* [ ] 2012-06-23 This is a todo item with start datestamp
* [X] 2012-06-23 ~ 2012-06-23  A todo item with both start and finish datestamp. 

* You can set the todo item timestamp style with 'g:riv_todo_timestamp'

  + when set to 2 , will init with a start datestamp.
    and when it's done , will add a finish datestamp.
  + when set to 1 , no init datestamp ,
    will add a finish datestamp when it's done.
  + when set to 0 , no datestamp

* Double Click or ``<Enter>`` on datestamp to change date. 

  If you have Calendar installed , it will use calendar to choose date.

* Use ``RivCreateDate`` ``<C-E>id`` to insert a datestamp of today.
* Use ``RivCreateTime`` ``<C-E>it`` to insert a timestamp of current time. 

Keyword groups:

* FIXED A todo item of FIXME/FIXED keyword.
* DONE 2012-06-13 ~ 2012-06-23 A todo item of TODO/DONE keyword.
* You can add your own keyword group for todo items with ``g:riv_todo_keywords``

  each group is seperated by ';' , each keyword is seperated by ','

  default is ``TODO,DONE;FIXME,FIXED;START,PROCESS,STOP``,

* ``RivTodoType1`` ``<C-E>e1``... ``RivTodoType4`` ``<C-E>e4`` 
  to add or change the todo item by group. 
* ``RivTodoAsk`` ``<C-E>e``` will show an keyword group list to choose.
* ``RivTodoDel`` ``<C-E>ex`` will delete the todo item

Helpers
~~~~~~~

A window to show something of the project.

* Todo Helper: Check and jump to your All/Todo/Done todo items of the project.

  + ``:RivTodoHelper`` or ``<C-E>ht``
    Open Todo Helper

  Inside the window , use '/' to search ,'<Tab>' to switch content,
  '<Enter>' to jump to. '<Esc>/q' to quit.

* Set ``g:riv_fuzzy_help`` to 1 to enable fuzzy searching in helper.

Publish
~~~~~~~

Some wrapper to convert rst files to html/xml/latex/odt/... 
(require python docutils package )

* ``Riv2HtmlFile``  ``<C-E>2hf``
  convert to html file.
* ``Riv2HtmlAndBrowse``  ``<C-E>2hh``
  convert to html file and browse. 
  default is 'firefox'

  The browser is set with ``g:riv_web_browser``
* ``Riv2HtmlProject`` ``<C-E>2hp``

Convert to the file and browse.
* ``Riv2Odt`` ``<C-E>2oo``  
* ``Riv2Xml`` ``<C-E>2xx``
* ``Riv2S5`` ``<C-E>2ss``
* ``Riv2Latex`` ``<C-E>2ll``
The browser is set with ``g:riv_ft_browser``. 
default is (unix:'xdg-open', windows:'start')

The path of building files by default is under ``_build`` in your project directory.
* Open the build path: `Riv2BuildPath` `<C-E>2b`
* To change the path. Set it in your vimrc::
    
    " Assume you have a project name project 1
    let project1.build_path = '~/Documents/Riv_Build'
