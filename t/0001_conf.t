use strict;
use warnings;
use 5.010;
use Test::More;

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";

use_ok( 'SmsMachine::Conf' );

my $conf_path = "$Bin/../conf";
my $conf = SmsMachine::Conf->new( $conf_path );

ok( $conf, 'Create object' );
ok( $conf->get_param( 'general' ), 'Get one param' );
ok( $conf->get_param( 'logger.dir' ), 'Got more one param' );
ok( ! $conf->get_param( 'myparam' ), 'Try get undefined param' );

done_testing();
