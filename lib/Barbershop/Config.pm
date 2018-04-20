package Barbershop::Config;

use base 'Class::Singleton';

use Config::Tiny;
use Hash::Flatten qw/flatten/;
use Barbershop::IO;

sub _new_instance
{
    my $class = shift;
    my $self  = bless { }, $class;
    
    my ( $config, $cfg) = ( Config::Tiny->read( Barbershop::IO->instance()->inspect('config','app.ini') ), {} );
  	
    $cfg->{$_} = $config->{$_} for ( keys %$config );
    
    $self->{'config'} = flatten( $cfg );

    return $self;
}

sub get
{
	return $_[0]->{'config'}->{ $_[1] };
}

1;