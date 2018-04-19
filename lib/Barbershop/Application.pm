package Barbershop::Application;

use Config::Tiny;
use Class::Tiny qw/config db/;

use Template::Mustache;
use Barbershop::Database;


sub BUILD
{
	my ($self, $args ) = @_;
	# lets do a few things to keep things in memory for performance

	my $config = Config::Tiny->read( $args->{'basedir'}->child('config')->child('app.ini')->stringify );

	

	if ( $config->{'database'} )
	{
		$self->db( Barbershop::Database->new( properties => $config->{'database'} ) );
	}
	
	# Lets store the configuration
	$self->config( $config );

}

sub respond
{
	my ($self, $query ) = @_;

	my $response = $query->header;

	$response .= "Hello, from Barbershop!";
	
	return $response;
}

1;