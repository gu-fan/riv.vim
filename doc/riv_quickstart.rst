###############
Riv: QuickStart
###############

:Author:    Rykka G.F
:Date:      2012-10-16 11:06:54

Riv is a plugin for better working with reStructuredText in Vim.

This Riv tutor, is to show enough command to working with it.

:NOTE: The commands of this document will modify the text.
       Make sure it's the copy of quickstart.rst

       If you started ``:RivQuickStart``, Then it's already a copy.

:NOTE: The ``<C-E>`` in command means ``Ctrl+E`` or ``Ctrl+e`` ,

       Commands ``<C-E>xx`` are based on the ``g:riv_global_leader``
       If you have changed it, using yours.

Read
====

Folding
-------
This document was opened with some of them are folded.

**Toggle Folding**

Click or press ``<Enter>`` on the folding to open it.

Use ``za`` to toggle folding.

**Update Folding**

Folding will be auto updated when you write to file, 

Use ``zx`` to update folding manually.

Syntax
------

**Items**

Items are highlighted.

*Italic*, **Strong**, ``Inline Literal``, `Interpreted`, 
www.python.org Syntax_


**Code**

``code`` directive are highlighted by it's language.

.. code:: cpp
   
    #include <iostream>
    using std::cout;
    using std::endl;
    int main()
    {
        cout << "Hello";
        cout << endl;
        return 0;
    }

Write
=====

Insert
------

**Insert Misc Things**
To Insert current date
``:RivCreateDate`` or ``<C-E>cdd``

    :Date: 

Create a strong text 
``:RivCreateStrong`` or  ``<C-E>cs``, 

    Strong

Create a strong text in Visual Mode.

    Make it Strong

These commands can be view by menu or by ``:popup Riv.Insert``

Indent
------

**Indents are fixed.**

You can use ``<`` ``>`` to change a line's indent.

Also ``<Tab>`` and ``<S-Tab>`` and ``<BS>`` in Insert Mode
at the beginning of line will change it's indent.

* This is a List

    Press ``<`` at This line to align it to parent.

    In Insert Mode, ``I<BS>`` at the line begining can be used.

**Change Multiple lines in Visual Mode**

* This is a List
    
    Line 1 ``Vjj<`` will align these lines to parent.
    Line 2
    Line 3
    
**List item will change it's level while Shifting.**

* This is a List

  + Press ``<`` to change it's level to parent list

  + To get a Normal ShiftRight, Use ``<C-E><``

RST
===

Section
-------

**Create a Section title**

``:RivTitle1`` to ``:RivTitle6`` or ``<C-E>s1`` to ``<C-E>s6``

Use ``<C-E>s3`` to create a level 3 section.

A Level 3 section

**View current document's sections**

``:RivHelpSection`` or ``<C-E>hs``


**Insert the Table of Contents**

``:RivCreateContent`` or ``<C-E>cc``



Block
-----

**Create a literal-block**

``:RivCreateLiteralBlock`` or ``<C-E>cb``


**Create a explicit-mark**

``:RivCreateExplicitMark`` or ``<C-E>cm``


List
----

**Toggle current line to list**

``:RivListToggle`` or ``<C-E>l```

* Press ``<C-E>l``` on this line To toggle the List

**Create a new list** 

``:RivListNew`` or ``<C-E>ln``, 
Also ``<C-Enter>`` in Inert Mode

1. Press ``A<C-Enter>`` to create a new list item

**Create a sub list** 

``:RivListSub`` or ``<C-E>lb``, 
Also ``<S-Enter>`` in Inert Mode

1. Press ``A<S-Enter>`` to create a sub list item

**Create a sup list**

``:RivListSup``  or ``<C-E>lp``,
Also ``<C-S-Enter>`` in Insert Mode

1. This is a List

    A. Press ``A<C-S-Enter>`` in insert mode to create a sup list item

Link
----

**Navigate between links** 

``:RivLinkNext`` ``:RivLinkPrev``,
or ``<Tab>`` and ``<S-Tab>`` in Normal Mode 

Section_ Link_

**Jump to Link Target** 

``:RivLinkOpen`` ``<C-E>ko``
Or ``<Enter>`` or Double clicking in Normal Mode

    Google_

**Link can targets to sections** 

Use `` or '' to jump back

    Section_ 

**Create a link**

``:RivCreateLink`` or ``<C-E>ck``

    Press ``<C-E>ck`` on Github to create the Link

Table
-----

**Create a Grid Table** 

``:RivTableCreat`` or ``<C-E>tc``



Table will be auto formatted when you leave insert mode.

In Insert mode:

    +-----------------------------------------+
    | Press ``<Enter>`` to creat a new line   |
    +-----------------------------------------+
    | Press ``<C-Enter>`` to create a new row |
    +-----------------------------------------+

Insert a ``|`` to create new columns.

    +---------+
    | A Table |
    +---------+

Publish
-------

If docutils_ package have installed.

**Convert document to other format**

``:Riv2HtmlAndBrowse`` or ``<C-E>2hh`` will convert current file to html and browse.

``:Riv2Odt`` or ``<C-E>2oo`` will convert current file to odt.

If you are working in a project.

``:Riv2HtmlProject`` will convert current project to html.
``:RivProjectHtmlIndex`` will open index in browser.

Riv
===

Project
-------
Keep your documents in a project

**Open main project's index file**

``:RivProjectIndex`` or ``<C-E>ww`` to 

**Show project list**

``:RivProjectList`` or ``<C-E>wa``

File
----
Link and edit files

**Link file in vim**

File with specified extensions will be highlighted and linked.

    index.rst ~/Documents/ test.py

It's not converted, so in vim only.

**Link file in other format**

To make links working after converting. 
Riv provide two styles::

    Moinmoin style: [[riv]]

    Sphinx style: :doc:`riv`

by default the Moinmoin style are used, 
And the links of this style will be converted.

If you are using Sphinx style. 
You must converting it using Sphinx_ toolkit.

Todo
----
Things Todos

**Creat todo item and toggle state**

On list lines only, ``:RivTodoToggle`` or ``<C-E>ee``

    A. [ ] Press ``<C-E>ee`` to toggle the todo state.

**Change Priorties**

``:RivTodoPrior`` or ``<C-E>ep``

    A. [ ] Press ``<C-E>ep`` to toggle the todo prior

Scratch
-------
Scratch is a place to hold your diaries or notes.

**Create scratch of Today**

``:RivScratchCreate`` or ``<C-E>sc``

**View Scratch Index**

``:RivScratchView`` or ``<C-E>sv``

Helper
------
Help manage the document.

**Section Helper** 

``:RivHelpSection`` or ``<C-E>hs``

**File Helper**  

``:RivHelpFile`` or ``<C-E>hf``

**Todo Helper** 

``:RivHelpTodo`` or ``<C-E>ht``

Where To go
===========

You have finished this tutor.

You can starting your reStructuredText in Vim.

If you are not familiar with Vim, use ``:h``.

To get a quick view of reStructuredText, use ``:RivPrimer``

If you want to view the detailed instruction, use ``:RivInstruction``

.. _Google: www.google.com
.. _docutils: http://docutils.sourceforge.net/
.. _Sphinx: http://sphinx.pocoo.org/ 
