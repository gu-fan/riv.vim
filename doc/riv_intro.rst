############################
Riv: reStructuredText in Vim
############################

:Author: Rykka G.F
:Update: 2013-01-12
:Version: 0.75 
:Github: https://github.com/Rykka/riv.vim

* _`Index`:

  * 1 Intro_ : Basic Intros

    * 1.1 Features_ : Implemented featues
    * 1.2 `On Screen`_ : Screenshots and Screencasts
    * 1.3 `Where To Go`_ : Start from here
    * 1.4 Tutors_ : Batteries Included
    * 1.5 Install_ : Installation
    * 1.6 `Todo and Done`_ : Thins Todo and logs
    * 1.7 Issues_ : Know Issues
    * 1.8 Contribution_ : Help improving

Intro
=====

**Riv**, short for 'reStructuredText in Vim'. 

Aim to provide better support of reStructuredText_ 
(a simple and powerful plain text markup) in vim.

It's for you to::

    Read documents clearer. (Folding, Linking and Extra highlight)
    Write documents faster. (Indent and Insert improvement)
    Manage documents easier. (Project,File and Sphinx support)
    Make things documented. (Todo and Scratch)

Features
--------
 
**Reading and Writing**

 **Vim Improved**

 :Folding:  Overview the structure.
 :Syntax:   Extra highlighting.
 :Indent:   Smarter indent.
 :Insert:   Speed up the input!

 **RST Documents**

 :Sections: Easy create, easy view.
 :Lists:    Auto numbered, auto leveled and auto indented.
 :Links:    Jumping and Highlighting.
 :Table:    Auto formatted. 
 :Publish:  Convert to html/xml/latex/odt...

**Document Managment**

 :Sphinx:   Working with Sphinx.
 :Project:  A workspace for your documents.
 :File:     Link local file in the document.
 :Scratch:  Writing notes and diaries.
 :Helpers:  Help work with document/project.
 :Todos:    Keep track of todo things.

On Screen
----------

ScreenShot: Work with Sphinx

.. image:: http://i.minus.com/ibnVOcyyNVfO8U.png

ScreenCast: 

* Riv: QuickStart_ (HD)

Where To Go
-----------

* Index_ : Index of Document

**Gettings Start**

* Install_: Installation
* Tutors_ : From the very basic
* Instructions_ : The detailed instruction.
  Use ``:RivInstruction`` in vim.

**About This Projcet**

* `Todo and Done`_: Todos and Logs
* Issues_: Known Issues
* Contribution_: Help improving

Install
-------
* Using Vundle_  (Recommended)

  Add this line to your vimrc::
 
    Bundle 'Rykka/riv.vim'


* Using downloaded zip/tar.gz file. 
  Just extract it to your ``.vim`` folder .


:NOTE: Make sure your .vim folder in option ``runtimepath`` 
       is before the $VIMRUNTIME, otherwise the syntax/indent files
       for rst files will use vim's built-in one.

       Default is before $VIMRUNTIME.

:NOTE: Make sure ``filetype plugin indent on`` and ``syntax on`` is in your vimrc

:NOTE: It's a developing version. 
       So things may change quickly.

       Keep up-to-date.

       You can get the latest version at https://github.com/Rykka/riv.vim 

* Related tools: 

  + python: docutils_ , required for converting to other format.
  + python: pygments_ for syntax highlighting in other format.
  + python: Sphinx_ for Sphinx users.
  + vim: Syntastic_  for syntax checking. docutils_ required.

    But if you are using Sphinx_'s tools set, you'd better not using it.
    Cause it could not recognize the sphinx's markups.

Tutors
------

**Vim**

* To get a tutor for vim. 
  Use ``vimtutor`` in your shell.
  
* To view the quick reference of vim.
  Use ``:h quickref``.

**RST**

* To get a quick view of reStructuredText.

  Read `A ReStructuredText Primer`_,
  Use ``:RivPrimer`` to open it in vim.
  
  or Read `Quick reStructuredText`_. 

* To get reStructuredText's detailed specification. 

  Read `reStructuredText Specification`_,
  Use ``:RivSpecification`` to open it in vim.

* And the `reStructuredText cheatsheet`_ for a quick review,
  Use ``:RivCheatSheet`` to open it in vim.

**Riv**

* Quick Start With Riv. 
  
  Read `QuickStart With Riv`_ ,
  Use ``:RivQuickStart`` in vim.

* Detailed Instruction for Riv:

  Read `Instructions`_ ,
  Use ``:RivInstruction`` in vim.

Todo and Done
-------------

This
~~~~~

Things todo in this version.

* 0.75:

  -  #21: Fix section syntax to ignore '::' and '..'.
  -  #25: Fix tutor's document path.  
  -  #27: Add ``g:riv_default_path`` ('~/Documents/Riv')

Next
~~~~~

See riv_todo_ (doc/riv_todo.rst)

Prev
~~~~

See riv_log_ (doc/riv_log.rst)

Issues
------

* If the document folding showing some error.
  You can try force reload ``:RivTestReload`` ``<C-E>t```
* Windows:
  
  - Converting to other format may fail. 
    
    This may due to docutils could not executing correctly with vimrun.exe.

* Mac OS:

  - The List don't act as expected. 
  
    Maybe Caused the ``<C-Enter>`` Could not be mapped.
    Use other map instead.

* Post issues at https://github.com/Rykka/riv.vim/issues
  Both bug reports and feature request and discussions are welcome. 

Contribution
------------

This project aims to provide better working with reStructuredText in vim.

And there are many things need to do.

If you are willing to improve this project, 
You can do something for it.

:Document: 
           1. This README document need review and rewrite.
              It is also the helpdoc in vim.
           2. Rewrite and merge the quickstart and quick intro.
              Which could be used in vim.
           3. A screencast for quickstart.

:Code:
        1. Support auto formatting for table with column/row span. 

           The code of ``PATH-TO-Docutils/parsers/rst/tableparser`` 
           can be referenced.
        2. Support more other plugins of reStructuredText_



.. _reStructuredText: http://docutils.sourceforge.net/rst.html
.. _Org-Mode: http://orgmode.org/
.. _Sphinx: http://sphinx.pocoo.org/
.. _QuickStart: http://www.youtube.com/watch?v=sgSz2J1NVJ8
.. _Instructions: https://github.com/Rykka/riv.vim/blob/master/doc/riv_instruction.rst
.. _A ReStructuredText Primer: http://docutils.sourceforge.net/docs/user/rst/quickstart.html
.. _Quick reStructuredText: http://docutils.sourceforge.net/docs/user/rst/quickref.html
.. _Quickstart With Riv:
   https://github.com/Rykka/riv.vim/blob/master/doc/riv_quickstart.rst
.. _Vundle: https://www.github.com/gmarik/vundle
.. _docutils: http://docutils.sourceforge.net/
.. _pygments: http://pygments.org/
.. _Syntastic: https://github.com/scrooloose/syntastic
.. _riv_log: https://github.com/Rykka/riv.vim/blob/master/doc/riv_log.rst
.. _riv_todo: https://github.com/Rykka/riv.vim/blob/master/doc/riv_todo.rst
.. _reStructuredText Specification: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html
.. _reStructuredText cheatsheet: http://docutils.sourceforge.net/docs/user/rst/cheatsheet.txt
