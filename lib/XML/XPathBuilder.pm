package XML::XPathBuilder;
use strict;
use warnings;
use Carp qw( croak );

our $VERSION = "0.00";

my %INIT_SUB = (
    initial_path => undef,
    paths        => sub { [ ] },
    quote_char   => sub { q{'} },
    debug        => sub { $ENV{XML_XPATH_BULIDER_DEBUG} },
);

__PACKAGE__->mk_accessor( $_ => $INIT_SUB{ $_ } )
    foreach keys %INIT_SUB;

sub new { bless { splice @_, 1 }, shift }

sub mk_accessor {
    my $class            = shift;
    my($name, $sub_ref ) = @_;

    croak "Name required."
        unless defined $name;

    no strict "refs";
    *{ "${class}::$name" } = sub {
        my $self = shift;

        if ( @_ ) {
            $self->{ $name } = shift;
        }
        elsif ( $sub_ref && ! defined $self->{ $name } ) {
            $self->{ $name } = $sub_ref->( );
        }

        return $self->{ $name };
    };
}

sub start {
    my $self = shift;
    my $path = shift;

    $self->paths( [ ] );

    return defined $path ? $self->find( $path ) : $self;
}

sub find {
    my $self = shift;
    my $path = shift
        or croak "Path required.";

    push @{ $self->paths }, $path;

    return $self;
}

sub include {
    my $self   = shift;
    my $string = shift
        or croak "String required.";

    croak "Call find first."
        unless @{ $self->paths };

    my $path = sprintf(
        q{%s[.=%s%s%s]},
        pop( @{ $self->paths } ),
        $self->quote_char,
        $string,
        $self->quote_char,
    );

    return $self->find( $path );
}

sub eq {
    my $self   = shift;
    my $number = shift
        or croak "Number required.";

    my $path = sprintf(
        q{%s[%d]},
        pop( @{ $self->paths } ),
        $number,
    );

    return $self->find( $path );
}

sub up {
    my $self = shift;
    push @{ $self->paths }, "..";
    return $self;
}

sub stop {
    my $self = shift;
    pop @{ $self->paths };
    return $self;
}

sub end {
    my $self = shift;
    return join q{/}, grep { defined } ( $self->initial_path, @{ $self->paths } );
}

1;

__END__

=head1 NAME

XML::XPathBuilder - Build path which for the XPath

=head1 SYNOPSIS

  use XML::XPathBuilder;
  my $builder = XML::XPathBuilder->new;

  $buider->find("//foo")->include("bar")->find("baz");

=head1 DESCRIPTION

The jQeury remembers a context in the DOM.
XPath can the same?  i want it.

i love XPath, but it has long path when doing a bit challenging way.

i learned XPath can //foo[.="bar"]/../baz, but it is difficult to write
to my template engine.

=head1 ATTRIBUTES

=over

=item initial_path( "foo" )

Specifies the path which is in the first path always.

=item quote_char( q{'} )

Specifies how this mobule quotes a word.

=item debug( 1 )

Warns in some process.

=back

=head1 METHODS

=over

=item find( $path )

Pushes a path to paths.  The paths is for result of building.

=item start( $path )

Processes almost same thing with find, but start always
cleans up paths.
After cleaning, set a path which is argument to the paths.

=item include( $string )

Adds a path to the paths, but has a bit modification that
changes word to XPath's word.

=item eq( $number )

Selects a element which appears in $number order.

=item up

Moves to the upper path.

=item stop

Remove previous path.

=item end

Builds up XPath's path.

=back

=head1 AUTHOR

kuniyoshi E<lt>kuniyoshi@cpan.orgE<gt>

=head1 SEE ALSO

=over

=item XML::XPath

=back

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

