package Barbershop::Request::Factory;

use base 'Class::Singleton';

use CGI::Carp;
use Barbershop::IO::Factory;
use Template::Mustache;
use Module::Load;
use CGI::Header;
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
	my ( $path, $params, $middleware ) = $self->parseurl( $query );

	# lets default all headers with a utf-8 output
	my $header = CGI::Header->new( { charset => 'utf-8'}, $query );
	
	# Step 1 - Check for middleware (guards or request preprocessing)
	if ( $middleware )
	{
		my @inspection = $self->middleware( $middleware, $header );
		return @inspection if ( scalar @inspection );	
	}

	# multi stage process of getting the response together
	# Step 1 - Load the module
	my $model = ( $path->child( "model.json" )->exists() ) ?  decode_json( $path->child( 'model.json' )->slurp_utf8() ) : {} ;
	
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

	return ( $header, $view );
}

# inspect - inspects the URL and translate to view path
# @scope - private
# @returns - path or false (if not found)
sub parseurl
{

	#use Data::Dump qw/dump/;
	#use CGI;
	#print CGI->new()->header;

	my ( $io, @segments ) = ( Barbershop::IO::Factory->instance(), split '/', $ENV{'QUERY_STRING'} );

	if ( scalar (@segments) == 0 )
	{
		return Barbershop::IO::Factory->instance()->base( "app", "routes", "welcome" );
	}

	my ( @parameters, @paths, @middleware, %params ) = ( undef, undef, undef, undef );


	foreach my $path (@segments)
	{
		if ( $io->is_dir( "app", "routes", @paths, $path ) )
		{
			push @paths, $path;

			# lets check if there is a middleware
			if ( $io->is_dir( "app", "routes", @paths, "middleware" ) )
			{
				push @middleware, ucfirst( $_->basename ) for ( $io->children( "app", "routes", @paths, "middleware" ) )
			}
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
		\%params,
		\@middleware
		);

}


sub _404
{
	return Barbershop::IO::Factory->instance()->slurp( "public", '404.html' );
}

sub middleware
{
	my ( $self, $middleware, $header ) = @_;

	foreach my $mids (  @$middleware )
	{
		load Barbershop::IO::Factory->instance()->inspect("app", "middleware", ucfirst( $mids ), "Handler.pm");
		
		my $handler = $mids."::Handler";

		$header = $handler->new()->handle( $header );
			
		return ( $header, "" ) if ( ref $header  eq 'CGI::Header::Redirect' );
	}

	return ();
}


1;