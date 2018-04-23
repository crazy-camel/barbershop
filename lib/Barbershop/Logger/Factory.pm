package Barbershop::Logger::Factory;

use base 'Class::Singleton';

use Barbershop::IO::Factory;
use Barbershop::Config::Factory;
use DateTime;



sub _new_instance
{
    my $self  = bless { }, shift;
    $self->{'timezone'} = Barbershop::Config::Factory->instance()->get("general.timezone", "America/New_York");
    return $self;
}


sub carp
{
	my ( $self, $args ) = @_;

	my $dt = $self->datetime();

	my ($package, $filename, $line) = caller;
	
	return  "[ ".DateTime->now( time_zone => $self->{'timezone'} )." ] $package - ln:$line : error - ".$_[1]."\n";
}

sub file
{
	my ( $self, $args ) = @_;
	return ( "logs", DateTime->now( time_zone => $self->{'timezone'} )->ymd("-"), "barbershop.log" );
}

sub log
{
	my ( $self, $args ) = @_;

	my @info = ( "[", DateTime->now( time_zone => $self->{'timezone'} ), "] [", uc( $args->{'type'} ), "] ", $args->{'message'} );

	Barbershop::IO::Factory->instance()->append( join("", @info) , $self->file() );
}

sub clear
{
	my ( $self, $args ) = @_;
	Barbershop::IO::Factory->instance()->clear( $self->file() );
}

1;