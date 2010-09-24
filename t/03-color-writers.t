#!/usr/bin/env perl
#
##########################################################################
#
# Name:         03-color-writers.t
# Version:      1.18
# Author:       Rene Uittenbogaard
# Date:         2010-09-25
# Requires:     Term::ScreenColor
# Description:  Tests for color printing methods in Term::ScreenColor
#

##########################################################################
# declarations

use strict;

my $teststring = 'zwerk';

my %NORMALS = (
	"\e[m\n"      => 1,
	"\e[0m\n"     => 1,
	"\e[m\cO\n"   => 1,
	"\e[0m\cO\n"  => 1,
	"\e(B\e[m\n"  => 1,
	"\e(B\e[0m\n" => 1,
);

##########################################################################
# main: setup pipe

sub main {
	my $childpid = open(HANDLE, "-|");
	die "cannot fork(): $!" unless defined $childpid;
	if ($childpid) {
		# parent
		test_output();
	} else {
		# child
		produce_output();
	}
}

##########################################################################
# child process: perform tests

sub produce_output {
	require Term::ScreenColor;
	my $scr;
	$ENV{TERM} = 'xterm';

	$scr = new Term::ScreenColor();
	$scr->cooked()->puts("\n"); # put newline after at(0,0)
#	$scr->flash() ->puts("\n"); # not available on all systems

	# add newlines after every escape because we will use the <FH>
	# operator to read lines from the pipe
	for my $colorizable (0 .. 1) {
		$scr->colorizable($colorizable);

		$scr->bold()		->puts("\n");
		$scr->underline()	->puts("\n");
		$scr->reverse()		->puts("\n");
		$scr->flash()		->puts("\n");

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

		$scr->putcolor('bold'		)->puts("\n");
		$scr->putcolor('underline'	)->puts("\n");
		$scr->putcolor('reverse'	)->puts("\n");

		$scr->putcolor('reset'		)->puts("\n");
		$scr->putcolor('ansibold'	)->puts("\n");
		$scr->putcolor('italic'		)->puts("\n");
		$scr->putcolor('underscore'	)->puts("\n");
		$scr->putcolor('blink'		)->puts("\n");
		$scr->putcolor('inverse'	)->puts("\n");
		$scr->putcolor('concealed'	)->puts("\n");

		$scr->putcolor('noansibold'	)->puts("\n");
		$scr->putcolor('noitalic'	)->puts("\n");
		$scr->putcolor('nounderscore'	)->puts("\n");
		$scr->putcolor('noblink'	)->puts("\n");
		$scr->putcolor('noinverse'	)->puts("\n");
		$scr->putcolor('noconcealed'	)->puts("\n");

		$scr->putcolored('bold',	$teststring)->puts("\n");
		$scr->putcolored('underline',	$teststring)->puts("\n");
		$scr->putcolored('reverse',	$teststring)->puts("\n");

		$scr->putcolored('reset',	$teststring)->puts("\n");
		$scr->putcolored('ansibold',	$teststring)->puts("\n");
		$scr->putcolored('italic',	$teststring)->puts("\n");
		$scr->putcolored('underscore',	$teststring)->puts("\n");
		$scr->putcolored('blink',	$teststring)->puts("\n");
		$scr->putcolored('inverse',	$teststring)->puts("\n");
		$scr->putcolored('concealed',	$teststring)->puts("\n");

		$scr->putcolored('noansibold',	$teststring)->puts("\n");
		$scr->putcolored('noitalic',	$teststring)->puts("\n");
		$scr->putcolored('nounderscore',$teststring)->puts("\n");
		$scr->putcolored('noblink',	$teststring)->puts("\n");
		$scr->putcolored('noinverse',	$teststring)->puts("\n");
		$scr->putcolored('noconcealed',	$teststring)->puts("\n");

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

		$scr->putcolor('black'		)->puts("\n");
		$scr->putcolor('red'		)->puts("\n");
		$scr->putcolor('green'		)->puts("\n");
		$scr->putcolor('yellow'		)->puts("\n");
		$scr->putcolor('blue'		)->puts("\n");
		$scr->putcolor('magenta'	)->puts("\n");
		$scr->putcolor('cyan'		)->puts("\n");
		$scr->putcolor('white'		)->puts("\n");

		$scr->putcolor('on_black'	)->puts("\n");
		$scr->putcolor('on_red'		)->puts("\n");
		$scr->putcolor('on_green'	)->puts("\n");
		$scr->putcolor('on_yellow'	)->puts("\n");
		$scr->putcolor('on_blue'	)->puts("\n");
		$scr->putcolor('on_magenta'	)->puts("\n");
		$scr->putcolor('on_cyan'	)->puts("\n");
		$scr->putcolor('on_white'	)->puts("\n");

		$scr->putcolored('black',	$teststring)->puts("\n");
		$scr->putcolored('red',		$teststring)->puts("\n");
		$scr->putcolored('green',	$teststring)->puts("\n");
		$scr->putcolored('yellow',	$teststring)->puts("\n");
		$scr->putcolored('blue',	$teststring)->puts("\n");
		$scr->putcolored('magenta',	$teststring)->puts("\n");
		$scr->putcolored('cyan',	$teststring)->puts("\n");
		$scr->putcolored('white',	$teststring)->puts("\n");

		$scr->putcolored('on_black',	$teststring)->puts("\n");
		$scr->putcolored('on_red',	$teststring)->puts("\n");
		$scr->putcolored('on_green',	$teststring)->puts("\n");
		$scr->putcolored('on_yellow',	$teststring)->puts("\n");
		$scr->putcolored('on_blue',	$teststring)->puts("\n");
		$scr->putcolored('on_magenta',	$teststring)->puts("\n");
		$scr->putcolored('on_cyan',	$teststring)->puts("\n");
		$scr->putcolored('on_white',	$teststring)->puts("\n");

		$scr->putcolor('33;41'		)->puts("\n");
		$scr->putcolor('bold blue'	)->puts("\n");
		$scr->putcolor('bold yellow'	)->puts("\n");
		$scr->putcolor('cyan on black'	)->puts("\n");
		$scr->putcolor('green on cyan'	)->puts("\n");
		$scr->putcolor('green on yellow')->puts("\n");
		$scr->putcolor('magenta reverse')->puts("\n");
		$scr->putcolor('on_red blink'	)->puts("\n");
		$scr->putcolor('yellow on red'	)->puts("\n");

		$scr->putcolored('33;41',		$teststring)->puts("\n");
		$scr->putcolored('bold blue',		$teststring)->puts("\n");
		$scr->putcolored('bold yellow',		$teststring)->puts("\n");
		$scr->putcolored('cyan on black',	$teststring)->puts("\n");
		$scr->putcolored('green on cyan',	$teststring)->puts("\n");
		$scr->putcolored('green on yellow',	$teststring)->puts("\n");
		$scr->putcolored('magenta reverse',	$teststring)->puts("\n");
		$scr->putcolored('on_red blink',	$teststring)->puts("\n");
		$scr->putcolored('yellow on red',	$teststring)->puts("\n");
	}
	# require special treatment
	$scr->colorizable(0);
	$scr->normal()->puts("\n");
	$scr->colorizable(1);
	$scr->normal()->puts("\n");

	$scr->cooked()->normal();
}

##########################################################################
# parent process: verify result

sub test_output {
	use Test::More tests => 235;
	my ($i, @tests, @descriptions, @results, $normal);

	@tests = (
		"at(0,0)",                                   "\e[1;1H",

		"bold()                     (colorizable=no)", "\e[1m",
		"underline()                (colorizable=no)", "\e[4m",
		"reverse()                  (colorizable=no)", "\e[7m",
		"flash()                    (colorizable=no)", "\e[?5h\e[?5l",

		"clear()                    (colorizable=no)", "",
		"reset()                    (colorizable=no)", "",
		"ansibold()                 (colorizable=no)", "",
		"italic()                   (colorizable=no)", "",
		"underscore()               (colorizable=no)", "",
		"blink()                    (colorizable=no)", "",
		"inverse()                  (colorizable=no)", "",
		"concealed()                (colorizable=no)", "",

		"noansibold()               (colorizable=no)", "",
		"noitalic()                 (colorizable=no)", "",
		"nounderscore()             (colorizable=no)", "",
		"noblink()                  (colorizable=no)", "",
		"noinverse()                (colorizable=no)", "",
		"noconcealed()              (colorizable=no)", "",

		"putcolor(bold)             (colorizable=no)", "",
		"putcolor(underline)        (colorizable=no)", "",
		"putcolor(reverse)          (colorizable=no)", "",

		"putcolor(reset)            (colorizable=no)", "",
		"putcolor(ansibold)         (colorizable=no)", "",
		"putcolor(italic)           (colorizable=no)", "",
		"putcolor(underscore)       (colorizable=no)", "",
		"putcolor(blink)            (colorizable=no)", "",
		"putcolor(inverse)          (colorizable=no)", "",
		"putcolor(concealed)        (colorizable=no)", "",

		"putcolor(noansibold)       (colorizable=no)", "",
		"putcolor(noitalic)         (colorizable=no)", "",
		"putcolor(nounderscore)     (colorizable=no)", "",
		"putcolor(noblink)          (colorizable=no)", "",
		"putcolor(noinverse)        (colorizable=no)", "",
		"putcolor(noconcealed)      (colorizable=no)", "",

		"putcolored(bold)           (colorizable=no)", $teststring,
		"putcolored(underline)      (colorizable=no)", $teststring,
		"putcolored(reverse)        (colorizable=no)", $teststring,

		"putcolored(reset)          (colorizable=no)", $teststring,
		"putcolored(ansibold)       (colorizable=no)", $teststring,
		"putcolored(italic)         (colorizable=no)", $teststring,
		"putcolored(underscore)     (colorizable=no)", $teststring,
		"putcolored(blink)          (colorizable=no)", $teststring,
		"putcolored(inverse)        (colorizable=no)", $teststring,
		"putcolored(concealed)      (colorizable=no)", $teststring,

		"putcolored(noansibold)     (colorizable=no)", $teststring,
		"putcolored(noitalic)       (colorizable=no)", $teststring,
		"putcolored(nounderscore)   (colorizable=no)", $teststring,
		"putcolored(noblink)        (colorizable=no)", $teststring,
		"putcolored(noinverse)      (colorizable=no)", $teststring,
		"putcolored(noconcealed)    (colorizable=no)", $teststring,

		"black()                    (colorizable=no)", "",
		"red()                      (colorizable=no)", "",
		"green()                    (colorizable=no)", "",
		"yellow()                   (colorizable=no)", "",
		"blue()                     (colorizable=no)", "",
		"magenta()                  (colorizable=no)", "",
		"cyan()                     (colorizable=no)", "",
		"white()                    (colorizable=no)", "",

		"on_black()                 (colorizable=no)", "",
		"on_red()                   (colorizable=no)", "",
		"on_green()                 (colorizable=no)", "",
		"on_yellow()                (colorizable=no)", "",
		"on_blue()                  (colorizable=no)", "",
		"on_magenta()               (colorizable=no)", "",
		"on_cyan()                  (colorizable=no)", "",
		"on_white()                 (colorizable=no)", "",

		"putcolor(black)            (colorizable=no)", "",
		"putcolor(red)              (colorizable=no)", "",
		"putcolor(green)            (colorizable=no)", "",
		"putcolor(yellow)           (colorizable=no)", "",
		"putcolor(blue)             (colorizable=no)", "",
		"putcolor(magenta)          (colorizable=no)", "",
		"putcolor(cyan)             (colorizable=no)", "",
		"putcolor(white)            (colorizable=no)", "",

		"putcolor(on_black)         (colorizable=no)", "",
		"putcolor(on_red)           (colorizable=no)", "",
		"putcolor(on_green)         (colorizable=no)", "",
		"putcolor(on_yellow)        (colorizable=no)", "",
		"putcolor(on_blue)          (colorizable=no)", "",
		"putcolor(on_magenta)       (colorizable=no)", "",
		"putcolor(on_cyan)          (colorizable=no)", "",
		"putcolor(on_white)         (colorizable=no)", "",

		"putcolored(black)          (colorizable=no)", $teststring,
		"putcolored(red)            (colorizable=no)", $teststring,
		"putcolored(green)          (colorizable=no)", $teststring,
		"putcolored(yellow)         (colorizable=no)", $teststring,
		"putcolored(blue)           (colorizable=no)", $teststring,
		"putcolored(magenta)        (colorizable=no)", $teststring,
		"putcolored(cyan)           (colorizable=no)", $teststring,
		"putcolored(white)          (colorizable=no)", $teststring,

		"putcolored(on_black)       (colorizable=no)", $teststring,
		"putcolored(on_red)         (colorizable=no)", $teststring,
		"putcolored(on_green)       (colorizable=no)", $teststring,
		"putcolored(on_yellow)      (colorizable=no)", $teststring,
		"putcolored(on_blue)        (colorizable=no)", $teststring,
		"putcolored(on_magenta)     (colorizable=no)", $teststring,
		"putcolored(on_cyan)        (colorizable=no)", $teststring,
		"putcolored(on_white)       (colorizable=no)", $teststring,

		"putcolor(33;41)            (colorizable=yes)", "",
		"putcolor(bold blue)        (colorizable=yes)", "",
		"putcolor(bold yellow)      (colorizable=yes)", "",
		"putcolor(cyan on black)    (colorizable=yes)", "",
		"putcolor(green on cyan)    (colorizable=yes)", "",
		"putcolor(green on yellow)  (colorizable=yes)", "",
		"putcolor(magenta reverse)  (colorizable=yes)", "",
		"putcolor(on_red blink)     (colorizable=yes)", "",
		"putcolor(yellow on red)    (colorizable=yes)", "",

		"putcolored(33;41)          (colorizable=yes)", $teststring,
		"putcolored(bold blue)      (colorizable=yes)", $teststring,
		"putcolored(bold yellow)    (colorizable=yes)", $teststring,
		"putcolored(cyan on black)  (colorizable=yes)", $teststring,
		"putcolored(green on cyan)  (colorizable=yes)", $teststring,
		"putcolored(green on yellow)(colorizable=yes)", $teststring,
		"putcolored(magenta reverse)(colorizable=yes)", $teststring,
		"putcolored(on_red blink)   (colorizable=yes)", $teststring,
		"putcolored(yellow on red)  (colorizable=yes)", $teststring,

		"bold()                     (colorizable=yes)", "\e[1m",
		"underline()                (colorizable=yes)", "\e[4m",
		"reverse()                  (colorizable=yes)", "\e[7m",
		"flash()                    (colorizable=yes)", "\e[?5h\e[?5l",

		"clear()                    (colorizable=yes)", "\e[0m",
		"reset()                    (colorizable=yes)", "\e[0m",
		"ansibold()                 (colorizable=yes)", "\e[1m",
		"italic()                   (colorizable=yes)", "\e[3m",
		"underscore()               (colorizable=yes)", "\e[4m",
		"blink()                    (colorizable=yes)", "\e[5m",
		"inverse()                  (colorizable=yes)", "\e[7m",
		"concealed()                (colorizable=yes)", "\e[8m",

		"noansibold()               (colorizable=yes)", "\e[22m",
		"noitalic()                 (colorizable=yes)", "\e[23m",
		"nounderscore()             (colorizable=yes)", "\e[24m",
		"noblink()                  (colorizable=yes)", "\e[25m",
		"noinverse()                (colorizable=yes)", "\e[27m",
		"noconcealed()              (colorizable=yes)", "\e[28m",

		"putcolor(bold)             (colorizable=yes)", "\e[1m",
		"putcolor(underline)        (colorizable=yes)", "\e[4m",
		"putcolor(reverse)          (colorizable=yes)", "\e[7m",

		"putcolor(reset)            (colorizable=yes)", "\e[0m",
		"putcolor(ansibold)         (colorizable=yes)", "\e[1m",
		"putcolor(italic)           (colorizable=yes)", "\e[3m",
		"putcolor(underscore)       (colorizable=yes)", "\e[4m",
		"putcolor(blink)            (colorizable=yes)", "\e[5m",
		"putcolor(inverse)          (colorizable=yes)", "\e[7m",
		"putcolor(concealed)        (colorizable=yes)", "\e[8m",

		"putcolor(noansibold)       (colorizable=yes)", "\e[22m",
		"putcolor(noitalic)         (colorizable=yes)", "\e[23m",
		"putcolor(nounderscore)     (colorizable=yes)", "\e[24m",
		"putcolor(noblink)          (colorizable=yes)", "\e[25m",
		"putcolor(noinverse)        (colorizable=yes)", "\e[27m",
		"putcolor(noconcealed)      (colorizable=yes)", "\e[28m",

		"putcolored(bold)           (colorizable=yes)", "\e[1m$teststring\e[0m",
		"putcolored(underline)      (colorizable=yes)", "\e[4m$teststring\e[0m",
		"putcolored(reverse)        (colorizable=yes)", "\e[7m$teststring\e[0m",

		"putcolored(reset)          (colorizable=yes)", "\e[0m$teststring\e[0m",
		"putcolored(ansibold)       (colorizable=yes)", "\e[1m$teststring\e[0m",
		"putcolored(italic)         (colorizable=yes)", "\e[3m$teststring\e[0m",
		"putcolored(underscore)     (colorizable=yes)", "\e[4m$teststring\e[0m",
		"putcolored(blink)          (colorizable=yes)", "\e[5m$teststring\e[0m",
		"putcolored(inverse)        (colorizable=yes)", "\e[7m$teststring\e[0m",
		"putcolored(concealed)      (colorizable=yes)", "\e[8m$teststring\e[0m",

		"putcolored(noansibold)     (colorizable=yes)", "\e[22m$teststring\e[0m",
		"putcolored(noitalic)       (colorizable=yes)", "\e[23m$teststring\e[0m",
		"putcolored(nounderscore)   (colorizable=yes)", "\e[24m$teststring\e[0m",
		"putcolored(noblink)        (colorizable=yes)", "\e[25m$teststring\e[0m",
		"putcolored(noinverse)      (colorizable=yes)", "\e[27m$teststring\e[0m",
		"putcolored(noconcealed)    (colorizable=yes)", "\e[28m$teststring\e[0m",

		"black()                    (colorizable=yes)", "\e[30m",
		"red()                      (colorizable=yes)", "\e[31m",
		"green()                    (colorizable=yes)", "\e[32m",
		"yellow()                   (colorizable=yes)", "\e[33m",
		"blue()                     (colorizable=yes)", "\e[34m",
		"magenta()                  (colorizable=yes)", "\e[35m",
		"cyan()                     (colorizable=yes)", "\e[36m",
		"white()                    (colorizable=yes)", "\e[37m",

		"on_black()                 (colorizable=yes)", "\e[40m",
		"on_red()                   (colorizable=yes)", "\e[41m",
		"on_green()                 (colorizable=yes)", "\e[42m",
		"on_yellow()                (colorizable=yes)", "\e[43m",
		"on_blue()                  (colorizable=yes)", "\e[44m",
		"on_magenta()               (colorizable=yes)", "\e[45m",
		"on_cyan()                  (colorizable=yes)", "\e[46m",
		"on_white()                 (colorizable=yes)", "\e[47m",

		"putcolor(black)            (colorizable=yes)", "\e[30m",
		"putcolor(red)              (colorizable=yes)", "\e[31m",
		"putcolor(green)            (colorizable=yes)", "\e[32m",
		"putcolor(yellow)           (colorizable=yes)", "\e[33m",
		"putcolor(blue)             (colorizable=yes)", "\e[34m",
		"putcolor(magenta)          (colorizable=yes)", "\e[35m",
		"putcolor(cyan)             (colorizable=yes)", "\e[36m",
		"putcolor(white)            (colorizable=yes)", "\e[37m",

		"putcolor(on_black)         (colorizable=yes)", "\e[40m",
		"putcolor(on_red)           (colorizable=yes)", "\e[41m",
		"putcolor(on_green)         (colorizable=yes)", "\e[42m",
		"putcolor(on_yellow)        (colorizable=yes)", "\e[43m",
		"putcolor(on_blue)          (colorizable=yes)", "\e[44m",
		"putcolor(on_magenta)       (colorizable=yes)", "\e[45m",
		"putcolor(on_cyan)          (colorizable=yes)", "\e[46m",
		"putcolor(on_white)         (colorizable=yes)", "\e[47m",

		"putcolored(black)          (colorizable=yes)", "\e[30m$teststring\e[0m",
		"putcolored(red)            (colorizable=yes)", "\e[31m$teststring\e[0m",
		"putcolored(green)          (colorizable=yes)", "\e[32m$teststring\e[0m",
		"putcolored(yellow)         (colorizable=yes)", "\e[33m$teststring\e[0m",
		"putcolored(blue)           (colorizable=yes)", "\e[34m$teststring\e[0m",
		"putcolored(magenta)        (colorizable=yes)", "\e[35m$teststring\e[0m",
		"putcolored(cyan)           (colorizable=yes)", "\e[36m$teststring\e[0m",
		"putcolored(white)          (colorizable=yes)", "\e[37m$teststring\e[0m",

		"putcolored(on_black)       (colorizable=yes)", "\e[40m$teststring\e[0m",
		"putcolored(on_red)         (colorizable=yes)", "\e[41m$teststring\e[0m",
		"putcolored(on_green)       (colorizable=yes)", "\e[42m$teststring\e[0m",
		"putcolored(on_yellow)      (colorizable=yes)", "\e[43m$teststring\e[0m",
		"putcolored(on_blue)        (colorizable=yes)", "\e[44m$teststring\e[0m",
		"putcolored(on_magenta)     (colorizable=yes)", "\e[45m$teststring\e[0m",
		"putcolored(on_cyan)        (colorizable=yes)", "\e[46m$teststring\e[0m",
		"putcolored(on_white)       (colorizable=yes)", "\e[47m$teststring\e[0m",

		"putcolor(33;41)            (colorizable=yes)", "\e[33;41m",
		"putcolor(bold blue)        (colorizable=yes)", "\e[1;34m",
		"putcolor(bold yellow)      (colorizable=yes)", "\e[1;33m",
		"putcolor(cyan on black)    (colorizable=yes)", "\e[36;40m",
		"putcolor(green on cyan)    (colorizable=yes)", "\e[32;46m",
		"putcolor(green on yellow)  (colorizable=yes)", "\e[32;43m",
		"putcolor(magenta reverse)  (colorizable=yes)", "\e[35;7m",
		"putcolor(on_red blink)     (colorizable=yes)", "\e[41;5m",
		"putcolor(yellow on red)    (colorizable=yes)", "\e[33;41m",

		"putcolored(33;41)          (colorizable=yes)", "\e[33;41m$teststring\e[0m",
		"putcolored(bold blue)      (colorizable=yes)", "\e[1;34m$teststring\e[0m",
		"putcolored(bold yellow)    (colorizable=yes)", "\e[1;33m$teststring\e[0m",
		"putcolored(cyan on black)  (colorizable=yes)", "\e[36;40m$teststring\e[0m",
		"putcolored(green on cyan)  (colorizable=yes)", "\e[32;46m$teststring\e[0m",
		"putcolored(green on yellow)(colorizable=yes)", "\e[32;43m$teststring\e[0m",
		"putcolored(magenta reverse)(colorizable=yes)", "\e[35;7m$teststring\e[0m",
		"putcolored(on_red blink)   (colorizable=yes)", "\e[41;5m$teststring\e[0m",
		"putcolored(yellow on red)  (colorizable=yes)", "\e[33;41m$teststring\e[0m",
	);

	$i = 1; @descriptions = grep { $i++ % 2 } @tests;
	$i = 0; @results      = grep { $i++ % 2 } @tests;

	foreach my $i (0 .. $#descriptions) {
		ok(<HANDLE> eq "$results[$i]\n", $descriptions[$i]);
	}
	$normal = <HANDLE>;
	ok($NORMALS{$normal}, "normal()                   (colorizable=no)");
	$normal = <HANDLE>;
	ok($NORMALS{$normal}, "normal()                   (colorizable=yes)");
}

##########################################################################
# main

main();

__END__

