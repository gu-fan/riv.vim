Riv TODOs
============

Things TODOs in the future. 

Any suggestion and advice is welcome.

TODOS
-----

1. Temlates:

   A. A shortcut to create basic file layout for each file in project.

      for file, shows parent index / index and file: create/modified date.

      for index, only show parent index and file.

      for root , only show file.

   B. HTML templates and CSS styles

2. Sections:

   + Sections: Adjust section level.
   + Sections: Shortcut to add sections references like the content directive?
   + Some eyecandy for section title? with galaxy.vim

3. Documents

   + Documents: Document part: options / commands.
   + Documents: Sreencast and screenshot of intro.

4. Links

   + Links:   The standalone web link with ``/`` is detected as local file.
   + Links:   Link tags between files?
   + Links:   Github flavor: create commit link, issue link?
   + TODO highlight in another color when the file of file link is not readable.

5. Lists

   A. '=' should format the sub list which indent is between parent's item and idt.
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

   + TODO [#C] Todos: Todo item priorities?
   + FIXME an option for setting default type when toggle todo.
   + TODO Rethiking the todo item
   + the name of todo cache.

7. _`Table`

  :Table_: FIXME  malformed when pressing ``enter`` sometimes
  :Table_: Support simple table format?
  :Table_: Support column span?
  :Table_: A vim table parser for compatible?
  :Table_: A shortcut or command to create table with row * col.
  :Table_: DONE 2012-07-05 Improved row & col count.

8. Folding

   + Folding: A buf parser write in python for performance?

9. Indent 

   + Indent:  <Tab> to indent. improved <BS> indent
   + Indent:  The content space for field list should align with prev field list.
   + Indent:  A command to format the indent of lists.

10. highlighting

    + highlight the directives with indents.
    + Simple table highlighting: not highlighted when after a literal block.
    + Simple table highlighting: the span line is not highlighted when one span.

11. Folding

   A. Sometimes folding did not update correctly.

12. File

    + File:    A template or snippet or shortcut for adding ``./`` and ``../`` 
      and files.  Maybe a sphinx doc ref as well.
    + A file tag jump like ``:xxx:`xxxx``` for sphinx docs
    + for bare style, a method to escape file that not convert to links
    + an option for not converting links

13. Publish

    + Publish: An option to enable highlighting todo items.

14. Helpers

    A. Helpers: An option Helper and option cache. 
       Let people use it even without touching ``.vimrc`` .
    B. Helpers: A command helper?
    C. A file helper : showing file structure
    D. A documnet helper : showing doucment structure
    E. TODO Todo Helper : showing document todo for a file not in project.

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


