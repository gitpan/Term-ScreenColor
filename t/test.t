#!/usr/bin/env perl

use strict;
use Test::More tests => 19;

# -------------- test inclusion --------------------

BEGIN { use_ok('Term::ScreenColor'); }

require_ok('Term::ScreenColor');

# -------------- test instantiation ----------------

my ($scr, $stdout);

open NULL, ">/dev/null";

# intercept STDOUT as this interferes with test output
{
	local *STDOUT = *NULL;
	$scr = new Term::ScreenColor();
}

isa_ok($scr, "Term::ScreenColor" );

# -------------- test Term::Screen::Fixes ----------

ok($scr->raw()              , 'call raw()');
ok($scr->cooked()           , 'call cooked()');
ok($scr->rows()        > 0  , 'call rows()');
ok($scr->cols()        > 0  , 'call cols()');
ok($scr->timeout()    == 0.4, 'get timeout');
ok($scr->timeout(0.5) == 0.5, 'set timeout');
ok($scr->get_more_fn_keys() , 'parse termcap-specific function keys');

$scr->noecho();
$scr->stuff_input('a');
ok($scr->flush_input()      , 'call flush_input()');
$scr->stuff_input('b');
ok($scr->getch() eq 'b'     , 'get simple character with getch()');
$scr->stuff_input('[15~');
ok($scr->getch() eq 'k5'    , 'get function key with getch()');
$scr->echo();

# intercept STDOUT as this interferes with test output
{
	local *STDOUT = *NULL;
	ok($scr->underline()        , 'set underline mode');
	ok($scr->reset()            , 'reset underline mode');
}

# -------------- test Term::ScreenColor ----------

ok($scr->colorizable(1)     , 'call colorizable()');
ok($scr->color2esc('green')     eq "\e[32m",
	'fetch foreground color escape sequence');
ok($scr->color2esc('on_yellow') eq "\e[43m",
	'fetch background color escape sequence');
ok($scr->colored('green on_yellow', 'mytext') eq "\e[32;43mmytext\e[0m",
	'put color escapes around text');

# ---------------------- end ----------------------


