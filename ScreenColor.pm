# Term::ScreenColor -- screen positioning and output coloring module
#
# Copyright (c) 1999-2003 Rene Uittenbogaard. All Rights Reserved
#
# This module is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

package Term::ScreenColor;

require Term::Screen;

@ISA = qw(Term::Screen);
$VERSION = '1.09';

# Most methods end in "$_[0]" so you can string things together, e.g.
# $scr->at(2,3)->cyan()->puts("hi");

sub new {
    my $self = shift;
    my $classname = ref($self) || $self;
    my $ob = new Term::Screen;
    # terminal types which support color (ugly solution, fix this)
    $ob->{is_colorizable} = $ENV{'TERM'} =~ /(^linux$|color|ansi)/i; 
    return bless $ob, $classname;
}

# I asked the author to include this in Term::Screen, it would fit better there.

sub raw {
    eval { system qw(stty raw -echo); };     # turn on raw input
    return $_[0];
}

sub cooked {
    eval { system qw(stty -raw echo); };     # turn off raw input
    return $_[0];
}

sub color2esc {
    # return color sequence
    my $this = ref $_[0] ? shift() : { is_colorizable => 1 };
    my $color = shift;
    return '' unless $this->{is_colorizable};
    $color =~ s/on\s+/on_/g;
    $color =~ s/bold/ansibold/g;   # present in Term::Screen, not in %ATTRIBUTES
    $color =~ s/reverse/inverse/g; # present in Term::Screen, not in %ATTRIBUTES
    return "\e[", join (';', map { $ATTRIBUTES{$_} } split(/\s+|;/, $color)), 'm';
}

sub color {
    # must be compatible with previous versions.
    goto &putcolor;
}

sub putcolor { 
    # print color sequence
    my $this = ref $_[0] ? shift() : undef;
    my $color = shift;
    print $this ? $this->color2esc($color) : &color2esc($color);
    return $this;
}

sub colored {
    # return string wrapped in color sequence
    my $this = ref $_[0] ? shift() : { is_colorizable => 1 };
    my $color = shift;
    return join('', @_) unless $this->{is_colorizable};
    return join('', &color2esc($color), @_, "\e[0m");
}

sub putcolored {
    # print string wrapped in color sequence
    my $this = ref $_[0] ? shift() : undef;
    my $color = shift;
    print $this ? $this->colored($color, @_) : &colored($color, @_);
    return $this;
}

sub colorizable {
    my ($this, $request) = (shift, shift);
    if (defined($request)) {
        $this->{is_colorizable} = $request;
        return $this;
    } else { 
        return $this->{is_colorizable};
    }
}

# initialisation

%ATTRIBUTES = (
  'clear'      => 0,  'black'      => 30,  'on_black'   => 40, 
  'reset'      => 0,  'red'        => 31,  'on_red'     => 41, 
  'ansibold'   => 1,  'green'      => 32,  'on_green'   => 42, 
  'underline'  => 4,  'yellow'     => 33,  'on_yellow'  => 43, 
  'underscore' => 4,  'blue'       => 34,  'on_blue'    => 44, 
  'blink'      => 5,  'magenta'    => 35,  'on_magenta' => 45, 
  'inverse'    => 7,  'cyan'       => 36,  'on_cyan'    => 46, 
  'concealed'  => 8,  'white'      => 37,  'on_white'   => 47,
);

foreach (keys %ATTRIBUTES) {
    eval qq(
        sub $_ {
	    \$this = shift;
            print "\e[$ATTRIBUTES{$_}m" if \$this->{is_colorizable};
            \$this;
        }
    );
}

# Add the values themselves as keys

foreach (values %ATTRIBUTES) {
	$ATTRIBUTES{$_} = $_;
}

1;

=pod

=head1 NAME

Term::ScreenColor - Screen positioning and coloring module for Perl

=head1 SYNOPSIS

An all perl Term::Screen based screen positioning module with ANSI
color support.

   use Term::ScreenColor;

   $scr = new Term::ScreenColor;
   $scr->at(2,0)->red()->on_yellow()->puts("Hello, Tau Ceti!");
   $scr->putcolored('cyan bold on blue', 'Betelgeuse');
   $scr->putcolored('1;36;44', 'Altair');
   $scr->raw();

=head1 DESCRIPTION

Term::ScreenColor adds ANSI coloring support, along with a few other useful
methods, to the objects provided in Term::Screen.

=head1 PUBLIC INTERFACE

In addition to the methods described in Term::Screen(3pm), Term::ScreenColor
offers the following methods:

=over

=item cooked()      	

Sets cooked input mode (using stty).

=item raw()      	

Sets raw input mode (using stty).

=item color()

Turn on a color by specifying its number in the table specified below:

   clear       => 0    black       => 30    on_black    => 40
   reset       => 0    red         => 31    on_red      => 41
   ansibold    => 1    green       => 32    on_green    => 42
   underline   => 4    yellow      => 33    on_yellow   => 43
   underscore  => 4    blue        => 34    on_blue     => 44
   blink       => 5    magenta     => 35    on_magenta  => 45
   inverse     => 7    cyan        => 36    on_cyan     => 46
   concealed   => 8    white       => 37    on_white    => 47

=item black() I<etc.>

Turn on a color by its name.

=item colorizable()

May be used to either set (if called with one integer argument) or query (if
called with no arguments) whether the terminal is believed to support ANSI
color codes. If this is set to off (0), no ANSI codes will be output. This
provides an easy way for turning on/off color.

=item putcolored()

Identical to puts(), but wraps its arguments in ANSI color sequences first,
using its first argument as color specification. Example:

   $scr->putcolored('cyan bold on blue', 'Betelgeuse');
   $scr->putcolored('1;36;44', 'Altair');

=back

=head1 AUTHOR

Rene Uittenbogaard (ruittenb@users.sourceforge.net)

Term::ScreenColor was based on:

=over

=item Term::Screen

Originally by Mark Kaehny (kaehny@execpc.com), now maintained by Jonathan
Stowe (jns@gellyfish.com)

=item Term::ANSIColor

By Russ Allbery (rra@cs.stanford.edu) and Zenin (zenin@best.com)

=back

=head1 SEE ALSO

Term::Screen(3pm), Term::Cap(3pm), termcap(5), stty(1)

=cut
