#######################
Riv: Take Notes in rst
#######################

:Last Update: 2018-01-21
:Version: 0.792

New Changes
===========

0.792: fix the python/rst syntax file

0.791: Add a conceal syntax for \*.rst filelink

0.79: As The clickable is not stable, and with many voting to disable it, revert to 0.77.


Intro
=====

**Riv** is a vim plugin for taking notes with reStructuredText_.

.. figure:: https://user-images.githubusercontent.com/579129/35188163-ea914ce8-fe6b-11e7-8a8e-11527785122b.gif
    :align: center

    riv.vim_ (vim) +  InstantRst_ (web server) +  rhythm.css_ (theme)

Comparion
=========

First things first.

There are some other note plugins in Vim, like vimwiki_, vim-notes_, VOoM_, etc.

Also org-mode_ if you are an Emacs fan.

**Why use this plugin?**

In comparison, the biggest advantage of **Riv.vim** is reStructuredText_ support. 

    reStructuredText is a markup language.

    Its syntax is similar to markdown_, but more powerful and extensible.
    Tables, LaTex, etc. are supported.

    It's widely used in the Python community, and has many relevant plugins.
    Sphinx_ (www.readthedocs.org) Pygments_, Nikola_, etc.

    Here is a post comparing reStructuredText and Markdown:
    https://gist.github.com/dupuy/1855764


Features
========

**Wiki**  
    Write wiki with project and file link support. **TODO** syntax is added.
**Editing**   
    Faster typing, easier navigation, clear indenting, auto formatting etc.
**Reading** 
    Improved syntax highlighting and folding support for reading document clearly.
**Publish** 
    Convert RST files to a number of different formats: PDF, HTML, XML, Latex and ODT, etc.
    A new theme rhythm.css_ is added for better performance. 
**Plugins**   
    Support many plugins like Sphinx_ syntax support.
    Other RST plugins:

    - Vim & Python: InstantRst_ for previewing RST documents instantly.
    - Vim & Python: Syntastic_ for syntax checking. Requires Docutils_ and Pygments_.
    - Python: Sphinx_ for Sphinx users.
    - Python: Nikola_ or pelican_ for static blogging with RST syntax.
    - Python: HoverCraft_ for writing presentation from RST.

    Contribution to this list are welcome.

Installation
============

Using Vundle_
-------------

**Recommended**
Add this line to your ``.vimrc`` (after you have properly set up Vundle_)::
 
    Bundle 'Rykka/riv.vim'

Downloaded zip/tar.gz file
--------------------------

Extract the contents of the archive to your ``.vim`` directory.

Config
------

You can add projects with ``g:riv_projects``::

    let proj1 = { 'path': '~/Dropbox/rst', }
    let g:riv_projects = [proj1]

More options see the ``:RivInstruction``

Make sure your ``.vim`` directory is before ``$VIMRUNTIME`` in ``runtimepath``.
By default it *is* present before ``$VIMRUNTIME``.

Also make sure ``filetype plugin indent on`` and ``syntax on`` options
are present in your ``.vimrc``.

Related tools
-------------

.. TODO

Tutorials
=========

You can have a quick start with ``:RivQuickStart``.

Here is the Screencast: 

* Riv: QuickStart_ (HD)


New To Vim
----------

* If you are new to Vim, you can get a basic overview of Vim using
  ``vimtutor``. To use it simply type ``vimtutor`` in your shell.
  
* To view the quick reference of Vim, use ``:h quickref``.

New To RST
----------

* To get a quick overview of reStructuredText, some of the available options
  are:

  Read "`A ReStructuredText Primer`_". You can use ``:RivPrimer`` to open it in
  Vim. Or, you can read "`Quick reStructuredText`_".

* For a detailed look at reStructuredText's specifications, take a look at
  "`reStructuredText Specification`_". You can use ``:RivSpecification`` to
  open it in Vim.

* Finally, you can use "`reStructuredText cheatsheet`_" for a quick review. Use
  ``:RivCheatSheet`` to open it in Vim.

New To Riv
----------

* For getting started with Riv, read "`QuickStart With Riv`_".
  You can also view it using ``:RivQuickStart`` in Vim.

* Detailed instructions for Riv are available at "`Instructions`_". Use
  ``:RivInstruction`` to read the same in Vim.

Issues
======

The bug tracker for Riv is at https://github.com/Rykka/riv.vim/issues.
You can use it to report bugs and open feature requests. Discussions related
to Riv are welcome too. 

You can follow my twitter `@rykkaf`_ and tweet me there too.

Common Issues
-------------

* If you get errors with folding in documents, you can try to force reload
  using ``:RivReload`` or ``<C-E>t```.

  Or just `:w` as it will auto-refold after saving.

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
.. _`@rykkaf`: https://twitter.com/rykkaf
.. _InstantRst: https://github.com/Rykka/InstantRst
.. _Galaxy.vim: https://github.com/Rykka/galaxy.vim
.. _HoverCraft: https://github.com/regebro/hovercraft
.. _typo.css:  https://github.com/sofish/Typo.css 
.. _VOoM: https://github.com/vim-voom/VOoM
.. _doctest.vim: https://github.com/Rykka/doctest.vim
.. _`#71`: https://github.com/Rykka/riv.vim/issues/71
.. _`#72`: https://github.com/Rykka/riv.vim/issues/72
.. _rhythm.css: https://github.com/Rykka/rhythm.css
.. _changelog: changelog.rst
.. _riv.vim: http://github.com/Rykka/riv.vim
.. _pelican: https://github.com/getpelican/pelican
