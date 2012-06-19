Intro
=====

:Author: Rykka G.Forest
:Date:   2012-06-19T01:15:53
:version: 0.62a

Riv is short for 'ReST in Vim'.
in which ReST is short for reStructuredText_ .

It is a plugin for writing and managing ReST Documents.

.. _reStructuredText: http://docutils.sourceforge.net/rst.html

It is for people who either want to manage files in wiki style project,
or writing documents with more html syntax support(than other markup language like markdown or mediawiki).

* Features include:
    
  + Folding : fold it with it's section, lists, and explicit mark, table, 
    literal-quotes...
  + Sections: Fold section and indicating it's section-number. 
    Also click on the section reference will bring you to the section title.
  + Lists : bullet and enumerated list can be create both auto numbered 
    and auto leveled.
  + Links : Clicking on links will execute default behavior for the link.
  + Table: Auto Format Table. (Currently require vim compiled with python.)
  + Projects: You can manage your rest documents in a folder with a wiki style way.
  + Local File: Provide two kinds of link pattern to choose to link a local file
    in the rst documents 
  + Miscs : create links , sections and other stuffs easier with short command.

  + Highlighting: fixed default syntax file to match the ReST syntax.
  + Highlighting for Lists , which is not included in default rst syntax file.
  + Highlighting for code blocks, And you can choose the code to highlights
  + Indents: fixed default indent file to match the ReST syntax.

  + Todos : you can add todo items , and it's datestamp , 
    also edit them easily. (highlights in vim only) 
  + Helpers: A little window to search things in project.

    - Todo Helper: you can check your All/Todo/Done items in current project.
    - TODO : CMD Helper: You can use CMDS and view it's details , it's a detailed version
      of menus.
    - TODO : OPT Helper: You can easily set your options, 
      and option will be cached. 

  + Scratch: a place to hold the scratches (auto named by date) of the project 
  + Convert: some wrapper to convert rst files to html/xml/latex/odt/... 
    and browse them.  Local Link file also converted.
    (You should have docutils package installed)

  + Recommened packages: 
    
    - Syntastic: for syntax checking of rst files.
    - Galaxy: My colorscheme generator, provide better (maybe!) highlights for the
      Eye Candy.


Install
-------

* TODO : add install instruction 
* TODO : add example vimrc


ToDo List
---------

* TODO : Add todo things here.
* TODO : Doc: add section deatils.
* TODO : Convert: Add highlights for todo items in html file.
* TODO : Windows: obj_dic seems unreachable.

