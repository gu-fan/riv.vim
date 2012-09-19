:Author: Rykka G.F
:Update: 2012-09-19
:Version: 0.71 
:Github: https://github.com/Rykka/riv.vim
:Google Group: https://groups.google.com/forum/#!forum/vim_riv

.. contents::

Intro
=====

**Riv** is a vim plugin for reading, writing and managing reStructuredText_ 
(a simple and powerful plain text markup).

Short for 'reStructuredText in Vim'. 

With it, you can::

    Read documents clearer.
    Write documents neater.
    Manage documents easier.

Features
--------
 
**Reading and Writing**

 Functions.

 :Folding_:  View the document strucutre
 :Syntax_:   Clearer highlighting and hinting.
 :Indent_:   Smarter indent.
 :Insert_:   Speed up the input!
 :Publish_:  Convert to html/xml/latex/odt... (docutils_ required)

 Document Structures.

 :Sections_: Easy create, easy view.
 :Lists_:    Auto numbered, auto leveled and auto indented.
 :Blocks_:   Highlighted and folded 
 :Inline_:   Highlighted.
 :Links_:    Jumping and Highlighting.
 :Table_:    Auto formatted. 

**Managing**

 :Project_:  Hold your rst documents in one place.
 :Scratch_:  writing diary or notes.
 :Helpers_: 
             a. `Section Helper`_: Showing section number of current document.
             b. `Todo Helper`_: Managing todo items of project or document.
             c. `File Helper`_: Showing rst files of current directory.
 :File_:     Link local file in rst documents. (non-reStructuredText syntax)

             But you can choose ``Sphinx`` or ``MoinMoin`` style.
 :Todos_:    Keep track of todo things. (non-reStructuredText syntax)    
             
             And it's similar with Emacs's Org-Mode_ style.

On Screen
----------

ScreenShot:

.. image:: http://i.minus.com/ibmv5c3yvWMisp.png

ScreenCast: TODO

Getting Started
---------------

* If this is your first exposure to reStructuredText, 
  please read `A ReStructuredText Primer`_ and the
  `Quick reStructuredText`_ user reference first.
* To get a quick overview of Riv features ,
  see `QuickIntro For Riv`_ (doc/riv_quickintro.rst)
* Installation: see `Install`_
* Quick Start: see `QuickStart With Riv`_  
  or use ``:RivQuickStart`` in vim.
* Instruction: see `Instructions`_ 
* To change mappings and commands. see Commands_
* Snapshots: `On Screen`_
* Post issues at https://github.com/Rykka/riv.vim/issues
  Both bug reports and feature request are welcome. 
* Discussion at https://groups.google.com/forum/#!forum/vim_riv
* Todos: Todo_.

Install
-------
* Using Vundle_  (Recommended)

  Add this line to your vimrc::
 
    Bundle 'Rykka/riv.vim'

.. _Vundle: https://www.github.com/gmarik/vundle

* Using downloaded zip/tar.gz file. 
  Just extract it to your ``.vim`` folder .


:NOTE: Make sure your .vim folder in option ``runtimepath`` 
       is before the $VIMRUNTIME, otherwise the syntax/indent files
       for rst files will use vim's built-in one.

       Default is before $VIMRUNTIME.

:NOTE: Make sure ``filetype plugin indent on`` and ``syntax on`` is in your vimrc

:NOTE: It's a developing version. 
       So things may change quickly.Keep up-to-date.

       You can get the latest version at https://github.com/Rykka/riv.vim 

* Related tools: 

  + python: docutils_ , required for converting to other format.
  + python: pygments_ for syntax highlighting in other format.
  + python: Sphinx_ for Sphinx users.
  + vim: Syntastic_  for syntax checking. docutils_ required.

    But if you are using Sphinx_'s tools set, you'd better not using it.
    Cause it could not recongize the sphinx's markups.

Todo  
---------

Prev
~~~~

See Changelog in  riv_log_ ( doc/riv_log.rst )

This
~~~~~

Things todo in this version.

* 0.71:

  :File_: DONE 2012-09-13 extension style show in vim only.
  :File_: DONE 2012-09-13 now square style (moinmoin) use ``[[xxx]]``. 
          easier for regxp match
  :File_: DONE 2012-09-13 Support Sphinx style  :file:, :doc:
  :Sections_: DONE 2012-09-17 Use sphinx section default markup style?
  :Sections_: DONE 2012-09-17 section create shortcut will check if it's 
              a section title undercursor and repl it.
  :Sections_: DONE 2012-09-17 A shortcut to create a document tree.
  :Sections_: DONE 2012-09-17 Add g:riv_content_format
  :Publish_: DONE 2012-09-13 remove '_`g:riv_file_link_convert`' 
  :Publish_: DONE 2012-09-18 different style.css for syntax highlighting in html
  :Publish_: DONE 2012-09-19 Fix link repl errors while converting to html.
  :Links_: DONE 2012-09-17 Add g:riv_create_link_pos
  :Miscs_: DONE 2012-09-19 A google group

Next 
~~~~~

* 0.72 
  - refactoring codes.
  - document
  - screencast and screenshot

See riv_todo_ ( doc/riv_todo.rst )

----

Instructions
============

reStructuredText
----------------

The following features apply for all ``*.rst`` documents 
having standard reStructuredText syntax.

Folding 
~~~~~~~~

**Folding** is a vim feature.

It shows a range of lines as a single line.
Thus you can get a better overview of the document strucutres.

And you can operate the folded lines with one line actions, 
like: select(V), copy(yy), paste(p) ... etc.

See ``:h folding`` for more infos.

Sections, lists, and blocks are folded automatically,
And extra infos are provided.

* Commands:

  **Normal Mode**

  These 'z' folding commands can be used.
  like 'zo' 'zc' ...

  Also Some extra commands are provided.

  + Open/Close Folding: ``zo``, ``zc``, ``zM``, ``zR``
  + Update Folding: ``zx``

    Also Foldings will be auto updated whilst writing buffer to file, like ``:write``

  + Toggle Folding: ``za``, ``zA``...

    You can define your own mappings for folding in your vimrc,
    I use ``<Space><Space>`` to toggle folding::

        nno <silent> <Space><Space> @=(foldclosed('.')>0?'zv':'zc')<CR>


  + Toggle folding with Cursor.

    Pressing ``<Enter>`` or double clicking on folded lines 
    will open the fold. like ``zo``

    Pressing ``<Enter>`` or double clicking on section heading
    will close the fold of the section. like ``zc``

* Extra Infos:

  Some extra info of folded lines will be shown at the first line.
  And the number of folded lines will be shown. 
  
  + Sections_ folding will show it's section number.
  + Todos_ folding will show the Todo progress : 
  + Table_ will show number of rows and columns.
  + '_`g:riv_fold_info_pos`' can be used to change info's side.
    - when set to ``left``, these info will be shown at left side.
    - default is ``right``, means shown at right side.
  
* Options:

  + To show the blank lines in the end of a folding, use '_`g:riv_fold_blank`'.

    - when set to 2 , will fold all blank lines.
    - when set to 1 , will fold all blank lines,
      but showing one blank line if there are some.
    - when set to 0 , will fold one blank line , 
      but will showing the rest.
    - default is 2

  + For large files. calculate folding may cost time. 
    So there are some options about it.

    - '_`g:riv_fold_level`' set which structures to be fold. 
    
      1. when set to 3 , means 'sections,lists and blocks'.
      2. when set to 2 , means 'sections and lists'
      3. when set to 1 , means 'sections'
      4. when set to 0 , means 'None'
      5. default is 3.
    
    - '_`g:riv_auto_fold_force`', enable reducing fold level when editing large files.
    
      1. when set to 1 , means 'On'.
      2. default is 1.
    
    - '_`g:riv_auto_fold1_lines`', the minimum lines file containing,
      to force set fold_level to section only.
    
      default is 5000.
    
    - '_`g:riv_auto_fold2_lines`', the minimum lines file containing,
      to force set fold_level to section and list only.
    
      default is 3000.
    
  + To open some of the fold when entering a file . 
    You can use ``:set fdls=1`` or use ``modeline`` for some files::

     ..  vim: fdls=0 :

Syntax
~~~~~~

Improved highlights for syntax items.

*  Local file with extension (xxx.rst) are highlighted.
*  Todo Item are highlighted. 

Code Highlighting
"""""""""""""""""

For the ``code`` directives (also ``sourcecode`` and ``code-block``). 
syntax highlighting is on ::
 
  .. code:: python
     
      # python highlighting
      # github does not support syntax highlighting rendering for rst file yet.
      x = [0 for i in range(100)]

The ``highlights`` directives in Sphinx_ could also be used to
highlight big block of codes.

* Use '_`g:riv_highlight_code`' to set which languages to be highlighted.

  default is ``lua,python,cpp,javascript,vim,sh``

:NOTE: To highlighting codes in converted file, 
       pygments_ package must installed for docutils_ to
       parse syntax highlighting.

       See http://docutils.sourceforge.net/sandbox/code-block-directive/tools/pygments-enhanced-front-ends/

Cursor Highlighting
"""""""""""""""""""

Some item that could operate by cursor are highlighted when cursor is on.

* Links are highlighted in ``hl-incSearch``

  + if the target fiel is invalid, it will be highlighted by 
    '_`g:riv_link_invalid_hl`', default is ``"ErrorMsg"``
* Todo items are highlighted in ``hl-DiffAdd``

You can disable Cursor Highlighting by set '_`g:riv_link_cursor_hl`' to 0


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
  + ``<BS>`` (BackSpace key) and ``<S-Tab>`` .
    will use fixed indentation if no preceding non-whitespace character, 
    otherwise ``<BS>``
  + ``<Tab>`` (Tab key).
    will use fixed indentation if no preceding non-whitespace character, 
    otherwise ``<Tab>``
  

Insert
~~~~~~

Super ``<Tab>`` and Super ``<Enter>`` in insert mode.

* ``Enter`` and ``KEnter`` (Keypad Enter) 
  (with modifier 'ctrl' and 'shift'): 
  
  + When in a grid table: creating table lines.
    
    See Table_ for details.
  + When in a list context: creating list lines.
    
    See Lists_ for details.

* ``Tab`` and ``Shift-Tab``:  
  
  * If insert-popup-menu is visible, will act as ``<C-N>`` or ``<C-P>``

    disable it by setting '_`g:riv_i_tab_pum_next`' to 0.
  * When in a table , ``<Tab>`` to next cell , ``<S-Tab>`` to previous one.
  * When not in a table, 

    + If it's a list, and cursor is before the list item, will shift the list. 
    + if have fixed indent, will indent with fixed indent. see indent_.
    + Otherwise:
      
      - if '_`g:riv_i_tab_user_cmd`' is not empty , executing it. 

        It's for users who want different behavior with ``<Tab>``::

          " For snipmate user. 
          let g:riv_i_tab_pum_next = 0
          " quote cmd with '"', special key must contain '\'
          let g:riv_i_tab_user_cmd = "\<c-g>u\<c-r>=snipMate#TriggerSnippet()\<cr>"

      - else act as ``<Tab>`` and ``<BS>``.
    
  :NOTE:  ``<S-Tab>`` is acting as ``<BS>`` when not in list or table .

* BackSpace: indent with fixed indent. see indent_.
* Most commands can be used in insert mode. like ``<C-E>ee`` ``<C-E>s1`` ...

:NOTE: to disaple mapping of ``<Tab>`` etc. in insert mode.

       set it in '_`g:riv_ignored_imaps`' , each item is split with ``,``. ::
        
        " no <Tab> and <S-Tab>
        let g:riv_ignored_imaps = "<Tab>,<S-Tab>"

       You can view default mappings with '_`g:riv_default.buf_imaps`'

* Insert extra things.

  + Use ``:RivCreateDate`` ``<C-E>id`` to insert a datestamp of today anywhere.
  + Use ``:RivCreateTime`` ``<C-E>it`` to insert a timestamp of current time anywhere. 


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

    Other commands is ``underline`` only, 

  + Folding: 

    Pressing ``<Enter>`` or double clicking on the section title 
    will toggle the folding of the section.

    The section number will be shown when folded.

  + Jumping:

    ``<Enter>`` or Clicking on the section reference will bring you to the section title.

    e.g.: click the link of Features_ will bring you to the ``Features`` Section (in vim)

  + Create a content table:
    
    Use ``:RivCreateContent`` or ``<C-E>ic`` to create it.

    It's similar with the ``content`` directive,
    except it create the content table into the document.

    The advantage is you can jumping with it in vim.

    The disadvantage is you must update it every time after you have changed the document.

    You can set '_`g:riv_content_format`' to change it's
    format::
        
        %i is the indent of each line
        %l is the list symbol '+'
        %n is the section number
        %t is the section title

        by default , it's '%i%l%n %t'
    
* Options:

  + Although you can define a section title with most punctuations
    (any non-alphanumeric printable 7-bit ASCII character). 

    Riv use following punctuations for titles: 

    ``= - ~ " ' ``` , (HTML has 6 levels)

    you can change it with '_`g:riv_section_levels`'

    The ``:RivTitle0`` will use ``#``

  + Section number are seperated by '_`g:riv_fold_section_mark`'

    default is ``"."``


See `reStructuredText sections`__ for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#sections

* Miscs:

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

    - Shift right: ``>`` ``:RivShiftRight`` or ``<C-ScrollWheelDown>`` (unix only) 
  
      Shift rightwards with ``ShiftWidth``

      If it's a list item, it will indent to the list item's sub list
  
    - Shift left: ``<`` ``:RivShiftLeft`` or ``<C-ScrollWheelUp>`` (unix only) 

      Shift leftwards with ``ShiftWidth``

      if it's a list item, it will indent to the list item's parent list

    - Format:   ``=``
      Format list's level and number.
    - To act as the vim's original ``<`` ``>`` and ``=``,
      just preceding a ``<C-E>``.  as ``<C-E><`` , ``<C-E>>`` and ``<C-E>=``

      Also ``<S-ScrollWheelDown>`` and ``<S-ScrollWheelUp>`` can 
      be used in unix

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
      will shift left.

    :NOTE: As this will break the ``<Tab>`` inserting operation 
           in ``visual block insert``. 

           You should use ``<Space>`` instead of ``<Tab>``

           See ``:h v_b_i``

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
    
    - ``:RivListType0`` ``<C-E>l1`` ... ``:RivListType4`` ``<C-E>l5``
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

A quick intro of the reStructuredText lists.

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
    
       * Most reStructuredText items is seperated by blank line. 
         Include sections, lists, blocks, paragraphs ...

       * Also the reStructuredText is indent sensitive.

       **So subitem of a list have strict syntax**

       To contain a subitem ( lists or paragraphs or blocks ) in a list , 
        
       A blank line is needed and the sub item should lines up with 
       the main list content's left edge.::

           * list 1

            - WRONG! this list is not line up with conten's left edge, 
              so it's in a block quote
             
               - WRONG! this list is in a block quote too.

           * list 2
             - TOO WRONG! A blank line is needed.
               it's not a sub list of prev list , it's just a line in the content. 

           * list 3
              - STILL WRONG! not line up and no blank line.
                it's not a sub list , but it's a list in a definition list

           * list 4

             - RIGHT! this one is sub list of list 4.


Blocks
~~~~~~

A quick intro of the Blocks of reStructuredText document.

Highlighted , and most are folded.

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

  | This is the second line (github did not render it correctly as it have div)

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

    -- Attribution (Github did not rendering it correctly as no 'attribution' class)
    
  The attribution is highlighted.

  See `Block Quotes`__ for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#block-quotes

* Doctest Blocks:

>>> print 'this is a Doctest block'
this is a Doctest block
    
It's highlighted, not folded.

See `Doctest Blocks`__ for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#doctest-blocks

* Explicit Markup Blocks::
    
    start with '..' and a whitespace.

  :NOTE: Although reStructuredText support start ``..`` with indent.
         Riv does not support this yet. 
         
         put all ``..`` at first column to gain highlighting and folding.

  The explicit markup syntax is used for footnotes, citations, hyperlink targets,
  directives, substitution definitions, and comments.

  It's folded , and it's highlighted depending on it's role.

  See `Explicit Markup Blocks`__ for syntax details.

  And for the ``code`` directives, syntax highlighting is on. 
  See `Code Highlighting`_  for details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#explicit-markup-blocks

Inline
~~~~~~~

Inline Markup are highlighted.

:In The Future: an option for conceal?

See `inline markup`__ for syntax details.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#inline-markup

Links
~~~~~

You can jumping with links.

And it's highlighted with `Cursor Highlighting`_.

* Commands:

  **Jumping(Normal Mode):**

  + Clicking on a links will jump to it's target. 
    
    - A web link ( www.xxx.xxx or http://xxx.xxx.xxx or xxx@xxx.xxx ): 

      Open web browser. 

      And if it's an email address ``xxx@xxx.xxx``,  ``mailto:`` will be added.

      web browser is set by '_`g:riv_web_browser`', default is ``firefox``

    - A internal reference ( ``xxx_ [xxx]_ `xxx`_`` ): 

      Find and Jump to the target.

      if it's an anonymous reference ``xxx__``,

      will jump to the nearest anonymous target.

    - A internal targets (``.. [xxx]:  .. _xxx:``)

      Find and Jump to the nearest backward reference.

    - A local file (if '`g:riv_file_link_style`_' is not 0):

      like (``xxx.vim`` or ``[[xxx/xxx]]``)

      Edit the file. 

      To split editing:
      As no split editing commands were defined, 
      you should split document first:
      ``<C-W><C-S>`` or ``<C-W><C-V>``

  + You can jump back to origin position with `````` or ``''``

  **Navigate(Normal Mode):**
    
  + ``<Tab>/<S-Tab>`` will navigate to next/prev link in document.
   
  **Create (Normal and Insert):**

  + ``:RivCreateLink`` ``<C-E>il``
    create a link from current word. 

    If it's empty, you will be asked to input one.

    If the link is not Anonymous References,
    The target will be put at the end of file by default.

    '_`g:riv_create_link_pos`' can be set to ``'.'``
    to make the target put below current line.

    default is ``'$'``, means at the end of file.

  + ``:RivCreateFoot`` ``<C-E>if``
    create a auto numbered footnote. 
    And append the footnote target to the end of file.


Link Items
""""""""""
* A quick Intro of Links.

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
  footnotes, and citations.

  Explicit hyperlink targets are defined as follows::

   .. _hyperlink-name: link-block
   .. __: anonymous-hyperlink-target-link-block
   _`an inline hyperlink target`
            
  See `Hyperlink targets`_ for syntax details.

  :NOTE: In converted file, Implicit hyperlink are internal file link, 
         and Explicit hyperlink are external links.

         While in vim, clicking both links will bring you to internal intarget.
         Cause it's target may not valid in local domain.

.. _Hyperlink References:
   http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#hyperlink-references

.. _Hyperlink targets:
   http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#hyperlink-targets

Table
~~~~~

Tables are highlighted and folded.

For Grid table, it is auto formatted.

* Grid Table: 

  Highlighted and Folded.
  When folded, the numbers of rows and columns will be shown as '3x2'

  Can be autoformated. Only support equal columns each row (no span).

  + Commands:

    - Create: Use ```<C-E>tc`` or ``:RivTableCreate`` to create table
    - Format: Use ``<C-E>tf`` or ``:RivTableFormat`` to format table.

      It will be auto formatted after leaving insert mode,
      or pressing ``<Enter>`` or ``<Tab>`` in insert mode.

    **Insert Mode Only:**

    - Inside the Table ::

        +-------+-------------------------------------------------------------+
        |       | Grid Table (No column or row span supported yet)            |
        +-------+-------------------------------------------------------------+
        | Lines | - <Enter> in column to add a new line                       |
        |       | - This is the second line of in same row of table.          |
        +-------+-------------------------------------------------------------+
        | Rows  | - <C-Enter> to add a seperator and a new row                |
        |       | - <C-S-Enter> to add a header seperator and a new row       |
        |       |   (There could be only one header seperator in a table)     |
        |       | - <S-Enter> to jump to next line                            |
        +-------+-------------------------------------------------------------+
        | Cell  | - <C-E>tn or <Tab> or RivTableNextCell, jump to next cell   |
        |       | - <C-E>tp or <S-Tab> or RivTablePrevCell, jump to prev cell |
        +-------+-------------------------------------------------------------+
        | Multi | - MultiByte characters are OK                               |
        |       | - 一二三四五  かきくけこ                                    |
        +-------+-------------------------------------------------------------+


      
      The table will be rendered as:

      +-------+-------------------------------------------------------------+
      |       | Grid Table (No column or row span supported yet)            |
      +-------+-------------------------------------------------------------+
      | Lines | - <Enter> in column to add a new line                       |
      |       | - This is the second line of in same row of table.          |
      +-------+-------------------------------------------------------------+
      | Rows  | - <C-Enter> to add a seperator and a new row                |
      |       | - <C-S-Enter> to add a header seperator and a new row       |
      |       |   (There could be only one header seperator in a table)     |
      |       | - <S-Enter> to jump to next line                            |
      +-------+-------------------------------------------------------------+
      | Cell  | - <C-E>tn or <Tab> or RivTableNextCell, jump to next cell   |
      |       | - <C-E>tp or <S-Tab> or RivTablePrevCell, jump to prev cell |
      +-------+-------------------------------------------------------------+
      | Multi | - MultiByte characters are OK                               |
      |       | - 一二三四五  かきくけこ                                    |
      +-------+-------------------------------------------------------------+

    See `Grid Tables`_ for syntax details.


* Simple Table:

  Highlighted and folded.
  When folded, the numbers of rows and columns will be shown as '3+2'

  No auto formatting. ::

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


  The table will be rendered as:

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

Some command wrapper to convert rst files to html/xml/latex/odt/... 
(docutils_  required)

* Commands:

  + Convert to Html

    - ``:Riv2HtmlIndex``  ``<C-E>wi``
      browse the html index page.
    - ``:Riv2HtmlFile``  ``<C-E>2hf``
      convert to html file.
  
    - ``:Riv2HtmlAndBrowse``  ``<C-E>2hh``
      convert to html file and browse. 
      default is 'firefox'
  
      the browser is set by `g:riv_web_browser`_, default is ``firefox``
  
    - ``:Riv2HtmlProject`` ``<C-E>2hp`` converting whole project into html.
      And will ask you to copy all the file with extension in '`g:riv_file_link_ext`_' 
  
  + ``:Riv2Odt`` ``<C-E>2oo`` convert to odt file and browse by ft browser
  
    The browser is set with '_`g:riv_ft_browser`'. 
    default is (unix:'xdg-open', windows:'start')
  
  + ``:Riv2Xml`` ``<C-E>2xx`` convert to xml file and browse by web browser
  + ``:Riv2S5`` ``<C-E>2ss`` convert to s5 file and browse by web browser
  + ``:Riv2Latex`` ``<C-E>2ll`` convert to latex file and edit in vim
  
* Options:

  + If you have installed Pygments_ , code will be highlighted
    in html , as the syntax highlight stylesheet have been embedded
    in it by Riv.

    You can change the stylesheet with '_`g:riv_html_code_hl_style`'

    - When set to 'default', 'emacs', or 'friendly'
      it will use pygments_'s relevant built-in style.
    - You can also use your own stylesheet.
      The full path should be provided.
    - default is 'default'
    
    - Syntax highlight for other formatting are not supported yet.

  + Some misc changing have been done on the stylesheet for better view in html.
    
    The ``literal`` and ``literal-block``'s background have been set to '#eeeeee'.

  + Output files path

    - For the files that are in a project. 
      The path of converted files by default is under ``build_path`` of your project directory. 
  
      1. default is ``_build``
      2. To change the path. Set it in your vimrc::
        
           " Assume you have a project name project 1
           let project1.build_path = '~/Documents/Riv_Build'
    
      3. Open the build path: ``:Riv2BuildPath`` ``<C-E>2b``
      4. local file link converting will be done. 
         See `local file link converting`_ for details.
  
    - For the files that not in a project.  
      '_`g:riv_temp_path`' is used to determine the output path
  
      1. When it's empty or ``0``, 
         the converted file is put under the same directory of file ,

      2. if `g:riv_temp_path`_ is ``1``,
         the converted file is put in the vim temp path,
      3. Otherwise the converted file is put in the `g:riv_temp_path`_,
      4. default is 1

      5. Also no local file link will be converted.


:NOTE: When converting, It will first try ``rst2xxxx2.py`` , then try ``rst2xxxx.py``

       You'd better install the package of python 2 version. 

       And make sure it's in your ``$PATH``

       Otherwise errors may occour as py3 version uses 'bytes'.


Riv 
-----

Following features provides more functions for rst documents.

* Project_, Scratch_, Helpers_ are extra function for managing rst documents.
* File_, Todos_ are extended syntax items for writing rst document.

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
  you can change it by defining project to '_`g:riv_projects`' in your vimrc.::

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

The link to edit local files.  ``non-reStructuredText syntax``

As reStructuredText haven't define a pattern for local files currently.

Riv provides some convenient way to link to other local files in
the rst documents. 

* For linking with local file in vim easily,
  The filename with extension , 
  like ``xxx.rst``  ``~/Documents/xxx.py``,
  will be highlighted and linked, only in vim.

  And you can disable highlighting it with 
  setting '_`g:riv_file_ext_link_hl`' to 0.

* Two types for linking file while converting to other format.
  (works for document in project only.)

  :MoinMoin: use ``[[xxx]]`` to link to a local file.
  :Sphinx: use ``:doc:`xxx``` and ``:file:`xxx.rst``` to link to local
           file and local document.

           See Sphinx_Role_Doc_.
           
           It will be not changed to link with Riv.
           You'd better use it with Sphinx_'s tool set.

  + You can switch style with '_`g:riv_file_link_style`'

    - when set to 1, ``MoinMoin``: 
    
      words like ``[[xxx]]`` ``[[xxx.vim]]`` will be detected as file link. 

      words like ``[[xxx/]]' will link to ``xxx/index.rst``

      words like ``[[/xxxx/xxx.rst]]`` 
      will link to ``DOC_ROOT/xxx/xxx.rst``

      words like ``[[~/xxx/xxx.rst]]``  ``[[x:/xxx/xxx.rst]]``
      will be considered as external file links

      words like ``[[/xxxx/xxx/]]`` ``[[~/xxx/xxx/]]`` 
      will be considered as external directory links, 
      and link to the directory.

    - when set to 2, ``Sphinx``:

      words like ``:doc:`xxx.rst``` ``:doc:`xxx.py``` ``:doc:`xxx.cpp``` will be detected as file link.

      NOTE: words like ``:doc:`xxx/``` are illegal in sphinx, You should use ``:doc:`xxx/index```  , 
      and link to ``xxx/index.rst``

      words like ``:doc:`/xxxx/xxx.rst```
      will link to ``DOC_ROOT/xxxx/xxx.rst``
    
      words like ``:file:`~/xxx/xxx.py``` ``:file:`/xxx/xxx.py``` ``:file:`x:/xxx.rst```
      will be considered as external file links

      words like ``:file:`~/xxx/xxx/``` 
      will be considered as external directory links, 
      and link to the directory.

      You can add other extensions with '_`g:riv_file_link_ext`'.
      which default is ``vim,cpp,c,py,rb,lua,pl`` ,
      meaning these files will be recongized.

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
the links need converting before Publish_.
       
When it's a rst file in a Project_.

Those detected local file link will be converted to an embedded link. 
in this form::

 `xxx.rst <xxx.html>`_ `xxx.py <xxx.py>`_

:NOTE: link converting in a table will make the table error format.
       So you'd better convert it to a link manually.
       use ``:RivCreateLink`` or ``<C-E>il`` to 
       create it manually. ::
   
           file.rst_

           .. _file.rst:: file.html   

For now it's overhead with substitude by a temp file.
A parser for docutils_ is needed in the future.

And for Sphinx_ users.
you should use Sphinx's tool set to convert it.

Scratch
~~~~~~~
  
Scratch is a place for writing diary or notes.

* ``:RivScratchCreate`` ``<C-E>sc``
  Create or jump to the scratch of today.

  Scratches are created auto named by date in '%Y-%m-%d' format.

* ``:RivScratchView`` ``<C-E>cv``
  View Scratch index.

  The index is auto created. Seperate scratches by years and month
  
  You can change the month name using 
  '_`g:riv_month_names`'. 

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

Todo items to keep track of todo things.  ``non-reStructuredText syntax``

It is Todo-box or Todo-keywords in a bullet/enumerated/field list.

* Todo Box:

  + [ ] This is a todo item of initial state.
  + [o] This is a todo item that's in progress.
  + [X] This is a todo item that's finished.

  + You can change the todo box item by '_`g:riv_todo_levels`' ,

    default is ``" ,o,X"``

* Todo Keywords:
    
  Todo Keywords are also supported

  + FIXED A todo item of FIXME/FIXED keyword group.
  + DONE 2012-06-13 ~ 2012-06-23 A todo item of TODO/DONE keyword group.
  + START A todo item of START/PROCESS/STOP keyword group.
  + You can define your own keyword group for todo items with '_`g:riv_todo_keywords`'
  
    each keyword is seperated by ',' , each group is seperated by ';'
  
    default is ``"TODO,DONE;FIXME,FIXED;START,PROCESS,STOP"``,

    :Note: the last one of each group is considered as the finish keyword.


* Datestamps:

  Todo items's start or end date.

  + [X] 2012-06-23 A todo item with datestamp
  + Double Click or ``<Enter>`` or ``:RivTodoDate`` on a datestamp to change date. 

    If you have Calendar_ installed , it will use it to choose date.

    .. _Calendar: https://github.com/mattn/calendar-vim
  + It is controled by '_`g:riv_todo_datestamp`'
  
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

  + [ ] [#A] a todo item of priorty A
  + [ ] [#C] a todo item of priorty C
  + Double Click or ``<Enter>`` or ``:RivTodoPrior`` on priorty item 
    to change priority. 
  + You can define the priorty chars by '_`g:riv_todo_priorities`'
    Only alphabet or digits are supported.

    default is ``"ABC"``

* Actions:

  Add Todo Item
  
  + Use ``:RivTodoToggle`` or ``<C-E>ee`` to add or switch the todo progress.
    
    When adding a todo item, todo group is '_`g:riv_todo_default_group`'

    default is 0, which is the todo box group.

  + Use ``:RivTodoType1`` ``<C-E>e1`` ... ``:RivTodoType4`` ``<C-E>e4`` 
    to add or change the todo item by group. 
  + Use ``:RivTodoAsk`` ``<C-E>e``` will show an keyword group list to choose.

  Change Todo Status

  + Double Click or ``<Enter>`` in the box/keyword to swith the todo progress.
  

 
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
    search item matching inputing, 
    ``<Enter>`` or ``<Esc>`` to quit search mode.
      
    Set '_`g:riv_fuzzy_help`' to 1 to enable fuzzy searching in helper.

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

also indicating following files if exists::

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

Miscs
~~~~~

Some useful plugins.
This is an incomplete list.
    
    + Snipmate: snippet
    + neocomplcache: auto complete and snippet
    + calendar: set datestamp with it
    + fugitive: git control
    + solarized: a nice colorscheme
    + galaxy.vim:  my colorshceme sets
    + ...

Appendix
========

Commands
--------

The mappings and commands are described in each section.

Default leader map for Riv is ``<C-E>``.
You can change it by following options.
  
  + '_`g:riv_global_leader`' : leader map for Riv global mapping.

    - ``:RivIndex`` ``<C-E>ww`` to open the project index.
    - ``:RivAsk`` ``<C-E>wa`` to choose one project to open.
    - ``:RivScratchCreate`` ``<C-E>sc`` Create or jump to the scratch of today.
    - ``:RivScratchView`` ``<C-E>cv`` View Scratch index.

  + '_`g:riv_buf_leader`' : leader map for reStructuredText buffers.
  + '_`g:riv_buf_ins_leader`' : leader map for reStructuredText buffers's insert mode.
  + To remap a single mapping, use ``map`` in your vimrc::
        
        map <C-E>wi    :RivIndex<CR> 

Options
-------

The Options are described in each section.

You can set them in your vimrc.



.. _Sphinx: http://sphinx.pocoo.org/
.. _Sphinx_role_doc: http://sphinx.pocoo.org/markup/inline.html#role-doc
.. _Org-Mode: http://orgmode.org/
.. _reStructuredText: http://docutils.sourceforge.net/rst.html
.. _Syntastic: https://github.com/scrooloose/syntastic
.. _docutils: http://docutils.sourceforge.net/
.. _pygments: http://pygments.org/

.. _riv_log: https://github.com/Rykka/riv.vim/blob/master/doc/riv_log.rst
.. _riv_todo: https://github.com/Rykka/riv.vim/blob/master/doc/riv_todo.rst
.. _QuickStart: 
.. _Quickstart With Riv:
   https://github.com/Rykka/riv.vim/blob/master/doc/riv_quickstart.rst
.. _Quickintro For Riv:
   https://github.com/Rykka/riv.vim/blob/master/doc/riv_quickintro.rst
.. _A ReStructuredText Primer: http://docutils.sourceforge.net/docs/user/rst/quickstart.html
.. _Quick reStructuredText: http://docutils.sourceforge.net/docs/user/rst/quickref.html
.. _Grid tables: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#grid-tables
.. _Simple Tables: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#simple-tables
