#!/usr/bin/env perl
#
##########################################################################
#
# Name:         02-color-wrappers.t
# Version:      1.19
# Author:       Rene Uittenbogaard
# Date:         2010-09-29
# Requires:     Term::ScreenColor
# Description:  Tests for string wrapping methods in Term::ScreenColor
#

##########################################################################
# declarations

use strict;
use Test::More tests => 172;

require Term::ScreenColor;

my $scr;

my %NORMALS = (
	"\e[m"      => 1,
	"\e[0m"     => 1,
	"\e[m\cO"   => 1,
	"\e[0m\cO"  => 1,
	"\e(B\e[m"  => 1,
	"\e(B\e[0m" => 1,
);

my %FLASHES = (
	"\e[?5h\e[?5l" => 1,
	""             => 1,
);

my @tests = (
	'clear          ', "\e[0m",
	'reset          ', "\e[0m",
	'ansibold       ', "\e[1m",
	'italic         ', "\e[3m",
	'underscore     ', "\e[4m",
	'blink          ', "\e[5m",
	'inverse        ', "\e[7m",
	'concealed      ', "\e[8m",
        
	'noansibold     ', "\e[22m",
	'noitalic       ', "\e[23m",
	'nounderscore   ', "\e[24m",
	'noblink        ', "\e[25m",
	'noinverse      ', "\e[27m",
	'noconcealed    ', "\e[28m",
        
	'black          ', "\e[30m",
	'red            ', "\e[31m",
	'green          ', "\e[32m",
	'yellow         ', "\e[33m",
	'blue           ', "\e[34m",
	'magenta        ', "\e[35m",
	'cyan           ', "\e[36m",
	'white          ', "\e[37m",
        
	'on_black       ', "\e[40m",
	'on_red         ', "\e[41m",
	'on_green       ', "\e[42m",
	'on_yellow      ', "\e[43m",
	'on_blue        ', "\e[44m",
	'on_magenta     ', "\e[45m",
	'on_cyan        ', "\e[46m",
	'on_white       ', "\e[47m",
	
	'33;41          ', "\e[33;41m",
	'bold blue      ', "\e[1;34m",
	'bold yellow    ', "\e[1;33m",
	'cyan on black  ', "\e[36;40m",
	'green on cyan  ', "\e[32;46m",
	'green on yellow', "\e[32;43m",
	'magenta reverse', "\e[35;7m",
	'on_red blink   ', "\e[41;5m",
	'yellow on red  ', "\e[33;41m",
);

##########################################################################
# test instantiation

sub init {
	$ENV{TERM} = 'xterm';
	open NULL, ">/dev/null";
	# intercept STDOUT as this interferes with test output
	{
		local *STDOUT = *NULL;
		$scr = new Term::ScreenColor();
		system "stty cooked echo"; # nicer output on terminal
	}
	return $scr;
}

##########################################################################
# test Term::ScreenColor

sub main {
	my ($scr) = @_;
	my ($i, @descriptions, @results);

	my $teststring = 'blurk';

	$i = 1; @descriptions = grep { $i++ % 2 } @tests;
	$i = 0; @results      = grep { $i++ % 2 } @tests;

	# ---------- colorizable off ----------
	ok($scr->colorizable(0), 'turn colorizable off');

	ok($scr->bold2esc()      eq "\e[1m",
			'fetch bold                              (colorizable=no)');
	ok($scr->underline2esc() eq "\e[4m",
			'fetch underline                         (colorizable=no)');
	ok($scr->reverse2esc()   eq "\e[7m",
			'fetch reverse                           (colorizable=no)');
	ok($FLASHES{$scr->flash2esc()},
			'fetch flash                             (colorizable=no)');
	ok($NORMALS{$scr->normal2esc()},
			'fetch normal                            (colorizable=no)');
	ok($scr->color2esc('')               eq "",
			'fetch color escapes for empty string    (colorizable=no)');
	ok($scr->colored('','test')          eq "test",
			'fetch colored() for empty string        (colorizable=no)');

	foreach $i (0 .. $#descriptions) {
		ok($scr->color2esc($descriptions[$i]) eq "",
			"fetch color escapes for $descriptions[$i] (colorizable=no)");
		ok($scr->colored($descriptions[$i], $teststring) eq $teststring,
			"fetch colored $descriptions[$i]           (colorizable=no)");
	}

	# ---------- colorizable on ----------
	ok($scr->colorizable(1), 'turn colorizable on');

	ok($scr->bold2esc()      eq "\e[1m",
			'fetch bold                              (colorizable=yes)');
	ok($scr->underline2esc() eq "\e[4m",
			'fetch underline                         (colorizable=yes)');
	ok($scr->reverse2esc()   eq "\e[7m",
			'fetch reverse                           (colorizable=yes)');
	ok($FLASHES{$scr->flash2esc()},
			'fetch flash                             (colorizable=yes)');
	ok($NORMALS{$scr->normal2esc()},
			'fetch normal                            (colorizable=yes)');
	ok($scr->color2esc('')               eq "",
			'fetch color escapes for empty string    (colorizable=yes)');
	ok($scr->colored('','test')          eq "test", 
			'fetch colored() for empty string        (colorizable=yes)');

	foreach $i (0 .. $#descriptions) {
		ok($scr->color2esc($descriptions[$i]) eq $results[$i],
			"fetch color escapes for $descriptions[$i] (colorizable=yes)");
		ok($scr->colored($descriptions[$i], $teststring) eq "$results[$i]$teststring\e[0m",
			"fetch colored $descriptions[$i]           (colorizable=yes)");
	}
}

##########################################################################
# main

$scr = init();
main($scr);

__END__

