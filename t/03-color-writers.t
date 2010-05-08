#!/usr/bin/env perl

use strict;

# ------------------- setup pipe -------------------

my ($childpid);

$childpid = open(HANDLE, "-|");

die "cannot fork(): $!" unless (defined $childpid);

if ($childpid) {
	# parent
	test_output();
} else {
	# child
	produce_output();
}

# ---------- child process: perform tests ---------

sub produce_output {
	require Term::ScreenColor;
	my $scr;
	$ENV{TERM} = 'xterm';

	$scr = new Term::ScreenColor();
	$scr->cooked()->puts("\n"); # put newline after at(0,0)
	$scr->flash() ->puts("\n");

	# add newlines after every escape because we will use the <FH>
	# operator to read lines from the pipe
	for my $colorizable (0..1) {
		$scr->colorizable($colorizable);

		$scr->normal()		->puts("\n");
		$scr->bold()		->puts("\n");
		$scr->underline()	->puts("\n");
		$scr->reverse()		->puts("\n");

		$scr->clear()		->puts("\n");
		$scr->reset()		->puts("\n");
		$scr->ansibold()	->puts("\n");
		$scr->italic()		->puts("\n");
		$scr->underscore()	->puts("\n");
		$scr->blink()		->puts("\n");
		$scr->inverse()		->puts("\n");
		$scr->concealed()	->puts("\n");

		$scr->noansibold()	->puts("\n");
		$scr->noitalic()	->puts("\n");
		$scr->nounderscore()	->puts("\n");
		$scr->noblink()		->puts("\n");
		$scr->noinverse()	->puts("\n");
		$scr->noconcealed()	->puts("\n");

		$scr->black()		->puts("\n");
		$scr->red()		->puts("\n");
		$scr->green()		->puts("\n");
		$scr->yellow()		->puts("\n");
		$scr->blue()		->puts("\n");
		$scr->magenta()		->puts("\n");
		$scr->cyan()		->puts("\n");
		$scr->white()		->puts("\n");

		$scr->on_black()	->puts("\n");
		$scr->on_red()		->puts("\n");
		$scr->on_green()	->puts("\n");
		$scr->on_yellow()	->puts("\n");
		$scr->on_blue()		->puts("\n");
		$scr->on_magenta()	->puts("\n");
		$scr->on_cyan()		->puts("\n");
		$scr->on_white()	->puts("\n");
	}
	$scr->cooked()->normal();
}

# ---------- parent process: verify result ---------

sub test_output {
	use Test::More tests => 70;
	my ($i, @tests, @descriptions, @results);

	@tests = (
		"at(0,0)",                         "\e[1;1H",
		"flash()",                         "\e[?5h\e[?5l",

		"normal()       (colorizable=no)", "\e[0m",
		"bold()         (colorizable=no)", "\e[1m",
		"underline()    (colorizable=no)", "\e[4m",
		"reverse()      (colorizable=no)", "\e[7m",

		"clear()        (colorizable=no)", "",
		"reset()        (colorizable=no)", "",
		"ansibold()     (colorizable=no)", "",
		"italic()       (colorizable=no)", "",
		"underscore()   (colorizable=no)", "",
		"blink()        (colorizable=no)", "",
		"inverse()      (colorizable=no)", "",
		"concealed()    (colorizable=no)", "",

		"noansibold()   (colorizable=no)", "",
		"noitalic()     (colorizable=no)", "",
		"nounderscore() (colorizable=no)", "",
		"noblink()      (colorizable=no)", "",
		"noinverse()    (colorizable=no)", "",
		"noconcealed()  (colorizable=no)", "",

		"black()        (colorizable=no)", "",
		"red()          (colorizable=no)", "",
		"green()        (colorizable=no)", "",
		"yellow()       (colorizable=no)", "",
		"blue()         (colorizable=no)", "",
		"magenta()      (colorizable=no)", "",
		"cyan()         (colorizable=no)", "",
		"white()        (colorizable=no)", "",

		"on_black()     (colorizable=no)", "",
		"on_red()       (colorizable=no)", "",
		"on_green()     (colorizable=no)", "",
		"on_yellow()    (colorizable=no)", "",
		"on_blue()      (colorizable=no)", "",
		"on_magenta()   (colorizable=no)", "",
		"on_cyan()      (colorizable=no)", "",
		"on_white()     (colorizable=no)", "",

		"normal()       (colorizable=yes)", "\e[0m",
		"bold()         (colorizable=yes)", "\e[1m",
		"underline()    (colorizable=yes)", "\e[4m",
		"reverse()      (colorizable=yes)", "\e[7m",

		"clear()        (colorizable=yes)", "\e[0m",
		"reset()        (colorizable=yes)", "\e[0m",
		"ansibold()     (colorizable=yes)", "\e[1m",
		"italic()       (colorizable=yes)", "\e[3m",
		"underscore()   (colorizable=yes)", "\e[4m",
		"blink()        (colorizable=yes)", "\e[5m",
		"inverse()      (colorizable=yes)", "\e[7m",
		"concealed()    (colorizable=yes)", "\e[8m",

		"noansibold()   (colorizable=yes)", "\e[22m",
		"noitalic()     (colorizable=yes)", "\e[23m",
		"nounderscore() (colorizable=yes)", "\e[24m",
		"noblink()      (colorizable=yes)", "\e[25m",
		"noinverse()    (colorizable=yes)", "\e[27m",
		"noconcealed()  (colorizable=yes)", "\e[28m",

		"black()        (colorizable=yes)", "\e[30m",
		"red()          (colorizable=yes)", "\e[31m",
		"green()        (colorizable=yes)", "\e[32m",
		"yellow()       (colorizable=yes)", "\e[33m",
		"blue()         (colorizable=yes)", "\e[34m",
		"magenta()      (colorizable=yes)", "\e[35m",
		"cyan()         (colorizable=yes)", "\e[36m",
		"white()        (colorizable=yes)", "\e[37m",

		"on_black()     (colorizable=yes)", "\e[40m",
		"on_red()       (colorizable=yes)", "\e[41m",
		"on_green()     (colorizable=yes)", "\e[42m",
		"on_yellow()    (colorizable=yes)", "\e[43m",
		"on_blue()      (colorizable=yes)", "\e[44m",
		"on_magenta()   (colorizable=yes)", "\e[45m",
		"on_cyan()      (colorizable=yes)", "\e[46m",
		"on_white()     (colorizable=yes)", "\e[47m",
	);
	$i = 1;
	@descriptions = grep { $i++ % 2 } @tests;
	$i = 0;
	@results      = grep { $i++ % 2 } @tests;

	foreach my $i (0 .. $#descriptions) {
		ok(<HANDLE> eq "$results[$i]\n", $descriptions[$i]);
	}
}

# ---------------------- end ----------------------


