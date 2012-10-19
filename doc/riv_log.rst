Changelogs
==========

* 0.73: This is mainly a bug fix version.

  :Intro: DONE 2012-10-19 ScreenCast tutor
  :Indent: FIXED 2012-10-16 List indentation for visual lines are wrong
  :File: DONE 2012-10-17 The file pattern separated for each project.
  :Insert: FIXED 2012-10-16 Literal-block create have trailing chars.
  :Lists: DONE 2012-10-17 Add :RivListToggle
  :Lists: DONE 2012-10-17 List new/sub/sup rewrite
  :Indent: FIXED 2012-10-17 fix SuperEnter's indent
  :Syntax: DONE 2012-10-17 add highlight for inline hyperlink reference and target
  :Syntax: FIXME fix the (**) highlight in directive.

* 0.72 

  :Syntax_: DONE 2012-09-25 highlight reStructuredText in python DocString.
  :File_: FIXED 2012-09-25 Fix the file link highlight of ``~/.xxx``
  :Sections_: FIXED 2012-10-04 Fix the section Helper.
  :Syntax_: FIXED 2012-10-04 Workaround of the Spell checking.
  :Intro_: DONE 2012-10-13 Options section.
  :Intro_: DONE 2012-10-15 Commands section.
  :Intro_: DONE 2012-10-16 Rewrite riv_quickstart
  :Intro_: DONE 2012-10-14 Rewrite riv_todo
  :Intro_: DONE 2012-10-14 Cheatsheet and Specification added.
  :File_:  DONE 2012-10-13 support user defined rst file suffix.
  :File_:  DONE 2012-10-13 support sphinx embedded :doc: link.
  :Test:   DONE 2012-10-13 Add `:RivVimTest` for vim script test.
  :Menu:   FIXED 2012-10-13 Fix menu disable/enable.
  :Links_: FIXED 2012-10-13 Fix target link jumping.
  :Commands: DONE 2012-10-15 Rewrite command and menu part.

* 0.71:

  :File_: DONE 2012-09-13 extension style show in vim only.
  :File_: DONE 2012-09-13 now square style (moinmoin) use ``[[xxx]]``. 
          easier for regxp match
  :File_: DONE 2012-09-13 Support Sphinx style  :file:, :doc:
  :Sections_: DONE 2012-09-17 Use sphinx section default markup style?
  :Sections_: DONE 2012-09-17 section create shortcut will check if it's 
              a section title undercursor and repl it.
  :Sections_: DONE 2012-09-17 A shortcut to create a document tree.
  :Sections_: DONE 2012-09-17 Add g:riv_content_format
  :Publish_: DONE 2012-09-13 remove '_`g:riv_file_link_convert`' 
  :Publish_: DONE 2012-09-18 different style.css for syntax highlighting in html
  :Publish_: DONE 2012-09-19 Fix link repl errors while converting to html.
  :Links_: DONE 2012-09-17 Add g:riv_create_link_pos
  :Miscs_: DONE 2012-09-19 A google group


* 0.70:

  :Table_:  DONE 2012-07-17 7b407b4b_ a table parser of vim version.
  :Table_:  DONE 2012-07-17 7b407b4b_ rewrite the table actions. 
  :Table_:  DONE 2012-07-18 a1f112d1_ add create table action.
  :Lists_:  FIXED 2012-07-19 fix list shifting with indent 0
  :Helpers_: DONE 2012-07-19 add folding to section helper
  :File_:   DONE 2012-07-21 improved link converting. add option

.. _a1f112d1: 
   https://github.com/Rykka/riv.vim/commit/a1f112d1e3f7b52130db1a4eeea7ef94c92d9c92
.. _7b407b4b: 
   https://github.com/Rykka/riv.vim/commit/7b407b4b5ff07467e1cdd78415984ee987e03f49

* 0.69:

  :Indent_: DONE 2012-07-07 8b2c4611_ Rewrite the indent for list and insert.
  :File_:   DONE 2012-07-07 dceab5c1_ Add File helper.
  :Document: DONE 2012-07-08 69e5a86e_ commit links
  :File_:   DONE 2012-07-08 a207e1e0_ Add Section helper.
  :Intro_:  DONE 2012-07-09 add Riv quickstart
  :Insert_: DONE 2012-07-13 rewrite and add options about ``i_tab``. 

.. _a207e1e0: 
   https://github.com/Rykka/riv.vim/commit/a207e1e0de177f6e6bd06fc2fab0151780074320
.. _69e5a86e: 
   https://github.com/Rykka/riv.vim/commit/69e5a86e530c09f1472b1d4c79c05854a061f8f3
.. _dceab5c1: 
   https://github.com/Rykka/riv.vim/commit/dceab5c1b0ae484c44763ff1172fc3d93debf2e6
.. _8b2c4611: 
   https://github.com/Rykka/riv.vim/commit/8b2c4611acf959a28d4413e0131de70b68c9368d

* 0.68:
    
  :Patterns:  DONE 2012-07-07 a2334f7b_ Rewrite the pattern and syntax patterns part. 
  :Todos_:    DONE 2012-07-07 a2334f7b_ Rewrite todo and todo helper.Add Todo Priorities. 
  :Syntax_:   DONE 2012-07-07 a2334f7b_ Cursor highlight will highlight the todo item 
  :Syntax_:   DONE 2012-07-07 a2334f7b_ Cursor highlight will check it's valid file
  :Lists_:    DONE 2012-07-07 0a959662_ Add list types 0 ~ 4 
  :Todos_:    DONE 2012-07-07 142b6c49_ Add Prior in helper


.. _142b6c49: 
    https://github.com/Rykka/riv.vim/commit/142b6c496b5050150a6b77eeed48e0ade79fc329

.. _0a959662: 
    https://github.com/Rykka/riv.vim/commit/0a95966247048e11d947fdeb4a2189e17c00d791
.. _a2334f7b:
    https://github.com/Rykka/riv.vim/commit/a2334f7b98e9ce83c06d95e7552a13ac6c2c1cd4

* 0.67:

  :Folding_: DONE 2012-07-05 da03e247_ The line block is folded now.
  :Table_:   DONE 2012-07-05 da03e247_ Improved row & col count.
  :Lists_:   DONE 2012-07-05 12bcabf3_ Rewrite the list shifting action and 
             formatting action.  only fix the indent caused by list-item change. 
             so it did not change the document structure.
  :Lists_:   DONE 2012-07-05 When we add parent list,
             check if there is a prev parent level and item.
  :Syntax_:  FIXED 2012-07-05 table: not highlighted when after a literal block.
  :Syntax_:  FIXED 2012-07-05 simple table: Span line is not highlighted with one span.

.. _12bcabf3:
    https://github.com/Rykka/riv.vim/commit/12bcabf38dee42f65996b23d658bff97d0f353e4

.. _da03e247: 
   https://github.com/Rykka/riv.vim/commit/da03e247418f86fe423d20961b61716fbea36d9b

* 0.66: 

  :Todos:   DONE 2012-06-29 add field list for todo items.
  :Indent:  DONE 2012-06-29 the indentation in directives should return 0 after 
             2 blank lines
  :Publish: DONE 2012-06-29 Support the reStructuredText document not in a project.
  :Indent:  DONE 2012-06-29 fix indent of field list. 
             the line + 2 should line up with it's begining .
  :Insert:  DONE 2012-06-29 9229651d_ ``<Tab>`` and ``<S-Tab>`` 
             before list item will now shift the list. 
  :Lists:   DONE 2012-06-30 2b81464f_ bullet list will auto numbered when change to
             enumerated list.
  :Lists:   DONE 2012-06-30 21b8db23_ createing new list action in a field list will
             only add it's indent. refile todo parts.
  :Links:   DONE 2012-06-30 69555b21_ Optimized link finding. Add email web link.
  :Links:   DONE 2012-06-30 69555b21_ Add anonymous phase target and reference 
             jumping and highlighting. 
  :Highlighting:   DONE 2012-07-01 4dc853c1_ fix doctest highlighting
  :Table:   DONE 2012-07-01 38a8cebb_ Support simple table folding.
  :Documents: DONE 2012-07-01 help doc use doc/riv.rst  which is link of README.rst
  :Documents: DONE 2012-07-01 Add reStructuredText hint and link in instructions
  :Indent:  DONE 2012-07-01 7e19b531_ The indent for shifting lists should based on 
             the parent/child list item length.
  :Lists:   DONE 2012-07-02 Add a list parser.

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

* 0.63 < :

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


.. _Folding: riv.rst#folding
.. _Lists:   riv.rst#Lists
.. _Table:   riv.rst#Table
.. _Syntax:  riv.rst#Syntax
.. _Indent:  riv.rst#Indent
.. _File:    riv.rst#File
.. _Intro:   riv.rst#Intro
.. _Insert:  riv.rst#Insert
.. _Todos:   riv.rst#Todos
.. _Helpers: riv.rst#Helpers
.. _Sections: riv.rst#Sections
.. _Publish: riv.rst#Publish
.. _Links: riv.rst#Links
.. _Miscs: riv.rst#Miscs
