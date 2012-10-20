##########
Riv: Todos
##########

.. rubric:: Things Todo...

Bugs
====

* **Folding**

  + Sometimes folding did not update correctly.
* **List**

  + List behavior not act correctly in Mac OS. see `issue 2`_
* **Publish**

  + Converting under windows have errors.

    This may due to docutils could not executing correctly with vimrun.exe.
* **Syntax**

  + The ``.. class:: Model(**Kwarg)`` will highlight all following document.
* **Insert**

  + The visual block insert for ``<Tab>`` are not usable.
* **Table**

  + The visual block insert for ``|`` in table are not usable.
  + The inline target ```xxx`_`` are not highlighted in table

Features
========

Vim
---

* **Folding**

  * Folding: A buf parser write in python for performance?

* **Syntax**

  * highlight the directives with indents.

RST
---

* **Sections**

  + [ ] [#C] Different color for different level of title.

* **Documents**

  * A quick ScreenCast tutor.
  * The commands section

* **Links**

  * Link anchor between files? 
    index.rst#section -> index.html#section
    also the Sphinx :ref: style.

* **Table**

  + Support simple table format?
  + Support column span for grid table?

Riv
---

* **Project**

  + [ ] [#B] A shortcut to create the sphinx TOC tree.
    also support navigating with the TOC tree.

* **Todos**

  * standard name of todo's cache. 

* **File**

    + hack the docutils parser with local file link.

* **Publish**

  * Publish: An option to enable highlighting todo items.
  * the temp path should be validated.
  * javascript for HTML with folding sections.
  * [o] support sphinx make and browse

* **Helpers**

  1. Helpers: An option Helper and option cache. 
     Let people use it even without touching ``.vimrc`` .
  2. Helpers: A command helper?
* **Scratch**

  + Scratch: Show Scratch sign in Calendar.




.. _issue 2: https://github.com/Rykka/riv.vim/issues/2 
