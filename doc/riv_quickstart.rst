====================
QuickStart With Riv
====================

:Author: Rykka
:Date: 2012-07-08 22:58:41

Riv use reStructuredText__ syntax to manage documents.

which is an easy-to-read, 
what-you-see-is-what-you-get plaintext markup syntax and parser system.

__ http://docutils.sourceforge.net/rst.html

This is an quick guide for both reStructuredText and Riv features.

If you have installed ``Riv``
Use ``:RivQuickStart`` or ``<C-E>hq`` to get view and edit it in vim.

You can edit it freely as it's not to be written to disk.
Use ``zx`` in the file to update folding.

Project
-------

Project is a place to hold your documents.

Use ``<C-E>ww`` to open your project index. 
Split current document first with ``<C-W><C-S>`` to split open it.

By default the path is at ``~/Documents/Riv``.
You can change it by defining project to ``g:riv_projects`` in your vimrc.::

    let project1 = { 'path': '~/Dropbox/rst',}
    let g:riv_projects = [project1]

Sections
--------

Section is a line with ``underline`` punctuations.

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

* Use ``<C-Enter>`` to create a next list item
* '*' , '+' or '-' is for bullet list.

  + ``<S-Enter>`` to create a child list item
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


Todos
-----

Todo item is for keep tracking of todo things.

They are some Todo symbols at the beginning of lists.
It's not reStructuredText syntax, so no highlighting in converted files.


* [ ] Use ``<C-E>ee`` to init a todo item on a list.
* [o] Press it again to toggle it's state.
* [X] 2012-07-08 When finished, A datestamp is auto added.
* Use ``<C-E>ex`` to delete it.

  + You can use Keywords as todo items either.
  + TODO Use ``<C-E>e2`` to choose the second keyword group.
    This is TODO/DONE group.
  + DONE 2012-07-08 It's done. 

* Priorities also supported. 

  + [ ] [#A] With a todo item. Use ``<C-E>ep`` to add priority
  + [ ] [#B] press it to toggle it's state.
  + [ ] [#C] press it to toggle it's state.
  + [ ] and press it again, it's deleted.

* All todo items can be clicked or ``<Enter>`` to toggle state, 
  and they are highlighted by cursor highlight.
* Use ``<C-E>ht`` to open the Todo Helper. 
  Which will show all todo items of current project or current file.

Links
-----

Links contains targets and references.

A link references is a word following with a underscore.

This is a Link_

Each references needs a link target.

A link target may be explicit or implicit.

.. _Link: This is a explicit target

Jumping
    ``<Enter>`` or Double-Click on links , will bring you to the target.

    Section title are auto generated as implicit target. 
    So you can create link to sections. e.g:  Sections_

Navitgate
    ``<Tab>`` or ``<S-Tab>`` will bring you to next/prev link.

Cursor highlighting
    When cursor is putting on a link, whole link will be highlighted

Files
-----

As reStructuredText does not define a local file link. 
Riv use extension to judge it's a local file link or not.

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



