====================
QuickStart With Riv
====================

:Author: Rykka
:Date: 2012-07-08 22:58:41

This is an quick guide for Riv_ 
and include a simple intro of reStructuredText_ syntax.

.. _Riv: https://github.com/Rykka/riv.vim
.. _reStructuredText: http://docutils.sourceforge.net/rst.html


Use it in Vim.
If you have installed ``Riv``, 
Use ``:RivQuickStart`` or ``<C-E>hq`` to get view and edit it in vim.

You can edit it freely as it's not to be written to disk.
Use ``zx`` in the file to update folding.

Project
-------

Project is a place to hold your documents.

Use ``<C-E>ww`` to open your project index. 

By default the path is at ``~/Documents/Riv``.
You can change it by defining project to ``g:riv_projects`` in your vimrc.::

    let project1 = { 'path': '~/Dropbox/rst',}
    let g:riv_projects = [project1]

Sections
--------

Section is defined by a line with ``underline`` punctuations.

Use ``<C-E>s1`` ~ ``<C-E>s6`` to create section level from 1 to 6.

It is auto folded, and showing section number at foldline.

You can use ``<C-E>hs`` to open the section helper, 
Then you can view and navigating sections of current document.

Paragraph
---------

Paragraph is the basic document content.
Each paragraph is seperated by an blank line.

This is a paragraph.
This is the second line of the paragraph.

This is a new paragraph.

Blocks
------

Blocks are auto folded::

    This is a literal block.
      The markup and indents are preserved by parser.
 
.. This is a comment
   The second line of the comment


Lists
-----

* List item 1
* List item 2
  ``<Enter>`` to insert with continuous paragraph of this list item

  A new paragraph of the list item.

* Use ``<C-Enter>`` to create a list item of the same level
* '*' , '+' or '-' is for bullet list.

  + Use ``<S-Enter>`` to create a list item of child level
  + sub list 2 

    - The List symbols for sublist is auto generated.  
      from '*' to '(i)'

        ``* + - 1. A. a. I. i. 1) ...``

      1. This is a enumerated list with arabic number
      2. second item
      3. third one

         A. This is a enumerated list with alphabet
         B. You can use ``>`` or ``<`` in visual and normal mode 
            to shift the list and it's level.
            numbers are auto updated.
            indents are auto fixed.
         C. and ``=`` will only update the number.
         D. You can use ``<C-E>l``` ~ ``<C-E>l4`` to add or change list symbol.
            it will not update the number nor fix the indent. 

            So you'd better act on an new line.

      4. Use ``<C-S-Enter>`` to create a list item of parent level

Todos
-----

Todo item is for keep tracking of todo things.

It is some Todo symbols at the beginning of field list , bullet or enumerated lists.

It's non-reStructuredText syntax, so no highlighting in converted files.

* A Todo box is used by default.

  + [ ] Use ``<C-E>ee`` to init a todo item on a list.
  + [o] Press it again to toggle it's state.
  + [X] 2012-07-08 When finished, A datestamp is auto added.
  + Use ``<C-E>ex`` to delete whole todo items.

* You can use Keywords as todo items either.

  + TODO Use ``<C-E>e2`` to choose the second keyword group.
    This is TODO/DONE group.
  + DONE 2012-07-08 It's done. 

* Priorities also supported. 

  + [ ] [#A] With a todo item. Use ``<C-E>ep`` to add priority
  + [ ] [#B] press again to toggle it's state.
  + [ ] [#C] press again to toggle it's state.
  + [ ] and again, it's deleted.

  :NOTE: Press ``<Enter>`` or click on the prior item will not delete it.

* All todo items can be clicked or ``<Enter>`` to toggle state, 
  and they are highlighted by cursor highlight.
* Use ``<C-E>ht`` to open the Todo Helper. 
  Which will show all todo items of current project or current file.

Links
-----

Links contains targets and references.

A link references is a word following with a underscore.

This is a Link reference to Python_ . ``Python_``

.. _Python: www.python.org

Each references needs a link target. 

A link target may be explicit or implicit.

Above reference is point to a explicit target, which It's defined like this::

   .. _Python: www.python.org

Sections, footnotes, citations will generate implicit target.

Jumping
    ``<Enter>`` or Double-Click on links , will bring you to the target.

    Click the reference link to sections will jump to the section title. 
    e.g.  Sections_

    You can jump back to origin position with `````` or ``''``

Navitgate
    ``<Tab>`` or ``<S-Tab>`` will bring you to next/prev link.

Cursor highlighting
    When cursor is putting on a link, whole link will be highlighted

Files
-----

As reStructuredText does not define syntax for local file link. 

Riv use file's extension to judge if it's a local file link or not.

File with extension of ``rst`` or ``py,cpp,...`` are judged as local file links

    e.g. note.rst  hello.py

    Clicking or ``<Enter>`` on it will edit that file.

File end with ``/`` are considered as directories. 

    e.g. Note/    

    CLicking or ``<Enter>`` on it will edit ``index.rst`` in the directory.

    An absolute direcotry will open that direcotry. 

    e.g. ~/Documents/


Cursor highlight will show a different color if it's not a valid file.

You can use ``<C-E>ht`` to open a file helper, 
which will show all rst fils in current directory for editing.

Inline Markup
-------------

There are some inline markup for reStructuredText. 

``*text*`` is emphasis (*italic*)
``**text**`` is strong emphasis (**bold**)

::

    `text` is for interpreting. 
    ``text`` is inline literal

``reference_`` is a link reference 

