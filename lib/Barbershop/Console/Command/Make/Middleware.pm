package Barbershop::Console::Command::Make::Middleware;

use Barbershop::IO::Factory;


sub can
{
	return ( $_[1] eq "make:middleware" ) ? 1 : 0;
}

sub handle
{

	if ( Barbershop::IO::Factory->instance()->exists( "app", "middleware", $_[1], "view.html" ) )
	{
		print "[make.path] error - that path already exists ($_[1])\n";
		return;
	}

	print "[make.middleware] new middleware [".$_[1]."] has been created in the app folder\n";
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
	return "make::middleware 	Create a middleware for your web application";
};


1;