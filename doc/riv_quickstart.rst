###############
Riv: QuickStart
###############

.. rubric:: A Taste of Riv

:Author:    Rykka G.F
:Date:      2012-10-16 11:06:54

Riv is a plugin for better working with reStructuredText in Vim.
This is a Riv tutor, designed to describe enough command to working 
with it.

If you are not familiar with Vim, use ``:h``.

If you are not familiar with reStructuredText, use ``:RivPrimer``

:NOTE: The commands of this document will modify the text.
       Make sure it's the copy of quickstart.rst

       If you started ``:RivQuickStart``, Then it's already a copy.

:NOTE: The commands ``<C-E>xx`` are based on the ``g:riv_global_leader``
       If you have changed it, using yours.

Read
====

Folding
-------

Folding is a vim feature to get an overview of document structure.

You will come to this project with some of them are folded.

You can click or press ``<Enter>`` on the folding to open it.
And you can use ``za`` to toggle folding.

If you have changed the document structure, 
Folding will be auto updated when you write to file, 
and you can use ``zx`` to update folding manually.

Syntax
------

reStructuredText items are highlighted.

*Italic*, **Strong**, ``Inline Literal``, `Interpreted`, 
www.python.org Syntax_

You can use ``code`` directive to highlight code.

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

You can insert extra field by ``:RivCreateXxx``

To Insert current date , Use ``:RivCreateDate``, 
or ``<C-E>cdd``

    :Date: 

You can create a stron text by ``:RivCreateStrong``
or  ``<C-E>cs``, 
You can use it in Visual Mode either.

    Make this Strong.

You can view these commands in menu or by ``:popup Riv.Insert``

Indent
------

The indentation of RST is complicated.

So the ``>`` , ``<`` in Normal Mode
and ``<Tab>`` and ``<S-Tab>``, ``<BS>`` in insert mode are using 
fixed indent in different context.

* This is a List

    Press ``<`` at This line to align it to parent's content.

    In Insert Mode, ``<BS>`` at the begining can be used.

Also the List item will be changed.

* This is a List

  + Press ``<`` on this line to change it's level and item to parent list

  + To gain a Normal ShiftRight, Use ``<C-E><``

RST
===

Section
-------

Create a Section title with ``:RivTitle1`` to ``:RivTitle6``
or ``<C-E>s1`` to ``<C-E>s6``

    A Title

Each Section are folded. 

You can view sections of current project by ``:RivHelpSection`` 
or ``<C-E>hs``

You can insert the table of sections of current file by ``:RivCreateContent``
or ``<C-E>cc``

Block
-----

You can create a literal-block by ``:RivCreateLiteralBlock``
or ``<C-E>cb``

You can create a explicit-mark by ``:RivCreateExplicitMark``
or ``<C-E>cm``

List
----

You can change current line to a list by ``:RivListToggle``
or ``<C-E>l```

* Press ``<C-E>l``` on this line To toggle the List

You can create a sub list by ``:RivListNew`` 
or ``<C-E>ln`` or ``<C-Enter>``

1. Press ``<C-Enter>`` in insert mode to create a new list item

You can create a sub list by ``:RivListSub`` 
or ``<C-E>lb`` or ``<S-Enter>``

1. Press ``<S-Enter>`` in insert mode to create a sub list item

You can create a sup list by ``:RivListSup`` 
or ``<C-E>lp`` or ``<C-S-Enter>``

1. This is a List

    A. Press ``<C-S-Enter>`` in insert mode to create a sup list item

You can change the list indent and level by ``<`` ``>`` on it's line
in Normal Mode.
or ``<Tab>`` ``<S-Tab>`` at the begining of that line in Insert mode.

1. This is a List

   A. Press ``<`` or ``>`` on This line to change it's level


Link
----

Jump to Link Target by ``:RivLinkOpen`` ``<C-E>ko``
Or ``<Enter>`` or Double clicking.

    Google_

Link can targets to sections. 

    Section_

You can create a link by ``:RivCreateLink`` or ``<C-E>ck``

    Press ``<C-E>ck`` on Github to create the Link

You can navigate between links by ``<Tab>`` and ``<S-Tab>`` in Normal
mode, or use ``:RivLinkNext`` ``:RivLinkPrev``


Table
-----

You can create a Grid Table by ``:RivTableCreat`` or ``<C-E>tc``

You can insert contents in it then.
Table Will be auto formatted when you leave insert mode.

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

If you have installed docutils_ package.

You can convert the document to other format.

``:Riv2HtmlFile`` will convert current file to html.

``:Riv2Odt`` will convert current file to odt.

If you are working in a project.

``:Riv2HtmlProject`` will convert current project to html.
``:RivHtmlIndex`` will open the html file in browser.

Riv
===

Project
-------
A project is a place to keep your documents.

``:RivIndex`` or ``<C-E>ww`` to open your main (first) project's index file.

``:RivAsk`` or ``<C-E>wa`` to show the list of your projects to open.

File
----

Files can be linked and opened.

The file with specified extensions will be highlighted and linked.

    The Riv Instuction: riv.rst
    
    But this link will not available after converted to other format.

For links working after converting.
Riv provide two style of file links.::

    Moinmoin style: [[riv]]

    Sphinx style: :doc:`riv`

by default the Moinmoin style are used.

If you are using Sphinx_ style. You must converting it using 
Sphinx toolkit.

Todo
----
You can creat a todo item and toggle it's state on a list item
by ``:RivTodoToggle`` or ``<C-E>ee``

    A. [ ] Press ``<C-E>ee`` to toggle the todo state.

Priorties can be used by ``:RivTodoPrior`` or ``<C-E>ep``

    A. [ ] Press ``<C-E>ep`` to toggle the todo prior

Scratch
-------
Scratch is a place to hold your diaries or notes.

Create scratch of Today: ``:RivScratchCreate`` or ``<C-E>sc``

View Scratch Index: ``:RivScratchView`` or ``<C-E>sv``

Helper
------
Helper is to help you manage the document.

Section Helper : ``:RivHelpSection`` or ``<C-E>hs``

File Helper : ``:RivHelpFile`` or ``<C-E>hf``

Todo Helper : ``:RivHelpTodo`` or ``<C-E>ht``

.. _Google: www.google.com
.. _docutils: http://docutils.sourceforge.net/
.. _Sphinx: http://sphinx.pocoo.org/ 
