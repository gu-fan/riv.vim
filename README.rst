#######################
Riv: Take Notes in rst
#######################

    The Internet is just a world passing around notes in a classroom.

    -- `Jon Stewart`_

:Last Update: 2014-07-12
:Version: 0.76 


Intro
=====


**Riv** is short for 'reStructuredText in Vim'.

It is a vim plugin for writing notes with reStructuredText_.

Comparion
=========


First things first, Why using this plugin?

There are some other note plugins in vim. (Also org-mode_ if you are a Emacs fan)

like vimwiki_, vim-notes_, etc.

In comparition, the most advantage of **Riv.vim** is it support reStructuredText_ for your note.

And reStructuredText's syntax are markdown_ alike, but are more powerful and extensible, support like table, LaTex, ect.
(This post have a comparions between them https://gist.github.com/dupuy/1855764)

It's used in many places like Sphinx_ (www.readthedocs.org) and have many relevent plugins(Pygments_, Nikola_).

Features
========
 

**Wiki**  
    Write rst document as a wiki with project and local file support. Also **TODO** syntax is added.
**Editing**   
    Faster typing, easier navigation, clear intending, auto formatting lists/tables etc.
**Syntax** 
    Improved syntax highlighting with the original one.
**Folding** 
    Improved folding support, which helps overview the structure of a document.
**Publish** 
    Convert rst files to a number of different formats such as pdf, html, xml, latex, odt etc.
**Sphinx**   
    Sphinx_ syntax support.



Installation
============

Using Vundle_
-------------

Recommended, Add this line to your .vimrc (after you
have properly set up Vundle_)::
 
    Bundle 'Rykka/riv.vim'

Downloaded zip/tar.gz file
--------------------------

Extract the contents of the archive to your ``.vim`` directory.

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
+ Python: Nikola_ for static blogging with rst syntax.

Tutorials
=========

Screencast: 

* Riv: QuickStart_ (HD)

Vim newbie
----------

* If you are new to Vim, you can get a basic overview of Vim using
  ``vimtutor``. To use it simply type ``vimtutor`` in your shell.
  
* To view the quick reference of Vim, use ``:h quickref``.

reST newbie
-----------

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

Issues
======

The bug tracker for Riv is at https://github.com/Rykka/riv.vim/issues.
You can use it to report bugs and open feature requests. Discussions related
to Riv are welcome too. 

You can follow my twitter @rykkaf_ and notice me there too.

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

.. _vimwiki: https://github.com/vimwiki/vimwiki 
.. _vim-notes: https://github.com/xolox/vim-notes 

.. _markdown: http://daringfireball.net/projects/markdown/

.. _org-mode: http://orgmode.org/


.. _Jon Stewart: http://en.wikipedia.org/wiki/Jon_Stewart 
.. _Nikola: https://github.com/getnikola/nikola

.. _@rykkaf: https://twitter.com/rykkaf
