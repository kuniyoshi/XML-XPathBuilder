use Test::Most;
use XML::XPathBuilder;

my $b = XML::XPathBuilder->new;

is( $b->initial_path, undef );
is( $b->initial_path( "foo" ), "foo" );
is( $b->initial_path, "foo" );

is_deeply( $b->paths, [ ] );
is_deeply( $b->paths( [ qw( foo bar ) ] ), [ qw( foo bar ) ] );
is_deeply( $b->paths, [ qw( foo bar ) ] );

is( $b->quote_char, q{'} );
is( $b->quote_char( q{"} ), q{"} );
is( $b->quote_char, q{"} );

is( $b->debug, undef );
is( $b->debug( 1 ), 1 );
is( $b->debug, 1 );

done_testing;

