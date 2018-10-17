################
Riv: Instruction
################

:Author: Rykka G.F
:Update: 2014-08-09
:Version: 0.77 
:Github: https://github.com/Rykka/riv.vim

* _`Index`:

  * 1 Instructions_ : Detailed Instructions

    * 1.1 Vim_ : Vim Improved Feature

      * 1.1.1 Folding_ : Overview the structure. 
      * 1.1.2 Syntax_ : Extra highlighting.
      * 1.1.3 Indent_ : Smarter indent. 
      * 1.1.4 Insert_ : Speed up the input!

    * 1.2 RST_ : Better RST Supporting

      * 1.2.1 Sections_ : Easy create, easy view.
      * 1.2.2 Lists_ : Auto numbered, auto leveled and auto indented.
      * 1.2.3 Links_ : Jumping and Highlighting.
      * 1.2.4 Table_ : Auto formatted. 
      * 1.2.5 Publish_ : Convert to html/xml/latex/odt...

    * 1.3 Riv_ : Management by Riv

      * 1.3.1 Sphinx_ :  Working with Sphinx.
      * 1.3.2 Project_ : A workspace for your documents.
      * 1.3.3 File_ : Link local file in the document.
      * 1.3.4 Scratch_ : Writing notes and diaries.
      * 1.3.5 Todos_ : Keep track of todo things.
      * 1.3.6 Helpers_ : Help work with document/project.

  * 2 Appendix_ : Extra Infomations

    * 2.1 Commands_ : Commands and Mappings.
    * 2.2 Options_ : Options and Settings.

Instructions
============

This is the detailed Instruction for Riv.

To View the Riv Intro , Use `:RivIntro`_

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
    :NOTE: When document's folding stucked, you can use `:RivReload`_ or ``<C-E>t``` 
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

   - normal style: ``xxx.rst_``
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
  
  **Normal**

  + ``>`` and ``<`` will indent with fixed indent.

    To use original ``shiftwidth`` indent.

    Use ``<C-E>>`` and ``<C-E><``

  **Insert**

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

* Insert extra fields.

  + `:RivCreateDate`_ : Insert current date 
  + `:RivCreateTime`_ : Insert current time
  + `:RivCreateEmphasis`_ : Create Emphasis text
  + `:RivCreateStrong`_ : Create Strong text
  + `:RivCreateLink`_ : Create Link based on current word
  + `:RivCreateFoot`_ : Create Footnote
  + `:RivCreateDate`_ : Insert Current Date
  + `:RivCreateTime`_ : Insert Current time
  + `:RivCreateInterpreted`_ : Interpreted
  + `:RivCreateLiteralInline`_ : LiteralInline
  + `:RivCreateLiteralBlock`_ : LiteralBlock
  + `:RivCreateHyperLink`_ : HyperLink
  + `:RivCreateTransition`_ : Transition
  + `:RivCreateExplicitMark`_ : ExplicitMark

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

    Use `:RivTitle1`_ ``<C-E>s1`` ...  `:RivTitle6`_ ``<C-E>s6`` ,
    To create level 1 to level 6 section title from current word.

    If the line empty, you will be asked to input a title.

    And `:RivTitle0`_ ``<C-E>s0`` will create a section title
    with an overline.

    Other commands is ``underline`` only.

    Riv use following punctuations for titles: 

    ``= - ~ " ' ``` , (HTML has 6 levels)

    You can change it with '`g:riv_section_levels`_'

    The `:RivTitle0`_ will use ``#``
    
    :NOTE: Keep in mind sub titles should be one level deeper
           than current one.
  
  + Folding: 

    Pressing ``<Enter>`` or double clicking on the section title 
    will toggle the folding of the section.

    The section number will be shown when folded.

  + Jumping:

    ``<Enter>`` or Clicking on the section reference will bring you to the section title.

    E.g.: click the link of Lists_ will bring you to the ``Lists`` Section (in vim)

  + Create a content table:
    
    Use `:RivCreateContent`_ or ``<C-E>ic`` to create it.

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

    - Shift right: ``>`` `:RivShiftRight`_ or ``<C-ScrollWheelDown>(UNIX only)``  
  
      Shift rightwards with ``ShiftWidth``

      If it's a list item, it will indent to the list item's sub list
  
    - Shift left: ``<`` `:RivShiftLeft`_ or ``<C-ScrollWheelUp>(UNIX only)``  

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
  
    Insert Mode Only. Note that some terminals pass ``<C-CR>`` and ``<S-CR>``
    as different (or indistinguishable) mappings, so the alternative key mapping
    should be used.

    - ``<CR>\<KEnter>`` (enter key and keypad enter key)
      Insert the content of this list.
  
      To insert content in new line of this list item. Add a blank line before it.
  
    - ``<C-CR>\<C-KEnter>`` 
      or ``<C-E>ln``
      Insert a new list of current list level
    - ``<S-CR>\<S-KEnter>`` 
      or ``<C-E>lb``
      Insert a new list of current child list level
    - ``<C-S-CR>\<C-S-KEnter>`` 
      or ``<C-E>lp``
      Insert a new list of current parent list level
    - When it's a field list, only the indent is inserted.
  
  + Change List Type:

    Normal and Insert Mode:
    
    - `:RivListType0`_ ``<C-E>l1`` ... `:RivListType4`_ ``<C-E>l5``
      Change or add list item symbol of type.
      
      The list item of each type is:: 
      
        '*' , '1.' , 'a.' , 'A)' ,'i)'

      :NOTE:  You should act this on a new list or list with no sub line.

              As list item changes, the indentation of it is changed.
              But this action does not change the sub item's indent.

              To change a list and it's sub item 
              with indentation fix , use shifting: ``>`` or ``<``.
             
    - `:RivListDelete`_ ``<C-E>lx``
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

  + `:RivCreateLink`_ ``<C-E>ik``
    create a link from current word. 

    If it's empty, you will be asked to input one.

    If the link is not Anonymous References,
    The target will be put at the end of file by default.

    '`g:riv_create_link_pos`_' can be used to change the target postion.

  + `:RivCreateFoot`_ ``<C-E>if``
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

    - Create: Use ```<C-E>tc`` or `:RivTableCreate`_ to create table
    - Format: Use ``<C-E>tf`` or `:RivTableFormat`_ to format table.

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

    - `:RivProjectHtmlIndex`_  ``<C-E>wi``
      browse the html index page.
    - `:Riv2HtmlFile`_  ``<C-E>2hf``
      convert to html file.
  
    - `:Riv2HtmlAndBrowse`_  ``<C-E>2hh``
      convert to html file and browse. 
      Default is 'firefox'
  
      The browser is set by `g:riv_web_browser`_, default is ``firefox``
  
    - `:Riv2HtmlProject`_ ``<C-E>2hp`` converting whole project into html.
      And will ask you to copy all the file with extension in '`g:riv_file_link_ext`_' 
  
  + `:Riv2Odt`_ ``<C-E>2oo`` convert to odt file and browse by ft browser
  
    The file browser is set with '`g:riv_ft_browser`_'. 
  
  + `:Riv2Xml`_ ``<C-E>2xx`` convert to xml file and browse by web browser
  + `:Riv2S5`_ ``<C-E>2ss`` convert to s5 file and browse by web browser
  + `:Riv2Latex`_ ``<C-E>2ll`` convert to latex file and edit in vim
  + `:Riv2Pdf`_ ``<C-E>2pp`` convert to latex file and then convert to pdf file.
  
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
    
      3. Open the build path: `:Riv2BuildPath`_ ``<C-E>2b``
      4. Local file link converting will be done. 
         See `local file link converting`_ for details.
      5. Set `g:riv_auto_rst2html`_ to 1 to automatic convert after writing.
         only project file are auto converted.
  
    - For the files that not in a project.  
      '`g:riv_temp_path`_' is used to determine the output path
  


:NOTE: When converting, It will first try ``rst2xxxx2.py`` , then try ``rst2xxxx.py``

       You'd better install the package of python 2 version. 

       And make sure it's in your ``$PATH``

       Otherwise errors may occur as py3 version uses 'bytes'.


Riv 
----

Following features provides more functions for rst documents.

* You can change some setting for a better working with Sphinx_.
* Project_, Scratch_, Helpers_ are extra function for managing rst documents.
* File_, Todos_ are extended syntax items for writing rst document.

Sphinx
~~~~~~

Riv can work with Sphinx (see `Sphinx Home`_ ).

- For now, you can use Cross-referencing document ``:doc:`xxx``` 
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

  And you can view the index page by `:RivProjectHtmlIndex`_ or ``<C-E>wi``


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

  + `:RivProjectIndex`_ ``<C-E>ww`` to open the first project index.
  + `:RivProjectList`_ ``<C-E>wa`` to choose one project to open.
  + `:RivProjectHtmlIndex`_ ``<C-E>wi`` Browse project html index.

* All projects are in `g:riv_projects`_, 

  + Define a project with a dictionary of options,
    If not defined, it will have the default value ::

      let project1 = { 'Name': 'My Working Notes', 'path': '~/Dropbox/rst',}
      let g:riv_projects = [project1]

  + To add multiple projects ::

      let project2 = { 'path': '~/Dropbox/rst2',}
      let g:riv_projects = [project1, project2]

  + if you are editing a rst document outside 
    a project.

    It's settings will using the first one.

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

* Using Rst's default HyperLink syntax to link local files.

  ::

      xxx.rst_
      Dir

      .. _xxx.rst: xxx.rst 
      .. _Dir: Dir/index.rst

  The ``:RivCreateLink`` (``<C-E>ck``) command are optimized to simplify working with them.

  You can type a ``xxx.rst`` or ``Dir/`` then use the command to make a link.

  For Simpify using, The local file links with 
  `g:riv_file_link_ext`_ will be auto opened in vim with 
  ``<2-Leftmouse>``, ``<CR>`` and ``:RivLinkOpen``
  if `g:riv_open_link_location`_ is set to 1.

  You can use ``:RivLinkShow`` to move to the location only.

  Also, The ``xxx.rst`` will be changed to ``xxx.html`` when convert to html

* WARNING! This method is deprecated! Use rst's normal link

  Two types for linking file while converting to other format.
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

  `:RivDeleteFile`_ ``<C-E>df``
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
       Use `:RivCreateLink`_ or ``<C-E>ck`` to 
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

* `:RivScratchCreate`_ ``<C-E>sc``
  Create or jump to the scratch of today.

  Scratches are created auto named by date in '%Y-%m-%d' format.

* `:RivScratchView`_ ``<C-E>sv``
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
  + Double Click or ``<Enter>`` or `:RivTodoDate`_ on a date stamp to change date. 

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
  + Double Click or ``<Enter>`` or `:RivTodoPrior`_ on priority item 
    to change priority. 
  + You can define the priority chars by '`g:riv_todo_priorities`_'

* Actions:

  Add Todo Item
  
  + Use `:RivTodoToggle`_ or ``<C-E>ee`` to add or switch the todo progress.
    
    Change default todo group by '`g:riv_todo_default_group`_'


  + Use `:RivTodoType1`_ ``<C-E>e1`` ... `:RivTodoType4`_ ``<C-E>e4`` 
    to add or change the todo item by group. 
  + Use `:RivTodoAsk`_ ``<C-E>e``` will show an keyword group list to choose.

  Change Todo Status

  + Double Click or ``<Enter>`` in the box/keyword to switch the todo progress.
  

 
  Delete Item 

  + Use `:RivTodoDel`_ ``<C-E>ex`` to delete the whole todo item

  Helper

  + Use `:RivHelpTodo`_ or ``<C-E>ht`` to open a `Todo Helper`_
  
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

    Set '`g:riv_todo_helper_ignore_done`_' to 1 to ignore TODOs that are marked
    as DONE in the display.

Todo Helper
"""""""""""

A helper to manage todo items of current project.
When current document is not in a project, will show current file's todo items.

+ `:RivHelpTodo`_ or ``<C-E>ht``
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

+ `:RivHelpFile`_ or ``<C-E>hf``
  Open File Helper.
  Default is in normal mode.

Section Helper
""""""""""""""
A helper showing current document section numbers

+ `:RivHelpSection`_ or ``<C-E>hs``
  Open Section Helper.
  Default is in normal mode.

Appendix
========

Commands
--------

+ Default leader map for Riv is ``<C-E>``.
  You can change it by '`g:riv_global_leader`_' 
  
+ To remap a single mapping, use ``map`` in your vimrc::

        map <C-E>wi    :RivIndex<CR> 

+ All commands can be executed by ``:{cmd}``.
  For example: ``:RivIndex`` to open the default Project Index.

+ You can use menu to view the commands Shortcut either.
  ``:popup Riv`` Can be used when you not showing the menu bar.


+ **Global**

  - _`:RivProjectIndex` : Open the default Riv project index in vim.

    **Normal** :	<C-E>ww,<C-E><C-W><C-W>

  - _`:RivProjectList` : Show Riv project list.

    **Normal** :	<C-E>wa,<C-E><C-W><C-A>

  - _`:RivProjectHtmlIndex` : Browse project html index.

    **Normal** :	<C-E>wi,<C-E><C-W><C-I>

  - _`:RivScratchCreate` : Create Or Edit Scratch of today.

    **Normal** :	<C-E>sc,<C-E><C-S><C-C>

  - _`:RivScratchView` : View The Index of Scratch Directory

    **Normal** :	<C-E>sv,<C-E><C-S><C-V>

+ **View**

  - _`:RivFoldToggle` : Toggle Fold

    **Normal** :	<C-E><Space><Space>

  - _`:RivFoldAll` : Toggle all folding

    **Normal** :	<C-E><Space>a

  - _`:RivFoldUpdate` : Update Folding

    **Normal** :	<C-E><Space>u

  - _`:RivLinkOpen` : Open Link under Cursor

    **Normal** :	<C-E>ko

  - _`:RivLinkShow` : Move cursor to the link target.

    **Normal** :	<C-E>ks

  - _`:RivLinkNext` : Jump to Next Link

    **Normal** :	<C-E>kn,<TAB>

  - _`:RivLinkPrev` : Jump to Prev Linx

    **Normal** :	<C-E>kp,<S-TAB>

  - _`:RivShiftRight` : Shift Right with level and indent adjustment.

    **Normal,Visual** :	<C-E>l>,>,<C-ScrollwheelDown>

  - _`:RivShiftLeft` : Shift Left with level and indent adjustment.

    **Normal,Visual** :	<C-E>l<,<,<C-ScrollwheelUp>

  - _`:RivShiftEqual` : Format List level

    **Normal,Visual** :	<C-E>l=,=

  - _`:RivNormRight` : Normal Shift Right

    **Normal,Visual** :	<C-E>>,<S-ScrollwheelDown>

  - _`:RivNormLeft` : Normal Shift Left

    **Normal,Visual** :	<C-E><lt>,<S-ScrollwheelUp>

  - _`:RivNormEqual` : Normal Equal

    **Normal,Visual** :	<C-E>=

  - _`:RivItemClick` : Open Link,Toggle item and toggle section folding

    **Normal** :	<2-LeftMouse>

  - _`:RivItemToggle` : Open Link, Toggle item

    **Normal** :	<CR>,<KEnter>

+ **Doc**

  - _`:RivTitle1` : Create Type 1 Title

    **Normal,Insert** :	<C-E>s1

  - _`:RivTitle2` : Create Type 2 Title

    **Normal,Insert** :	<C-E>s2

  - _`:RivTitle3` : Create Type 3 Title

    **Normal,Insert** :	<C-E>s3

  - _`:RivTitle4` : Create Type 4 Title

    **Normal,Insert** :	<C-E>s4

  - _`:RivTitle5` : Create Type 5 Title

    **Normal,Insert** :	<C-E>s5

  - _`:RivTitle6` : Create Type 6 Title

    **Normal,Insert** :	<C-E>s6

  - _`:RivTitle0` : Create Type 0 Title

    **Normal,Insert** :	<C-E>s0

  - _`:RivTableCreate` : Create a Table

    **Normal,Insert** :	<C-E>tc

  - _`:RivTableFormat` : Format table

    **Normal,Insert** :	<C-E>tf

  - _`:RivTableNextCell` : Nav to Next Cell

    **Normal,Insert** :	<C-E>tn

  - _`:RivTablePrevCell` : Nav to Prev Cell

    **Normal,Insert** :	<C-E>tp

  - _`:RivListNew` : Create a New List

    **Normal,Insert** :	<C-E>ln

  - _`:RivListSub` : Create a sub list item

    **Normal,Insert** :	<C-E>lb

  - _`:RivListSup` : Create a sup list item

    **Normal,Insert** :	<C-E>lp

  - _`:RivListToggle` : ToggleList item

    **Normal,Insert** :	<C-E>l`

  - _`:RivListDelete` : Delete List item

    **Normal,Insert** :	<C-E>lx

  - _`:RivListType0` : Create a List type 0

    **Normal,Insert** :	<C-E>l1

  - _`:RivListType1` : Create a List type 1

    **Normal,Insert** :	<C-E>l2

  - _`:RivListType2` : Create a List type 2

    **Normal,Insert** :	<C-E>l3

  - _`:RivListType3` : Create a List type 3

    **Normal,Insert** :	<C-E>l4

  - _`:RivListType4` : Create a List type 4

    **Normal,Insert** :	<C-E>l5

  - _`:RivTodoToggle` : Toggle Todo item's status

    **Normal,Insert** :	<C-E>ee

  - _`:RivTodoDel` : Del Todo Item

    **Normal,Insert** :	<C-E>ex

  - _`:RivTodoDate` : Change Date stamp under cursor

    **Normal,Insert** :	<C-E>ed

  - _`:RivTodoPrior` : Change Todo Priorties

    **Normal,Insert** :	<C-E>ep

  - _`:RivTodoAsk` : Show the todo group list

    **Normal,Insert** :	<C-E>e`

  - _`:RivTodoType1` : Change to group 1

    **Normal,Insert** :	<C-E>e1

  - _`:RivTodoType2` : Change to group 2

    **Normal,Insert** :	<C-E>e2

  - _`:RivTodoType3` : Change to group 3

    **Normal,Insert** :	<C-E>e3

  - _`:RivTodoType4` : Change to group 4

    **Normal,Insert** :	<C-E>e4

  - _`:RivTodoUpdateCache` : Update Todo cache

    **Normal** :	<C-E>uc

+ **Edit**

  - _`:RivCreateLink` : Create Link based on current word

    **Normal,Insert** :	<C-E>ck

  - _`:RivCreateFoot` : Create Footnote

    **Normal,Insert** :	<C-E>cf

  - _`:RivCreateDate` : Insert Current Date

    **Normal,Insert** :	<C-E>cdd

  - _`:RivCreateTime` : Insert Current time

    **Normal,Insert** :	<C-E>cdt

  - _`:RivCreateContent` : Insert Content Table

    **Normal** :	<C-E>cc

  - _`:RivCreateEmphasis` : Emphasis

    **Normal,Insert** :	<C-E>ce

  - _`:RivCreateStrong` : Strong

    **Normal,Insert** :	<C-E>cs

  - _`:RivCreateInterpreted` : Interpreted

    **Normal,Insert** :	<C-E>ci

  - _`:RivCreateLiteralInline` : LiteralInline

    **Normal,Insert** :	<C-E>cl

  - _`:RivCreateLiteralBlock` : LiteralBlock

    **Normal,Insert** :	<C-E>cb

  - _`:RivCreateHyperLink` : HyperLink

    **Normal,Insert** :	<C-E>ch

  - _`:RivCreateTransition` : Transition

    **Normal,Insert** :	<C-E>cr

  - _`:RivCreateExplicitMark` : ExplicitMark

    **Normal,Insert** :	<C-E>cm

  - _`:RivDeleteFile` : Delete Current File

    **Normal** :	<C-E>df

+ **Miscs**

  - _`:Riv2HtmlFile` : Convert to html

    **Normal** :	<C-E>2hf

  - _`:Riv2HtmlAndBrowse` : Convert to html and browse current file

    **Normal** :	<C-E>2hh

  - _`:Riv2HtmlProject` : Convert project to html

    **Normal** :	<C-E>2hp

  - _`:Riv2Odt` : Convert to odt

    **Normal** :	<C-E>2oo

  - _`:Riv2S5` : Convert to S5

    **Normal** :	<C-E>2ss

  - _`:Riv2Xml` : Convert to Xml

    **Normal** :	<C-E>2xx

  - _`:Riv2Latex` : Convert to Latex

    **Normal** :	<C-E>2ll

  - _`:Riv2Pdf` : Convert to Pdf

    **Normal** :	<C-E>2pp

  - _`:Riv2BuildPath` : Show Build Path of the project

    **Normal** :	<C-E>2b

  - _`:RivReload` : Force reload Riv and Current Document

    **Normal** :	<C-E>t`

  - _`:RivTestFold0` : Test folding time

    **Normal** :	<C-E>t1

  - _`:RivTestFold1` : Test folding time and foldlevel

    **Normal** :	<C-E>t2

  - _`:RivTestTest` : Test the test

    **Normal** :	<C-E>t4

  - _`:RivTestObj` : Show Test object

    **Normal** :	<C-E>t3

  - _`:RivSuperBackSpace` : Super Backspace

    **Insert** :	<C-E>mq,<BS>

  - _`:RivSuperTab` : Super Tab

    **Insert** :	<C-E>me,<Tab>

  - _`:RivSuperSTab` : Super Shift Tab

    **Insert** :	<C-E>mw,<S-Tab>

  - _`:RivSuperEnter` : Super Enter

    **Normal,Insert** :	<C-E>mm,<Enter>,<KEnter>

  - _`:RivSuperCEnter` : Super Ctrl Enter

    **Normal,Insert** :	<C-E>mj,<C-Enter>,<C-KEnter>

  - _`:RivSuperSEnter` : Super Shift Enter

    **Normal,Insert** :	<C-E>mk,<S-Enter>,<S-KEnter>

  - _`:RivSuperMEnter` : Super Alt Enter

    **Normal,Insert** :	<C-E>mh,<C-S-Enter>,<M-Enter>,<C-S-KEnter>,<M-KEnter>

  - _`:RivHelpTodo` : Show Todo Helper

    **Normal** :	<C-E>ht,<C-E><C-h><C-t>

  - _`:RivHelpFile` : Show File Helper

    **Normal** :	<C-E>hf,<C-E><C-h><C-f>

  - _`:RivHelpSection` : Show Section Helper

    **Normal** :	<C-E>hs

  - _`:RivVimTest` : Run doctest for Vim Script

  - _`:RivIntro` : Show Riv Intro

  - _`:RivInstruction` : Show Riv Instruction

  - _`:RivQuickStart` : Show Riv QuickStart

  - _`:RivPrimer` : Show RST Primer

  - _`:RivCheatSheet` : Show RST CheatSheet

  - _`:RivSpecification` : Show RST Specification

  - _`:RivGetLatest` : Show Get Latest Info


Options
-------

+-------------------------------+----------------------------------------------------------+
| **Name**                      | **Description**                                          |
+-------------------------------+----------------------------------------------------------+
| **Main**                      |                                                          |
+-------------------------------+----------------------------------------------------------+
| _`g:riv_default`              | The dictionary contain all riv runtime variables.        |
|                               |                                                          |
| {...}                         |                                                          |
+-------------------------------+----------------------------------------------------------+
| _`g:riv_projects`             | The list contain your project's settings.                |
|                               |                                                          |
| []                            | Defaults are::                                           |
|                               |                                                          |
|                               |   'path'               : '~/Documents/Riv'               |
|                               |   'build_path'         : '_build'                        |
|                               |   'scratch_path'       : 'Scratch'                       |
|                               |   'source_suffix'      : `g:riv_source_suffix`_          |
|                               |   'master_doc'         : `g:riv_master_doc`_             |
+-------------------------------+----------------------------------------------------------+
| Commands_                     |                                                          |
+-------------------------------+----------------------------------------------------------+
| _`g:riv_global_leader`        | Leader map for Riv global mapping.                       |
|                               |                                                          |
| '<C-E>'                       |                                                          |
+-------------------------------+----------------------------------------------------------+
| File_                         |                                                          |
+-------------------------------+----------------------------------------------------------+
| _`g:riv_master_doc`           | The master rst document for each directory in project.   |
|                               |                                                          |
| 'index'                       | You can set it for each project.                         |
+-------------------------------+----------------------------------------------------------+
| _`g:riv_source_suffix`        | The suffix of rst document.                              |
|                               |                                                          |
| '.rst'                        | You can set it for each project.                         |
|                               |                                                          |
|                               | Also for all files with the suffix,                      |
|                               | filetype will be set to 'rst'                            |
+-------------------------------+----------------------------------------------------------+
| _`g:riv_file_link_ext`        | The file link with these extension will be recognized.   |
|                               |                                                          |
| 'vim,cpp,c,py,rb,lua,pl'      | These files will be copied when converting a porject.    |
|                               |                                                          |
|                               | These files along with ,'rst,txt' and                    |
|                               | source_suffixs used in your project will                 |
|                               | be highlighted.                                          |
+-------------------------------+----------------------------------------------------------+
| _`g:riv_open_link_location`   | The file link with default extension will be recognized. |
| 1                             | These files will be opened when open it's link reference |
|                               |                                                          |
|                               | when set to 0 , will just jump to the link location.     |
|                               |                                                          |
|                               | when set to 1, will open exist files, relative file      |
|                               | with  `g:riv_file_link_ext`_ and links                   |
|                               |                                                          |
+-------------------------------+----------------------------------------------------------+
| _`g:riv_file_ext_link_hl`     | Syntax highlighting for file with extensions             |
|                               | in `g:riv_file_link_ext`_.                               |
| 1                             |                                                          |
+-------------------------------+----------------------------------------------------------+
| _`g:riv_file_link_invalid_hl` | Cursor Highlight Group for non-exists file link.         |
|                               |                                                          |
| 'ErrorMsg'                    |                                                          |
+-------------------------------+----------------------------------------------------------+
| _`g:riv_file_link_style`      | The file link style.                                     |
|                               |                                                          |
| 1                             | - 1:``MoinMoin`` style::                                 |
|                               |                                                          |
|                               |    [[xxx]] => xxx.rst                                    |
|                               |    [[xxx/]] => xxx/index.rst                             |
|                               |    [[/xxx]] => DOC_ROOT/xxx.rst                          |
|                               |    [[xxx.vim]] => xxx.vim                                |
|                               |    ('vim' is in `g:riv_file_link_ext`_)                  |
|                               |    [[~/xxx/xxx.rst]] => ~/xxx/xxx.rst                    |
|                               |                                                          |
|                               | - 2: ``Sphinx`` style::                                  |
|                               |                                                          |
|                               |     :doc:`xxx` => xxx.rst                                |
|                               |     :doc:`xxx/index`  => xxx/index.rst                   |
|                               |                                                          |
|                               |     :download:`xxx.py` => xxx.py                         |
+-------------------------------+----------------------------------------------------------+

+------------------------------------+-------------------------------------------------+
| Syntax_                            |                                                 |
+------------------------------------+-------------------------------------------------+
| _`g:riv_highlight_code`            | The language name                               |
|                                    |                                                 |
| 'lua,python,cpp,javascript,vim,sh' | is the syntax name used by vim.                 |
|                                    |                                                 |
|                                    | For some syntax have different name in pygments |
|                                    | and vim,  you can use `|` to seperate it.       |
|                                    |                                                 |
|                                    | e.g: pygments_code_name|vim_code_name           |
+------------------------------------+-------------------------------------------------+

+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_code_indicator`                    | Highlight the first column of code directives.         |
|                                            |                                                        |
| 1                                          |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_link_cursor_hl`                    | Cursor's Hover Highlighting for links.                 |
|                                            |                                                        |
| 1                                          |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_python_rst_hl`                     | Highlight ``DocString`` in python files                |
|                                            |                                                        |
| 0                                          | with rst syntax.                                       |
+--------------------------------------------+--------------------------------------------------------+
| Todos_                                     |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_todo_levels`                       | The Todo levels for Todo-Box.                          |
|                                            |                                                        |
| " ,o,X"                                    | Means ``[ ]``, ``[o]``, ``[X]`` by default.            |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_todo_priorities`                   | The Todo Priorities for Todo-Items                     |
|                                            |                                                        |
| "ABC"                                      | Only alphabetic or digits.                             |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_todo_default_group`                | The default Todo Group for ':RivTodoToggle'            |
|                                            |                                                        |
| 0                                          | - 0 is the Todo-Box group.                             |
|                                            | - 1 and other are the Todo-Keywords group.             |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_todo_datestamp`                    | The datestamp behavior for Todo-Item.                  |
|                                            |                                                        |
| 1                                          | - 0: no DateStamp                                      |
|                                            | - 1: only finish datestamp                             |
|                                            | - 2: both initial and finish datestamp                 |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_todo_keywords`                     | The Todo-Keywords groups.                              |
|                                            |                                                        |
| "TODO,DONE;FIXME,FIXED;START,PROCESS,STOP" | Each group is separated by ';',                        |
|                                            | Each keyword is separated by ','.                      |
+--------------------------------------------+--------------------------------------------------------+
|  Folding_                                  |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_disable_folding`                   | Disable Folding or not                                 |
|                                            |                                                        |
| 0                                          | - 0: Enable it.                                        |
|                                            | - 1: Disable it.                                       |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_fold_blank`                        | Folding blank lines in the end of the folding lines.   |
|                                            |                                                        |
| 2                                          | - 0: fold one blank line, show rest.                   |
|                                            | - 1: fold all blank lines, show one if more than one.  |
|                                            | - 2: fold all blank lines.                             |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_fold_level`                        | Folding more structure for document.                   |
|                                            |                                                        |
| 3                                          | - 0: 'None'                                            |
|                                            | - 1: 'Sections'                                        |
|                                            | - 2: 'Sections and Lists'                              |
|                                            | - 3: 'Sections,Lists and Blocks'.                      |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_fold_section_mark`                 | Mark to seperate the section numbers: '1.1', '1.1.1'   |
|                                            |                                                        |
| '.'                                        |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_fold_auto_update`                  | Auto Update folding whilst write to buffer.            |
|                                            |                                                        |
| 1                                          |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_auto_fold_force`                   | Reducing fold level for editing large files.           |
|                                            |                                                        |
| 1                                          |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_auto_fold1_lines`                  | Lines of file exceeds this will fold section only      |
|                                            |                                                        |
| 5000                                       |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_auto_fold2_lines`                  | Lines of file exceeds this will fold section and list  |
|                                            |                                                        |
| 3000                                       |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_fold_info_pos`                     | The position for fold info.                            |
|                                            |                                                        |
| 'right'                                    |                                                        |
|                                            |                                                        |
|                                            | - 'left', infos will be shown at left side.            |
|                                            | - 'right', show infos at right side.                   |
+--------------------------------------------+--------------------------------------------------------+
| Publish_                                   |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_web_browser`                       | The browser for browsing html and web links.           |
|                                            |                                                        |
| 'firefox'                                  |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_ft_browser`                        | The browser for opening files.                         |
|                                            |                                                        |
| UNIX:'xdg-open', windows:'start'           |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_rst2html_args`                     | Extra args for converting to html.                     |
|                                            |                                                        |
| ''                                         |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_rst2odt_args`                      | Extra args for converting to odt.                      |
|                                            |                                                        |
| ''                                         |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_rst2xml_args`                      | Extra args for converting to xml.                      |
|                                            |                                                        |
| ''                                         |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_rst2s5_args`                       | Extra args for converting to s5.                       |
|                                            |                                                        |
| ''                                         |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_rst2latex_args`                    | Extra args for converting to latex.                    |
|                                            |                                                        |
| ''                                         |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_temp_path`                         | The temp path for converting a file **NOT**            |
|                                            | in a project.                                          |
| 1                                          |                                                        |
|                                            | - 0: put under the same directory of converting file.  |
|                                            | - 1: put in the temp path of vim.                      |
|                                            | - 'PATH': to the path if it's valid.                   |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_html_code_hl_style`                | The code highlight style for html.                     |
|                                            |                                                        |
| 'default'                                  | - 'default', 'emacs', or 'friendly':                   |
|                                            |   use pygments_'s relevant built-in style.             |
|                                            | - 'FULL_PATH': use your own style sheet in path.       |
+--------------------------------------------+--------------------------------------------------------+
| Insert_                                    |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_disable_del`                       | Set to 1 to disable the invocation of :fixdel, which   |
|                                            | disabled the <Del> key from deleting a character under |
| 0                                          | cursor; default is 0.                                  |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_disable_indent`                    | Set to 1 to use vim's default indent expr function.    |
|                                            | default is 0.                                          |
| 0                                          |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_i_tab_pum_next`                    | Use ``<Tab>`` to act as ``<C-N>`` in insert mode when  |
|                                            | there is a popup menu.                                 |
| 1                                          |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_i_tab_user_cmd`                    | User command to hook ``<Tab>`` in insert mode.         |
|                                            |                                                        |
| ''                                         | let g:riv_i_tab_user_cmd =                             |
|                                            | "\<c-g>u\<c-r>=snipMate#TriggerSnippet()\<cr>"         |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_i_stab_user_cmd`                   | User command to hook ``<S-Tab>`` in insert mode.       |
|                                            |                                                        |
| ''                                         |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_ignored_imaps`                     | Use to disable mapping in insert mode.                 |
|                                            |                                                        |
| ''                                         | ``let g:riv_ignored_imaps = "<Tab>,<S-Tab>"``          |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_ignored_nmaps`                     | Use to disable mapping in normal mode.                 |
|                                            |                                                        |
| ''                                         | ``let g:riv_ignored_nmaps = "<Tab>,<S-Tab>"``          |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_ignored_vmaps`                     | Use to disable mapping in visual mode.                 |
|                                            |                                                        |
| ''                                         | ``let g:riv_ignored_vmaps = "<Tab>,<S-Tab>"``          |
+--------------------------------------------+--------------------------------------------------------+
| **Miscs**                                  |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_create_link_pos`                   | Link Target's position when created.                   |
|                                            |                                                        |
| '$'                                        | - '.' : below current line.                            |
|                                            | - '$' : append at end of file.                         |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_month_names`                       | Month Names for Scratch Index                          |
|                                            |                                                        |
| 'January,February,March,April,             |                                                        |
| May,June,July,August,September,            |                                                        |
| October,November,December'                 |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_section_levels`                    | The section line punctuations for section title.       |
|                                            |                                                        |
| '=-~"''`'                                  | **NOTE**                                               |
|                                            | Use ``''`` to escape ``'`` in literal-quote ``'xxx'``. |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_content_format`                    | The format for content table.                          |
|                                            |                                                        |
| '%i%l%n %t'                                | - %i is the indent of each line                        |
|                                            | - %l is the list symbol '+'                            |
|                                            | - %n is the section number                             |
|                                            | - %t is the section title                              |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_fuzzy_help`                        | Fuzzy searching in helper.                             |
|                                            |                                                        |
| 0                                          |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_todo_helper_ignore_done`           | Ignore TODOs that are marked as DONE in helper.        |
|                                            |                                                        |
| 0                                          |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_auto_format_table`                 | Auto formating table when leave Insert Mode            |
|                                            |                                                        |
| 1                                          |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_auto_rst2html`                     | Auto Converting rst to html after writing.             |
|                                            | file should in project.                                |
|                                            |                                                        |
| 0                                          |                                                        |
|                                            |                                                        |
+--------------------------------------------+--------------------------------------------------------+
| _`g:riv_default_path`                      | Default path for your project.                         |
|                                            |                                                        |
| '~/Documents/Riv'                          |                                                        |
+--------------------------------------------+--------------------------------------------------------+




.. _Sphinx_role_doc: http://sphinx.pocoo.org/markup/inline.html#role-doc
.. _Org-Mode: http://orgmode.org/
.. _reStructuredText: http://docutils.sourceforge.net/rst.html
.. _Syntastic: https://github.com/scrooloose/syntastic
.. _Vundle: https://www.github.com/gmarik/vundle
.. _docutils: http://docutils.sourceforge.net/
.. _pygments: http://pygments.org/
.. _Quickstart With Riv:
   https://github.com/Rykka/riv.vim/blob/master/doc/riv_quickstart.rst
.. _A ReStructuredText Primer: http://docutils.sourceforge.net/docs/user/rst/quickstart.html
.. _Quick reStructuredText: http://docutils.sourceforge.net/docs/user/rst/quickref.html
.. _Grid tables: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#grid-tables
.. _Simple Tables: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#simple-tables

.. _reStructuredText Specification: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html
.. _reStructuredText cheatsheet: http://docutils.sourceforge.net/docs/user/rst/cheatsheet.txt
.. _Sphinx Home: http://sphinx.pocoo.org/
.. _QuickStart: http://www.youtube.com/watch?v=sgSz2J1NVJ8
.. _``xxx.rst: ``xxx.rst_
