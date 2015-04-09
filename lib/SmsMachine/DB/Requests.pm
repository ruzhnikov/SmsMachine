package SmsMachine::DB::Requests;

=head1 NAME

SmsMachine::DB::Requests

=head1 DESCRIPTION

Requests to database

=head1 SYNOPSIS

my $dbh   = SmsMachine::DB->new;
my $tasks = $dbh->get_tasks;

for my $task ( @{ $tasks } ) {
    say $task->{id} . ": " . $task->{status};
}

=head1 AUTHOR

Alexander Ruzhnikov <ruzhnikov85@gmail.com>

=cut

use strict;
use warnings;
use 5.010;

=head1 METHODS

=over

=item B<get_tasks_query>( $self, %param )

=cut

sub get_tasks_query {
    my ( $self, %param ) = @_;

    my (@bind_params, @wherecond);
    my ($fields, $wherecond);

    if ( $param{status} ) {
        for my $status ( @{ $param{status} } ) {
            push @wherecond, 'status = ?';
            push @bind_params, $status;
        }
    }

    if ( $param{fields} ) {
        $fields = join( ', ', @{ $param{fields} } );
    }

    $wherecond = join( ' OR ', @wherecond ) if ( scalar @wherecond );

    if ( $param{id} ) {
        $wherecond .= ' AND ' if $wherecond;
        if ( scalar @{ $param{id} } == 1 ) {
            $wherecond .= 'id = ?';
            push @bind_params, $param{id}->[0];
        }
        else {
            $wherecond .= 'id IN ( ' . join( ', ', @{ $param{id} } ) . ' )';
        }
    }

    my $query = qq/SELECT / .
                ( $fields ? $fields : 'id' ) .
                qq/ FROM / . $self->task_table .
                ( $wherecond ? qq/ WHERE $wherecond / : '' ) .
                qq/ LIMIT 0,/ . $self->limit;

    return $self->dbh->selectall_arrayref( $query, { Slice => {} }, @bind_params );
}

sub get_tasks {
    my ( $self ) = @_;

    return $self->get_tasks_query(
        status => [ qw/ new running / ],
        fields => [ qw/ id status / ],
    );
}

sub get_task_info {
    my ( $self, $task_id, $fields ) = @_;

    $fields ||= '*';

    return $self->get_tasks_query(
        fields => [ $fields ],
        id     => [ $task_id ],
    );
}

sub get_new_tasks {
    my ( $self ) = @_;

    return $self->get_tasks_query(
        status => [ qw/ new / ],
        fields => [ qw/ id / ],
    );
}

sub get_run_tasks {
    my ( $self ) = @_;

    return $self->get_tasks_query(
        status => [ qw/ running / ],
        fields => [ qw/ id / ],
    );
}

sub get_suc_tasks {
    my ( $self ) = @_;

    return $self->get_tasks_query(
        status => [ qw/ success / ],
        fields => [ qw/ id / ],
    );
}

sub get_fail_tasks {
    my ( $self ) = @_;

    return $self->get_tasks_query(
        status => [ qw/ fail / ],
        fields => [ qw/ id / ],
    );
}

sub get_task_date_start {
    my ( $self, $task_id ) = @_;

    return $self->get_task_info( $task_id, 'date_start' );
}

=back

=cut

1;
