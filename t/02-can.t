use Test::Most tests => 1;

my $module  = "XML::XPathBuilder";
my @methods = qw(
    initial_path  quote_char  paths  debug
    new  mk_accessor
    start  find  include  eq  up  stop  end
);

eval "require $module";
can_ok( $module, @methods );

