"=============================================
"    Name: cmd.vim
"    File: cmd.vim
" Summary: Commands
"  Author: Rykka G.F
"  Update: 2014-08-09
"=============================================
let s:cpo_save = &cpo
set cpo-=C
" cmds "{{{1
let g:riv_default.cmds = [
\{'name': 'RivProjectIndex', 'act': 'call riv#index()',
    \'note': 'Open the default Riv project index in vim.',
    \'menu': 'Project.Index',
    \'type': 'global', 'mode': 'm', 'maps': ['ww', '<C-W><C-W>'],
    \'keys': [],
\},
\{'name': 'RivProjectList' , 'act': 'call riv#index_list()',
    \'note': 'Show Riv project list.',
    \'menu': 'Project.List',
    \'type': 'global', 'mode': 'm', 'maps': ['wa', '<C-W><C-A>'] ,
    \'keys': [],
\},
\{'name': 'RivProjectHtmlIndex' , 'act': 'call riv#publish#browse()',
    \'note': 'Browse project html index.',
    \'menu': 'Project.Html\ Index',
    \'type': 'global', 'mode': 'm', 'maps': ['wi', '<C-W><C-I>'] ,
    \'keys': [],
\},
\{'name': 'RivScratchCreate' , 'act': 'call riv#create#scratch()',
    \'note': 'Create Or Edit Scratch of today.',
    \'menu': 'Scratch.Create',
    \'type': 'global', 'mode': 'm', 'maps': ['sc', '<C-S><C-C>'] ,
    \'keys': [],
\},
\{'name': 'RivScratchView' , 'act': 'call riv#create#view_scr()',
    \'note': 'View The Index of Scratch Directory',
    \'menu': 'Scratch.View',
    \'type': 'global', 'mode': 'm', 'maps': ['sv', '<C-S><C-V>'] ,
    \'keys': [],
\},
\{'menu': '---View---','type': 'menu' } ,
\{'name': 'RivFoldToggle', 'act': '@=(foldclosed(".")>0?"zv":"zc")<CR>',
    \'type': 'norm', 'mode': 'n', 'maps': ['<Space><Space>'], 'keys':[],
    \'note': 'Toggle Fold',
    \'menu': 'Fold.Toggle',
\},
\{'name': 'RivFoldAll', 'act': '@=(foldclosed(".")>0?"zR":"zM")<CR>',
    \'type': 'norm', 'mode': 'n', 'maps': ['<Space>a'], 'keys':[],
    \'note': 'Toggle all folding',
    \'menu': 'Fold.Toggle\ All',
\},
\{'name': 'RivFoldUpdate', 'act': 'zx',
    \'type': 'norm', 'mode': 'n', 'maps': ['<Space>u'], 'keys':[],
    \'note': 'Update Folding',
    \'menu': 'Fold.Update',
\},
\{'name': 'RivLinkOpen' , 'act': 'call riv#link#open()',
    \'note': 'Open Link under Cursor',
    \'menu': 'Link.Open',
    \'type': 'buf', 'mode': 'n', 'maps': ['ko'], 'keys': [],
\},
\{'name': 'RivLinkShow' , 'act': 'call riv#link#open(1)',
    \'note': 'Move to Link under Cursor',
    \'menu': 'Link.Show',
    \'type': 'buf', 'mode': 'n', 'maps': ['ks'], 'keys': [],
\},
\{'name': 'RivLinkNext' , 'act': 'call riv#link#finder("f")',
    \'note': 'Jump to Next Link',
    \'menu': 'Link.Next',
    \'type': 'buf', 'mode': 'n', 'maps': ['kn'], 'keys': ['<Tab>'],
\},
\{'name': 'RivLinkPrev' , 'act': 'call riv#link#finder("b")',
    \'note': 'Jump to Prev Linx',
    \'menu': 'Link.Prev',
    \'type': 'buf', 'mode': 'n', 'maps': ['kp'], 'keys': ['<S-Tab>'],
\},
\{'name': 'RivShiftRight' , 'act': 'call riv#list#shift("+")',
    \'note': 'Shift Right with level and indent adjustment.',
    \'menu': 'Indent.Shift\ Right',
    \'type': 'buf', 'mode': 'nv', 'maps': ['l>'], 'keys': ['>', '<C-ScrollwheelDown>'],
\},
\{'name': 'RivShiftLeft' , 'act': 'call riv#list#shift("-")',
    \'note': 'Shift Left with level and indent adjustment.',
    \'menu': 'Indent.Shift\ Left',
    \'type': 'buf', 'mode': 'nv', 'maps': ['l<'], 'keys': ['<', '<C-ScrollwheelUp>'],
\},
\{'name': 'RivShiftEqual' , 'act': 'call riv#list#shift("=")',
    \'note': 'Format List level',
    \'menu': 'Indent.Shift\ Equal',
    \'type': 'buf', 'mode': 'nv', 'maps': ['l='], 'keys': ['='],
\},
\{'name': 'RivNormRight', 'act': '>>', 'vact':'>',
    \'type': 'norm', 'mode': 'nv', 'maps': ['>'], 'keys':['<S-ScrollwheelDown>'],
    \'note': 'Normal Shift Right',
    \'menu': 'Indent.Normal\ Right',
\},
\{'name': 'RivNormLeft', 'act': '<<', 'vact':'<',
    \'type': 'norm', 'mode': 'nv', 'maps': ['<lt>'], 'keys':['<S-ScrollwheelUp>'],
    \'note': 'Normal Shift Left',
    \'menu': 'Indent.Normal\ Left',
\},
\{'name': 'RivNormEqual', 'act': '==', 'vact':'=',
    \'type': 'norm', 'mode': 'nv', 'maps': ['='], 'keys':[],
    \'note': 'Normal Equal',
    \'menu': 'Indent.Normal\ Equal',
\},
\{'name': 'RivItemClick' , 'act': 'call riv#action#db_click(1)',
    \'note': 'Open Link,Toggle item and toggle section folding',
    \'type': 'buf', 'mode': 'm', 'maps': [], 'keys': ['<2-LeftMouse>'],
\},
\{'name': 'RivItemToggle' , 'act': 'call riv#action#db_click(0)',
    \'note': 'Open Link, Toggle item',
    \'menu': 'Item.Toggle',
    \'type': 'buf', 'mode': 'm', 'maps': [], 'keys': ['<CR>', '<KEnter>'],
\},
\{'menu': '---Doc---','type': 'menu' } ,
\{'name': 'RivTitle1' , 'act': 'call riv#section#title(1)',
    \'note': 'Create Type 1 Title',
    \'menu': 'Section.Title\ 1',
    \'type': 'buf', 'mode': 'mi', 'maps': ['s1'], 'keys': [],
\},
\{'name': 'RivTitle2' , 'act': 'call riv#section#title(2)',
    \'note': 'Create Type 2 Title',
    \'menu': 'Section.Title\ 2',
    \'type': 'buf', 'mode': 'mi', 'maps': ['s2'], 'keys': [],
\},
\{'name': 'RivTitle3' , 'act': 'call riv#section#title(3)',
    \'note': 'Create Type 3 Title',
    \'menu': 'Section.Title\ 3',
    \'type': 'buf', 'mode': 'mi', 'maps': ['s3'], 'keys': [],
\},
\{'name': 'RivTitle4' , 'act': 'call riv#section#title(4)',
    \'note': 'Create Type 4 Title',
    \'menu': 'Section.Title\ 4',
    \'type': 'buf', 'mode': 'mi', 'maps': ['s4'], 'keys': [],
\},
\{'name': 'RivTitle5' , 'act': 'call riv#section#title(5)',
    \'note': 'Create Type 5 Title',
    \'menu': 'Section.Title\ 5',
    \'type': 'buf', 'mode': 'mi', 'maps': ['s5'], 'keys': [],
\},
\{'name': 'RivTitle6' , 'act': 'call riv#section#title(6)',
    \'note': 'Create Type 6 Title',
    \'menu': 'Section.Title\ 6',
    \'type': 'buf', 'mode': 'mi', 'maps': ['s6'], 'keys': [],
\},
\{'name': 'RivTitle0' , 'act': 'call riv#section#title(0)',
    \'note': 'Create Type 0 Title',
    \'menu': 'Section.Title\ 0',
    \'type': 'buf', 'mode': 'mi', 'maps': ['s0'], 'keys': [],
\},
\{'name': 'RivTableCreate' , 'act': 'call riv#table#create()',
    \'note': 'Create a Table',
    \'menu': 'Table.Create',
\'type': 'buf', 'mode': 'mi', 'maps': ['tc'], 'keys': [],
\},
\{'name': 'RivTableFormat' , 'act': 'call riv#table#format()',
    \'note': 'Format table',
    \'menu': 'Table.Format',
    \'type': 'buf', 'mode': 'mi', 'maps': ['tf'], 'keys': [],
\},
\{'name': 'RivTableNextCell' , 'act': 'call cursor(riv#table#nextcell())',
    \'note': 'Nav to Next Cell',
    \'menu': 'Table.Next\ Cell',
    \'type': 'buf', 'mode': 'mi', 'maps': ['tn'], 'keys': [],
\},
\{'name': 'RivTablePrevCell' , 'act': 'call cursor(riv#table#prevcell())',
    \'note': 'Nav to Prev Cell',
    \'menu': 'Table.Prev\ Cell',
    \'type': 'buf', 'mode': 'mi', 'maps': ['tp'], 'keys': [],
\},
\{'name': 'RivListNew' , 'act': 'call riv#list#new(0)',
    \'note': 'Create a New List',
    \'menu': 'List.New',
    \'type': 'buf', 'mode': 'mi', 'maps': ['ln'], 'keys': [],
\},
\{'name': 'RivListSub' , 'act': 'call riv#list#new(1)',
    \'note': 'Create a sub list item',
    \'menu': 'List.Sub\ List',
    \'type': 'buf', 'mode': 'mi', 'maps': ['lb'], 'keys': [],
\},
\{'name': 'RivListSup' , 'act': 'call riv#list#new(-1)',
    \'note': 'Create a sup list item',
    \'menu': 'List.Sup\ List',
    \'type': 'buf', 'mode': 'mi', 'maps': ['lp'], 'keys': [],
\},
\{'name': 'RivListToggle' , 'act': 'call riv#list#toggle()',
    \'note': 'ToggleList item',
    \'menu': 'List.Toggle\ List',
    \'type': 'buf', 'mode': 'mi', 'maps': ['l`'], 'keys': [],
\},
\{'name': 'RivListDelete' , 'act': 'call riv#list#delete()',
    \'note': 'Delete List item',
    \'menu': 'List.Del\ List',
    \'type': 'buf', 'mode': 'mi', 'maps': ['lx'], 'keys': [],
\},
\{'name': 'RivListType0' , 'act': 'call riv#list#change(0)',
    \'note': 'Create a List type 0',
    \'menu': 'List.Type\ 0',
    \'type': 'buf', 'mode': 'mi', 'maps': ['l1'], 'keys': [],
\},
\{'name': 'RivListType1' , 'act': 'call riv#list#change(1)',
    \'note': 'Create a List type 1',
    \'menu': 'List.Type\ 1',
    \'type': 'buf', 'mode': 'mi', 'maps': ['l2'], 'keys': [],
\},
\{'name': 'RivListType2' , 'act': 'call riv#list#change(2)',
    \'note': 'Create a List type 2',
    \'menu': 'List.Type\ 2',
    \'type': 'buf', 'mode': 'mi', 'maps': ['l3'], 'keys': [],
\},
\{'name': 'RivListType3' , 'act': 'call riv#list#change(3)',
    \'note': 'Create a List type 3',
    \'menu': 'List.Type\ 3',
    \'type': 'buf', 'mode': 'mi', 'maps': ['l4'], 'keys': [],
\},
\{'name': 'RivListType4' , 'act': 'call riv#list#change(4)',
    \'note': 'Create a List type 4',
    \'menu': 'List.Type\ 4',
    \'type': 'buf', 'mode': 'mi', 'maps': ['l5'], 'keys': [],
\},
\{'name': 'RivTodoToggle' , 'act': 'call riv#todo#toggle()',
    \'note': 'Toggle Todo item''s status',
    \'menu': 'Todo.Toggle',
    \'type': 'buf', 'mode': 'mi', 'maps': ['ee'], 'keys': [],
\},
\{'name': 'RivTodoDel' , 'act': 'call riv#todo#delete()',
    \'note': 'Del Todo Item',
    \'menu': 'Todo.Del',
    \'type': 'buf', 'mode': 'mi', 'maps': ['ex'], 'keys': [],
\},
\{'name': 'RivTodoDate' , 'act': 'call riv#todo#change_datestamp()',
    \'note': 'Change Date stamp under cursor',
    \'menu': 'Todo.Date\ Stamp',
    \'type': 'buf', 'mode': 'mi', 'maps': ['ed'], 'keys': [],
\},
\{'name': 'RivTodoPrior' , 'act': 'call riv#todo#toggle_prior(1)',
    \'note': 'Change Todo Priorties',
    \'menu': 'Todo.Prior',
    \'type': 'buf', 'mode': 'mi', 'maps': ['ep'], 'keys': [],
\},
\{'name': 'RivTodoAsk' , 'act': 'call riv#todo#todo_ask()',
    \'note': 'Show the todo group list',
    \'menu': 'Todo.Group\ List',
    \'type': 'buf', 'mode': 'mi', 'maps': ['e`'], 'keys': [],
\},
\{'name': 'RivTodoType1' , 'act': 'call riv#todo#change(0)',
    \'note': 'Change to group 1',
    \'menu': 'Todo.Group\ 1',
    \'type': 'buf', 'mode': 'mi', 'maps': ['e1'], 'keys': [],
\},
\{'name': 'RivTodoType2' , 'act': 'call riv#todo#change(1)',
    \'note': 'Change to group 2',
    \'menu': 'Todo.Group\ 2',
    \'type': 'buf', 'mode': 'mi', 'maps': ['e2'], 'keys': [],
\},
\{'name': 'RivTodoType3' , 'act': 'call riv#todo#change(2)',
    \'note': 'Change to group 3',
    \'menu': 'Todo.Group\ 3',
    \'type': 'buf', 'mode': 'mi', 'maps': ['e3'], 'keys': [],
\},
\{'name': 'RivTodoType4' , 'act': 'call riv#todo#change(3)',
    \'note': 'Change to group 4',
    \'menu': 'Todo.Group\ 4',
    \'type': 'buf', 'mode': 'mi', 'maps': ['e4'], 'keys': [],
\},
\{'name': 'RivTodoUpdateCache' , 'act': 'call riv#todo#force_update()',
    \'note': 'Update Todo cache',
    \'menu': 'Todo.Update\ Cache',
    \'type': 'buf', 'mode': 'm', 'maps': ['uc'], 'keys': [],
\},
\{'menu': '---Edit---' ,'type': 'menu' } ,
\{'name': 'RivCreateLink' , 'act': 'call riv#create#link(mode().visualmode())',
    \'note': 'Create Link based on current word',
    \'menu': 'Insert.Link',
    \'type': 'buf', 'mode': 'vmi', 'maps': ['ck'], 'keys': [],
\},
\{'name': 'RivCreateGitLink' , 'act': 'call riv#create#git_commit_url()',
    \'note': 'Create github commit link',
    \'menu': 'Insert.Git\ Link',
    \'type': 'buf', 'mode': 'mi', 'maps': ['cg'], 'keys': [],
\},
\{'name': 'RivCreateFoot' , 'act': 'call riv#create#foot()',
    \'note': 'Create Footnote',
    \'menu': 'Insert.Footnote',
    \'type': 'buf', 'mode': 'mi', 'maps': ['cf'], 'keys': [],
\},
\{'name': 'RivCreateDate' , 'act': 'call riv#create#date()',
    \'note': 'Insert Current Date',
    \'menu': 'Insert.Date',
    \'type': 'buf', 'mode': 'mi', 'maps': ['cdd'], 'keys': [],
\},
\{'name': 'RivCreateTime' , 'act': 'call riv#create#date(1)',
    \'note': 'Insert Current time',
    \'menu': 'Insert.Time',
    \'type': 'buf', 'mode': 'mi', 'maps': ['cdt'], 'keys': [],
\},
\{'name': 'RivCreateContent' , 'act': 'call riv#section#content()',
    \'note': 'Insert Content Table',
    \'menu': 'Insert.Content\ Table',
    \'type': 'buf', 'mode': 'm', 'maps': ['cc'], 'keys': [],
\},
\{'name': 'RivCreateEmphasis' , 'act': 'call riv#create#wrap_inline("*",%M)',
    \'note': 'Emphasis',
    \'menu': 'Insert.Emphasis',
    \'type': 'mod', 'mode': 'ni', 'maps': ['ce'], 'keys': [],
\},
\{'name': 'RivCreateStrong' , 'act': 'call riv#create#wrap_inline("**",%M)',
    \'note': 'Strong',
    \'menu': 'Insert.Strong',
    \'type': 'mod', 'mode': 'ni', 'maps': ['cs'], 'keys': [],
\},
\{'name': 'RivCreateInterpreted' , 'act': 'call riv#create#wrap_inline("`",%M)',
    \'note': 'Interpreted',
    \'menu': 'Insert.Interpreted',
    \'type': 'mod', 'mode': 'ni', 'maps': ['ci'], 'keys': [],
\},
\{'name': 'RivCreateLiteralInline' , 'act': 'call riv#create#wrap_inline("``",%M)',
    \'note': 'LiteralInline',
    \'menu': 'Insert.LiteralInline',
    \'type': 'mod', 'mode': 'ni', 'maps': ['cl'], 'keys': [],
\},
\{'name': 'RivCreateLiteralBlock' , 'act': "call riv#create#literal_block()",
    \'note': 'LiteralBlock',
    \'menu': 'Insert.LiteralBlock',
    \'type': 'buf', 'mode': 'ni', 'maps': ['cb'], 'keys': [],
\},
\{'name': 'RivCreateHyperLink' , 'act': "call riv#create#hyperlink()",
    \'note': 'HyperLink',
    \'menu': 'Insert.HyperLink',
    \'type': 'buf', 'mode': 'ni', 'maps': ['ch'], 'keys': [],
\},
\{'name': 'RivCreateTransition' , 'act': "call riv#create#transition()",
    \'note': 'Transition',
    \'menu': 'Insert.Transition',
    \'type': 'buf', 'mode': 'ni', 'maps': ['cr'], 'keys': [],
\},
\{'name': 'RivCreateExplicitMark' , 'act': "call riv#create#exp_mark()",
    \'note': 'ExplicitMark',
    \'menu': 'Insert.ExplicitMark',
    \'type': 'buf', 'mode': 'ni', 'maps': ['cm'], 'keys': [],
\},
\{'name': 'RivDeleteFile' , 'act': 'call riv#create#delete()',
    \'note': 'Delete Current File',
    \'menu': 'Delete.Current\ File',
    \'type': 'buf', 'mode': 'm', 'maps': ['df'], 'keys': [],
\},
\{'menu': '---Miscs---' ,'type': 'menu' } ,
\{'name': 'Riv2HtmlFile' , 'act': 'call riv#publish#file2("html",0)',
    \'note': 'Convert to html',
    \'menu': 'Convert.Html.Convert',
    \'type': 'buf', 'mode': 'm', 'maps': ['2hf'], 'keys': [],
\},
\{'name': 'Riv2HtmlAndBrowse' , 'act': 'call riv#publish#file2("html",1)',
    \'note': 'Convert to html and browse current file',
    \'menu': 'Convert.Html.Convert\ And\ Browse',
    \'type': 'buf', 'mode': 'm', 'maps': ['2hh'], 'keys': [],
\},
\{'name': 'Riv2HtmlProject' , 'act': 'call riv#publish#proj2("html")',
    \'note': 'Convert project to html',
    \'menu': 'Convert.Html.Project',
    \'type': 'buf', 'mode': 'm', 'maps': ['2hp'], 'keys': [],
\},
\{'name': 'Riv2Odt' , 'act': 'call riv#publish#file2("odt",1)',
    \'note': 'Convert to odt',
    \'menu': 'Convert.Odt',
    \'type': 'buf', 'mode': 'm', 'maps': ['2oo'], 'keys': [],
\},
\{'name': 'Riv2S5' , 'act': 'call riv#publish#file2("s5",1)',
    \'note': 'Convert to S5',
    \'menu': 'Convert.S5',
    \'type': 'buf', 'mode': 'm', 'maps': ['2ss'], 'keys': [],
\},
\{'name': 'Riv2Pdf' , 'act': 'call riv#publish#file2("pdf",1)',
    \'note': 'Convert to PDF',
    \'menu': 'Convert.Pdf',
    \'type': 'buf', 'mode': 'm', 'maps': ['2pp'], 'keys': [],
\},
\{'name': 'Riv2Xml' , 'act': 'call riv#publish#file2("xml",1)',
    \'note': 'Convert to Xml',
    \'menu': 'Convert.Xml',
    \'type': 'buf', 'mode': 'm', 'maps': ['2xx'], 'keys': [],
\},
\{'name': 'Riv2Latex' , 'act': 'call riv#publish#file2("latex",1)',
    \'note': 'Convert to Latex',
    \'menu': 'Convert.Latex',
    \'type': 'buf', 'mode': 'm', 'maps': ['2ll'], 'keys': [],
\},
\{'name': 'Riv2BuildPath' , 'act': 'call riv#publish#open_path()',
    \'note': 'Show Build Path of the project',
    \'menu': 'Convert.Build\ Path',
    \'type': 'buf', 'mode': 'm', 'maps': ['2b'], 'keys': [],
\},
\{'name': 'RivReload' , 'act': 'call riv#test#reload()',
    \'note': 'Force reload Riv and Current Document',
    \'menu': 'Test.Force\ Reload',
    \'type': 'buf', 'mode': 'm', 'maps': ['t`'], 'keys': [],
\},
\{'name': 'RivTestFold0' , 'act': 'call riv#test#fold(0)',
    \'note': 'Test folding time',
    \'menu': 'Test.Fold\ Time',
    \'type': 'buf', 'mode': 'm', 'maps': ['t1'], 'keys': [],
\},
\{'name': 'RivTestFold1' , 'act': 'call riv#test#fold(1)',
    \'note': 'Test folding time and foldlevel',
    \'menu': 'Test.Fold\ Level',
    \'type': 'buf', 'mode': 'm', 'maps': ['t2'], 'keys': [],
\},
\{'name': 'RivTestTest' , 'act': 'call riv#test#test()',
    \'note': 'Test the test',
    \'menu': '',
    \'type': 'buf', 'mode': 'm', 'maps': ['t4'], 'keys': [],
\},
\{'name': 'RivTestObj' , 'act': 'call riv#test#show_obj()',
    \'note': 'Show Test object',
    \'menu': 'Test.Object',
    \'type': 'buf', 'mode': 'm', 'maps': ['t3'], 'keys': [],
\},
\{'name': 'RivSuperBackSpace', 'act': "riv#action#ins_backspace()",
    \'note': 'Super Backspace',
    \'type': 'ins', 'mode': 'i', 'maps': ['mq'], 'keys':['<BS>'],
\},
\{'name': 'RivSuperTab', 'act': 'riv#action#ins_tab()',
    \'note': 'Super Tab',
    \'type': 'expr', 'mode': 'i', 'maps': ['me'], 'keys':['<Tab>'],
\},
\{'name': 'RivSuperSTab', 'act': 'riv#action#ins_stab()',
    \'note': 'Super Shift Tab',
    \'type': 'expr', 'mode': 'i', 'maps': ['mw'], 'keys':['<S-Tab>'],
\},
\{'name': 'RivSuperEnter', 'act': 'call riv#action#ins_enter()',
    \'note': 'Super Enter',
    \'type': 'buf', 'mode': 'ni', 'maps': ['mm'], 'keys':['<Enter>', '<KEnter>'], 'keymode': 'i',
\},
\{'name': 'RivSuperCEnter', 'act': 'call riv#action#ins_c_enter()',
    \'note': 'Super Ctrl Enter',
    \'type': 'buf', 'mode': 'ni', 'maps': ['mj'], 'keys':['<C-Enter>', '<C-KEnter>'], 'keymode': 'i',
\},
\{'name': 'RivSuperSEnter', 'act': 'call riv#action#ins_s_enter()',
    \'note': 'Super Shift Enter',
    \'type': 'buf', 'mode': 'ni', 'maps': ['mk'], 'keys':['<S-Enter>', '<S-KEnter>'], 'keymode': 'i',
\},
\{'name': 'RivSuperMEnter', 'act': 'call riv#action#ins_m_enter()',
    \'note': 'Super Alt Enter',
    \'type': 'buf', 'mode': 'ni', 'maps': ['mh'], 'keys':['<C-S-Enter>', '<M-Enter>', '<C-S-KEnter>', '<M-KEnter>'], 'keymode': 'i',
\},
\{'name': 'RivHelpTodo' , 'act': 'call riv#todo#todo_helper()',
    \'note': 'Show Todo Helper',
    \'menu': 'Helper.Todo',
    \'type': 'global', 'mode': 'm', 'maps': ['ht', '<C-h><C-t>'] ,
    \'keys': [],
\},
\{'name': 'RivHelpFile' , 'act': 'call riv#file#helper()',
    \'note': 'Show File Helper',
    \'menu': 'Helper.File',
    \'type': 'global', 'mode': 'm', 'maps': ['hf', '<C-h><C-f>'] ,
    \'keys': [],
\},
\{'name': 'RivHelpSection' , 'act': 'call riv#file#section_helper()',
    \'note': 'Show Section Helper',
    \'menu': 'Helper.Section',
    \'type': 'buf', 'mode': 'm', 'maps': ['hs'], 'keys': [],
\},
\{'name': 'RivVimTest', 'act': 'call doctest#start(<f-args>)',
    \'type': 'farg', 'args': '-nargs=*',
    \'note': 'Run doctest for Vim Script',
    \'menu': 'Helper.VimTest',
\},
\{'name': 'RivIntro' , 'act': 'call riv#action#tutor("riv_intro","[Riv_Intro]")',
    \'note': 'Show Riv Intro',
    \'menu': 'About.Riv\ Intro',
    \'type': 'menu'
\},
\{'name': 'RivInstruction' , 'act': 'call riv#action#tutor("riv_instruction", "[Riv_Instruction]")',
    \'note': 'Show Riv Instrucion',
    \'menu': 'About.Riv\ Intruction',
    \'type': 'menu'
\},
\{'name': 'RivQuickStart' , 'act': 'call riv#action#tutor("riv_quickstart", "[Riv_QuickStart]")',
    \'note': 'Show Riv QuickStart',
    \'menu': 'About.Riv\ QuickStart',
    \'type': 'menu'
\},
\{'name': 'RivPrimer' , 'act': 'call riv#action#open("primer")',
    \'note': 'Show RST Primer',
    \'menu': 'About.RST\ Primer',
    \'type': 'menu'
\},
\{'name': 'RivCheatSheet' , 'act': 'call riv#action#open("cheatsheet")',
    \'note': 'Show RST CheatSheet',
    \'menu': 'About.RST\ CheatSheet',
    \'type': 'menu'
\},
\{'name': 'RivSpecification' , 'act': 'call riv#action#open("specification")',
    \'note': 'Show RST Specification',
    \'menu': 'About.RST\ Specification',
    \'type': 'menu'
\},
\{'name': 'RivDirectives' , 'act': 'call riv#action#open("directives")',
    \'note': 'Show RST Directives',
    \'menu': 'About.RST\ Directives',
    \'type': 'menu'
\},
\{'name': 'RivGetLatest',
  \'note': 'Show Get Latest Info',
  \'menu': 'About.Riv\ v'.escape(g:riv_default.version,'.'), 
  \'act': 'call riv#get_latest()', 
  \'type': 'menu'}
\]
"}}}1
fun! riv#cmd#init_cmds() "{{{
  " Load all cmds

  let leader = g:riv_global_leader
  for cmd in g:riv_default.cmds
    if cmd.type == 'global' 
      exe "com!" cmd.name cmd.act
      exe "nor <Plug>(".cmd.name.")" ":".cmd.name."<CR>"
      if has_key(cmd, 'maps')
        for map in cmd.maps
          exe "map <silent>" leader.map "<Plug>(".cmd.name.")"
        endfor
      endif
    elseif cmd.type == 'buf'
      exe "com!" cmd.name cmd.act
      exe "nor <Plug>(".cmd.name.") :".cmd.name."<CR>" 
    elseif cmd.type == 'mod'
      let act_n = substitute(cmd.act, '%M','"n"','')
      exe "com!" cmd.name act_n
      exe "nor <Plug>(".cmd.name.") :" cmd.name."<CR>"
    elseif cmd.type == 'norm'
      exe "com!" cmd.name cmd.act
      exe "nor <Plug>(".cmd.name.")" ":".cmd.name."<CR>" 
    elseif cmd.type == 'farg'
      exe "com!" cmd.args cmd.name  cmd.act
      exe "nor <Plug>(".cmd.name.") :" cmd.name."<CR>"
    elseif cmd.type == 'menu'
      if has_key(cmd, 'act')
        exe "com!" cmd.name cmd.act
        exe "nor <Plug>(".cmd.name.")" ":".cmd.name."<CR>" 
      endif
    endif

  endfor
endfun "}}}
fun! riv#cmd#init_maps() "{{{
  let leader = g:riv_global_leader
  for cmd in g:riv_default.cmds
    if cmd.type == 'buf'
      if has_key(cmd, 'maps') 
        if !has_key(cmd, 'keymode')
          for key in map(copy(cmd.maps), 'leader.v:val') + cmd.keys
            if cmd.mode =~ 'm'
              if index(g:riv_default.ignored_maps, key) == -1
                exe "map <silent><buffer>" key "<Plug>(".cmd.name.")"
              endif
            endif
            if cmd.mode =~ 'n'
              if index(g:riv_default.ignored_nmaps, key) == -1
                exe "nma <silent><buffer>" key "<Plug>(".cmd.name .")"
              endif
            endif
            if cmd.mode =~ 'i'
              if index(g:riv_default.ignored_imaps, key) == -1
                exe "ima <silent><buffer>" key "<C-O><Plug>(".cmd.name.")"
              endif
            endif
            if cmd.mode =~ 'v'
              " for the range function. only :call can be used.
              " NOTE: #29: use noremap to execute cmd.act
              if index(g:riv_default.ignored_vmaps, key) == -1
              exe "vno <silent><buffer>" key ":".cmd.act."<CR>" 
              endif
            endif
          endfor
        else
          " For the key and map have seperated Mode.
          for key in map(copy(cmd.maps), 'leader.v:val')
            if cmd.mode =~ 'm'
              if index(g:riv_default.ignored_maps, key) == -1
                exe "map <silent><buffer>" key "<Plug>(".cmd.name.")"
              endif
            endif
            if cmd.mode =~ 'n'
              if index(g:riv_default.ignored_nmaps, key) == -1
                exe "nma <silent><buffer>" key "<Plug>(".cmd.name .")"
              endif
            endif
            if cmd.mode =~ 'i'
              if index(g:riv_default.ignored_imaps, key) == -1
                exe "ima <silent><buffer>" key "<C-O><Plug>(".cmd.name.")"
              endif
            endif
            if cmd.mode =~ 'v'
              " for the range function. only :call can be used.
              if index(g:riv_default.ignored_vmaps, key) == -1
              exe "vno <silent><buffer>" key ":".cmd.act."<CR>" 
              endif
            endif
          endfor
          for key in cmd.keys
            if cmd.keymode =~ 'm'
              if index(g:riv_default.ignored_maps, key) == -1
                exe "map <silent><buffer>" key "<Plug>(".cmd.name.")"
              endif
            endif
            if cmd.keymode =~ 'n'
              if index(g:riv_default.ignored_nmaps, key) == -1
                exe "nma <silent><buffer>" key "<Plug>(".cmd.name .")"
              endif
            endif
            if cmd.keymode =~ 'i'
              exe "ino <silent><buffer>" key "<C-O>:".cmd.act."<CR>"
            endif
            if cmd.keymode =~ 'v'
              " for the range function. only :call can be used.
              if index(g:riv_default.ignored_vmaps, key) == -1
                exe "vno <silent><buffer>" key ":".cmd.act."<CR>" 
              endif
            endif
          endfor
        endif
      endif
    elseif cmd.type == 'ins'
      "XXX This is for those super inserting
      if has_key(cmd, 'maps')
        for key in map(copy(cmd.maps), 'leader.v:val') + cmd.keys
            if index(g:riv_default.ignored_imaps, key) == -1
              exe "ino <silent><buffer><expr>" key cmd.act 
            endif
        endfor
      endif
    elseif cmd.type == 'mod'

      let act_n = substitute(cmd.act, '%M','"n"','')
      let act_v = substitute(cmd.act, '%M','"v"','')
      let act_i = substitute(cmd.act, '%M','"i"','')
      if has_key(cmd, 'maps')
        for key in map(copy(cmd.maps), 'leader.v:val') + cmd.keys
          exe "nma <silent><buffer>" key "<Plug>(".cmd.name.")"
          exe "vno <silent><buffer>" key "<Esc>:".act_v."<CR>"
          exe "ino <silent><buffer>" key "<Esc>:".act_i."<CR>"
        endfor
      endif
    elseif cmd.type == 'expr'
      if has_key(cmd, 'maps')
        for key in map(copy(cmd.maps), 'leader.v:val') + cmd.keys
          if cmd.mode =~ 'i'
            if index(g:riv_default.ignored_imaps, key) == -1
              exe "ino <silent><buffer><expr>" key cmd.act 
            endif
          endif
          if cmd.mode =~ 'v'
            if index(g:riv_default.ignored_vmaps, key) == -1
              exe "vno <silent><buffer><expr>" key cmd.act 
            endif
          endif
          if cmd.mode =~ 'n'
            if index(g:riv_default.ignored_nmaps, key) == -1
              exe "vno <silent><buffer><expr>" key cmd.act 
            endif
          endif
        endfor
      endif
    elseif cmd.type == 'norm'
      if has_key(cmd, 'maps')
        for key in map(copy(cmd.maps), 'leader.v:val') + cmd.keys
          if cmd.mode =~ 'n'
            if index(g:riv_default.ignored_nmaps, key) == -1
              exe "nno <silent><buffer>" key cmd.act
            endif
          endif
          if cmd.mode =~ 'v' && has_key(cmd, 'vact')
            exe "vno <silent><buffer>" key cmd.vact
          else
            exe "vno <silent><buffer>" key cmd.act
          endif
        endfor
      endif
    endif
  endfor
endfun "}}}
fun! riv#cmd#init_menu() "{{{
  let leader = g:riv_global_leader
  for cmd in g:riv_default.cmds
    if !has_key(cmd, 'menu') || empty(cmd.menu)
      continue
    endif
    if has_key(cmd, 'act')
      if has_key(cmd, 'maps') && !empty(cmd.maps)
        let map = '<Tab>'.leader.cmd.maps[0] 
      else
        let map = ''
      endif
      exe "75 am Riv.". cmd.menu . map "<Plug>(".cmd.name.")"
    else
      exe "75 am Riv.". cmd.menu . ' :'
    endif
  endfor
endfun "}}}
fun! riv#cmd#gen_intro() "{{{
  " return lines of cmd intros for README
  let buf = []
  let leader = g:riv_global_leader
  call add(buf, '+ **Global**')
  call add(buf, '')
  for cmd in g:riv_default.cmds
    if !has_key(cmd, 'name') || !has_key(cmd, 'note')
      let m = substitute(cmd.menu,'-','','g')
      call add(buf, '+ **'.m.'**')
      call add(buf, '')
      continue
    endif
    call add(buf, '  - _`:'.cmd.name.'` '.': '. cmd.note)
    call add(buf, '')
    if has_key(cmd, 'mode')
      let mode = cmd.mode
      let modeline = '    **'
      if mode =~ 'm' || mode =~ 'n'
        let modeline .= 'Normal,'
      endif
      if mode =~ 'v'
        let modeline .= 'Visual,'
      endif
      if mode =~ 'i'
        let modeline .= 'Insert,'
      endif
      let keys = map(copy(cmd.maps), 'leader.v:val') + cmd.keys
      let keyline = '	'
      for k in keys
        let keyline .= k.','
      endfor
      call add(buf, substitute(modeline,',$','** ','').':'
            \.substitute(keyline,',$','',''))
      call add(buf, '')
    endif
  endfor
  return buf
    
endfun "}}}

fun! riv#cmd#init() "{{{
  " init commands and menus
  call riv#cmd#init_cmds()
  call riv#cmd#init_menu()
endfun "}}}

if expand('<sfile>:p') == expand('%:p') "{{{
    call riv#cmd#init()
    call riv#cmd#init_maps()
endif "}}}
let &cpo = s:cpo_save
unlet s:cpo_save
" vim:sw=2:
