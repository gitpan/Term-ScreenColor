# Makefile.PL for Term::ScreenColor module

use ExtUtils::MakeMaker;

WriteMakefile(	NAME	  => 'Term::ScreenColor',
		PREREQ_PM => { 'Term::Screen' => 1.03 },
		VERSION	  => '1.10');

