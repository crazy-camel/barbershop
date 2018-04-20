package Barbershop::Application;

use base 'Class::Singleton';

use CGI::Carp qw/fatalsToBrowser/;
use Barbershop::Config;
use Barbershop::IO;
use Barbershop::Database;


use Template::Mustache;


sub _new_instance
{

	my $class = shift;
    my $base = shift;
    my $self  = bless { }, $class;

    $_->instance( $base ) for ('Barbershop::IO','Barbershop::Config', 'Barbershop::Database');

    return $self;
}

sub respond
{
	my ($self, $query ) = @_;

	my $response = $query->header;

	$response .= "Hello, from Barbershop!";
	
	return $response;
}

1;