Riv Instruction
===============

:Author: Rykka G.Forest
:Date:   2012-06-29 10:38:56
:Version: 0.66 
:Github: https://github.com/Rykka/riv.vim

**Riv** is a vim plugin for managing and writing reStructuredText_ documents.
Short for 'reStructuredText in Vim'. 

It is for people either want to manage documents in a wiki way,
or writing reStructuredText documents in an easy way.

.. _reStructuredText: http://docutils.sourceforge.net/rst.html


Features
--------
 
These features are for all reStructuredText files.

:Folding_:  Fold document by documents structures (Section/List/Block).
:Sections_: Section level and section number auto detected. 
:Lists_:    Auto Numbered and auto leveled bullet and enumerated list.
:Links_:    Jumping with links.
:Table_:    Auto formatted table.
:Indent_:   Improved indentation 
:Insert_:   Improvment of some mapping in insert mode.
:Highlighting_: Improved syntax file. 

These features are for the Riv Project. 

:Project_:  Manage your reStructuredText documents in a wiki way.
:File_:     Links to local file in rst documents. 
:Scratch_:  A place for writing diary or hold idea and thoughts.
:Todos_:    Writing todo lists in reStructuredText documents .
:Helpers_:  A help window for showing and doing something.

  + `Todo Helper`_: Managing todo items of project.

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

Prev
~~~~

See Changelog in doc/riv.txt

* 0.64:

  + DONE 2012-06-23  README : rewrite intro/feature part
  + DONE 2012-06-24  Doc  : Help document from README.
  + DONE 2012-06-24  Menu : add and fix.
  + DONE 2012-06-24  A shortcut to add date and time.
  + FIXED 2012-06-23 Fold : table should not show an empty line in folding of lists.
    (nothing wrong, just indent it with the list.)
  + DONE 2012-06-23  Fold : the fold text should showing correct line while editing.
  + FIXED 2012-06-24 Fold : wrong end of section when fold_blank is 0.


* 0.65:

  + DONE 2012-06-27 take care of the slash of directory in windows .
  + FIXED 2012-06-28 correct cursor position when creating todo items and list items.
  + DONE 2012-06-28 format the scratch index, sort with year/month/day 

This
~~~~~

Things todo in this version.

* 0.66: 

  :Todo_:   DONE 2012-06-29 add field list for todo items.
  :Indent_: correct ``<BS>`` indentation to reach the begin of field list.
  :Indent_: DONE 2012-06-29 the indentation in directives should act the same as in comments.


Next 
~~~~~

Things todo in next versions.

:Links_:   The standalone web link with ``/`` will be considered as local file.
:File_:    A template or snippet or shortcut for adding ``./`` and ``../`` and files.
           Maybe a sphinx doc ref and the content directive as well.
:Documents_: Document part: options / commands.
:Documents_: Seperate instruction and intro. help use instruction.rst 
:Publish_: An option to enable highlighting todo items.
:Helpers_: An option Helper and option cache. 
           Let people use it even without touching ``.vimrc`` .
:Scratch_: Show Scratch sign in Calendar.
:Publish_: Support the reStructuredText document not in a project.
:Helpers_: A command helper?
:Links_:   Link tags?
:Todo_:    Todo item priorities?
:Table_:   Support simple table format?
:Table_:   A shortcut or command to create table with row * col.
:Sections_: Adjust section level.

.. _Documents: 

----

Instruction Details
===================

* How to use?

  + For writing reStructuredText documents in an easy way.

    When editing an reStructuredText document (``*.rst`` ), 
    these settings will be automatically on. 
    (make sure ``filetype on`` in your vimrc)

  + For managing documents in a wiki way, you should setup a project first, 
    see Project_.

* About the mapping

  Default leader map for Riv is ``<C-E>``.
  You can change it by following options.
  
  + ``g:riv_global_leader`` : leader map for Riv global mapping.

    - ``:RivIndex`` ``<C-E>ww`` to open the project index.
    - ``:RivAsk`` ``<C-E>wa`` to choose one project to open.
    - ``:RivScratchCreate`` ``<C-E>cc`` Create or jump to the scratch of today.
    - ``:RivScratchView`` ``<C-E>cv`` View Scratch index.

  + ``g:riv_buf_leader`` : leader map for reStructuredText buffers.
  + ``g:riv_buf_ins_leader`` : leader map for reStructuredText buffers's insert mode.


For reStructuredText
--------------------

These features are for all reStructuredText files.

Folding 
~~~~~~~~

Fold reStructuredText file with sections, lists, and blocks automatically.

When folded, some info of the item will be shown at the foldline.

Folding will be updated after you write buffer to file.

Pressing ``<Enter>`` or double clicking on folded lines will open that fold.

* Update Folding: use ``zx`` or ``<C-E><Space>j``
* Toggle Folding: use ``za`` or ``<C-E><Space><Space>`` 
* Toggle all Folding: use ``zA`` or ``<C-E><Space>m``

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
    

    ..  vim: fdl=0 :
        This means all fold will be folded when opening files

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
  + ``:RivListTypeRemove`` ``<C-E>lx``
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

   :NOTE: To enable highlighting in converted file, 
          python ``pygments`` package must installed for ``docutils`` 
          parsing syntax highlighting.

          see http://docutils.sourceforge.net/sandbox/code-block-directive/tools/pygments-enhanced-front-ends/

*  The links under cursor are highlighted. 
   Disable it by set ``g:riv_hover_link_hl`` to 0

Indent
~~~~~~

Improved indent file.

In Insert mode , when starting a newline or 

* starting newline (``<Enter>`` or ``o`` in Normal mode):
  will start newline with correct indentation 
* ``<BS>`` (BackSpace key).
  will goto correct indentation if no preceding non-whitespace character
  and after the indentation's ``&shiftwidth`` position , otherwise ``<BS>``

Insert
~~~~~~

Improvment for some mapping in insert mode. Detail in each section.

Also most shortcut can be used in insert mode. like ``<C-E>ee`` ``<C-E>s1`` ...

* Enter: Insert lists_ with ``<C-Enter>`` , ``<S-Enter>`` and ``<C-S-Enter>``.

  When in a table_, ``<Enter>`` to create a new line

  When not in a table, will start new line with correct indentation

* Tab:  When in a table , ``<Tab>`` to next cell , ``<S-Tab>`` to previous one.

  When not in a table , will act as ``<C-N>`` or ``<C-P>`` if insert-popup-menu 
  is visible.
  
  Otherwise output a ``<Tab>``

* BackSpace: for indent_, will goto correct indentation if no preceding non-whitespace character and after the indentation's ``&shiftwidth`` position ,
  otherwise ``<BS>``


For Riv
-------

These features are for the Riv Project.

Project
~~~~~~~

Manage your reStructuredText documents in a wiki way.

* By default. the path of project is at '~/Documents/Riv',
  you can set it by adding project to ``g:riv_projects`` in your vimrc.::

    let project1 = { 'path': '~/Dropbox/rst',}
    let g:riv_projects = [project1]

    " You could add multiple projects as well 
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

  + when set to 1, use ``bare extension style``:

    words like ``xxx.rst`` ``xxx.py`` ``xxx.cpp`` will be detected as file link.

    words like ``xxx/`` will be considered as directory , 
    and link to ``xxx/index.rst``

    words like ``/xxxx/xxx.rst`` ``~/xxx/xxx.rst`` ``x:/xxx.rst``
    will be considered as external file links

    words like ``/xxxx/xxx/`` ``~/xxx/xxx/`` 
    will be considered as external directory links, 
    and link to the directory.

    You can add other extensions with ``g:riv_file_link_ext``.
    which default is ``vim,cpp,c,py,rb,lua,pl`` ,
    meaning these files will be recongized.

  + when set to 2, ``square bracket style``: 
    
    words like ``[xxx]`` ``[xxx.vim]`` will be detected as file link. 

    words like ``[xxx/]' will link to ``xxx/index.rst``

    words like ``[/xxxx/xxx.rst]`` ``[~/xxx/xxx.rst]``  ``[x:/xxx/xxx.rst]``
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
  
The scratches is created auto named by date in '%Y-%m-%d' format.
It is a place for writing diary or hold idea and thoughts.

Scratches will be put in scratch folder in project directory.
You can change it with 'scratch_path' of project setting ,default is 'scratch'::
    
    " Use another directory
    let project1.scratch_path = 'diary'
    " Use absolute path, then no todo helper and no converting for it.
    let project1.scratch_path = '~/Documents/diary'

* ``:RivScratchCreate`` ``<C-E>cc``
  Create or jump to the scratch of today.

* ``:RivScratchView`` ``<C-E>cv``
  View Scratch index.

  The index is auto created. You can change the month name using 
  ``g:riv_month_names``. 

  default is:

      ``January,February,March,April,May,June,July,August,September,October,November,December``

Todos
~~~~~

Writing and highlighting todo items in reStructuredText documents.
It's not the reStructuredText syntax. 
So no highlighting when converted.

Todo items are todo-box or todo-keywords in bullet/enumerated/field lists.

Datestamps are supported to show todo items's start/end date.

The statistics of the todo progress (include child items) will be shown when folded. 

* A Todo item:

  + [ ] This is a todo item of initial state.
  + [o] This is a todo item that's in progress.
  + [X] This is a todo item that's finished.

* Datestamps:

  + You can set the todo item timestamp style with 'g:riv_todo_timestamp'
  
    - when set to 2 , will init with a start datestamp.
      and when it's done , will add a finish datestamp.

      1. [ ] 2012-06-23 This is a todo item with start datestamp
      2. [X] 2012-06-23 ~ 2012-06-23  A todo item with both start and finish datestamp. 
  
    - when set to 1 , no init datestamp ,
      will add a finish datestamp when it's done.

      1. [X] 2012-06-23 This is a todo item with finish datestamp, 

    - when set to 0 , no datestamp
  
* Keyword groups:
    
  + FIXED A todo item of FIXME/FIXED keyword.
  + DONE 2012-06-13 ~ 2012-06-23 A todo item of TODO/DONE keyword.
  + You can define your own keyword group for todo items with ``g:riv_todo_keywords``
  
    each keyword is seperated by ',' , each group is seperated by ';'
  
    default is ``TODO,DONE;FIXME,FIXED;START,PROCESS,STOP``,

* Actions:

  + Use ``:RivTodoToggle`` or ``<C-E>ee`` to add or switch the todo status.
  + Double Click or ``<Enter>`` in the box/keyword to swith the todo status
  + Double Click or ``<Enter>`` or ``:RivTodoDate`` on a datestamp to change date. 
  
    If you have Calendar_ installed , it will use it to choose date.
  
  + Use ``:RivTodoType1`` ``<C-E>e1`` ... ``:RivTodoType4`` ``<C-E>e4`` 
    to add or change the todo item by group. 
  + Use ``:RivTodoAsk`` ``<C-E>e``` will show an keyword group list to choose.
  + Use ``:RivTodoDel`` ``<C-E>ex`` will delete the todo item

  + Use ``:RivCreateDate`` ``<C-E>id`` to insert a datestamp of today anywhere.
  + Use ``:RivCreateTime`` ``<C-E>it`` to insert a timestamp of current time anywhere. 
  + Use ``:RivTodoHelper`` or ``<C-E>ht`` to open a `Todo Helper`_
  
Helpers
~~~~~~~

A window to show something of the project.

* _`Todo Helper` : A helper to manage todo items of current project.

  + ``:RivTodoHelper`` or ``<C-E>ht``
    Open to view all todo-items.
    Default is in search mode.

    - ``/`` to search todo item matching inputing, ``<Enter>`` or ``<Esc>`` to quit
      search mode.
      
      Set ``g:riv_fuzzy_help`` to 1 to enable fuzzy searching in helper.

    - ``<Tab>`` to switch content, 
      there are 'All/Todo/Done' contents for Todo Helper.
    - ``<Enter>`` or Double Click to jump to the todo item.
    - ``<Esc>`` or ``q`` to quit the window

Publish
~~~~~~~

Some wrapper to convert rst files to html/xml/latex/odt/... 
(require python docutils package )

* ``:Riv2HtmlFile``  ``<C-E>2hf``
  convert to html file.
* ``:Riv2HtmlAndBrowse``  ``<C-E>2hh``
  convert to html file and browse. 
  default is 'firefox'

  The browser is set with ``g:riv_web_browser``
* ``:Riv2HtmlProject`` ``<C-E>2hp`` converting whole project into html.
  And all the file with extension in ``g:riv_file_link_ext`` will be copied there too.

Convert to the file and browse.

* ``:Riv2Odt`` ``<C-E>2oo`` convert to odt file and browse
* ``:Riv2Xml`` ``<C-E>2xx`` convert to xml file and browse
* ``:Riv2S5`` ``<C-E>2ss`` convert to s5 file and browse
* ``:Riv2Latex`` ``<C-E>2ll`` convert to latex file and browse

The browser is set with ``g:riv_ft_browser``. 
default is (unix:'xdg-open', windows:'start')

The path of building files by default is under ``_build`` in your project directory.

* To change the path. Set it in your vimrc::
    
    " Assume you have a project name project 1
    let project1.build_path = '~/Documents/Riv_Build'

* Open the build path: ``:Riv2BuildPath`` ``<C-E>2b``
