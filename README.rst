Intro
=====

:Author: Rykka G.Forest
:Date:   2012-06-19T01:15:53
:version: 0.62a

**Riv** is short for 'ReST in Vim'.
in which **ReST** is short for reStructuredText_ .

It is a vim plugin for managing and writing ReST Documents.

.. _reStructuredText: http://docutils.sourceforge.net/rst.html

It is for people either want to manage documents in a personal wiki ,
or writing documents with more html syntax support (than other markup language).

And you may need to see the `markup syntax of ReST documents`__ first.

__ http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html

Features
========
    
* Folding : Fold ReST file with sections, lists, and explicit mark, table, 
  literal-quotes...
* Sections: Section levels are auto recongized.
  The section number will be showing when folded.
  Clicking on the section reference will bring you to the section title.
* Lists : Auto Numbered and auto leveled for bullet and enumerated list
* Links : Clicking on links will executing it's default behavior 
  (open browser/edit file/jump to internal target)
* Table : Auto Format Table. 
  (Currently require vim compiled with python. And Grid Table only.)::

    +-----------------+-----------+
    | The Grid Table  | column 2  |
    +=================+===========+
    | row 2           |           |
    +-----------------+-----------+

..

    +-----------------+-----------+
    | The Grid Table  | column 2  |
    +=================+===========+
    | row 2           |           |
    +-----------------+-----------+



* Project: You can manage your ReST documents with a wiki style way.
* Local File: As ReST haven't define a pattern for local files currently.
  **Riv.vim**  provides two kinds of patterns to determine the local file
  in the rst documents.

  - 'xxx.rst' 'xxx.py' 'xxx.cpp' , directory is 'xxx/' .
     and you can add other extensions with `g:riv_file_link_ext`
  - '[xxx] [xxx.vim]' , directory is '[xxx/]'

* Scratch: The scratches (auto named by date) , can be accessed quickly.
* Miscs : Create sections, lists, links , 
  and other stuffs easier with short command.

* Highlighting: Fixed default syntax file to match the ReST syntax.

  +  Lists Highlighting added.
  +  Code Block syntax highlighting added. ( `.. code:: python` )
     You can use `g:riv_highlight_code` to choose 
     which type of code to highlight.
* Indent: Fixed default indent file to match the ReST syntax.

* Todos : you can add todo items , and it's datestamp , 
  also edit them easily.
* Helpers: A little window to search things in project.

  + Todo Helper: you can check your All/Todo/Done items in current project.
* Convert: some wrapper to convert rst files to html/xml/latex/odt/... 
  and browse them.  Local Link file also converted.
  (require python docutils package )

Install
-------
* Using Vundle_  (Recommend)

  Add this line to your vimrc::
 
    Bundle 'Rykka/riv.vim'

.. _Vundle: www.github.com/gmarik/vundle


* Using the zip file. 
  Just download the zipped file and extract to your `.vim` folder .

:NOTE: Make sure the your .vim folder in option 'runtimepath' 
       is before the $VIMRUNTIME. 
       Otherwise the syntax/indent files for rst file will using the vim built-in one.

* Recommened packages: 
    
  + Syntastic_  for syntax checking of rst files.
    (require python docutils package )

.. _Syntastic: https://github.com/scrooloose/syntastic

Todo
---------

* TODO add section deatils.

