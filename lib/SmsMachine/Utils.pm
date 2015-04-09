package SmsMachine::Utils;

use strict;
use warnings;
use 5.010;
use POSIX qw/ strftime /;
use Date::Parse qw/ str2time /;
use File::Spec;

sub get_now {
    return strftime "%Y-%m-%d %H:%M:%S", localtime(time);
}

sub check_run_time {
    my ( $time_start, $time_end ) = @_;

    return unless ( $time_start && $time_end );

    my ( $local_time ) = localtime(time);
    my $unix_time = time();

    my $year = $local_time->[5];
    my $mon  = $local_time->[4];
    my $mday = $local_time->[3];

    $mon += 1;
    $year += 1900;

    my $date_start = $year . ':' . $mon . ':' . $mday . ' ' . $time_start;
    my $date_end   = $year . ':' . $mon . ':' . $mday . ' ' . $time_end;

    return 1 if $unix_time > str2time( $date_start ) && $unix_time < str2time( $date_end );
    return;
}

sub get_conf_dir {
    my $conf_dir = '/etc/smsmachine';

    return $conf_dir if -e $conf_dir && -d $conf_dir;

    my $current_path = (File::Spec->splitpath( __FILE__ ))[1];
    $conf_dir = $current_path . '../../conf';

    return $conf_dir;
}

1;
