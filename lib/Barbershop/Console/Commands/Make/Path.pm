package Barbershop::Console::Commands::Make::Path;

use Barbershop::IO::Factory;

sub can
{
	return ( $_[1] eq "make:path" ) ? 1 : 0;
}

sub handle
{

	if ( Barbershop::IO::Factory->instance()->exists( "app", $_[1] ) )
	{
		print "[make.path] error - that path already exists ( $_[1] )\n";
		return;
	}

	Barbershop::IO::Factory->instance()->touch( "app", $_[1], "view.html" )->spew_utf8("<!--\n\tBarbershop v1.0\n-->");
	Barbershop::IO::Factory->instance()->touch( "app", $_[1], "model.json" )->spew_utf8("{\n}");

	print "[make.path] new path [ ".$_[1]." ] has been created in the app folder\n";
}


sub help
{
	return "Help for Making paths";
};


1;