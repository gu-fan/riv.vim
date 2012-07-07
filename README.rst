Intro
=====

:Author: Rykka G.Forest
:Date:   2012-07-07 12:31:41
:Version: 0.68 
:Github: https://github.com/Rykka/riv.vim

**Riv** is a vim plugin for managing and writing reStructuredText_ documents.
Short for 'reStructuredText in Vim'. 

It is for people either want to manage documents in a wiki way,
or writing documents in a neat way.

.. _reStructuredText: http://docutils.sourceforge.net/rst.html

Screenshot
----------

**Overview of this Intro**

.. image::  http://i.minus.com/jqyQGm8G9gO9h.png

**The Folding infos**

.. image::  http://i.minus.com/ibeAAXZxjcyoZ5.png



Features
--------
 
These features are for all reStructuredText files.

 :Sections_: Section level and section number auto detected. 
 :Lists_:    Auto Numbered and auto leveled bullet and enumerated list.
 :Blocks_:   Highlighting and folding blocks.
 :Links_:    Jumping with links.
 :Table_:    Auto formatted table.
 :Folding_:  Fold document by document structures (Section/List/Block).
 :Indent_:   Improved indentation 
 :Insert_:   Improvment of some mapping in insert mode.
 :Syntax_:   Improved syntax file. 
 :Publish_:  some wrapper to convert rst files to html/xml/latex/odt/... 
            (require python docutils package )


These features are for the Riv Project. 

 :Project_:  Manage your reStructuredText documents in a wiki way.
 :File_:     Links to local file in rst documents. 
 :Scratch_:  A place for writing diary or hold idea and thoughts.
 :Todos_:    Writing todo lists in reStructuredText documents .
 :Helpers_:  A help window for showing and doing something.

             a. `Todo Helper`_: Managing todo items of project.

* To Install: see `Install`_
* To Start: see `Instruction`_

Install
-------
* Using Vundle_  (Recommend)

  Add this line to your vimrc::
 
    Bundle 'Rykka/riv.vim'

.. _Vundle: https://www.github.com/gmarik/vundle

* Using downloaded file. 
  Just extract to your ``.vim`` folder .

:NOTE: Make sure the your .vim folder in option ``runtimepath`` 
       is before the $VIMRUNTIME. 

       Otherwise the syntax/indent files for rst file will using the vim built-in one.

* Recommend plugins: 

  + Syntastic_  for syntax checking of rst files.
    (require python docutils package )

    .. _Syntastic: https://github.com/scrooloose/syntastic

Issues
------

* Currently it's a developing version. 
  So things may change quickly.Keep up-to-date.

* Both bug reports and feature request are welcome. 
  Please Post issues at https://github.com/Rykka/riv.vim/issues


Todo
---------

Prev
~~~~

See Changelog in doc/riv_log.rst riv_log_

This
~~~~~

Things todo in this version.

* 0.68:
    
  :Patterns:  DONE 2012-07-07 a2334f7b_ Rewrite the pattern and syntax patterns part. 
  :Todos_:    DONE 2012-07-07 a2334f7b_ Rewrite todo and todo helper.Add Todo Priorities. 
  :Syntax_:   DONE 2012-07-07 a2334f7b_ Cursor highlight will highlight the todo item 
  :Syntax_:   DONE 2012-07-07 a2334f7b_ Cursor highlight will check it's valid file
  :Lists_:    DONE 2012-07-07 0a959662_ Add list types 0 ~ 4 
  :Todos_:    DONE 2012-07-07 142b6c49_ Add Prior in helper


.. _142b6c49: 
    https://github.com/Rykka/riv.vim/commit/142b6c496b5050150a6b77eeed48e0ade79fc329

.. _0a959662: 
    https://github.com/Rykka/riv.vim/commit/0a95966247048e11d947fdeb4a2189e17c00d791
.. _a2334f7b:
    https://github.com/Rykka/riv.vim/commit/a2334f7b98e9ce83c06d95e7552a13ac6c2c1cd4

Next 
~~~~~

See doc/riv_todo.rst riv_todo_

.. _riv_log: https://github.com/Rykka/riv.vim/blob/master/doc/riv_log.rst
.. _riv_todo: https://github.com/Rykka/riv.vim/blob/master/doc/riv_todo.rst

----

Instruction
===========

* How to use?

  + If you are not familiar with reStructuredText, see QuickStart_

  + For writing documents, See detail instruction in `reStructuredText Guide`_

  + For managing documents, See detail instruction in `Riv Guide`_

* About the mapping

  The mapping and commands are described in each section.

  Default leader map for Riv is ``<C-E>``.
  You can change it by following options.
  
  + ``g:riv_global_leader`` : leader map for Riv global mapping.

    - ``:RivIndex`` ``<C-E>ww`` to open the project index.
    - ``:RivAsk`` ``<C-E>wa`` to choose one project to open.
    - ``:RivScratchCreate`` ``<C-E>cc`` Create or jump to the scratch of today.
    - ``:RivScratchView`` ``<C-E>cv`` View Scratch index.

  + ``g:riv_buf_leader`` : leader map for reStructuredText buffers.
  + ``g:riv_buf_ins_leader`` : leader map for reStructuredText buffers's insert mode.
  + To remap one mapping, use the ``map`` commands ::
        
        map <C-E>wi    :RivIndex<CR> 

.. _QuickStart: http://docutils.sourceforge.net/docs/user/rst/quickstart.html

reStructuredText Guide
----------------------

Following features are in all reStructuredText files.

When editing an reStructuredText document (``*.rst`` ), 

These settings will be automatically on. 

:NOTE: make sure ``filetype plugin indent on`` and ``syntax on`` is in your vimrc

Sections 
~~~~~~~~~

Sections are basic document structure.

Section titles are highlighted. 

Section levels and numbers are auto detected.
Sections are folded by it's section level, 
and showing it's section number (chapter number) as fold info.


* Actions:

  Normal and Insert Mode

  + Create: 

    Use ``:RivTitle1`` ``<C-E>s1`` ...  ``:RivTitle6`` ``<C-E>s6`` ,
    To create level 1 to level 6 section title from current word.

    If it's empty, you will be asked to input one.

    Section title created by Riv is ``underline`` only, 
    To add an ``overline``, you should copy the ``underline`` and paste it there.

  + Folding: 

    Pressing ``<Enter>`` or double clicking on section title will toggle the folding
    of the section.

    The section number will be shown when folded.

  + Jumping:

    Clicking on the section reference will bring you to the section title.

    e.g. Features_ link will bring you to the `Feature` Section (in vim)

* Options:

  + Although you can define a section title with most punctuations
    (any non-alphanumeric printable 7-bit ASCII character). 

    Riv use following punctuations for titles: 

    ``= - ~ " ' ``` , (HTML has 6 levels)

    you can change it with ``g:riv_section_levels``

  + Section number are seperated by ``g:riv_fold_section_mark``

    default is ``"-"``


See `reStructuredText sections`__ for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#sections

Lists
~~~~~

There are several List items in reStructuredText.

All are highlighted. Most are folded.

The bullet and enumerated list are auto level and auto numbered.

* Auto Level:

  When you shift the list or add child/parent list , 
  the type of list item will be changed automatically.

  The level sequence is as follows:  

  ``* + - 1. A. a. I. i. 1) A) a) I) i) (1) (A) (a) (I) (i)``
  
  You can use any of them as a list item, but the changing sequence is hard coded.

  This means when you shift right or add a child list with a ``-`` list item, 
  the new one will be ``1.``

  And if you shift left or add a parent list item with a ``a.`` list item , 
  the new one will be ``A.``

* Auto Number:

  When you adding a new list or shifting an list, 
  these list items will be auto numbered.

* Actions:

  + Shifting:

    Normal and Visual Mode:

    - Shift right: ``>`` ``:RivShiftRight`` or ``<C-ScrollWheelDown>`` (unix only) 
  
      Shift rightwards, And add a level of list.
  
    - Shift left: ``<`` ``:RivShiftLeft`` or ``<C-ScrollWheelUp>``  (unix only) 

      Shift leftwards, And minus a level of list.

    - Format:   ``=``
      Format list's level and number.

    :NOTE: The shifting indentation is dynamic. 
           if it's a list item,
           When shifting right, it will indent to the list item's sub list
           When shifting left, it will indent to the list item's parent list

           otherwise it will use ``shiftwidth`` 
           and check if it's in a list item to fix the indentation

    :NOTE: As commands not working in Select Mode.

           You should make sure the vim option ``'selectmode'`` not contain ``mouse``,
           in order to use mouse to start visual mode. 

           Cause this option will be changed by ``:behave mswin``.

    Insert Mode Only: 
  
    - ``<Tab>`` when cursor is before an end of a list item.
      will shift right.
    
    - ``<S-Tab>`` when cursor is before an end of a list item.
      will shift left.

  + New List:
  
    Insert Mode Only: 

    - ``<CR>\<KEnter>`` (enter key and keypad enter key)
      Insert the content of this list.
  
      To insert content in new line of this list item. add a blank line before it.
  
    - ``<C-CR>\<C-KEnter>`` 
      Insert a new list of current list level
    - ``<S-CR>\<S-KEnter>`` 
      Insert a new list of current child list level
    - ``<C-S-CR>\<C-S-KEnter>`` 
      Insert a new list of current parent list level
    - When it's a field list, only the indent is inserted.
  
  + Change List Type:

    Normal and Insert Mode:
    
    - ``:RivListType0`` ``<C-E>l``` ... ``:RivListType4`` ``<C-E>l4``
      Change or add list item symbol of type.
      
      The list item of each type is:: 
      
        '*' , '1.' , 'a.' , 'A)' ,'i)'

      :NOTE:  You should act this on a new list or list with no sub line.

              As list item changes, the indentation of it is changed.
              But this action does not change the sub items's indent.

              To change a list and it's sub item 
              with indentation fix , use shifting: ``>`` or ``<``.
             
    - ``:RivListDelete`` ``<C-E>lx``
      Delete current list item symbol



List items
""""""""""

Intro of the reStructuredText lists.

* Bullet Lists

  List item start with ``*,+,-`` , 
  **NOT** include ``•‣⁃`` as they are unicode chars.

  It is highlighted, folded. And auto leveled.

  See `Bullet Lists`__  for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#bullet-lists

1. Enumerated Lists

   A sequenced enumerator. like arabic numberl , alphabet characters , Roman numerals
   with the formating type ``#.`` ``(#)`` ``#)``

   It is highlighted, folded. auto numbered and auto leveled.
    
   See `Enumerated Lists`__  for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#enumerated-lists

Definition Lists
    A list with a term and an indented definition.

    It is highlighted, not folded.

    See `Definition Lists`__  for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#definition-lists

:Field Lists:   A List which field name is suffix and 
                prefix by a single colon ``:field:``

                It is highlighted, and folded.

                Bibliographic Fields items are highlighted in another color.

                See `Field Lists`__  for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#field-lists

* Option Lists

  A list for command-line options and descriptions

  -a         Output all.
  -b         Output both (this description is
             quite long).

  It is highlighted , not folded.

  See `Option Lists`__  for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#option-lists


:NOTE: **A reStructuredText syntax hint**
    
       Most reStructuredText items is seperated by blank line. 
       Include sections, lists, blocks, paragraphs ...

       The reStructuredText is indent sensitive.

       To contain a sublist or second paragraph or blocks in a list , 
        
       A blank line is needed and the the item should 
       lines up with the main list content's left edge.::

        * parent list

          second paragraph

          + sub list

           - WRONG! this list is not line up with conten's left edge, 
             so it's in a block quote
             
              - WRONG! this list is in a block quote too.

          + sub list2
            - TOO WRONG! 
              it's not a sub list of prev list , it's just a line in the content. 

          + sub list 3
             - STILL WRONG!
               it's not a sub list , but it's a list in a definition list

          + sub list 4

            - RIGHT! this one is sub list of sub list4.


       and following enumerated lists, definition lists , field lists and option lists.


Blocks
~~~~~~

The Block elements of the document.

* Literal Blocks:
    
  Indented liteal Blocks ::

   This is a Indented Literal Block.
   No markup processing is done within it

   for a in [5,4,3,2,1]:   # this is program code, shown as-is
          print a
   print "it's..."

  Quoted literal blocks ::

   > This is a Indented Literal Block.
   > It have a punctuation '' at the line beginning.
   > The quoting characters are preserved in the processed document

  It's highlighted and folded.

  See `Literal Blocks`__ for syntax details.
    
__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#literal-blocks

* Line Blocks::

    | It should have '|' at the begining
    | It can have multiple lines

  | This is a line block
  | This is the second line

  It's highlighted and folded. 

  :Note: for speed considering , the blank line between line blocks are ignored
         as they are a single line block.

  See `Line Blocks`__ for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#line-blocks

* Block Quotes:

    Block quote are indented paragraphs.

    This is a block quote

  Block quotes are not highlighted and not folded, 
  cause it contains other document elements.

    This is a blockquote with attribution

    -- Attribution

  The attribution: a text block beginning with "--", "---".::

    -- Attribution
    
  The attribution is highlighted.

  See `Block Quotes`__ for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#block-quotes

* Doctest Blocks:

>>> print 'this is a Doctest block'
this is a Doctest block
    
  It's highlighted but not folded.

  See `Doctest Blocks`__ for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#doctest-blocks

* Explicit Markup Blocks::
    
    start with '..' and a whitespace.


  The explicit markup syntax is used for footnotes, citations, hyperlink targets,
  directives, substitution definitions, and comments.

  It's folded , and it's highlighted depending on it's role.

  See `Explicit Markup Blocks`__ for syntax details.

  And for the ``code`` directives, syntax highlighting is on. 
  See `code syntax highlighting`_  for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#explicit-markup-blocks

Inline Markup
~~~~~~~~~~~~~~

Inline Markup are highlighted.

Maybe an option for conceal in the future.

See `inline markup`__ for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#inline-markup

Links
~~~~~

Links are highlighted in syntax and highlighted with `cursor highlighting`_.

And you can jumping with links.

* Actions:

  Jumping(Normal Mode):

  + Clicking on links will jump there.
    
    - A web link ( www.xxx.xxx or http://xxx.xxx.xxx or xxx@xxx.xxx ): 

      Open web browser. 

      if it's an email address ``xxx@xxx.xxx`` will add ``mailto:`` 

      the browser is set by ``g:riv_web_browser``, default is ``firefox``

    - A internal reference ( ``xxx_ [xxx]_ `xxx`_`` ): 

      Find and Jump to the target.

      if it's an anonymous reference ``xxx__``,

      will jump to the nearest anonymous target.

    - A internal targets (``.. [xxx]:  .. _xxx:``)

      Find and Jump to the nearest reference , backward.

    - A local file (if ``g:riv_localfile_linktype`` is not 0):

      Edit the file. 

      To split editing , you could split the document first:
      ``<C-W><C-S>`` or ``<C-W><C-V>``

  Navigate(Normal Mode):
    
  + ``<Tab>/<S-Tab>`` will navigate to next/prev link in document.
   
  Create (Normal and Insert):

  + ``:RivCreateLink`` ``<C-E>il``
    create a link from current word. 

    If it's empty, you will be asked to input one.

  + ``:RivCreateFoot`` ``<C-E>if``
    create a auto numbered footnote. 
    And append the footnote target to the end of file.

:NOTE: **A reStructuredText syntax hint**

       Links are hyperlink references and hyperlink targets.
        
       The hyperlink references are indicated by a trailling underscore
       or stanalone hyperlinks::

            xxx_            A reference
            `xxx xxx`_      Phase reference
            xxx__           Anonymous referces, links to next anonymous targes
            `Python home page <http://www.python.org>`_ 
                            Embedded URIs
            [xxx]_          A footnote or citation reference
            www.xxxx.xxx   http://xxx.xxx.xxx
                            Standalone hyperlinks
            xxx@ccc.com     Email adress as mailto:xxx@ccc.com

       See `Hyperlink References`_ for syntax details.

       There are implicit hyperlink targets and explicit hyperlink targets.

       Implicit hyperlink targets are generated by section titles, 
       footnotes, and citations

       Explicit hyperlink targets are defined as follows::

        .. _hyperlink-name: link-block
        .. __: anonymous-hyperlink-target-link-block
        _`an inline hyperlink target`
            
       See `Hyperlink targets`_ for syntax details.

.. _Hyperlink References:
   http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#hyperlink-references

.. _Hyperlink targets:
   http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#hyperlink-targets

Table
~~~~~

Tables are highlighted and folded.

For Grid table, it is auto formatted.
(Currently require vim compiled with python. )

* Grid Table: 

  Highlighted and Folded.
  When folded, the numbers of rows and columns will be shown as '3x2'

  Can be autoformated. Only support equal columns each row (no span).

  + Actions:

    Insert Mode Only:

    To create a table , just insert ``| xxx |`` and press ``<Enter>``.

    It will be autoformatted after Leave Insert Mode 
    or pressing ``<Enter>`` or ``<Tab>`` ::

        +--------+-----------------------------------------------------------+
        | 4x2    | Grid Table                                                |
        +========+===========================================================+
        | Lines  | - <Enter> in column to add a new line of column           |
        |        | - This is the second line of in same row of table.        |
        +--------+-----------------------------------------------------------+
        | Rows   | <Enter> in seperator to add a new row                     |
        +--------+-----------------------------------------------------------+
        | Cells  | <Tab> and <S-Tab> in table will switch to next/prev cell  |
        +--------+-----------------------------------------------------------+


    +--------+-----------------------------------------------------------+
    | 4x2    | Grid Table                                                |
    +========+===========================================================+
    | Lines  | - <Enter> in column to add a new line of column           |
    |        | - This is the second line of in same row of table.        |
    +--------+-----------------------------------------------------------+
    | Rows   | <Enter> in seperator to add a new row                     |
    +--------+-----------------------------------------------------------+
    | Cells  | <Tab> and <S-Tab> in table will switch to next/prev cell  |
    +--------+-----------------------------------------------------------+

    See `Grid Tables`__ for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#grid-tables

* Simple Table:

  Highlighted and folded.
  When folded, the numbers of rows and columns will be shown as '3+2'

  No auto formatting. ::

      ===========  ========================
            A 6x2 Simple Table
      -------------------------------------
      Col 1        Col 2
      ===========  ========================
      1             row 1        
      2             row 2        
      3             - first line row 3
                    - second line of row 3
      ===========  ========================


  ===========  ========================
        A 6x2 Simple Table
  -------------------------------------
  Col 1        Col 2
  ===========  ========================
  1             row 1        
  2             row 2        
  3             - first line row 3
                - second line of row 3
  ===========  ========================


    See `Simple Tables`__ for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#simple-tables

Folding 
~~~~~~~~

**Folding** is a vim feature to allow you to display a section as one line.

Riv will fold reStructuredText file with sections, lists, and blocks automatically.

* Actions (Normal Mode Only):

  + Open Folding: Pressing ``<Enter>`` or double clicking on folded lines 
    will open that fold. 

    use ``zo`` ``zO`` or ``zv`` will open it either.

    :NOTE: To use mouse to open or close fold anywhere. 
           ``set fdc=1``

  + Close Folding:  use ``zc`` or ``zC`` will close it.

    Also pressing ``<Enter>`` or double clicking the section title
    will close the section.

  + Update Folding: use ``zx`` or ``<C-E><Space>j``

    Folding will be auto updated after you write buffer to file.

  + Toggle Folding: use ``za`` or ``<C-E><Space><Space>`` 
  + Toggle all Folding: use ``zA`` or ``<C-E><Space>m``


* Extra Infos:
  When folded, some extra info of the item will be shown at the foldline.
  also the number of folded lines will be shown. See screenshot_

  + The sections_ will show it's section number
  + The lists_ will show todos_ progress : 
    ( 0 + 50 + 100+ 0 + 0 + 50 ) / 6 ≈ 33
  
    - [ ]  a todo box of start. 0%
    - [o]  a todo box of in progress. 50%
    - [X] 2012-06-29  a todo box of finish. 100%
    - TODO a todo/done keyword group of start. 0%
    - FIXME a fixme/fixed keyword group of start. 0%
    - PROCESS a start/process/stop keyword group of progress. 50%
  
  + The table_ will show it's rows and columns.
  
    +-------+----+
    | a     | b  |
    +-------+----+
    | c     | d  |
    +-------+----+
  
  + You can use ``g:riv_fold_info_pos`` to change the info position.
  
    - when set to ``left``, these info will be shown at left side.
    - default is ``right``
  
  
  
* Options:

  + To show the blank lines in the end of a folding, use ``g:riv_fold_blank``.

    - when set to 2 , will fold all blank lines.
    - when set to 1 , will fold all blank lines,
      but showing one blank line if there are some.
    - when set to 0 , will fold one blank line , 
      but will showing the rest.
    - default is 2

  + For large files. calculate folding may cost time. 
    So there are some options about it.

    - ``g:riv_fold_level`` set which structures to be fold. 
    
      1. when set to 3 , means 'sections,lists and blocks'.
      2. when set to 2 , means 'sections and lists'
      3. when set to 1 , means 'sections'
      4. when set to 0 , means 'None'
      5. default is 3.
    
    - ``g:riv_auto_fold_force``, enable reducing fold level when editing large files.
    
      1. when set to 1 , means 'On'.
      2. default is 1.
    
    - ``g:riv_auto_fold1_lines``, the minimum lines file containing,
      to force set fold_level to section only.
    
      default is 5000.
    
    - ``g:riv_auto_fold2_lines``, the minimum lines file containing,
      to force set fold_level to section and list only.
    
      default is 3000.
    
  + To open some of the fold when opening a file . 
    You can use ``:set fdls=1`` or use ``modeline`` for some files::

     ..  vim: fdls=0 :

  + Use  ':h folding' in vim to get an overview of folding in vim.

Syntax
~~~~~~

Highlights of document items.

*  _`Code Syntax Highlighting`

   For the ``code`` directives (also ``sourcecode`` and ``code-block``). 
   syntax highlighting is on ::
 
     .. code:: python
     
         # python highlighting
         # github does not support syntax highlighting rendering for rst file yet.
         x = [0 for i in range(100)]

   + Use ``g:riv_highlight_code`` to set which languages to be highlighted.

     default is ``lua,python,cpp,javascript,vim,sh``

   :NOTE: To enable syntax highlighting in converted file, 
          python pygments_  package must installed for ``docutils`` 
          parsing syntax highlighting.

          See http://docutils.sourceforge.net/sandbox/code-block-directive/tools/pygments-enhanced-front-ends/

*  The local files are highlighted by highlight group ``rstFileLink``, 
*  _`Cursor Highlighting` 

   Some item that could interactive with cursor are highlighted when cursor is on.

   + Links are highlighted by ``hl-DiffText``

     - For local file links , if the target is invalid , it will be highlighted by 
       ``hl-DiffChange``
   + For Todo items, it is highlighted by ``hl-DiffAdd``

   Disable it by set ``g:riv_hover_link_hl`` to 0
*  Todo Item are highlighted only in vim, not in converted files.

Indent
~~~~~~

Improved indent in insert mode.

* Actions:
    
  Insert Mode Only

  + starting newline (``<Enter>`` or ``o`` in Normal mode):
    will start newline with correct indentation 
  + ``<BS>`` (BackSpace key).
    will goto correct indentation if no preceding non-whitespace character
    and after the indentation's ``&shiftwidth`` position , otherwise ``<BS>``
  

Insert
~~~~~~

Improvment for some mapping in insert mode. Detail commands are in each section.

Most shortcuts can be used in insert mode. like ``<C-E>ee`` ``<C-E>s1`` ...

* Enter: Insert lists_ with ``<C-Enter>`` , ``<S-Enter>`` and ``<C-S-Enter>``.

  When in a table_, ``<Enter>`` to create a new line

  When not in a table, will start new line with correct indentation

* Tab:  When in a table , ``<Tab>`` to next cell , ``<S-Tab>`` to previous one.

  When not in a table , will act as ``<C-N>`` or ``<C-P>`` if insert-popup-menu 
  is visible.

  When in a list, and cursor is before the list symbol, will shift the list. 
  
  Otherwise output a ``<Tab>`` or ``<S-Tab>``

* BackSpace: for indent_, will goto correct indentation if no preceding non-whitespace character and after the indentation's ``&shiftwidth`` position ,
  otherwise ``<BS>``


Publish
~~~~~~~

Some wrapper to convert rst files to html/xml/latex/odt/... 
(require python docutils_  package )

* Actions:

  + ``:Riv2HtmlFile``  ``<C-E>2hf``
    convert to html file.
  
  + ``:Riv2HtmlAndBrowse``  ``<C-E>2hh``
    convert to html file and browse. 
    default is 'firefox'
  
    the browser is set by ``g:riv_web_browser``, default is ``firefox``
  
  + ``:Riv2HtmlProject`` ``<C-E>2hp`` converting whole project into html.
    And will ask you to copy all the file with extension in ``g:riv_file_link_ext`` 
  
  + ``:Riv2Odt`` ``<C-E>2oo`` convert to odt file and browse by ft browser
  
    The browser is set with ``g:riv_ft_browser``. 
    default is (unix:'xdg-open', windows:'start')
  
  + ``:Riv2Xml`` ``<C-E>2xx`` convert to xml file and browse by web browser
  + ``:Riv2S5`` ``<C-E>2ss`` convert to s5 file and browse by web browser
  + ``:Riv2Latex`` ``<C-E>2ll`` convert to latex file and edit by gvim
  
* Options:

  + For the files that are in a project. 
    The path of converted files by default is under ``build_path`` of your project directory. 
  
    - default is ``_build``
    - To change the path. Set it in your vimrc::
        
        " Assume you have a project name project 1
        let project1.build_path = '~/Documents/Riv_Build'
    
    - Open the build path: ``:Riv2BuildPath`` ``<C-E>2b``
  
  + For the files that not in a project.  
    ``g:riv_temp_path`` is used to determine the output path
  
    - When it's empty or ``0``, 
      the converted file is put under the same directory of file ,

    - if the ``g:riv_temp_path`` is ``1``,
      the converted file is put in the vim temp path,
    - Otherwise the converted file is put in the ``g:riv_temp_path``,
    - default is 1

    - Also no local file link will be converted.

:NOTE: When converting, It will first try ``rst2xxxx2.py`` , then try ``rst2xxxx.py``
       You should install the package of python 2 version .
       Otherwise errors will occour.

.. _docutils: http://docutils.sourceforge.net/
.. _pygments: http://pygments.org/

Riv Guide
---------

Following features are in documents within project.

Some can be used in a document without a project. 

Project
~~~~~~~

Project is a place to hold your rst documents. 

Though you can edit reStructuredText documents anywhere.
There are some convenience with projects.

* File_ :  You can write documents and navigating with local file link. 

  ``index.rst`` is the index for each direcotry.

  An ``index.rst`` will be auto created for a new project.
* Publish_ : You can convert whole project to html, and view them as wiki.
* Todos_ : You can manage all the todo items in a project
* Scratch_ : Writing diary in a project

* The default project path is ``'~/Documents/Riv'``,
  you can change it by defining project to ``g:riv_projects`` in your vimrc.::

    let project1 = { 'path': '~/Dropbox/rst',}
    let g:riv_projects = [project1]

* Use ``:RivIndex`` ``<C-E>ww`` to open the first project index.


* You can have multiple projects also::

    " You could add multiple projects as well 
    let project2 = { 'path': '~/Dropbox/rst2',}
    let g:riv_projects = [project1, project2]
* Use ``:RivAsk`` ``<C-E>wa`` to choose one project to open.

File
~~~~

The link to edit local files.

As reStructuredText haven't define a pattern for local files currently.

Riv provides two kinds of style to determine the local file
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

* File link are highlighted and cursor highlighted.
  See `Cursor Highlighting`_

* To delete a local file in project.

  ``:RivDelete`` ``<C-E>df``
  it will also delete all reference to this file in ``index.rst`` of the directory.

* When Publish_ , and it's a file in a project.

  All detected local file link will be converted to an embedded link. 
  Except the links in a grid table or line of an explicit markup.

  Those links should use ``:RivCreateLink`` or ``<C-E>il`` to 
  convert it manually.

    e.g. `xxx.rst <xxx.html>`_ `xxx.py <xxx.py>`_

Scratch
~~~~~~~
  
Scratch is a place for writing diary or hold idea and thoughts.

* ``:RivScratchCreate`` ``<C-E>cc``
  Create or jump to the scratch of today.

  Scratches are created auto named by date in '%Y-%m-%d' format.

* ``:RivScratchView`` ``<C-E>cv``
  View Scratch index.

  The index is auto created. You can change the month name using 
  ``g:riv_month_names``. 

  default is:

      ``January,February,March,April,May,June,July,August,September,October,November,December``

Scratches will be put in scratch folder in project directory.
You can change it with 'scratch_path' of project setting ,default is 'Scratch'::
    
    " Use another directory
    let project1.scratch_path = 'Diary'
    " Use absolute path, then no todo helper and no converting for it.
    let project1.scratch_path = '~/Documents/Diary'

Todos
~~~~~

Todo items to keep track of todo things.

It is Todo-box or Todo-keywords in a bullet/enumerated/field list.

* Todo Box:

  + [ ] This is a todo item of initial state.
  + [o] This is a todo item that's in progress.
  + [X] This is a todo item that's finished.

  + You can change the todo box item by ``g:riv_todo_levels`` ,

    default is ``" ,o,X"``

* Todo Keywords:
    
  Todo Keywords are also supported

  + FIXED A todo item of FIXME/FIXED keyword group.
  + DONE 2012-06-13 ~ 2012-06-23 A todo item of TODO/DONE keyword group.
  + START A todo item of START/PROCESS/STOP keyword group.
  + You can define your own keyword group for todo items with ``g:riv_todo_keywords``
  
    each keyword is seperated by ',' , each group is seperated by ';'
  
    default is ``"TODO,DONE;FIXME,FIXED;START,PROCESS,STOP"``,

    :Note: the end of each group is considered as the 'DONE' keyword


* Datestamps:

  Todo items's start or end date.

  + [X] 2012-06-23 A todo item with datestamp
  + Double Click or ``<Enter>`` or ``:RivTodoDate`` on a datestamp to change date. 

    If you have Calendar_ installed , it will use it to choose date.

    .. _Calendar: https://github.com/mattn/calendar-vim
  + It is controled by ``g:riv_todo_datestamp``
  
    - when set to 2 , will init with a start datestamp.
      and when it's done , will add a finish datestamp.

      1. [ ] 2012-06-23 This is a todo item with start datestamp
      2. [X] 2012-06-23 ~ 2012-06-23  A todo item with both start and finish datestamp. 
  
    - when set to 1 , no init datestamp ,
      will add a finish datestamp when it's done.

      1. [X] 2012-06-23 This is a todo item with finish datestamp, 

    - when set to 0 , no datestamp
    - Default is 1
  
* Priorities:

  The Priorites of todo item

  + [ ] [#A] priorty A
  + [ ] [#C] priorty B
  + Double Click or ``<Enter>`` or ``:RivTodoPrior`` on priorty to change priority. 
  + You can define the priorty chars by ``g:riv_todo_priorities``
    Only alphabet or digits are supported.

    default is ``"ABC"``

* Actions:

  Add Todo Item
  
  + Use ``:RivTodoToggle`` or ``<C-E>ee`` to add or switch the todo progress.
    
    When adding a todo item, todo group is ``g:riv_todo_default_group``

    default is 0, which is the todo box group.

  + Use ``:RivTodoType1`` ``<C-E>e1`` ... ``:RivTodoType4`` ``<C-E>e4`` 
    to add or change the todo item by group. 
  + Use ``:RivTodoAsk`` ``<C-E>e``` will show an keyword group list to choose.

  Change Todo Status

  + Double Click or ``<Enter>`` in the box/keyword to swith the todo progress.
  

 
  Delete Item 

  + Use ``:RivTodoDel`` ``<C-E>ex`` will delete the todo item

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

A window to show something of the project.


* _`Todo Helper` : A helper to manage todo items of current project.
  When current file is not in a project, will show current file's todo items.

  See Todos_ for details.

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

Miscs
~~~~~

* Insert extra things.

  + Use ``:RivCreateDate`` ``<C-E>id`` to insert a datestamp of today anywhere.
  + Use ``:RivCreateTime`` ``<C-E>it`` to insert a timestamp of current time anywhere. 
