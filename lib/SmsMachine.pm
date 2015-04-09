package SmsMachine;

use strict;
use warnings;
use 5.010;

use SmsMachine::Logger;
use SmsMachine::Conf;
use SmsMachine::DB;
use SmsMachine::Utils;


sub new {
    my $class = shift;

    my $self = bless {}, $class;
    $self->_init_config;
    $self->_init_logger;

    return $self;
}

sub _init_logger {
    my $self = shift;

    my $log_conf = $self->conf->get_param( 'logger' );
    my $logfile  = $self->conf->get_general->{path} . '/' .
                        $log_conf->{dir} . '/' . $log_conf->{file};

    $logfile = ( -e $logfile ) ? $logfile : '';

    $self->{_logger} = SmsMachine::Logger::init( $logfile );
}

sub _init_config {
    my $self = shift;

    my $config_path = SmsMachine::Utils::get_conf_dir;
    $self->{_conf}  = SmsMachine::Conf->new( $config_path );
}

sub _init_db {
    my $self = shift;

    unless ( $self->{_db} ) {
        my $db_conf = $self->conf->get_param( 'database.db_params' );
        $db_conf->{path} = $self->conf->get_param( 'general.path' );
        $self->{_db} = SmsMachine::DB->new( $db_conf );
    }
}

sub log {
    my $self = shift;

    $self->_init_logger unless $self->{_logger};
    return $self->{_logger};
}

sub db {
    my $self = shift;

    $self->_init_db unless $self->{_db};
    return $self->{_db};
}

sub conf {
    my $self = shift;

    $self->_init_config unless $self->{_conf};
    return $self->{_conf};
}

1;
