# Term::ScreenColor -- screen positioning and output coloring module
#
# Copyright (c) 1999-2010 Rene Uittenbogaard. All Rights Reserved
#
# This module is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.

########################################################################
# Term::Screen::Fixes

# A couple of things that should have been fixed in Term::Screen.
# I requested the maintainer to incorporate these. Fix them here
# until they are fixed there.

package Term::Screen::Fixes;

require Term::Screen;

@ISA = qw(Term::Screen);

=for Term::Screen
=item new()
Initialize the screen. Does not clear the screen, but does home the cursor.

=cut

sub new
{
    my ( $prototype, @args ) = @_;

    my $classname = ref($prototype) || $prototype;

    $this = Term::Screen::Fixes->SUPER::new();
    bless $this, $prototype;
    $this->{FN_TIMEOUT} = 0.4;  # timeout for FN keys, in seconds
    $this->get_more_fn_keys();  # define function key table from defaults
    return $this;
}

=for Term::Screen
=item timeout($)
Returns and/or sets the function key timeout.

=cut

sub timeout
{
    my ( $self, $timeout ) = @_;

    if ( defined $timeout )
    {
        $self->{FN_TIMEOUT} = $timeout;
    }

    return $self->{FN_TIMEOUT};
}

=for Term::Screen
=item getch()
Returns just a char in raw mode. Function keys are returned as their
capability names, e.g. the up key would return "ku".  See the
C<get_fn_keys> function for what a lot of the names are. This will wait
for $this-E<gt>{FN_TIMEOUT} seconds for a next char if the first char(s)
are part of a possible fn key string.  You can use perl's sysread() to
go 'underneath' getch if you want. See the table in
Term::Screen::get_fn_keys() for more information.

=cut

# This does not just include the timeout, but it also substitutes sysread
# for getc.
# It's a real shame this wasn't fixed in Term::Screen, as this is a real
# problem and it requires us to duplicate the entire subroutine here.

sub getch
{
    my $this = shift;
    my ( $c, $nc, $fn_flag) = ('', '', 0);
    my $partial_fn_str = '';

    if ( $this->{IN} ) { $c = chop( $this->{IN} ); }
    else { sysread( STDIN, $c, 1 ); }

    $partial_fn_str = $c;
    while ( exists( $this->{KEYS}{$partial_fn_str} ) )
    {    # in a possible function key sequence
        $fn_flag = 1;
        if ( $this->{KEYS}{$partial_fn_str} )    # key found
        {
            $c              = $this->{KEYS}{$partial_fn_str};
            $partial_fn_str = '';
            last;
        }
        else    # wait for another key to see if were in FN yet
        {
            if ( $this->{IN} ) { $partial_fn_str .= chop( $this->{IN} ); }
            elsif ( !$this->key_pressed(0) && !$this->key_pressed( $this->{FN_TIMEOUT} ) )
            {
                last;
            }
            else
            {
                sysread(STDIN, $nc, 1);
                $partial_fn_str .= $nc;
            }
        }
    }
    if ($fn_flag)    # seemed like a fn key
    {
        if ($partial_fn_str)    # oops not a fn key
        {
            # buffer up the received chars
            $this->{IN} = CORE::reverse($partial_fn_str) . $this->{IN};
            $c = chop( $this->{IN} );
            $this->puts($c) if ( $this->{ECHO} && ( $c ne "\e" ) );
        }

        # if fn_key then never echo so do nothing here
    }
    elsif ( $this->{ECHO} && ( $c ne "\e" ) ) { $this->puts($c); } # regular key
    return $c;
}

=for Term::Screen
=item underline()
The us value from termcap - turn on underline.

=cut

sub underline
{
    my $this = shift;
    $this->term()->Tputs( 'us', 1, *STDOUT );
    return $this;
}

=for Term::Screen
=item raw()
Sets raw input mode using stty(1).

=cut

sub raw {
    my $this = shift;
    # wrapped so inherited versions can call with different input codes
    eval { system qw(stty raw -echo) };
    return $this->noecho();
}

=for Term::Screen
=item cooked()
Sets cooked input mode using stty(1).

=cut

sub cooked {
    my $this = shift;
    # wrapped so inherited versions can call with different input codes
    eval { system qw(stty -raw echo) };
    return $this->echo();
}

=for Term::Screen
=item flush_input()
Clears input buffer and removes any incoming chars.

=cut

sub flush_input
{
    my $this = shift;
    my $discard;
    $this->{IN} = '';
    while ( $this->key_pressed() ) { sysread(STDIN, $discard, 1); }
    return $this;
}

sub get_more_fn_keys {
    my $this = shift;
    my $term = $this->term();

#    $this->def_key( "ku", "\e[A" );   # vt100
#    $this->def_key( "kd", "\e[B" );   # vt100
#    $this->def_key( "kr", "\e[C" );   # vt100
#    $this->def_key( "kl", "\e[D" );   # vt100

    $this->def_key( "ku", "\eOA" );   # xterm
    $this->def_key( "kd", "\eOB" );   # xterm
    $this->def_key( "kr", "\eOC" );   # xterm
    $this->def_key( "kl", "\eOD" );   # xterm

#    $this->def_key( "k1",  "\e[11~" ); # vt100
#    $this->def_key( "k2",  "\e[12~" ); # vt100
#    $this->def_key( "k3",  "\e[13~" ); # vt100
#    $this->def_key( "k4",  "\e[14~" ); # vt100
#    $this->def_key( "k5",  "\e[15~" ); # vt100
#    $this->def_key( "k6",  "\e[17~" ); # vt100
#    $this->def_key( "k7",  "\e[18~" ); # vt100
#    $this->def_key( "k8",  "\e[19~" ); # vt100
#    $this->def_key( "k9",  "\e[20~" ); # vt100
#    $this->def_key( "k10", "\e[21~" ); # vt100
#    $this->def_key( "k11", "\e[23~" ); # vt100
#    $this->def_key( "k12", "\e[24~" ); # vt100

    $this->def_key( "k1", "\eOP" );   # xterm
    $this->def_key( "k2", "\eOQ" );   # xterm
    $this->def_key( "k3", "\eOR" );   # xterm
    $this->def_key( "k4", "\eOS" );   # xterm

    $this->def_key( "k1", "\e[[A" );  # Linux console
    $this->def_key( "k2", "\e[[B" );  # Linux console
    $this->def_key( "k3", "\e[[C" );  # Linux console
    $this->def_key( "k4", "\e[[D" );  # Linux console
    $this->def_key( "k5", "\e[[E" );  # Linux console

#    $this->def_key( "ins",  "\e[2~" );  # vt100
#    $this->def_key( "del",  "\e[3~" );  # vt100
#    $this->def_key( "pgup", "\e[5~" );  # vt100
#    $this->def_key( "pgdn", "\e[6~" );  # vt100

    $this->def_key( "home", "\e[H" );   # vt100
    $this->def_key( "end",  "\e[F" );   # vt100

    $this->def_key( "home", "\eOH" );   # xterm
    $this->def_key( "end",  "\eOF" );   # xterm

    $this->def_key( "home", "\e[1~" );  # Linux console
    $this->def_key( "end",  "\e[4~" );  # Linux console

    $this->def_key( "home", "\eO" );
    $this->def_key( "end",  "\eOw" );
    $this->def_key( "end",  "\eOe" );

    # try to get more useful things out of termcap

    my %keys = (
        kI  => "ins",
        kD  => "del",
        kh  => "home",
       '@7' => "end",
        kP  => "pgup",
        kN  => "pgdn",
       'k;' => "k10",
        F1  => "k11",
        F2  => "k12",
    );

    my $count = 0;
    foreach $fn (keys %keys) {
        if (exists $term->{"_$fn"}) {
#            print "Defining $keys{$fn} as $term->{\"_$fn\"}\n";
            $this->def_key($keys{$fn}, $term->{"_$fn"});
            $count++;
        }
    }
    return $count;
}

########################################################################
# Term::ScreenColor

package Term::ScreenColor;

@ISA = qw(Term::Screen::Fixes);
$VERSION = '1.11';

# Most methods end in "$_[0]" so you can string things together, e.g.
# $scr->at(2,3)->cyan()->puts("hi");

sub new {
    my $this = shift;
    my $classname = ref($this) || $this;
    my $ob = Term::ScreenColor->SUPER::new();
    # terminal types which support color (ugly solution, fix this)
    $ob->{is_colorizable} = $ENV{'TERM'} =~ /(^linux$|color|ansi)/i;
    return bless $ob, $classname;
}

sub color2esc {
    # return color sequence
    my $this = ref $_[0] ? shift() : { is_colorizable => 1 };
    my $color = shift;
    return '' unless $this->{is_colorizable};
    $color =~ s/on\s+/on_/g;
    $color =~ s/bold/ansibold/g;   # present in Term::Screen, not in %ATTRIBUTES
    $color =~ s/reverse/inverse/g; # present in Term::Screen, not in %ATTRIBUTES
    return "\e[".join (';', map { $ATTRIBUTES{$_} } split(/\s+|;/, $color)).'m';
}

sub color {
    # must be compatible with previous versions.
    goto &putcolor;
}

sub putcolor {
    # print color sequence
    my $this = ref $_[0] ? shift() : undef;
    my $color = shift;
#    print $this ? $this->color2esc($color) : &color2esc($color);
    print color2esc($color);
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
#    print $this ? $this->colored($color, @_) : &colored($color, @_);
    print colored($color, @_);
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
            return \$this;
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

A Term::Screen based screen positioning module with ANSI
color support.

   use Term::ScreenColor;

   $scr = new Term::ScreenColor;
   $scr->at(2,0)->red()->on_yellow()->puts("Hello, Tau Ceti!");
   $scr->putcolored('cyan bold on blue', 'Betelgeuse');
   $scr->putcolored('1;36;44', 'Altair');
   $scr->raw();

=head1 DESCRIPTION

Term::ScreenColor adds ANSI coloring support, along with a few other useful
methods, to those provided in Term::Screen.

=head1 PUBLIC INTERFACE

In addition to the methods described in Term::Screen(3pm), Term::ScreenColor
offers the following methods:

=over

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

# vim: set tabstop=4 shiftwidth=4 expandtab:

