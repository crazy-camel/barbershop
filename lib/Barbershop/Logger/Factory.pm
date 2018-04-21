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
	my $dt = DateTime->now( time_zone => $_[0]->{'timezone'} );

	my ($package, $filename, $line) = caller;
	
	return "[ $dt ] $package - ln:$line : error - ".$_[1]."\n";
}

1;