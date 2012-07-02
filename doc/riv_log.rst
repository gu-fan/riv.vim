Changelogs
==========

* 0.66: 

  + :Todos_:   DONE 2012-06-29 add field list for todo items.
  + :Indent_:  DONE 2012-06-29 the indentation in directives should return 0 after 
               2 blank lines
  + :Publish_: DONE 2012-06-29 Support the reStructuredText document not in a project.
  + :Indent_:  DONE 2012-06-29 fix indent of field list. 
               the line + 2 should line up with it's begining .
  + :Insert_:  DONE 2012-06-29 9229651d_ ``<Tab>`` and ``<S-Tab>`` 
               before list item will now shift the list. 
  + :Lists_:   DONE 2012-06-30 2b81464f_ bullet list will auto numbered when change to
               enumerated list.
  + :Lists_:   DONE 2012-06-30 21b8db23_ createing new list action in a field list will
               only add it's indent. refile todo parts.
  + :Links_:   DONE 2012-06-30 69555b21_ Optimized link finding. Add email web link.
  + :Links_:   DONE 2012-06-30 69555b21_ Add anonymous phase target and reference 
               jumping and highlighting. 
  + :Highlighting_:   DONE 2012-07-01 4dc853c1_ fix doctest highlighting
  + :Table_:   DONE 2012-07-01 38a8cebb_ Support simple table folding.
  + :Documents_: DONE 2012-07-01 help doc use doc/riv.rst  which is link of README.rst
  + :Documents_: DONE 2012-07-01 Add reStructuredText hint and link in instructions
  + :Indent_:  DONE 2012-07-01 7e19b531_ The indent for shifting lists should based on 
               the parent/child list item length.
  + :Lists_:   DONE 2012-07-02 Add a list parser.

.. _7e19b531: 
   https://github.com/Rykka/riv.vim/commit/7e19b531371e47e36bc039fa4f142434bcf4eb39
.. _38a8cebb: 
   https://github.com/Rykka/riv.vim/commit/38a8cebbc69f018cbc7caafa26473e2aee2dbe94
.. _4dc853c1: 
   https://github.com/Rykka/riv.vim/commit/4dc853c132848872810fdc549df3dc429f31fa56
.. _69555b21: 
   https://github.com/Rykka/riv.vim/commit/69555b2172950ed1ddf236e43b3bdcaea343afe0
.. _9229651d: 
   https://github.com/Rykka/riv.vim/commit/9229651de15005970990df57afba06d1b54e9bc9
.. _2b81464f:
   https://github.com/Rykka/riv.vim/commit/2b81464fa2479f8aced799d9117a5081d9e780dc
.. _21b8db23:
   https://github.com/Rykka/riv.vim/commit/21b8db2398a6d8cbbf2332b9938c110022de2095


* 0.65:

  + DONE 2012-06-27 take care of the slash of directory in windows .
  + FIXED 2012-06-28 correct cursor position when creating todo items and list items.
  + FIXED 2012-06-28 link highlight group removed after open another buffer.
  + FIXED 2012-06-28 auto mkdir when write file to disk
  + DONE 2012-06-28 format the scratch index, sort with year/month/day 


* 0.64:

  + DONE 2012-06-23  README : rewrite intro/feature part
  + DONE 2012-06-24  Doc  : Help document from README.
  + DONE 2012-06-24  Menu : add and fix.
  + DONE 2012-06-24  A shortcut to add date and time.
  + FIXED 2012-06-23 Fold : table should not show an empty line in folding of lists.
    (nothing wrong, just indent it with the list.)
  + DONE 2012-06-23  Fold : the fold text should showing correct line while editing.
  + FIXED 2012-06-24 Misc : highlight for hover link change to DiffText
  + FIXED 2012-06-24 Misc : create link now will add an empty line.

* ~ 0.63:

  + DONE 2012-06-20 fix fold line with east_asia char
  + DONE 2012-06-20 multi col/row table
  + DONE 2012-05-19 Format Table , use python?
  + FIXED 2012-05-15 intened list item should be highlighted.
  + DONE  2012-05-16 more .ext file to recongnize
  + DONE  2012-05-16 More section title format.
  + FIXED 2012-05-17 deflist wrong indent but still highlighted
  + FIXED 2012-05-19 section title  3 row , wrong highlighted
  + FIXED 2012-05-25 wrong comment fold region include normal text.
  + DONE  2012-06-01 highlight syn directives (code code-block code-name highlights)
  + FIXED 2012-06-01  the enum list's indentation is wrong. 
    (Note: it's right sometimes, and only recongnize num follow '.')
    (wrong with indented enum list)
  + DONE  2012-06-01 Doc Section index Buffer? same as the contents directive
  + FIXED 2012-06-02 wrong highlight of literal block. one blank line need after '::'

