package SmsMachine::DB;

use strict;
use warnings;
use 5.010;
use DBI;
use Carp qw/ croak /;

use constant {
    QUERY_LIMIT  => 10,  # limit for queries
    QUERY_OFFSET => 0,
};

use base qw/ SmsMachine::DB::Requests /;

sub new {
    my ( $class, $config ) = @_;

    my $file = $config->{path} . '/' . $config->{dbdir} . '/' . $config->{dbfile};
    unless ( -e $file ) {
        croak "DB file $file not found";
    }

    my $self = bless { _db_file => $file }, $class;
    my $add_params = {
                RaiseError     => 1,
                sqlite_unicode => 1,
    };
    $self->{_dbh} = DBI->connect( "dbi:SQLite:dbname=$file", '', '', $add_params ) or die DBI->errstr;
    $self->{_query_limit}  = QUERY_LIMIT;
    $self->{_query_offset} = QUERY_OFFSET;

    $self->{_task_table} = 'tasks';
    $self->{_msg_table}  = 'task_messages';
    $self->{_num_table}  = 'task_numbers';

    return $self;
}

sub dbh { shift->{_dbh} }
sub limit { shift->{_query_limit} }
sub offset { shift->{_query_offset} }
sub task_table { shift->{_task_table} }
sub msg_table { shift->{_msg_table} }
sub num_table { shift->{_num_table} }


1;
