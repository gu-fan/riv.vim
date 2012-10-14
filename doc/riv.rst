############################
Riv: reStructuredText in Vim
############################

.. rubric:: In vim, for reStructuredText.

:Author: Rykka G.F
:Update: 2012-10-13
:Version: 0.72 
:Github: https://github.com/Rykka/riv.vim

* Contents:

  * 1 Intro_

    * 1.1 Features_
    * 1.2 `On Screen`_
    * 1.3 `Getting Started`_
    * 1.4 Install_
    * 1.5 `Todo and Done`_
    * 1.6 Issues_
    * 1.7 Contribution_

  * 2 Instructions_

    * 2.1 Vim_

      * 2.1.1 Folding_
      * 2.1.2 Syntax_
      * 2.1.3 Indent_
      * 2.1.4 Insert_

    * 2.2 RST_

      * 2.2.1 Sections_
      * 2.2.2 Lists_
      * 2.2.3 Links_
      * 2.2.4 Table_
      * 2.2.5 Publish_

    * 2.3 Riv_

      * 2.3.1 Project_
      * 2.3.2 File_
      * 2.3.3 Scratch_
      * 2.3.4 Todos_
      * 2.3.5 Helpers_
      * 2.3.6 Sphinx_

  * 3 Appendix_

    * 3.1 Commands_
    * 3.2 Options_

Intro
=====

**Riv**, short for 'reStructuredText in Vim'. 

Is for writing and managing your document with reStructuredText_ 
(a simple and powerful plain text markup) in vim.

With it, you can::

    Read documents clearer. (with folding and extra highlighting)
    Write documents faster. (with indent and insert improvement)
    Manage documents easier. (with project and Sphinx support)
    Make life documented. (with Todo and Scratch.)

Features
--------
 
**Reading and Writing**

 **Vim Improved**

 :Folding_:  Overview the structure.
 :Syntax_:   Extra highlighting.
 :Indent_:   Smarter indent.
 :Insert_:   Speed up the input!

 **RST Documents**

 :Sections_: Easy create, easy view.
 :Lists_:    Auto numbered, auto leveled and auto indented.
 :Links_:    Jumping and Highlighting.
 :Table_:    Auto formatted. 
 :Publish_:  Convert to html/xml/latex/odt...

 **Riv Managment**

 :Sphinx_:   Working with Sphinx.
 :Project_:  A workspace for your documents.
 :File_:     Link local file in the document.
 :Scratch_:  Writing notes and diaries.
 :Helpers_:  Help work with document/project.
 :Todos_:    Keep track of todo things.

On Screen
----------

ScreenShot: Work with Sphinx_

.. image:: http://i.minus.com/ibj1XigngbbYKl.png 

ScreenCast: TODO

Getting Started
---------------

* Installation: see Install_
* Know Issues: Issues_ 
* Things Todo: `Todo and Done`_.
* Contribute: Contribution_.

* Mappings and commands. See Commands_
* Options. See Options_

**Reading Guide**

* Quick Start for Riv: see `QuickStart With Riv`_  
  or use ``:RivQuickStart`` in vim.
* Detailed Instruction for Riv: see `Instructions`_ 
  or ``:h riv``, and It's this document.

* If you are not familiar with reStructuredText.

  Read `A ReStructuredText Primer`_ and `Quick reStructuredText`_. 
* If you want view reStructuredText's detailed specification. 

  Read `reStructuredText Specification`_

  Use ``:RivSpecification`` to open it in vim.

* And the `reStructuredText cheatsheet`_ for a quick view.

  Use ``:RivCheatSheet`` to open it in vim.

Install
-------
* Using Vundle_  (Recommended)

  Add this line to your vimrc::
 
    Bundle 'Rykka/riv.vim'


* Using downloaded zip/tar.gz file. 
  Just extract it to your ``.vim`` folder .


:NOTE: Make sure your .vim folder in option ``runtimepath`` 
       is before the $VIMRUNTIME, otherwise the syntax/indent files
       for rst files will use vim's built-in one.

       Default is before $VIMRUNTIME.

:NOTE: Make sure ``filetype plugin indent on`` and ``syntax on`` is in your vimrc

:NOTE: It's a developing version. 
       So things may change quickly.

       Keep up-to-date.

       You can get the latest version at https://github.com/Rykka/riv.vim 

* Related tools: 

  + python: docutils_ , required for converting to other format.
  + python: pygments_ for syntax highlighting in other format.
  + python: Sphinx_ for Sphinx users.
  + vim: Syntastic_  for syntax checking. docutils_ required.

    But if you are using Sphinx_'s tools set, you'd better not using it.
    Cause it could not recognize the sphinx's markups.

Todo and Done
-------------

Prev
~~~~

See Change log in  riv_log_ (doc/riv_log.rst)

This
~~~~~

Things todo in this version.

* 0.72 

  :Syntax_: DONE 2012-09-25 highlight reStructuredText in python DocString.
  :File_: FIXED 2012-09-25 Fix the file link highlight of ``~/.xxx``
  :Sections_: FIXED 2012-10-04 Fix the section Helper.
  :Syntax_: FIXED 2012-10-04 Workaround of the Spell checking.
  :Intro_: DONE 2012-10-13 Options_ section.
  :Intro_: Commands_ section.
  :Intro_: ScreenCast tutor
  :Intro_: Rewrite riv_quickstart
  :Intro_: DONE 2012-10-14 Rewrite riv_todo
  :Intro_: DONE 2012-10-14 Cheatsheet and Specification added.
  :File_:  DONE 2012-10-13 support user defined rst file suffix.
  :File_:  DONE 2012-10-13 support sphinx embedded :doc: link.
  :Test:   DONE 2012-10-13 Add `:RivDocTestVim` for vim script test.
  :Menu:   FIXED 2012-10-13 Fix menu disable/enable.
  :Links_: FIXED 2012-10-13 Fix target link jumping.

Next
~~~~~

See riv_todo_ (doc/riv_todo.rst)


Issues
------

* If the document folding showing some error.
  You can try force reload ``:RivTestReload`` ``<C-E>t```
* Windows:
  
  - Converting to other format may fail. 
    
    This may due to docutils could not executing correctly with vimrun.exe.

* Mac OS:

  - The List don't act as expected. 
  
    Maybe Caused the ``<C-Enter>`` Could not be mapped.
    Use other map instead.

* Post issues at https://github.com/Rykka/riv.vim/issues
  Both bug reports and feature request and discussions are welcome. 

Contribution
------------

There are many things need to do.

If you are willing to improve this plugin, Contribute to it.

:Document: 
           1. This README document need review and rewrite.
              It is also the helpdoc in vim.
           2. Rewrite and merge the quickstart and quick intro.
              Which could be used in vim.
           3. A screencast for quickstart.

:Code:
        1. Support auto formatting for table with column/row span. 

           The code of ``PATH-TO-Docutils/parsers/rst/tableparser`` 
           can be referenced.
        2. Support more other plugins of reStructuredText_

----

Instructions
============

Vim
---
Following features are improved with vim built-in one.

Folding 
~~~~~~~~

**Folding** is a vim feature.

It shows a range of lines as a single line.
Thus you can get a better overview of the document structures.

And you can operate the folded lines with one line actions, 
like: select(V), copy(yy), paste(p) ... Etc.

See ``:h folding`` for more infos.

With Riv, Sections, lists, and blocks are folded automatically,
And extra infos are provided.

* Commands:

  **Normal Mode**

  These 'z' folding commands can be used.
  Like 'zo' 'zc' ...

  Also extra commands are provided.

  + Open/Close Folding: ``zo``, ``zc``, ``zM``, ``zR``
  + Update Folding: ``zx``

    And foldings will be auto updated whilst writing buffer to file, ``:write`` or ``:update``.

    You can disable it by setting '`g:riv_fold_auto_update`_' to 0.

    :NOTE: When you write to a file without updating folding,
           Previous folding structure of the document will be breaked. 
           Manual updating is needed.

           So use it with caution.
    :NOTE: When document's folding stucked, you can use ``:RivTestReload`` or ``<C-E>t``` 
           to reload document and the folding.

  + Toggle Folding: ``za``, ``zA``...

    You can define your own mappings for folding in your vimrc,
    I use ``<Space><Space>`` to toggle folding::

        nno <silent> <Space><Space> @=(foldclosed('.')>0?'zv':'zc')<CR>


  + Toggle folding with Cursor.

    Pressing ``<Enter>`` or double clicking on folded lines 
    will open the fold. Like ``zo``

    Pressing ``<Enter>`` or double clicking on section heading
    will close the fold of the section. Like ``zc``

* Extra Infos:

  Some extra info of folded lines will be shown at the first line.
  And the number of folded lines will be shown. 
  
  + Folded Sections_ will show it's section number.
  + Folded Todos_ will show the Todo progress in percentage.
  + Folded Table_ will show number of rows and columns.
  + '`g:riv_fold_info_pos`_' can be used to change info's position.
  
* Extra Options:

  + To show the blank lines in the end of a folding, use '`g:riv_fold_blank`_'.
  + For large files. Calculate folding may cost time. 
    So there are some options about it.

    - '`g:riv_fold_level`_' set which structures to be fold. 
    - '`g:riv_auto_fold_force`_', '`g:riv_auto_fold1_lines`_', '`g:riv_auto_fold2_lines`_'
      reducing fold level when editing large files.
    
  + To open some of the fold when entering a file . 
    You can use ``:set fdls=1`` or use ``modeline`` for some files::

     ..  vim: fdls=0 :

Syntax
~~~~~~

Improved highlights for syntax items.

*  File_ Link are highlighted. 

   - extension style: ``xxx.rst xxx.vim``
   - moinmoin style: ``[[xxx]] [[xxx.vim]]``
   - Sphinx style: ``:doc:`xxx` :download:`xxx.vim```

*  Todos_ Item are highlighted.
*  You can use ``:set spell`` for spell checking,
   and ``spell`` is on in Literal-Block.


Code Highlighting
"""""""""""""""""

For the ``code`` directives (also ``sourcecode`` and ``code-block``). 
Syntax highlighting of Specified languages are on ::
 
  .. code:: python
     
      # python highlighting
      # github does not support syntax highlighting rendering for rst file yet.
      x = [0 for i in range(100)]

There are code block indicator for every code directives,
It's first column of the line in code block are highlighted to 
indicate it's a code block.

You can disable it by setting `g:riv_code_indicator`_ to 0.


The ``highlights`` directives in Sphinx_ could also be used to
highlight big block of codes. ::

  .. highlights:: python

  x = [0 for i in range(100)]

  .. highlights::
    

* Use '`g:riv_highlight_code`_' to set which languages to be highlighted.


:NOTE: To highlighting codes in converted file, 
       pygments_ package must installed for docutils_ to
       parse syntax highlighting.

       See http://docutils.sourceforge.net/sandbox/code-block-directive/tools/pygments-enhanced-front-ends/

Cursor Highlighting
"""""""""""""""""""

Some item that could operate by cursor are highlighted when cursor is on.

* Links are highlighted in ``hl-incSearch``

  + if the target file is invalid, it will be highlighted by 
    '`g:riv_file_link_invalid_hl`_'
* Todo items are highlighted in ``hl-DiffAdd``

You can disable Cursor Highlighting by set '`g:riv_link_cursor_hl`_' to 0

Docstring Highlighting
""""""""""""""""""""""

For python files. 
DocString can be highlighted using reStructuredText.

You can enable it by setting ``g:riv_python_rst_hl`` to 1.

Also you can set the file type to ``rst`` 
to gain riv features in python file. ::
    
    set ft=rst

Indent
~~~~~~

Smarter indent in insert mode.

As indenting in reStructuredText is complicated. 
Riv will fixed indent for lines in the context of 
blocks, list, explicit marks. 

If no fix is needed, ``shiftwidth`` will be used for the indenting.

* Commands:
    
  **Insert Mode**

  + Newline (``<Enter>`` or ``o`` in Normal mode):
    will start newline with fixed indentation 
  + ``<BS>`` (Backspace key) and ``<S-Tab>`` .
    Will use fixed indentation if no preceding non-whitespace character, 
    otherwise ``<BS>``
  + ``<Tab>`` (Tab key).
    Will use fixed indentation if no preceding non-whitespace character, 
    otherwise ``<Tab>``
  

Insert
~~~~~~

Super ``<Tab>`` and Super ``<Enter>`` in insert mode.

* ``Enter`` and ``KEnter`` (Keypad Enter) 
  (with modifier 'Ctrl' and 'Shift'): 
  
  + When in a grid table: creating table lines.
    
    See Table_ for details.
  + When in a list context: creating list lines.
    
    See Lists_ for details.

* ``Tab`` and ``Shift-Tab``:  
  
  * If insert-popup-menu is visible, will act as ``<C-N>`` or ``<C-P>``

    Disable it by setting '`g:riv_i_tab_pum_next`_' to 0.
  * When in a table , ``<Tab>`` to next cell , ``<S-Tab>`` to previous one.
  * When not in a table, 

    + If it's a list, and cursor is before the list item, will shift the list. 
    + if have fixed indent, will indent with fixed indent. See indent_.
    + Otherwise:
      
      - if '`g:riv_i_tab_user_cmd`_' is not empty , executing it. 

        It's for users who want different behavior with ``<Tab>``::

          " For snipmate user. 
          let g:riv_i_tab_pum_next = 0
          " quote cmd with '"', special key must contain '\'
          let g:riv_i_tab_user_cmd = "\<c-g>u\<c-r>=snipMate#TriggerSnippet()\<cr>"

      - else act as ``<Tab>`` and ``<BS>``.
    
  :NOTE:  ``<S-Tab>`` is acting as ``<BS>`` when not in list or table .

* Backspace: indent with fixed indent. See indent_.
* Most commands can be used in insert mode. Like ``<C-E>ee`` ``<C-E>s1`` ...

:NOTE: To disable mapping of ``<Tab>`` etc. in insert mode.

       Set it in '`g:riv_ignored_imaps`_' , each item is split with ``,``. ::
        
        " no <Tab> and <S-Tab>
        let g:riv_ignored_imaps = "<Tab>,<S-Tab>"

       You can view default mappings with '_`g:riv_default.buf_imaps`'

* Insert extra things.

  + Use ``:RivCreateDate`` ``<C-E>id`` to insert a date stamp of today anywhere.
  + Use ``:RivCreateTime`` ``<C-E>it`` to insert a time stamp of current time anywhere. 


RST 
---

Following features are for all document which filetype is ``rst``.
And are all standard reStructuredText syntax.

Sections 
~~~~~~~~~

Section level and numbers are auto detected.

And it's folded by it's level.

* Commands:

  **Normal and Insert Mode**

  + Create and Modify titles: 

    Use ``:RivTitle1`` ``<C-E>s1`` ...  ``:RivTitle6`` ``<C-E>s6`` ,
    To create level 1 to level 6 section title from current word.

    If the line empty, you will be asked to input a title.

    And ``:RivTitle0`` ``<C-E>s0`` will create a section title
    with an overline.

    Other commands is ``underline`` only.

    Riv use following punctuations for titles: 

    ``= - ~ " ' ``` , (HTML has 6 levels)

    You can change it with '`g:riv_section_levels`_'

    The ``:RivTitle0`` will use ``#``

  + Folding: 

    Pressing ``<Enter>`` or double clicking on the section title 
    will toggle the folding of the section.

    The section number will be shown when folded.

  + Jumping:

    ``<Enter>`` or Clicking on the section reference will bring you to the section title.

    E.g.: click the link of Features_ will bring you to the ``Features`` Section (in vim)

  + Create a content table:
    
    Use ``:RivCreateContent`` or ``<C-E>ic`` to create it.

    It's similar with the ``content`` directive,
    except it create the content table into the document.

    The advantage is you can jumping with it in vim,
    and have full control of it.

    The disadvantage is you must update it every time 
    after you have changed the document structure.

    You can set '`g:riv_content_format`_' to change it's format.
    
* Extra Options:

  + Section mark:

    Section number are separated by '`g:riv_fold_section_mark`_'

See `reStructuredText sections`__ for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#sections

* Misc:

  For convenience, Page-break ``^L`` (Ctrl-L in insert mode) was made to break current section in vim, works like transitions__.

__  http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#transitions

Lists
~~~~~

There are several types of list items in reStructuredText.

They are highlighted. Some are folded.

* Auto Leveled:

  Bullet and enumerated list.

  When you shift the list or add child/parent list , 
  the type of list item will be changed automatically.

  The level sequence is as follows:  

  ``* + - 1. A. a. I. i. 1) A) a) I) i) (1) (A) (a) (I) (i)``
  
  You can use any of them as a list item, but the changing sequence is hard coded.

  This means when you shift right or add a child list with a ``-`` list item, 
  the new one will be ``1.``

  And if you shift left or add a parent list item with a ``a.`` list item , 
  the new one will be ``A.``

* Auto Numbered:

  Bullet and enumerated list.

  When you adding a new list or shifting an list, 
  these list items will be auto numbered.

* Auto Indented:

  Bullet and enumerated list and field list.

  When you adding a new list or shifting an list, 
  these list items will be auto indented.

* Commands:

  + Shifting:

    **Normal and Visual Mode**

    - Shift right: ``>`` ``:RivShiftRight`` or ``<C-ScrollWheelDown>(UNIX only)``  
  
      Shift rightwards with ``ShiftWidth``

      If it's a list item, it will indent to the list item's sub list
  
    - Shift left: ``<`` ``:RivShiftLeft`` or ``<C-ScrollWheelUp>(UNIX only)``  

      Shift leftwards with ``ShiftWidth``

      If it's a list item, it will indent to the list item's parent list

    - Format:   ``=``
      Format list's level and number.
    - To act as the vim's original ``<`` ``>`` and ``=``,
      just preceding a ``<C-E>``,  as ``<C-E><`` , ``<C-E>>`` and ``<C-E>=``

      Also ``<S-ScrollWheelDown>`` and ``<S-ScrollWheelUp>`` can 
      be used in UNIX

    :Tips: To make shifting with mouse more easier.

           You should make sure the vim option ``'selectmode'`` not contain ``mouse``,
           in order to use mouse to start visual mode, not select mode
           As commands not working in Select Mode.

           And this option will be reset by ``:behave mswin``.
           So you should put it behind that.

    **Insert Mode**
  
    - ``<Tab>`` when cursor is before the list's content
      will shift right.
    
    - ``<S-Tab>`` when cursor is before the list's content.
      Will shift left.

    :NOTE: As this will break the ``<Tab>`` inserting operation 
           in ``visual-block insert``. 

           You should use ``<Space>`` instead of ``<Tab>``

           or use ``visual-block replace``
           See ``:h v_b_i`` and ``:h v_b_r``

  + New List:
  
    Insert Mode Only: 

    - ``<CR>\<KEnter>`` (enter key and keypad enter key)
      Insert the content of this list.
  
      To insert content in new line of this list item. Add a blank line before it.
  
    - ``<C-CR>\<C-KEnter>`` 
      or ``<C-E>li``
      Insert a new list of current list level
    - ``<S-CR>\<S-KEnter>`` 
      or ``<C-E>lj``
      Insert a new list of current child list level
    - ``<C-S-CR>\<C-S-KEnter>`` 
      or ``<C-E>lk``
      Insert a new list of current parent list level
    - When it's a field list, only the indent is inserted.
  
  + Change List Type:

    Normal and Insert Mode:
    
    - ``:RivListType0`` ``<C-E>l1`` ... ``:RivListType4`` ``<C-E>l5``
      Change or add list item symbol of type.
      
      The list item of each type is:: 
      
        '*' , '1.' , 'a.' , 'A)' ,'i)'

      :NOTE:  You should act this on a new list or list with no sub line.

              As list item changes, the indentation of it is changed.
              But this action does not change the sub item's indent.

              To change a list and it's sub item 
              with indentation fix , use shifting: ``>`` or ``<``.
             
    - ``:RivListDelete`` ``<C-E>lx``
      Delete current list item symbol

Links
~~~~~

You can jumping with links.

And it's highlighted with `Cursor Highlighting`_.

* Commands:

  **Jumping(Normal Mode):**

  + Clicking on a links  will jump to it's target. 

    ``<Enter>/<KEnter>`` or double click or ``<C-E>ko``
    
    - A web link ( www.xxx.xxx or http://xxx.xxx.xxx or xxx@xxx.xxx ): 

      Open web browser. 

      And if it's an email address ``xxx@xxx.xxx``,  ``mailto:`` will be added.

      Web browser is set by '`g:riv_web_browser`_'.

    - A internal reference ( ``xxx_ [xxx]_ `xxx`_`` ): 

      Find and Jump to the target.

      If it's an anonymous reference ``xxx__``,

      Will jump to the nearest anonymous target.

    - A internal targets (``.. [xxx]:  .. _xxx:``)

      Find and Jump to the nearest backward reference.

    - A local file (if '`g:riv_file_link_style`_' is not 0):

      Like (``xxx.vim`` or ``[[xxx/xxx]]``)

      Edit the file. 

      To split editing:
      As no split editing commands were defined, 
      you should split document first:
      ``<C-W><C-S>`` or ``<C-W><C-V>``

  + You can jump back to origin position with `````` or ``''``

  **Navigate(Normal Mode):**
    
  + Navigate to next/previous link in document.

    ``<Tab>/<S-Tab>`` or ``<C-E>kn/<C-E>kp``
   
  **Create (Normal and Insert):**

  + ``:RivCreateLink`` ``<C-E>ik``
    create a link from current word. 

    If it's empty, you will be asked to input one.

    If the link is not Anonymous References,
    The target will be put at the end of file by default.

    '`g:riv_create_link_pos`_' can be used to change the target postion.

  + ``:RivCreateFoot`` ``<C-E>if``
    create a auto numbered footnote. 
    And append the footnote target to the end of file.


Table
~~~~~

Tables are highlighted and folded.

For Grid table, it is auto formatted.

* Grid Table: 

  Highlighted and Folded.
  When folded, the numbers of rows and columns will be shown as '3x2'

  Will be auto formated. Only support equal columns each row (no span).
  Disable auto-formatting by setting '`g:riv_auto_format_table`_' to 0.

  + Commands:

    - Create: Use ```<C-E>tc`` or ``:RivTableCreate`` to create table
    - Format: Use ``<C-E>tf`` or ``:RivTableFormat`` to format table.

      It will be auto formatted after leaving insert mode,
      or pressing ``<Enter>`` or ``<Tab>`` in insert mode.

    **Insert Mode Only:**

    - Inside the Table

      +-------+-------------------------------------------------------------+
      |       | Grid Table (No column or row span supported yet)            |
      +-------+-------------------------------------------------------------+
      | Lines | - <Enter> in column to add a new line                       |
      |       | - This is the second line of in same row of table.          |
      +-------+-------------------------------------------------------------+
      | Rows  | - <C-Enter> to add a separator and a new row                |
      |       | - <C-S-Enter> to add a header seperator and a new row       |
      |       |   (There could be only one header seperator in a table)     |
      |       | - <S-Enter> to jump to next line                            |
      +-------+-------------------------------------------------------------+
      | Cell  | - <C-E>tn or <Tab> or RivTableNextCell, jump to next cell   |
      |       | - <C-E>tp or <S-Tab> or RivTablePrevCell, jump to prev cell |
      +-------+-------------------------------------------------------------+
      | Multi | - Multi Byte characters are OK                              |
      |       | - 一二三四五  かきくけこ                                    |
      +-------+-------------------------------------------------------------+

    See `Grid Tables`_ for syntax details.

    :NOTE: As ``visual-block insert`` be overrided and could not be used in 
           a table.

           You can use ``visual-block Replace`` instead. see ``:h v_b_r``

* Simple Table:

  Highlighted and folded.
  When folded, the numbers of rows and columns will be shown as '3+2'

  No auto formatting.

  ===========  ========================
        A Simple Table
  -------------------------------------
  Col 1        Col 2
  ===========  ========================
  1             row 1        
  2             row 2        
  3             - first line row 3
                - second line of row 3
  ===========  ========================

  See `Simple Tables`_ for syntax details.


Publish
~~~~~~~

Convert rst files to html/xml/latex/odt/... 
(Some command wrapper, docutils_ required)

* Commands:

  + Convert to Html

    - ``:Riv2HtmlIndex``  ``<C-E>wi``
      browse the html index page.
    - ``:Riv2HtmlFile``  ``<C-E>2hf``
      convert to html file.
  
    - ``:Riv2HtmlAndBrowse``  ``<C-E>2hh``
      convert to html file and browse. 
      Default is 'firefox'
  
      The browser is set by `g:riv_web_browser`_, default is ``firefox``
  
    - ``:Riv2HtmlProject`` ``<C-E>2hp`` converting whole project into html.
      And will ask you to copy all the file with extension in '`g:riv_file_link_ext`_' 
  
  + ``:Riv2Odt`` ``<C-E>2oo`` convert to odt file and browse by ft browser
  
    The file browser is set with '`g:riv_ft_browser`_'. 
  
  + ``:Riv2Xml`` ``<C-E>2xx`` convert to xml file and browse by web browser
  + ``:Riv2S5`` ``<C-E>2ss`` convert to s5 file and browse by web browser
  + ``:Riv2Latex`` ``<C-E>2ll`` convert to latex file and edit in vim
  
* Options:

  + If you have installed Pygments_ , code will be highlighted
    in html , as the syntax highlight style sheet have been embedded
    in it by Riv.

    You can change the style sheet with '`g:riv_html_code_hl_style`_'
    
    - Syntax highlight for other formatting are not supported yet.

  + Some misc changing have been done on the style sheet for better view in html.
    
    The ``literal`` and ``literal-block``'s background have been set to '#eeeeee'.
  + To add some args while converting.

    `g:riv_rst2html_args`_ , `g:riv_rst2latex_args`_ and Etc. can be used.

  + Output files path

    - For the files that are in a project. 
      The path of converted files by default is under ``build_path`` of your project directory. 
  
      1. Default is ``_build``
      2. To change the path. Set it in your vimrc::
        
           " Assume you have a project name project 1
           let project1.build_path = '~/Documents/Riv_Build'
    
      3. Open the build path: ``:Riv2BuildPath`` ``<C-E>2b``
      4. Local file link converting will be done. 
         See `local file link converting`_ for details.
  
    - For the files that not in a project.  
      '`g:riv_temp_path`_' is used to determine the output path
  


:NOTE: When converting, It will first try ``rst2xxxx2.py`` , then try ``rst2xxxx.py``

       You'd better install the package of python 2 version. 

       And make sure it's in your ``$PATH``

       Otherwise errors may occur as py3 version uses 'bytes'.


Riv 
---

Following features provides more functions for rst documents.

* You can change some setting for a better working with Sphinx_.
* Project_, Scratch_, Helpers_ are extra function for managing rst documents.
* File_, Todos_ are extended syntax items for writing rst document.

Sphinx
~~~~~~

Riv can work with Sphinx (see `Sphinx Home`_ ).

- For now, you can use Cross-referencing  document ``:doc:`xxx``` 
  and downloadable file ``:download:`xxx``` to jump to that document.
  With setting `g:riv_file_link_style` to 2.

  The Cross-referencing arbitrary locations ``:ref:`xxx``` 
  are not supported yet.

- To work with other master_doc and source_suffix, 
  like 'main.txt' instead of 'index.rst'

  Define the global '`g:riv_master_doc`_' and '`g:riv_source_suffix`_'
  or define 'master_doc' and 'source_suffix' in your project.

- There are no wrapper for making command of Sphinx.
  You should use ``:make html`` by your own.

  And you can view the index page by ``:Riv2HtmlIndex`` or ``<C-E>wi``


Project
~~~~~~~

Project is a place to hold your rst documents. 

Though you can edit reStructuredText documents anywhere.
There are some convenience with projects.

File_
    Write documents and navigating with local file link. 
Publish_
    Convert whole project to html, and view them as wiki.
Todos_ 
    Manage all the todo items in a project
Scratch_ 
    Writing diary in a project

* Global Commands:

  + ``:RivIndex`` ``<C-E>ww`` to open the first project index.
  + ``:RivAsk`` ``<C-E>wa`` to choose one project to open.

* All projects are in `g:riv_projects`_, 

  + Define a project with a dictionary of options,
    If not defined, it will have the default value ::

      let project1 = { 'path': '~/Dropbox/rst',}
      let g:riv_projects = [project1]

  + To add multiple projects ::

      let project2 = { 'path': '~/Dropbox/rst2',}
      let g:riv_projects = [project1, project2]

File
~~~~

The link to edit local files.  ``non-reStructuredText syntax``

As reStructuredText haven't define a pattern for local files currently.

Riv provides some convenient way to link to other local files in
the rst documents. 

* For linking with local file in vim easily,
  The filename with extension , 
  like ``xxx.rst``  ``~/Documents/xxx.py``,
  will be highlighted and linked, only in vim.

  And you can disable highlighting it with 
  setting '`g:riv_file_ext_link_hl`_' to 0.

* Two types for linking file while converting to other format.
  (works for document in project only.)

  :MoinMoin: use ``[[xxx]]`` to link to a local file.
  :Sphinx: use ``:doc:`xxx``` and ``:download:`xxx.rst``` to link to local
           file and local document.

           See Sphinx_Role_Doc_.
           
           It will be not changed to link with Riv.
           You'd better use it with Sphinx's tool set.

  + You can switch style with '`g:riv_file_link_style`_'

    - when set to 1, ``MoinMoin``: 
    
      Words like ``[[xxx]]`` ``[[xxx.vim]]`` will be detected as file link. 

      Words like ``[[xxx/]]' will link to ``xxx/index.rst``

      Words like ``[[/xxxx/xxx.rst]]`` 
      will link to ``DOC_ROOT/xxx/xxx.rst``

      Words like ``[[~/xxx/xxx.rst]]``  ``[[x:/xxx/xxx.rst]]``
      will be considered as external file links

      Words like ``[[/xxxx/xxx/]]`` ``[[~/xxx/xxx/]]`` 
      will be considered as external directory links, 
      and link to the directory.

    - when set to 2, ``Sphinx``:

      Words like ``:doc:`xxx.rst``` ``:doc:`xxx.py``` ``:doc:`xxx.cpp``` will be detected as file link.

      NOTE: words like ``:doc:`xxx/``` are illegal in sphinx, You should use ``:doc:`xxx/index```  , 
      and link to ``xxx/index.rst``

      Words like ``:doc:`/xxxx/xxx.rst```
      will link to ``DOC_ROOT/xxxx/xxx.rst``
    
      Words like ``:download:`~/xxx/xxx.py``` ``:download:`/xxx/xxx.py``` ``:download:`x:/xxx.rst```
      will be considered as external file links

      Words like ``:download:`~/xxx/xxx/``` 
      will be considered as external directory links, 
      and link to the directory.

      You can add other extensions with '`g:riv_file_link_ext`_'.

    - when set to 0, no local file link.
    - default is 1.

  
  :NOTE: **Difference between extension and link style.**

         The ``[[/xxx]]`` and ``:doc:`/xxx``` 
         are linked to Document Root ``DOC_ROOT/xxx.rst``
         both with MoinMoin and sphinx style(?).

         But the ``/xxx/xxx.rst`` detected with extension
         will be linked to ``/xxx/xxx.rst`` in your disk 

* The file links are highlighted. See `Cursor Highlighting`_
* To delete a local file in project.

  ``:RivDelete`` ``<C-E>df``
  it will also delete all reference to this file in ``index.rst`` of the directory.

Local File Link Converting
""""""""""""""""""""""""""
       
As the local file link is not the default syntax in reStructuredText.
The links need converting before Publish_.

And it's only converted for rst file in a Project_.

Those detected local file link will be converted to an embedded link. 
in this form::

 `xxx.rst <xxx.html>`_ `xxx.py <xxx.py>`_

:NOTE: link converting in a table will make the table error format.
       So you'd better convert it to a link manually.
       Use ``:RivCreateLink`` or ``<C-E>il`` to 
       create it manually. ::
   
           file.rst_

           .. _file.rst:: file.html   

For now it's overhead with substitute by a temp file.
A parser for docutils_ is needed in the future.

And for Sphinx_ users.
You should use Sphinx's tool set to convert it.

Scratch
~~~~~~~
  
Scratch is a place for writing diary or notes.

* ``:RivScratchCreate`` ``<C-E>sc``
  Create or jump to the scratch of today.

  Scratches are created auto named by date in '%Y-%m-%d' format.

* ``:RivScratchView`` ``<C-E>sv``
  View Scratch index.

  The index is auto created. Separate scratches by years and month
  
  You can change the month name using 
  '`g:riv_month_names`_'. 


Scratches will be put in scratch folder in project directory.
You can change it with 'scratch_path' of project setting ,default is 'Scratch'::
    
    " Use another directory
    let project1.scratch_path = 'Diary'
    " Use absolute path, then no todo helper and no converting for it.
    let project1.scratch_path = '~/Documents/Diary'

Todos
~~~~~

Todo items to keep track of todo things.  ``non-reStructuredText syntax``

It is Todo-box or Todo-keywords in a bullet/enumerated/field list.

* Todo Box:

  + [ ] This is a todo item of initial state.
  + [o] This is a todo item that's in progress.
  + [X] This is a todo item that's finished.

  + You can change the todo box item by '`g:riv_todo_levels`_' ,


* Todo Keywords:
    
  Todo Keywords are also supported

  + FIXED A todo item of FIXME/FIXED keyword group.
  + DONE 2012-06-13 ~ 2012-06-23 A todo item of TODO/DONE keyword group.
  + START A todo item of START/PROCESS/STOP keyword group.
  + You can define your own keyword group for todo items with '`g:riv_todo_keywords`_'

* Date stamps:

  Todo item's start or end date.

  + [X] 2012-06-23 A todo item with date stamp
  + Double Click or ``<Enter>`` or ``:RivTodoDate`` on a date stamp to change date. 

    If you have Calendar_ installed , it will use it to choose date.

    .. _Calendar: https://github.com/mattn/calendar-vim
  + It is controlled by '`g:riv_todo_datestamp`_'

    - when set to 0 , no date stamp
    - when set to 1 , no initial date stamp ,
      will add a finish date stamp when it's done.

      1. [X] 2012-06-23 This is a todo item with finish date stamp, 

    - when set to 2 , will initial with a start date stamp.
      And when it's done , will add a finish date stamp.

      1. [ ] 2012-06-23 This is a todo item with start date stamp
      2. [X] 2012-06-23 ~ 2012-06-23  A todo item with both start and finish date stamp. 
  
    - Default is 1

* Priorities:

  The Priorities of todo item

  + [ ] [#A] a todo item of priority A
  + [ ] [#C] a todo item of priority C
  + Double Click or ``<Enter>`` or ``:RivTodoPrior`` on priority item 
    to change priority. 
  + You can define the priority chars by '`g:riv_todo_priorities`_'

* Actions:

  Add Todo Item
  
  + Use ``:RivTodoToggle`` or ``<C-E>ee`` to add or switch the todo progress.
    
    Change default todo group by '`g:riv_todo_default_group`_'


  + Use ``:RivTodoType1`` ``<C-E>e1`` ... ``:RivTodoType4`` ``<C-E>e4`` 
    to add or change the todo item by group. 
  + Use ``:RivTodoAsk`` ``<C-E>e``` will show an keyword group list to choose.

  Change Todo Status

  + Double Click or ``<Enter>`` in the box/keyword to switch the todo progress.
  

 
  Delete Item 

  + Use ``:RivTodoDel`` ``<C-E>ex`` to delete the whole todo item

  Helper

  + Use ``:RivTodoHelper`` or ``<C-E>ht`` to open a `Todo Helper`_
  
* Folding Info:

  When list is folded. 
  The statistics of the child items (or this item) todo progress will be shown.
* Highlights:
   
  Todo items are highlighted.

  As it's not the reStructuredText syntax. 
  So highlighted in vim only.

  When cursor are in a Todo Item , current item will be highlighted.

Helpers
~~~~~~~

A window for helping project management.

* Basic Commands:

  + ``/`` to enter search mode.
    Search item matching inputing, 
    ``<Enter>`` or ``<Esc>`` to quit search mode.
      
    Set '`g:riv_fuzzy_help`_' to 1 to enable fuzzy searching in helper.

  + ``<Tab>`` to switch content, 
  + ``<Enter>`` or Double Click to jump to the item.
  + ``<Esc>`` or ``q`` to quit the window

Todo Helper
"""""""""""

A helper to manage todo items of current project.
When current document is not in a project, will show current file's todo items.

+ ``:RivHelpTodo`` or ``<C-E>ht``
  Open Todo Helper.
  Default is in search mode.

File Helper
"""""""""""

A helper to show rst files of current directory.

Also indicating following files if exists::

    'ROOT': 'RT' Root of project
    'INDX': 'IN' Index of current directory
    'CURR': 'CR' Current file
    'PREV': 'PR' Previous file

+ ``:RivHelpFile`` or ``<C-E>hf``
  Open File Helper.
  Default is in normal mode.




Section Helper
""""""""""""""
A helper showing current document section numbers

+ ``:RivHelpSection`` or ``<C-E>hs``
  Open Section Helper.
  Default is in normal mode.

Appendix
========

Commands
--------

The mappings and commands are described in each section.

Default leader map for Riv is ``<C-E>``.
You can change it by following options.
  
  + '`g:riv_global_leader`_' : Leader map for Riv global mapping.
  + '`g:riv_buf_leader`_' : Leader map in reStructuredText buffers only, Normal/Visual Mode.
  + '`g:riv_buf_ins_leader`_' : Leader map in reStructuredText buffers only, Insert Mode.
  + To remap a single mapping, use ``map`` in your vimrc::
        
        map <C-E>wi    :RivIndex<CR> 

Besides mappings, you can use 'Riv' menus.

**TODO**: A command and mapping table.


Options
-------

+-------------------------------+----------------------------------+--------------------------------------------------------+
| **Name**                      | **Default**                      | **Description**                                        |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| **Main**                      |                                  |                                                        |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_default`              | {...}                            | The dictionary contain all riv runtime variables.      |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_projects`             | []                               | The list contain your project's settings.              |
|                               |                                  |                                                        |
|                               |                                  | Defaults are::                                         |
|                               |                                  |                                                        |
|                               |                                  |   'path'               : '~/Documents/Riv'             |
|                               |                                  |   'build_path'         : '_build'                      |
|                               |                                  |   'scratch_path'       : 'Scratch'                     |
|                               |                                  |   'source_suffix'      : `g:riv_source_suffix`_        |
|                               |                                  |   'master_doc'         : `g:riv_master_doc`_           |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| Commands_                     |                                  |                                                        |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_global_leader`        | '<C-E>'                          | Leader map for Riv global mapping.                     |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_buf_leader`           | '<C-E>'                          | Leader map in reStructuredText buffers only.           |
|                               |                                  |                                                        |
|                               |                                  | Normal/Visual Mode                                     |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_buf_ins_leader`       | '<C-E>'                          | Leader map in reStructuredText buffers only.           |
|                               |                                  |                                                        |
|                               |                                  | Insert Mode                                            |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| File_                         |                                  |                                                        |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_master_doc`           | 'index'                          | The master rst document for each directory in project. |
|                               |                                  |                                                        |
|                               |                                  | You can set it for each project.                       |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_source_suffix`        | '.rst'                           | The suffix of rst document.                            |
|                               |                                  |                                                        |
|                               |                                  | You can set it for each project.                       |
|                               |                                  |                                                        |
|                               |                                  | Also for all files with the suffix,                    |
|                               |                                  | filetype will be set to 'rst'                          |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_file_link_ext`        | 'vim,cpp,c,                      | The file link with these extension will be recognized. |
|                               | py,rb,lua,pl'                    |                                                        |
|                               |                                  | These files will be copied when converting a porject.  |
|                               |                                  |                                                        |
|                               |                                  | These files along with ,'rst,txt' and                  |
|                               |                                  | source_suffixs used in your project will               |
|                               |                                  | be highlighted.                                        |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_file_ext_link_hl`     | 1                                | Syntax highlighting for file with extensions           |
|                               |                                  | in `g:riv_file_link_ext`_.                             |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_file_link_invalid_hl` | 'ErrorMsg'                       | Cursor Highlight Group for non-exists file link.       |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_file_link_style`      | 1                                | The file link style.                                   |
|                               |                                  |                                                        |
|                               |                                  | - 1:``MoinMoin`` style::                               |
|                               |                                  |                                                        |
|                               |                                  |    [[xxx]] => xxx.rst                                  |
|                               |                                  |    [[xxx/]] => xxx/index.rst                           |
|                               |                                  |    [[/xxx]] => DOC_ROOT/xxx.rst                        |
|                               |                                  |    [[xxx.vim]] => xxx.vim                              |
|                               |                                  |    ('vim' is in `g:riv_file_link_ext`_)                |
|                               |                                  |    [[~/xxx/xxx.rst]] => ~/xxx/xxx.rst                  |
|                               |                                  |                                                        |
|                               |                                  | - 2: ``Sphinx`` style::                                |
|                               |                                  |                                                        |
|                               |                                  |     :doc:`xxx` => xxx.rst                              |
|                               |                                  |     :doc:`xxx/index`  => xxx/index.rst                 |
|                               |                                  |                                                        |
|                               |                                  |     :download:`xxx.py` => xxx.py                       |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| Syntax_                       |                                  |                                                        |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_highlight_code`       | 'lua,python,cpp,                 | The language name                                      |
|                               | javascript,vim,sh'               | is the syntax name used by vim.                        |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_code_indicator`       | 1                                | Highlight the first column of code directives.         |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_link_cursor_hl`       | 1                                | Cursor's Hover Highlighting for links.                 |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_python_rst_hl`        | 0                                | Highlight ``DocString`` in python files                |
|                               |                                  | with rst syntax.                                       |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| Todos_                        |                                  |                                                        |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_todo_levels`          | " ,o,X"                          | The Todo levels for Todo-Box.                          |
|                               |                                  |                                                        |
|                               |                                  | Means ``[ ]``, ``[o]``, ``[X]`` by default.            |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_todo_priorities`      |                                  | The Todo Priorities for Todo-Items                     |
|                               | "ABC"                            |                                                        |
|                               |                                  | Only alphabetic or digits.                             |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_todo_default_group`   | 0                                | The default Todo Group for ':RivTodoToggle'            |
|                               |                                  |                                                        |
|                               |                                  | - 0 is the Todo-Box group.                             |
|                               |                                  | - 1 and other are the Todo-Keywords group.             |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_todo_datestamp`       | 1                                | The datestamp behavior for Todo-Item.                  |
|                               |                                  |                                                        |
|                               |                                  | - 0: no DateStamp                                      |
|                               |                                  | - 1: only finish datestamp                             |
|                               |                                  | - 2: both initial and finish datestamp                 |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_todo_keywords`        | "TODO,DONE;FIXME,FIXED;          | The Todo-Keywords groups.                              |
|                               | START,PROCESS,STOP"              |                                                        |
|                               |                                  | Each group is separated by ';',                        |
|                               |                                  | Each keyword is separated by ','.                      |
+-------------------------------+----------------------------------+--------------------------------------------------------+
|  Folding_                     |                                  |                                                        |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_fold_blank`           | 2                                | Folding blank lines in the end of the folding lines.   |
|                               |                                  |                                                        |
|                               |                                  | - 0: fold one blank line, show rest.                   |
|                               |                                  | - 1: fold all blank lines, show one if more than one.  |
|                               |                                  | - 2: fold all blank lines.                             |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_fold_level`           | 3                                | Folding more structure for document.                   |
|                               |                                  |                                                        |
|                               |                                  | - 0: 'None'                                            |
|                               |                                  | - 1: 'Sections'                                        |
|                               |                                  | - 2: 'Sections and Lists'                              |
|                               |                                  | - 3: 'Sections,Lists and Blocks'.                      |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_fold_section_mark`    | '.'                              | Mark to seperate the section numbers: '1.1', '1.1.1'   |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_fold_auto_update`     | 1                                | Auto Update folding whilst write to buffer.            |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_auto_fold_force`      | 1                                | Reducing fold level for editing large files.           |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_auto_fold1_lines`     | 5000                             | Lines of file exceeds this will fold section only      |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_auto_fold2_lines`     | 3000                             | Lines of file exceeds this will fold section and list  |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_fold_info_pos`        | 'right'                          | The position for fold info.                            |
|                               |                                  |                                                        |
|                               |                                  | - 'left', infos will be shown at left side.            |
|                               |                                  | - 'right', show infos at right side.                   |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| Publish_                      |                                  |                                                        |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_web_browser`          | 'firefox'                        | The browser for browsing html and web links.           |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_ft_browser`           | UNIX:'xdg-open', windows:'start' | The browser for opening files.                         |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_rst2html_args`        | ''                               | Extra args for converting to html.                     |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_rst2odt_args`         | ''                               | Extra args for converting to odt.                      |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_rst2xml_args`         | ''                               | Extra args for converting to xml.                      |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_rst2s5_args`          | ''                               | Extra args for converting to s5.                       |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_rst2latex_args`       | ''                               | Extra args for converting to latex.                    |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_temp_path`            | 1                                | The temp path for converting a file **NOT**            |
|                               |                                  | in a project.                                          |
|                               |                                  |                                                        |
|                               |                                  | - 0: put under the same directory of converting file.  |
|                               |                                  | - 1: put in the temp path of vim.                      |
|                               |                                  | - 'PATH': to the path if it's valid.                   |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_html_code_hl_style`   | 'default'                        | The code highlight style for html.                     |
|                               |                                  |                                                        |
|                               |                                  | - 'default', 'emacs', or 'friendly':                   |
|                               |                                  |   use pygments_'s relevant built-in style.             |
|                               |                                  | - 'FULL_PATH': use your own style sheet in path.       |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| Insert_                       |                                  |                                                        |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_i_tab_pum_next`       | 1                                | Use ``<Tab>`` to act as ``<C-N>`` in insert mode when  |
|                               |                                  | there is a popup menu.                                 |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_i_tab_user_cmd`       | ''                               | User command to hook ``<Tab>`` in insert mode.         |
|                               |                                  |                                                        |
|                               |                                  | let g:riv_i_tab_user_cmd =                             |
|                               |                                  | "\<c-g>u\<c-r>=snipMate#TriggerSnippet()\<cr>"         |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_i_stab_user_cmd`      | ''                               | User command to hook ``<S-Tab>`` in insert mode.       |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_ignored_imaps`        | ''                               | Use to disable mapping in insert mode.                 |
|                               |                                  |                                                        |
|                               |                                  | ``let g:riv_ignored_imaps = "<Tab>,<S-Tab>"``          |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| **Miscs**                     |                                  |                                                        |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_create_link_pos`      | '$'                              | Link Target's position when created.                   |
|                               |                                  |                                                        |
|                               |                                  | - '.' : below current line.                            |
|                               |                                  | - '$' : append at end of file.                         |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_month_names`          | 'January,February,March,April,   | Month Names for Scratch Index                          |
|                               | May,June,July,August,September,  |                                                        |
|                               | October,November,December'       |                                                        |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_section_levels`       | '=-~"''`'                        | The section line punctuations for section title.       |
|                               |                                  |                                                        |
|                               |                                  | **NOTE**                                               |
|                               |                                  | Use ``''`` to escape ``'`` in literal-quote ``'xxx'``. |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_content_format`       | '%i%l%n %t'                      | The format for content table.                          |
|                               |                                  |                                                        |
|                               |                                  | - %i is the indent of each line                        |
|                               |                                  | - %l is the list symbol '+'                            |
|                               |                                  | - %n is the section number                             |
|                               |                                  | - %t is the section title                              |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_fuzzy_help`           | 0                                | Fuzzy searching in helper.                             |
+-------------------------------+----------------------------------+--------------------------------------------------------+
| _`g:riv_auto_format_table`    | 1                                | Auto formating table when leave Insert Mode            |
+-------------------------------+----------------------------------+--------------------------------------------------------+




.. _Sphinx_role_doc: http://sphinx.pocoo.org/markup/inline.html#role-doc
.. _Org-Mode: http://orgmode.org/
.. _reStructuredText: http://docutils.sourceforge.net/rst.html
.. _Syntastic: https://github.com/scrooloose/syntastic
.. _Vundle: https://www.github.com/gmarik/vundle
.. _docutils: http://docutils.sourceforge.net/
.. _pygments: http://pygments.org/
.. _riv_log: https://github.com/Rykka/riv.vim/blob/master/doc/riv_log.rst
.. _riv_todo: https://github.com/Rykka/riv.vim/blob/master/doc/riv_todo.rst
.. _Quickstart With Riv:
   https://github.com/Rykka/riv.vim/blob/master/doc/riv_quickstart.rst
.. _A ReStructuredText Primer: http://docutils.sourceforge.net/docs/user/rst/quickstart.html
.. _Quick reStructuredText: http://docutils.sourceforge.net/docs/user/rst/quickref.html
.. _Grid tables: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#grid-tables
.. _Simple Tables: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#simple-tables

.. _reStructuredText Specification: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html
.. _reStructuredText cheatsheet: http://docutils.sourceforge.net/docs/user/rst/cheatsheet.txt


.. _Sphinx Home: http://sphinx.pocoo.org/
