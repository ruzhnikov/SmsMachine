#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;
use FindBin qw/ $Bin /;
use lib "$Bin/../lib/";
use POSIX   qw/ setsid :sys_wait_h /;

use constant {
    MAX_PROC     => 2, # number of forks
    WORK_PROC_ID => 1, # number of work process
    DB_PROC_ID   => 2,
};

use SmsMachine;
use SmsMachine::WorkerProcess;
use SmsMachine::DB;

my %CHILD_PROCESS;

for ( 1 .. MAX_PROC ) {
    my $pid = fork();

    if ( $pid ) { # родитель
        if ( $_ == WORK_PROC_ID ) {
            $CHILD_PROCESS{ $pid } = 'work_process';
        }
        elsif ( $_ == DB_PROC_ID ) {
            $CHILD_PROCESS{ $pid } = 'db_process';
        }
    }
    else { # потомки
        # if ( $_ == WORK_PROC_ID ) {
        #     SmsMachine::WorkerProcess->new->work;
        # }
    }
}
