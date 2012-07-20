===================
Quick Intro for Riv
===================

:Author: Rykka G.Forest
:Date:  2012-07-19 03:34:13

This is a Quick Intro for Riv_ .

It will introduce brief features of Riv.

You should have a basic understanding of reStructuredText_

.. _Riv: https://github.com/Rykka/riv.vim
.. _reStructuredText: http://docutils.sourceforge.net/rst.html


OverView
--------

Following features are for all reStructuredText documents.

:Folding_:  Folding of Riv.
:Sections_: Creating section titles and showing section number.
:Lists_:    Creating lists auto numbered and leveled.
:Tables_:   Creating and formatting tables.
:Links_:    Creating and jumping with links.

Following features are non-restructuredtext syntax.

:Projects_: Put your documents together.
:Files_:    Local file links.
:Todos_:    Todo Items.

Folding
-------
Sections, lists , tables and blocks are folded.

And extra info will be shown at the fold line.

Folding is updated when write file.
You can update it manually by ``zx``

Click on a folded line will open the fold , as ``zv``.

Click on section title will fold the section.

Sections
--------
To create a section title. 
Press ``<C-E>s1`` ... ``<C-E>s6``. 
Each mapping will create a title in that level.

The title of this section is ``<C-E>s2`` on 'Sections'.

You can view current section numbers in folding info. 
It is '1-2', indicating it's the second subtitle of title one.

You can press ``<C-E>hs`` to open a section helper 
to view the section title and it's numbers too.

Similar as the ``contents`` directive of restructuredtext.


Lists
-----

* You can create a list with ``<C-E>l1`` ... ``<C-E>l5``, 
  or just enter the list symbol by your own.

* This is a bullet list.

1. This is a enumerated list.

Insert Mode Only:

* To enter following paragraph of the list item, 
  Press ``<Enter>``
* To enter a new list item of same level. 
  Press ``<C-Enter>``
* To enter a list item of child level (sublist),
  Press ``<S-Enter>``

  + This is a sublist.
  + The level of list symbols are hard coded.
    From ``* + -`` to ``1. A. a. I. i. 1) A) ....``

    But you can start from any level.

A. this is a enumerated list with alphabet character sequence.
B. ``<C-Enter>`` will create the next list item. And it's auto numbered.
C. the following list item

* You can shift the list with 
  ``>`` (``:RivShiftRight``) or ``<`` (``:RivShiftLeft``)

  + Shifting left on this item will change identation and turn ``+`` to ``*`` 
  + list number and indentation is auto fixed.
  + a preceding blank line should be added, if shifting from same level to sub level.

For example, you can test shifting all or some of the following list:

1. list
   line

   A. list
   B. list
      line
   C. list
      line

      a. list
         line
      b. list 
         line

   D. list 
      line


Tables
------

You can create table with ``<C-E>tc`` or ``:RivTableCreate``

Insert mode only:

+-------------------------------------------------+--------------------------+
| Table                                           |                          |
+-------------------------------------------------+--------------------------+
| Use <Enter> to create a new line                | This is line 1           |
|                                                 | This is a new line       |
+-------------------------------------------------+--------------------------+
| Use <C-Enter> to create a new row this is row 1 |                          |
+-------------------------------------------------+--------------------------+
|                                                 | this is new row          |
+-------------------------------------------------+--------------------------+
| Use <S-Enter> to jump to the next line          |                          |
+-------------------------------------------------+--------------------------+
| Use <Tab> or <S-Tab> to jump to the next cell   |                          |
+-------------------------------------------------+--------------------------+
| Multibyte char could be included                | 一二三四五    かきくけこ |
+-------------------------------------------------+--------------------------+

Table will be auto formated after exit insert mode
or pressing ``<Enter>`` or ``<Tab>``

Links
-----

You can create a link target with it's reference ``<C-E>il`` or ``:RivCreateLink``

Python_

.. _Python: www.python.org

Normal mode action:

* Clicking or ``<Enter>`` on a link reference will jump to it's target.
  If it's a web link, will open web browser to browse it.
* Use ``<Tab>`` or ``<S-Tab>`` to find next/prev links.

Section titles are implicit targets that can be reference to.

So click Folding_ will jump to the folding section.

Links are cursor highlighted.

Projects
--------
Project is the place to put your documents in.

by default it's at ``~/Documents/Riv``. 

You can open it with ``<C-E>ww``, ``index.rst`` of the project will be opened.

if you have defined multiple projects, use ``<C-E>wa`` to choose one.

Files
-----

There is no local file link syntax in reStructuredText currently.

By default setting, 
Riv use file's extension to judge that.

the xxx.rst  xxx.py will be considered as local links.

clicking or ``<Enter>`` on it will edit that file.

and xxx/ will open the index.rst in that folder.

local file link is highlighted in a different syntax color with other links.
also non-exists file will be cursor highlighted in ``ErrorMsg``

Todos
-----

Todo items are defined for keep tracking of todo things.

This is non-reStructuredText syntax.

* Use ``<C-E>e1`` ... ``<C-E>e4`` to create a todo item on a list.
* [ ] This is a todo box
* TODO This is a TODO/DONE todo keyword 

* Use ``<C-E>ee`` to add or toggle the todo state.
* [ ] progressing
* [X] 2012-07-19 when finished. an datestamp will be added.

* Todo priorities are supported. 
* [ ] [#A] Use ``<C-E>ep`` on a todo item to add priorities and toggle it's state.

Clicking on the todo items will toggle it's state. 

Click on the datestamp will change the date. 
and if you have Calendar_ installed, will use it to choose date.

.. _Calendar: https://github.com/mattn/calendar-vim

You can use ``<C-E>ht`` to open a todo helper
for searching and view all todo items.

If you are in a project , it will show todo items of the project.
otherwise it will show todo items of current document.

Use ``<Tab>`` in the helper to toggle item filter.

Conclusion
----------
This is a quick intro, so not all features are introduced.

See Intro_ for the full intro of Riv.

.. _Intro: https://github.com/Rykka/riv.vim#intro

Hope you enjoy documenting with Riv.

