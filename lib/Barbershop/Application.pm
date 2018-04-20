package Barbershop::Application;

use base 'Class::Singleton';

use Barbershop::Config;
use Barbershop::IO;
use Barbershop::Database;


use Template::Mustache;


sub _new_instance
{

	my $class = shift;

	my %args  = @_ && ref $_[0] eq 'HASH' ? %{ $_[0] } : @_;
    
    my $self  = bless { %args }, $class;

    # lets load the other singleton's

    Barbershop::IO->instance( $args{'basedir'} );

    Config::Tiny->read( Barbershop::IO->instance()->parse('config/app.ini') );

    Barbershop::Config->instance( $args{'basedir'} );

	my ($self, $args ) = @_;
	# lets do a few things to keep things in memory for performance
	my $basedir = $args->{'basedir'}->stringify;
	my $config = Config::Tiny->read( $args->{'basedir'}->child('config')->child('app.ini')->stringify );

	use CGI;
	my $q = CGI->new();

	use Data::Dump 'dump';

	print $q->header;


	if ( $config->{'database'} )
	{
		$self->db( Barbershop::Database->new( 
			properties => $config->{'database'},
			context => $basedir
		));
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