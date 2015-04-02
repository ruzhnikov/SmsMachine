package SmsMachine::DB;

use Modern::Perl;
use DBI;
use Carp qw/ croak /;

use base qw/ SmsMachine::DB::Requests /;

sub new {
    my ( $class, $config ) = @_;

    my $file = $config->{path} . '/' . $config->{dbdir} . '/' . $config->{dbfile};
    unless ( -e $file ) {
        croak "DB file $file not found";
    }

    my $self = bless { _db_file => $file }, $class;
    $self->{_dbh} = DBI->connect( "dbi:SQLite:dbname=$file", '', '' );

    return $self;
}

sub dbh { shift->{_dbh} }

1;
