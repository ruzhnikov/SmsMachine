package SmsMachine::Conf;

=encoding utf8

=head1 NAME

SmsMachine::Conf

=head1 DESCRIPTION

Модуль для работы с данными из конфига

=head1 AUTHOR

Alexander Ruzhnikov <<ruzhnikov85@gmail.com>>

=cut

use Modern::Perl;
use YAML::Syck ();

my $CONFIG_PATH = '/etc/smsmachine';
my $CONFIG_NAME = 'server.yml';

=head1 METHODS

=over

=item B<new>( $class, $config_path )

Конструктор.

$config_path -- путь до конфига. Необязательный параметр.
    По умолчанию ипользуется /etc/smsmachine

=cut

sub new {
    my ( $class, $config_path ) = @_;

    $config_path ||= $CONFIG_PATH;

    my $self = bless { _path => $config_path }, $class;
    $self->_init_conf;

    return $self;
}

=item B<get_param>( $self, $param )

Получить значение параметра. Можно получить данные по вложенному параметру.
Возвращает значение параметра или пустое значение.
Вложенность определяется через '.'
Например, param1.param2.param3

=cut

sub get_param {
    my ( $self, $param ) = @_;

    my $res_data;

    my @param_array = split( /\./, $param );
    if ( scalar @param_array == 1 ) {
        $res_data = $self->_conf->{ $param } if $self->_conf->{ $param };
    }
    elsif ( scalar @param_array > 1 ) {
        my $key = shift @param_array;
        if ( $self->_conf->{ $key } ) {
            my $tmp_data = $self->_conf->{ $key };
            for ( @param_array ) {
                $tmp_data = ( $_ =~ /^\d+$/ ) ? delete $tmp_data->[$_] : delete $tmp_data->{$_};
                last unless $tmp_data;
            }
            $res_data = $tmp_data if $tmp_data;
        }
    }

    return $res_data;
}

sub _conf {
    my $self = shift;

    $self->_init_conf unless $self->{_conf_data};
    return $self->{_conf_data};
}

sub _init_conf {
    my $self = shift;

    unless ( $self->{_conf_data} ) {
        my $file_path = $self->{_path} . '/' . $CONFIG_NAME;
        $self->{_conf_data} = YAML::Syck::LoadFile( $file_path );
    }

    return 1;
}

=back

=cut

1;
