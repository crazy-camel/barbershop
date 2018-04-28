package Barbershop::Request::Factory;

use base 'Class::Singleton';

use CGI::Carp;
use Barbershop::IO::Factory;
use Template::Mustache;
use Env;
use Module::Load;
use JSON::XS;


sub _new_instance
{
    my $self  = bless { }, shift;
    $self->{'base_dir'} = shift;
    return $self;
}


sub process
{
	my ( $self, $query ) = @_;
	my ( $path, $params ) = $self->parseurl( $query );

	# lets default all headers with a utf-8 output
	my @headers = ( { 'key' => 'charset', 'value' => 'utf-8' } );
	
	# Step 1 - Check for middleware (guards or request preprocessing)
		

	# multi stage process of getting the response together
	# Step 1 - Load the module
	my $model = ( $path->child( "model.json")->exists() ) ?  decode_json( $path->child( 'model.json' )->slurp_utf8() ) : {} ;
	
	# Lets merge in the parameters if any
	$model->{'query'}->{$_} = $params->{ $_ } for ( keys %$params );

	# lets action the controller if it exists
	if ( $path->child("controller.pm")->exists() )
	{
		load $path->child( "controller.pm" )->stringify;
		$model = Controller->new( $model )->model;		
	}
		
	my $template = Template::Mustache->new(
		template_path =>  ( $path->child("view.html")->exists() ) 
				? $path->child("view.html")->stringify
				: Barbershop::IO::Factory->instance()->inspect( "public", "404.html" ),
		partials_path => Barbershop::IO::Factory->instance()->inspect( "app", "partials" )
	);

	my $view = $template->render( $model );

	return ( \@headers, $view );
}

# inspect - inspects the URL and translate to view path
# @scope - private
# @returns - path or false (if not found)
sub parseurl
{
	my ( $io, @paths, %params ) = ( Barbershop::IO::Factory->instance(), (), () );
	my @segments = split '/', $QUERY_STRING;
	my @parameters;

	if ( scalar (@segments) == 0 )
	{
		return Barbershop::IO::Factory->instance()->base( "app", "routes", "welcome" );
	}

	foreach my $path (@segments)
	{
		if ( $io->is_dir( "app", "routes", @paths, $path ) )
		{
			push @paths, $path;
			next;
		}
		push @parameters, $path;
	}
	
	if ( @parameters )
	{
		push @parameters, 1 if (  scalar( @parameters ) % 2 != 0 );
		%params = @parameters ;
	}

	return ( 
		Barbershop::IO::Factory->instance()->base( "app", "routes", @paths ),
		\%params
		);

}

sub headers
{
	my ( $self, $args ) = @_;
	
	my @headers =  (
        { 'key' => 'charset', 'value' => 'utf-8' }
    );

    push @headers, { 'key' => $_ , 'value' => $args->{$_} } for keys %{ $args };

    return @headers;
}

sub _404
{
	return Barbershop::IO::Factory->instance()->slurp( "public", '404.html' );
}


1;