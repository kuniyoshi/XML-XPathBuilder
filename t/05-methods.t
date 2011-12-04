use Test::Most;
use XML::XPathBuilder;

my $b = XML::XPathBuilder->new( initial_path => "/home/kuniyoshi" );

is( $b->end, "/home/kuniyoshi" );

$b->find( "bin" );
is( $b->end, "/home/kuniyoshi/bin" );

$b->stop;
is( $b->end, "/home/kuniyoshi" );

$b->find( "Downloads" )
  ->include( "movies" );
is( $b->end, "/home/kuniyoshi/Downloads[.='movies']" );

$b->stop
  ->find( "Documents" )
  ->eq( 1 );
is( $b->end, "/home/kuniyoshi/Documents[1]" );

$b->stop
  ->find( "bin" )
  ->up;
is( $b->end, "/home/kuniyoshi/bin/.." );

done_testing;

