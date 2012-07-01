Intro
=====

:Author: Rykka G.Forest
:Date:   2012-07-01 02:59:36
:Version: 0.66 
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
:Highlighting_: Improved syntax file. 
:Publish_:  some wrapper to convert rst files to html/xml/latex/odt/... 
            (require python docutils package )

These features are for the Riv Project. 

:Project_:  Manage your reStructuredText documents in a wiki way.
:File_:     Links to local file in rst documents. 
:Scratch_:  A place for writing diary or hold idea and thoughts.
:Todos_:    Writing todo lists in reStructuredText documents .
:Helpers_:  A help window for showing and doing something.

  + `Todo Helper`_: Managing todo items of project.



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

  + Calendar_ setting datestamp easier.

    .. _Calendar: https://github.com/mattn/calendar-vim

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

See Changelog in doc/riv_log.rst

* 0.65:

  + TODO  2012-07-01 take care of the slash of directory in windows .
  + FIXED 2012-06-28 correct cursor position when creating todo items and list items.
  + FIXED 2012-06-28 link highlight group removed after open another buffer.
  + FIXED 2012-06-28 auto mkdir when write file to disk
  + DONE  2012-06-28 format the scratch index, sort with year/month/day 

This
~~~~~

Things todo in this version.

* 0.66: 

  :Todos_:   DONE 2012-06-29 add field list for todo items.
  :Indent_:  DONE 2012-06-29 the indentation in directives should return 0 after 
             2 blank lines
  :Publish_: DONE 2012-06-29 Support the reStructuredText document not in a project.
  :Indent_:  DONE 2012-06-29 fix indent of field list. 
             the line + 2 should line up with it's begining .
  :Insert_:  DONE 2012-06-29 9229651d_ ``<Tab>`` and ``<S-Tab>`` 
             before list item will now shift the list. 
  :Lists_:   DONE 2012-06-30 2b81464f_ bullet list will auto numbered when change to
             enumerated list.
  :Lists_:   DONE 2012-06-30 21b8db23_ createing new list action in a field list will
             only add it's indent. refile todo parts.
  :Links_:   DONE 2012-06-30 69555b21_ Optimized link finding. Add email web link.
  :Links_:   DONE 2012-06-30 69555b21_ Add anonymous phase target and reference 
             jumping and highlighting. 
  :Highlighting_:   DONE 2012-07-01 4dc853c1_ fix doctest highlighting
  :Table_:   DONE 2012-07-01 38a8cebb_ Support simple table folding.
  :Documents_: DONE 2012-07-01 help doc use doc/riv.rst  which is link of README.rst
  :Documents_: DONE 2012-07-01 Add reStructuredText hint and link in instructions
  :Indent_:  DONE 2012-07-01 7e19b531_ The indent for shifting lists should based on 
             the parent/child list item length.
  :Lists_:   DONE 2012-07-02 Add a list parser.

.. _7e19b531: 
   https://github.com/Rykka/riv.vim/commit/7e19b531371e47e36bc039fa4f142434bcf4eb39
.. _38a8cebb: 
   https://github.com/Rykka/riv.vim/commit/38a8cebbc69f018cbc7caafa26473e2aee2dbe94
.. _4dc853c1: 
   https://github.com/Rykka/riv.vim/commit/4dc853c132848872810fdc549df3dc429f31fa56
.. _69555b21: 
   https://github.com/Rykka/riv.vim/commit/69555b2172950ed1ddf236e43b3bdcaea343afe0
.. _9229651d: 
   https://github.com/Rykka/riv.vim/commit/9229651de15005970990df57afba06d1b54e9bc9
.. _2b81464f:
   https://github.com/Rykka/riv.vim/commit/2b81464fa2479f8aced799d9117a5081d9e780dc
.. _21b8db23:
   https://github.com/Rykka/riv.vim/commit/21b8db2398a6d8cbbf2332b9938c110022de2095

Next 
~~~~~

Things todo in next versions.

:Links_:   The standalone web link with ``/`` is detected as local file.
:File_:    A template or snippet or shortcut for adding ``./`` and ``../`` and files.
           Maybe a sphinx doc ref as well.
:Documents_: Document part: options / commands.
:Documents_: Sreencast and screenshot of intro.
:Publish_: An option to enable highlighting todo items.
:Helpers_: An option Helper and option cache. 
           Let people use it even without touching ``.vimrc`` .
:Scratch_: Show Scratch sign in Calendar.
:Helpers_: A command helper?
:Links_:   Link tags between files?
:Links_:   Github flavor: create commit link, issue link?
:Todos_:   Todo item priorities?
:Table_:   Support simple table format?
:Table_:   Support column span?
:Table_:   A vim table parser for compatible?
:Table_:   A shortcut or command to create table with row * col.
:Sections_: Adjust section level.
:Sections_: Shortcut to add sections references like the content directive?
:Folding_: A buf parser write in python for performance?
:Indent_:  <Tab> should act as <Bs> when indenting
:Indent_:  The content space for field list should align with prev field list.
:Indent_:  A command to format the indent of lists.


.. _Documents: Intro_

----

Instruction
===========

* How to use?

  + If you are not familiar with reStructuredText, see QuickStart_

  + For writing documents,

    When editing an reStructuredText document (``*.rst`` ), 

    These settings will be automatically on. 
    (make sure ``filetype on`` in your vimrc)

    See detail instruction in `For reStructuredText`_

  + For managing documents, 

    See detail instruction in `For Riv`_

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

.. _QuickStart: http://docutils.sourceforge.net/docs/user/rst/quickstart.html

For reStructuredText
--------------------

These features are in all reStructuredText files.

Sections 
~~~~~~~~~

Section levels and numbers are auto detected.

* Actions:

  Normal and Insert Mode

  + Create: 

    Use ``:RivTitle1`` ``<C-E>s1`` ...  ``:RivTitle6`` ``<C-E>s6`` ,
    To create level 1 to level 6 section title from current word.

    If it's empty, you will be asked to input one.

  + Folding: 

    Pressing ``<Enter>`` or double clicking on section title will toggle the folding
    of the section.

    The section number will be shown when folded.

  + Jumping:

    Clicking on the section reference will bring you to the section title.

    e.g. Features_ link will bring you to the `Feature` Section (in vim)

* Options:

  Although you can define a section title with most punctuations
  (any non-alphanumeric printable 7-bit ASCII character). 

  Riv use following punctuations for titles: 

  ``= - ~ " ' ``` , (HTML has 6 levels)

  you can change it with ``g:riv_section_levels``

:NTOE: **A reStructuredText syntax hint**
    
       reStructuredText Section title have two styles. 
        
            ``underline`` and ``underline and overline``

       both of them can be used freely. 

       As section title created by Riv is ``underline`` only, 
       To add an ``overline``, you should copy the ``underline`` and paste it there.

       A blank line is need before the title if it's not the first line of document,
       A blank line after a title is optional. 

       The punctuation lines must begin at column 1.

       The highlighting of it is a hint for it.

       See `reStructuredText sections`__

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#sections

Lists
~~~~~

Auto numbered and auto leveled bullet and enumerated list.

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

    - Shift right: ``>`` or ``<C-ScrollWheelDown>`` 
  
      Add Indentation, And add a level for list.
  
      if the first item is a list , the indentation is based on the list item.
      otherwise the indentation is based on ``'shiftwidth'``.
  
    - Shift left: ``<`` or ``<C-ScrollWheelUp>`` 
      Remove Indentation, And remove a level for list.

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
  
  + Change List type:

    Normal and Insert Mode:
    
    - ``:RivListTypeNext`` ``<C-E>l1``
      Change current list item symbol to next type
    - ``:RivListTyePrev`` ``<C-E>l2``
      Change current list item symbol to prev type
    - ``:RivListTypeRemove`` ``<C-E>lx``
      Delete current list item symbol

:NOTE: **A reStructuredText syntax hint**

       To contain a sublist or second paragraph or blocks in a list , 
       you should make a new blank line ,
       and make the the item lines up with the main list content's left edge.::

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

       See `reStructuredText Bullet Lists`__ 

       and following enumerated lists, definition lists , field lists and option lists.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#bullet-lists

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

  See `Literal Blocks`__
    
__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#literal-blocks

* Line Blocks::

    | It should have '|' at the begining
    | It can have multiple lines

  | This is a line block
  | This is the second line

  It's highlighted but not folded.

  See `Line Blocks`__

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

  See `Block Quotes`__

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#block-quotes

* Doctest Blocks:

>>> print 'this is a Doctest block'
this is a Doctest block
    
  It's highlighted but not folded

  See `Doctest Blocks`__

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#doctest-blocks

* Explicit Markup Blocks::
    
    start with '..' and a whitespace.

  The explicit markup syntax is used for footnotes, citations, hyperlink targets,
  directives, substitution definitions, and comments.

  It's folded , and it's highlighted depending on it's role.

  See `Explicit Markup Blocks`__

  And for the ``code`` directives, syntax highlighting is on. 
  See `code block syntax highlighting`_ 

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#explicit-markup-blocks

Links
~~~~~

Jumping with links

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

       See `Hyperlink References`_

       There are implicit hyperlink targets and explicit hyperlink targets.

       Implicit hyperlink targets are generated by section titles, 
       footnotes, and citations

       Explicit hyperlink targets are defined as follows::

        .. _hyperlink-name: link-block
        .. __: anonymous-hyperlink-target-link-block
        _`an inline hyperlink target`
            
       See `Hyperlink targets`_

.. _Hyperlink References:
   http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#hyperlink-references

.. _Hyperlink targets:
   http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#hyperlink-targets

Table
~~~~~

Auto Format Table 
(Currently require vim compiled with python. )

Grid Table: 

    Highlighted and Folded.
    When folded, the numbers of rows and columns will be shown as '3x2'

    Can be autoformated. Only support equal columns each row (no span).

  + Actions:

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

    See `Grid Tables`__

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#grid-tables

Simple Table:

  Highlighted and folded.
  When folded, the numbers of rows and columns will be shown as '3+2'

  No auto formatting.

  ===========  ========================
        This is a Simple Table
  -------------------------------------
  Col 1        Col 2
  ===========  ========================
  1             row 1        
  2             row 2        
  3             - first line row 3
                - second line of row 3
  ===========  ========================


    See `Simple Tables`__

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#simple-tables

Folding 
~~~~~~~~

Fold reStructuredText file with sections, lists, and blocks automatically.

* Actions (Normal Mode Only):

  + Open Folding: Pressing ``<Enter>`` or double clicking on folded lines 
    will open that fold. 

    use ``zo`` ``zO`` or ``zv`` will open it either.

  + Close Folding:  use ``zc`` ``zC`` will close it.

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
    
  + To set an initial folding level for a file . you can use ``modeline``::

     ..  vim: fdl=0 :
         This means all fold will be folded when opening files

Highlighting
~~~~~~~~~~~~

Improved syntax file. 

*  Imporoved Section,Lists,Blocks,Links Highlightings 
*  _`Code Block Syntax Highlighting`

   for the ``code`` directives (also ``sourcecode`` and ``code-block``). 
   syntax highlighting is on ::
 
     .. code:: python
     
         # python highlighting
         # github does not support syntax highlighting rendering for rst file yet.
         x = [0 for i in range(100)]

   You can use ``g:riv_highlight_code`` to set which languages to be highlighted.
   default is ``lua,python,cpp,javascript,vim,sh``

   :NOTE: To enable syntax highlighting in converted file, 
          python pygments_  package must installed for ``docutils`` 
          parsing syntax highlighting.

          See http://docutils.sourceforge.net/sandbox/code-block-directive/tools/pygments-enhanced-front-ends/

*  The local files are highlighted by ``rstFileLink``, 
   you can change the color if needed.
*  The links under cursor are highlighted by ``hl-difftext``
   Disable it by set ``g:riv_hover_link_hl`` to 0
*  Todo Item are highlighted only in vim, not in converted files.

Indent
~~~~~~

Improved indent file.

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

:NOTE: When converting, It will first try ``rst2xxxx2.py`` , then try ``rst2xxxx.py``
       You should install the package of python 2 version .
       Otherwise errors will occour.

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
    The path of converted files by default is under ``_build`` in your project directory.
  
    - To change the path. Set it in your vimrc::
        
        " Assume you have a project name project 1
        let project1.build_path = '~/Documents/Riv_Build'
    
    - Open the build path: ``:Riv2BuildPath`` ``<C-E>2b``
  
  + For the files that not in a project.  
    ``g:riv_temp_path`` is used to determine the output path
  
    - When it's empty , the converted file is put under the same directory of file ,
    - Otherwise the converted file is put in the ``g:riv_temp_path``,
      make sure it's an absolute path.
    - Also no local file link will be converted.



.. _docutils: http://docutils.sourceforge.net/
.. _pygments: http://pygments.org/

For Riv
-------

These features are for documents in a Riv Project, 
Though some can be used in a document without a project. 
They have no full support.

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

* When Publish to html, and it's a file in a project.
  all detected local file link except the links in a grid table, 
  will be converted to an embedded link. 

  The links in a grid table should use ``:RivCreateLink`` or ``<C-E>il`` to 
  convert it manually.

    e.g. `xxx.rst <xxx.html>`_ `xxx.py <xxx.py>`_

* To delete a local file in project.

  ``:RivDelete`` ``<C-E>df``
  it will also delete all reference to this file in ``index.rst`` of the directory.

Scratch
~~~~~~~
  
The scratches is created auto named by date in '%Y-%m-%d' format.
It is a place for writing diary or hold idea and thoughts.

Scratches will be put in scratch folder in project directory.
You can change it with 'scratch_path' of project setting ,default is 'Scratch'::
    
    " Use another directory
    let project1.scratch_path = 'Diary'
    " Use absolute path, then no todo helper and no converting for it.
    let project1.scratch_path = '~/Documents/Diary'

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

When list is folded. 
The statistics of the child items (or this item) todo progress will be shown.

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
    - Default is 1
  
* Keyword groups:
    
  + FIXED A todo item of FIXME/FIXED keyword.
  + DONE 2012-06-13 ~ 2012-06-23 A todo item of TODO/DONE keyword.
  + START A todo item of TODO/DONE keyword.
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

