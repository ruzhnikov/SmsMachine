package SmsMachine::Logger;

use strict;
use warnings;
use 5.010;
use Log::Log4perl;

sub init {
    my $filename = shift;

    my $conf;
    my $date_format   = '[%d{yyyy-MM-dd HH:mm:ss}]';
    my $conv_patternt = $date_format . ' [%p] %F{2}:%L %m%n';
    if ( $filename ) {
        $conf = qq(
            log4perl.category.SmsMachine  = DEBUG, Logfile

            log4perl.appender.Logfile          = Log::Log4perl::Appender::File
            log4perl.appender.Logfile.filename = $filename
            log4perl.appender.Logfile.layout   = Log::Log4perl::Layout::PatternLayout
            log4perl.appender.Logfile.layout.ConversionPattern = $conv_patternt
        );
    }
    else {
        $conf = qq(
            log4perl.category.SmsMachine  = DEBUG, Screen

            log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
            log4perl.appender.Screen.stderr  = 0
            log4perl.appender.Screen.layout  = Log::Log4perl::Layout::PatternLayout
            log4perl.appender.Screen.layout.ConversionPattern = $conv_patternt
        );
    }

    Log::Log4perl::init( \$conf );

    return Log::Log4perl::get_logger('SmsMachine');
}

1;
