package Barbershop::Console::Command::Make::Path;

use Barbershop::IO::Factory;

my $template = "<!DOCTYPE html>
<html lang=\"{{ lang }}\">
<head>
	<meta charset=\"UTF-8\">
	<title>{{ title }}</title>
</head>
<body>
	<h1>{{ title }}</h1>
	<p>Make something great!</p>
</body>
</html>";


sub can
{
	return ( $_[1] eq "make:path" ) ? 1 : 0;
}

sub handle
{

	if ( Barbershop::IO::Factory->instance()->exists( "app", "routes", $_[1], "view.html" ) )
	{
		print "[make.path] error - that path already exists ($_[1])\n";
		return;
	}

	Barbershop::IO::Factory->instance()->template( "view.html", "app", "routes", $_[1], "view.html" );
	Barbershop::IO::Factory->instance()->touch( "app", "routes", $_[1], "model.json" )->spew_utf8( "{\"title\":\"". $_[0]->str_replace( "/", " - ", ucfirst( $_[1] ), 1 ) ."\", \"lang\": \"en\"}" );

	print "[make.path] new path [".$_[1]."] has been created in the app folder\n";
}

sub str_replace {
	my ($self, $needle, $replacement, $haystack, $global  ) = @_;
	
	my $length = length( $haystack );
	my $target = length( $needle );
	
	for( my $i = 0; $i < ($length - $target + 1); $i++ ) {
		if( substr( $haystack, $i, $target ) eq $needle ) {
			$haystack = substr( $haystack, 0, $i ) . $replacement . substr( $haystack, $i + $target );
			return $haystack unless $global;
		}
	}
	return $haystack;
}


sub help
{
	return "Help for Making paths";
};


1;