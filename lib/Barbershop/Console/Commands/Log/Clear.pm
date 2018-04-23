package Barbershop::Console::Commands::Log::Clear;


use Barbershop::Logger::Factory;
use feature qw/say/;

sub can
{
	return ( $_[1] eq "log:clear" ) ? 1 : 0;
}

sub handle
{
	Barbershop::Logger::Factory->instance()->clear();
	say "[log.clear] log has been cleared";
}


sub help
{
	return "Help from Clear";
}

1;