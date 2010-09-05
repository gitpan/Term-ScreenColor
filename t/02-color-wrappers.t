#!/usr/bin/env perl

use strict;
use Test::More tests => 83;

require Term::ScreenColor;

my ($scr, @tests, @descriptions, @results, $i, $normal);

my %NORMALS = (
	"\e[m"     => 1,
	"\e[0m"    => 1,
	"\e[m\cO"  => 1,
	"\e[0m\cO" => 1,
);

# -------------- test instantiation ----------------

$ENV{TERM} = 'xterm';

open NULL, ">/dev/null";

# intercept STDOUT as this interferes with test output
{
	local *STDOUT = *NULL;
	$scr = new Term::ScreenColor();
	system "stty cooked echo"; # nicer output on terminal
}

# -------------- test Term::ScreenColor ----------

@tests = (
	"clear       ", "\e[0m",
	"reset       ", "\e[0m",
	"ansibold    ", "\e[1m",
	"italic      ", "\e[3m",
	"underscore  ", "\e[4m",
	"blink       ", "\e[5m",
	"inverse     ", "\e[7m",
	"concealed   ", "\e[8m",

	"noansibold  ", "\e[22m",
	"noitalic    ", "\e[23m",
	"nounderscore", "\e[24m",
	"noblink     ", "\e[25m",
	"noinverse   ", "\e[27m",
	"noconcealed ", "\e[28m",

	"black       ", "\e[30m",
	"red         ", "\e[31m",
	"green       ", "\e[32m",
	"yellow      ", "\e[33m",
	"blue        ", "\e[34m",
	"magenta     ", "\e[35m",
	"cyan        ", "\e[36m",
	"white       ", "\e[37m",

	"on_black    ", "\e[40m",
	"on_red      ", "\e[41m",
	"on_green    ", "\e[42m",
	"on_yellow   ", "\e[43m",
	"on_blue     ", "\e[44m",
	"on_magenta  ", "\e[45m",
	"on_cyan     ", "\e[46m",
	"on_white    ", "\e[47m",
);

$i = 1;
@descriptions = grep { $i++ % 2 } @tests;
$i = 0;
@results      = grep { $i++ % 2 } @tests;

ok($scr->colorizable(0), 'turn colorizable off');

ok($scr->bold2esc()      eq "\e[1m", 'fetch bold         (colorizable=no)');
ok($scr->underline2esc() eq "\e[4m", 'fetch underline    (colorizable=no)');
ok($scr->reverse2esc()   eq "\e[7m", 'fetch reverse      (colorizable=no)');
$normal = $scr->normal2esc();
ok($NORMALS{$normal}, 'fetch normal       (colorizable=no)');

foreach $i (0 .. $#descriptions) {
	ok($scr->color2esc($descriptions[$i]) eq "",
		"fetch $descriptions[$i] (colorizable=no)");
}

ok($scr->colorizable(1), 'turn colorizable on');

ok($scr->bold2esc()      eq "\e[1m", 'fetch bold         (colorizable=yes)');
ok($scr->underline2esc() eq "\e[4m", 'fetch underline    (colorizable=yes)');
ok($scr->reverse2esc()   eq "\e[7m", 'fetch reverse      (colorizable=yes)');
$normal = $scr->normal2esc();
ok($NORMALS{$normal}, 'fetch normal       (colorizable=yes)');

foreach $i (0 .. $#descriptions) {
	ok($scr->color2esc($descriptions[$i]) eq $results[$i],
		"fetch $descriptions[$i] (colorizable=yes)");
}

ok($scr->color2esc('')               eq "", 
	'fetch color combination for empty string');
ok($scr->color2esc('bold yellow')    eq "\e[1;33m", 
	'fetch color combination 1');
ok($scr->color2esc('yellow on red')  eq "\e[33;41m",
	'fetch color combination 2');
ok($scr->color2esc('33;41')          eq "\e[33;41m",
	'fetch color combination 3');
ok($scr->color2esc('green on cyan')  eq "\e[32;46m",
	'fetch color combination 4');
ok($scr->color2esc('cyan on black')  eq "\e[36;40m",
	'fetch color combination 5');
ok($scr->color2esc('on_red blink')   eq "\e[41;5m", 
	'fetch color combination 6');
ok($scr->colored('bold blue',       'mytext1') eq "\e[1;34mmytext1\e[0m",
	'apply color combination 1');
ok($scr->colored('yellow on red',   'mytext2') eq "\e[33;41mmytext2\e[0m",
	'apply color combination 2');
ok($scr->colored('33;41',           'mytext3') eq "\e[33;41mmytext3\e[0m",
	'apply color combination 3');
ok($scr->colored('green on yellow', 'mytext4') eq "\e[32;43mmytext4\e[0m",
	'apply color combination 4');
ok($scr->colored('cyan on black',   'mytext5') eq "\e[36;40mmytext5\e[0m",
	'apply color combination 5');
ok($scr->colored('magenta reverse', 'mytext6') eq "\e[35;7mmytext6\e[0m",
	'apply color combination 6');

# ---------------------- end ----------------------

