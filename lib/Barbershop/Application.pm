package Barbershop::Application;

use base 'Class::Singleton';

use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;

use Barbershop::Config::Factory;
use Barbershop::IO::Factory;
use Barbershop::Database::Factory;
use Barbershop::Request::Factory;
use Barbershop::Logger::Factory;

sub _new_instance
{

	my ( $class, $base ) = @_;
    my $self  = bless { }, $class;

    $_->instance( $base ) for ('Barbershop::IO::Factory','Barbershop::Config::Factory', 'Barbershop::Database::Factory', 'Barbershop::Logger::Factory', 'Barbershop::Request::Factory');

    return $self; 
}

sub respond
{
	my ($self, $query ) = @_;

	my ($headers, $body) = Barbershop::Request::Factory->instance()->process( $query );

	my $response = ( ref $headers eq 'CGI::Header::Redirect' ) ? $headers->as_string() : $query->header( $headers->header );

	$response .= $body;
	
	return $response;
}

1;