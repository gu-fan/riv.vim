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

You can create a reference by ``:RivCreateLink``
or ``<C-E>ck``

    Link: Where

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

Block
-----

List
----

Link
----

Table
-----

Publish
-------

Riv
===

Project
-------

File
----

Todo
----

Scratch
-------

Helper
------

Sphinx
------


