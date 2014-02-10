############################
Riv: reStructuredText in Vim
############################

**Your Personal Wiki in RST, And More**

:Author: Rykka G.F
:Update: 2014-02-10
:Version: 0.75 
:Github: https://github.com/Rykka/riv.vim

* _`Index`:

  * 1 Intro_: Basic introduction
  * 2 Features_: Implemented features
  * 3 `Riv in Action`_: Screenshots and screencasts
  * 4 Installation_: Installing Riv
  * 5 Tutorials_: Tutorials for Riv, Vim, as well as reStructuredText.
  * 6 `Todo and Changelog`_: Things to do and things already done.
  * 7 Issues_: Known issues
  * 8 Contributing_: Help improving

Intro
=====

**Riv** is short for 'reStructuredText in Vim'.

It is a plugin for the `Vim text editor`_, which aims to provide better support
for reStructuredText_  (a simple and powerful plain text markup) in Vim.

In Short, It can be your Personal Wiki,
Also can be your Document Writer,
Even with your code doc writer. 

Riv will help you in the following ways:

* Make the documents clearer to read and easier to navigate using folding,
  linking and providing extra syntax highlighting.
* Enable you to write documents faster through improved indentation and
  inserting.
* Easier management of documents through "Project", "File" and "Sphinx_"
  support.
* Enable you to document things using the "Todo" and "Scratch" features.

Features
========
 
Reading and Writing
-------------------

**Vim Improved ;-)**

:**Folding**:     Improved folding support, which helps overview the structure
                  of a document.
:**Syntax**:      Extra syntax highlighting.
:**Indent**:      Smarter indentation.
:**Insert**:      Faster insertion of text, as well as easier navigation.

**reST Documents**

:Sections: Easily create section titles. Sections are folded by default.
:Lists:    Auto numbered, auto leveled and auto indented.
:Links:    Highlight links, jump to link targets, create links.
:Table:    Auto formatting of tables, as well as commands to create tables.
:Publish:  Convert rst files to a number of different formats such as
           pdf, html, xml, latex, odt etc.

Document Managment
------------------

:Sphinx:   Support for Sphinx.
:Project:  You can group related documents under a central location called a 
           project. Projects allow you to perform actions on all the
           member files at the same time.
:File:     Link support for local files in the document.
:Scratch:  Write notes and diaries.
:Todos:    Maintain Todo lists.
:Helpers:  Help work with documents and projects.

Riv in Action
=============

Screenshot: 

* Working with Sphinx

.. image:: http://i.minus.com/ibnVOcyyNVfO8U.png

Screencast: 

* Riv: QuickStart_ (HD)

Installation
============

Using Vundle
------------

This is the recommended method to install Riv. Using Vundle_ you can update to
the latest Git version of Riv easily.

To manage Riv using Vundle, simply add this line to your .vimrc (after you
have properly set up Vundle)::
 
    Bundle 'Rykka/riv.vim'

Using downloaded zip/tar.gz file
---------------------------------

Just extract the contents of the archive to your ``.vim`` directory.

:NOTE: Make sure that your .vim directory is placed before $VIMRUNTIME in the 
       ``runtimepath`` option of your .vimrc, otherwise Vim's built-in 
       syntax/indent files will override the ones provided by Riv
       (for rst files).

       By default it *is* present before $VIMRUNTIME.

:NOTE: Make sure the ``filetype plugin indent on`` and ``syntax on`` options
       are present in your .vimrc.

:NOTE: Riv is under active development, so things may change quickly. 

       You are advised to keep up-to-date.

       You can get the latest version at https://github.com/Rykka/riv.vim 

Related tools
-------------

+ Python: Docutils_, required for converting reST files to other formats.
+ Python: Pygments_, provides syntax highlighting for other formats.
+ Python: Sphinx_ for Sphinx users.
+ Vim: Syntastic_ for syntax checking. Requires Docutils_.

Tutorials
=========

Vim
---

* If you are new to Vim, you can get a basic overview of Vim using
  ``vimtutor``. To use it simply type ``vimtutor`` in your shell.
  
* To view the quick reference of Vim, use ``:h quickref``.

reST
----

* To get a quick overview of reStructuredText, some of the available options
  are:

  Read "`A ReStructuredText Primer`_". You can use ``:RivPrimer`` to open it in
  Vim. Or, you can read "`Quick reStructuredText`_".

* For a detailed look at reStructuredText's specifications, take a look at
  "`reStructuredText Specification`_". You can use ``:RivSpecification`` to
  open it in Vim.

* Finally, you can use "`reStructuredText cheatsheet`_" for a quick review. Use
  ``:RivCheatSheet`` to open it in Vim.

Riv
---

* For getting started with Riv, read "`QuickStart With Riv`_".
  You can also view it using ``:RivQuickStart`` in Vim.

* Detailed instructions for Riv are available at "`Instructions`_". Use
  ``:RivInstruction`` to read the same in Vim.

Todo and Changelog
==================

Current Version
---------------

Things that need to be done in the following version.

* **0.75:**

  -  #21: Fix section syntax to ignore ``::`` and ``..``.
  -  #25: Fix tutor's document path.  
  -  #27: Add ``g:riv_default_path`` ('~/Documents/Riv')
  -  #29: noremap for commands.
  -  For html filetype, copy image for 'image/figure' directives.

Future Versions
---------------

See riv_todo_ (doc/riv_todo.rst)

Changelog
---------

See riv_log_ (doc/riv_log.rst)

Issues
======

The bug tracker for Riv is at https://github.com/Rykka/riv.vim/issues.
You can use it to report bugs and open feature requests. Discussions related
to Riv are welcome too. 

Common Issues
-------------

* If you get errors with folding in documents, you can try to force reload
  using ``:RivTestReload`` or ``<C-E>t```.

* Windows:
  
  - Converting to other formats may fail. 
    
    This could happen due to Docutils not working correctly with
    ``vimrun.exe``.

* Mac OS:

  - Lists don't act as expected.
  
    This could happen if the ``<C-Enter>`` key could not be mapped. Try some
    other mapping instead.

Contributing
============

This project aims to provide better support for working with reStructuredText
in Vim.

And there are many things that need to be done.

If you are willing to help improve this project, the following areas need 
contribution:

:Documentation:
               1. Rewrite and merge the quickstart and intro, which could be
                  used in Vim.
               2. A screencast for the quickstart.

:Code:
        1. Support auto formatting for table with column/row span. 

           The code of ``PATH-TO-Docutils/parsers/rst/tableparser`` 
           can be referenced.
        2. Support for more plugins of reStructuredText_.


.. _Vim text editor: http://www.vim.org/
.. _reStructuredText: http://docutils.sourceforge.net/rst.html
.. _Sphinx: http://sphinx.pocoo.org/
.. _QuickStart: http://www.youtube.com/watch?v=sgSz2J1NVJ8
.. _Instructions: https://github.com/Rykka/riv.vim/blob/master/doc/riv_instruction.rst
.. _A ReStructuredText Primer: http://docutils.sourceforge.net/docs/user/rst/quickstart.html
.. _Quick reStructuredText: http://docutils.sourceforge.net/docs/user/rst/quickref.html
.. _Quickstart With Riv:
   https://github.com/Rykka/riv.vim/blob/master/doc/riv_quickstart.rst
.. _Vundle: https://www.github.com/gmarik/vundle
.. _Docutils: http://docutils.sourceforge.net/
.. _Pygments: http://pygments.org/
.. _Syntastic: https://github.com/scrooloose/syntastic
.. _riv_log: https://github.com/Rykka/riv.vim/blob/master/doc/riv_log.rst
.. _riv_todo: https://github.com/Rykka/riv.vim/blob/master/doc/riv_todo.rst
.. _reStructuredText Specification: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html
.. _reStructuredText cheatsheet: http://docutils.sourceforge.net/docs/user/rst/cheatsheet.txt
