import re

import roman
# copy from docutils.parsers.rst.states 
# 

class Struct:

    """Stores data attributes for dotted-attribute access."""

    def __init__(self, **keywordargs):
        self.__dict__.update(keywordargs)


def _loweralpha_to_int(s, _zero=(ord('a')-1)):
    return ord(s) - _zero

def _upperalpha_to_int(s, _zero=(ord('A')-1)):
    return ord(s) - _zero

def _lowerroman_to_int(s):
    return roman.fromRoman(s.upper())

non_whitespace_before = r'(?<![ \n])'
non_whitespace_escape_before = r'(?<![ \n\x00])'
non_unescaped_whitespace_escape_before = r'(?<!(?<!\x00)[ \n\x00])'
non_whitespace_after = r'(?![ \n])'
simplename = r'(?:(?!_)\w)+(?:[-._+:](?:(?!_)\w)+)*'

grid_table_top_pat = re.compile(r'\+-[-+]+-\+ *$')
"""Matches the top (& bottom) of a full table)."""

simple_table_top_pat = re.compile('=+( +=+)+ *$')
"""Matches the top of a simple table."""

simple_table_border_pat = re.compile('=+[ =]*$')
enum = Struct()

enum.formatinfo = {
    'parens': Struct(prefix='(', suffix=')', start=1, end=-1),
    'rparen': Struct(prefix='', suffix=')', start=0, end=-1),
    'period': Struct(prefix='', suffix='.', start=0, end=-1)}
enum.formats = enum.formatinfo.keys()
enum.sequences = ['arabic', 'loweralpha', 'upperalpha',
                    'lowerroman', 'upperroman'] # ORDERED!
enum.sequencepats = {'arabic': '[0-9]+',
                        'loweralpha': '[a-z]',
                        'upperalpha': '[A-Z]',
                        'lowerroman': '[ivxlcdm]+',
                        'upperroman': '[IVXLCDM]+',}
enum.converters = {'arabic': int,
                    'loweralpha': _loweralpha_to_int,
                    'upperalpha': _upperalpha_to_int,
                    'lowerroman': _lowerroman_to_int,
                    'upperroman': roman.fromRoman}

pats = {}
"""Fragments of patterns used by transitions."""

pats['nonalphanum7bit'] = '[!-/:-@[-`{-~]'
pats['alpha'] = '[a-zA-Z]'
pats['alphanum'] = '[a-zA-Z0-9]'
pats['alphanumplus'] = '[a-zA-Z0-9_-]'
pats['enum'] = ('(%(arabic)s|%(loweralpha)s|%(upperalpha)s|%(lowerroman)s'
                '|%(upperroman)s|#)' % enum.sequencepats)
pats['optname'] = '%(alphanum)s%(alphanumplus)s*' % pats
# @@@ Loosen up the pattern?  Allow Unicode?
pats['optarg'] = '(%(alpha)s%(alphanumplus)s*|<[^<>]+>)' % pats
pats['shortopt'] = r'(-|\+)%(alphanum)s( ?%(optarg)s)?' % pats
pats['longopt'] = r'(--|/)%(optname)s([ =]%(optarg)s)?' % pats
pats['option'] = r'(%(shortopt)s|%(longopt)s)' % pats

for format in enum.formats:
    pats[format] = '(?P<%s>%s%s%s)' % (
            format, re.escape(enum.formatinfo[format].prefix),
            pats['enum'], re.escape(enum.formatinfo[format].suffix))
patterns = {
        'bullet': u'[-+*\u2022\u2023\u2043]( +|$)',
        'enumerator': r'(%(parens)s|%(rparen)s|%(period)s)( +|$)' % pats,
        'field_marker': r':(?![: ])([^:\\]|\\.)*(?<! ):( +|$)',
        'option_marker': r'%(option)s(, %(option)s)*(  +| ?$)' % pats,
        'doctest': r'>>>( +|$)',
        'line_block': r'\|( +|$)',
        'grid_table_top': grid_table_top_pat,
        'simple_table_top': simple_table_top_pat,
        'explicit_markup': r'\.\.( +|$)',
        'anonymous': r'__( +|$)',
        'line': r'(%(nonalphanum7bit)s)\1* *$' % pats,
        'text': r''}

initial_transitions = (
        'bullet',
        'enumerator',
        'field_marker',
        'option_marker',
        'doctest',
        'line_block',
        'grid_table_top',
        'simple_table_top',
        'explicit_markup',
        'anonymous',
        'line',
        'text')


riv_ptn = Struct()

riv_ptn.blank     = re.compile('^\s*$')
riv_ptn.nonblank  = re.compile('^(?=\S)')
riv_ptn.lists     = re.compile(r"""
                     ^[ \t]*
                    ([-+*]
                     |(?:\d+|[#a-z]|[imcxv]+)[.)]
                     |[(](?:\d+|[#a-z]|[imcxv]+)[)]
                     )""", re.I | re.X)
riv_ptn.exp_m     = re.compile('^\.\.( +|$)')
riv_ptn.s_bgn     = re.compile('^( |$)')
riv_ptn.S_bgn     = re.compile('^\S')
riv_ptn.section   = re.compile(patterns['line'])
riv_ptn.indent    = re.compile(r'^ *(?P<tab>\t*) *')
riv_ptn.table_all = re.compile(r"""
                            ^\s*
                                (?P<con>\|.*\|
                            |
                                \+[-=+]+\+.*\|
                            |
                                \|.*\+[-=+]+\+)
                            \s*$
                            |^\s*
                                (?P<sep>\+[-=+]+\+)
                            \s*$""", re.U | re.X)
riv_ptn.table_sepr = re.compile(r'^\s*(?:\+-+)+\+\s*$')
riv_ptn.table_head = re.compile(r'^\s*(?:\+=+)+\+\s*$')
riv_ptn.table_con = re.compile(r'^\s*\|.*\|\s*$')
riv_ptn.table_cel = re.compile(r'(?<=\|)([^|]+)(?=\|)')

if __name__ == "__main__":
    print riv_ptn.indent.match("  	  ").groupdict()['tab']
    print riv_ptn.nonblank.match("1")
