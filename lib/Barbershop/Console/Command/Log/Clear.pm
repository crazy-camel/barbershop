package Barbershop::Console::Command::Log::Clear;

use Barbershop::Logger::Factory;


sub can
{
	return ( $_[1] eq "log:clear" ) ? 1 : 0;
}

sub handle
{
	Barbershop::Logger::Factory->instance()->clear();
	print "[log.clear] log has been cleared\n";
}


sub help
{
	return "log:clear 		Clears the log file\n";
}

1;