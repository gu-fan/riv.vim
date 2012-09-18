Riv TODO
==========

Things TODO or NOT in the future 

TODOS
-----

1. Temlates:

   A. A Even QuickStarter for reStructuredText quick start.

   B. A shortcut to create basic file layout for each file in project.

      for file, shows parent index / index and file: create/modified date.

      for index, only show parent index and file.

      for root , only show file.

   C. HTML templates and CSS styles

2. Sections:

   + Sections: Adjust section level.
   + Sections: Shortcut to add sections references like the content directive?
   + Some eyecandy for section title? with galaxy.vim

3. Documents

   + Documents: Document part: options / commands.
   + Documents: Sreencast and screenshot of intro.

4. Links

   + Links:   The standalone web link with ``/`` is detected as local file.
   + Links:   Link tags between files? index.rst#section -> index.html#section
   + Links:   Github flavor: create commit link, issue link?
   + DONE 2012-07-07 highlight in another color when the file of file link is not readable.

5. Lists

   A. DONE 2012-07-07 '>' and '<' and '=' will format the sub list's num/level and fix the indent
   B. DONE 2012-07-05 Rewrite the list shifting action and formatting action.
      only fix the indent caused by list-item change. 
      so it did not change the document structure.

      a. a non-list 
      b. a list
      c. a sub list of a list 
      d. a sub sentence of a list
      e. a blockquote.
      f. the shiftwidth and shift length
      g. should the indent use the list's shift setting?

   C. DONE 2012-07-05 When we add parent list , check if there is a prev parent level and item.

6. Todos

   + DONE [#C] 2012-07-07 Todos: Todo item priorities?
   + FIXED 2012-07-07 an option for setting default type when toggle todo.
   + DONE 2012-07-07 Rethiking the todo item
   + the name of todo cache.

7. Table

  :Table_: FIXME  malformed when pressing ``enter`` sometimes
  :Table_: Support simple table format?
  :Table_: Support column span?
  :Table_: A vim table parser for compatible?
  :Table_: A shortcut or command to create table with row * col.
  :Table_: DONE 2012-07-20 Improved row & col count.

8. Folding

   + Folding: A buf parser write in python for performance?

9. Indent 

   + DONE 2012-07-08 Indent:  <Tab> to indent. improved <BS> indent
   + DONE 2012-08-18 Indent:  The content space for field list should align with prev field list.
   + DONE 2012-07-08 Indent:  A command to format the indent of lists.
     Use '>' '<' to indent list lvel, use '=' to format number only

10. Syntax

    + highlight the directives with indents.
    + DONE 2012-07-05 table : not highlighted when after a literal block.
    + FIXED 2012-07-05 simple table : span line is not highlighted with one span.

11. Folding

   A. XXX Sometimes folding did not update correctly.

12. File

    + File:    A template or snippet or shortcut for adding ``./`` and ``../`` 
      and files.  Maybe a sphinx doc ref as well.
    + [X] 2012-09-17 A file tag jump like ``:xxx:`xxxx``` for sphinx docs
    + [X] 2012-09-17 A file tag jump like ``[[xxx]]`` like moinmoin and most other wikis.
    + [X] 2012-09-18 for bare style, a method/syntax to escape file that not convert to links
    + hack the docutils parser with local file link.
    + add ``:download:`` 
    + update the sphinx link rule.
    + sphinx link support embedded style.

    THOUGHT::

        The file jumping in vim uses bare style and moinmoin or sphinx style.
        And only the '[[xxx]]' or  ':doc:`../people`' will be changed to link

    :Think: Made it less confuse with different patterns

            1. bare style only show in vim. and not converted.
            2. you can choose moinmoin wiki style ``[[xxx]]``

               or the sphinx style ``:doc:`xxx``` ``:file:`xxx```

13. Publish

    + Publish: An option to enable highlighting todo items.
    + the temp path should be validated.
    + javascript for HTML with folding sections.
    + templating? jinja?
    + support sphinx make and browse

14. Helpers

    A. Helpers: An option Helper and option cache. 
       Let people use it even without touching ``.vimrc`` .
    B. Helpers: A command helper?
    C. DONE 2012-07-08 A file helper : showing file structure
    D. DONE 2012-07-08 A documnet helper : showing doucment structure
    E. DONE 2012-07-07 Todo Helper : showing document todo for a file not in project.

15. Scratch

    - Scratch: Show Scratch sign in Calendar.

16. ScreenCast

    + A list tutor
    + A todo tutor
    + A section tutor

17. A site to show and discuss and store.
18. built-in Calendar and todo schedule?

   A. when things finished , update the status
   B. sync with calendar?



.. _Table: riv.rst#table
