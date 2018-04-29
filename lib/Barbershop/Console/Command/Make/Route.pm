package Barbershop::Console::Command::Make::Route;

use Barbershop::IO::Factory;


sub can
{
	return ( $_[1] eq "make:route" ) ? 1 : 0;
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

	print "[make.path] new route [".$_[1]."] has been created in the app folder\n";
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
	return "make::route 		Create a route for your web application";
};


1;