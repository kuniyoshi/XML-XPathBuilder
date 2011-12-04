use Test::Most tests => 1;

my $module = "XML::XPathBuilder";
eval "require $module";
new_ok( $module );

