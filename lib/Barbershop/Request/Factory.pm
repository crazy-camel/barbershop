package Barbershop::Request::Factory;

use base 'Class::Singleton';

use Barbershop::IO::Factory;
use Template::Mustache;
use Env;
use feature qw/say/;


sub process
{
	my ($self, $query) = @_;
	my ( $path, $params ) = $self->parseurl();

	if ( $path eq '404' or not $path->exists( "view.html" ) )
	{
		return _404( $params );
	}

	# initialize a new request of each
	my ( $model, $controller, $view ) = ( undef, undef, undef ); 
	
	foreach my $portion ( "model", "controller", "view" )
	{
		if ( $path->exists( "model.yml" ) && $portion eq "model" );
		if ( $path->exists( "model.yml" ) && $portion eq "model" );
	}

	# three stage process of getting the response together
	my $template = Template::Mustache->new(
		template_path =>  $path,
		partials_path => Barbershop::IO::Factory->instance()->inspect( "app", "partials" )
	);

	#use Data::Dump qw/dump/;
	#my $content = join "", map { $_->render() } ( values %{ $template->partials } ) ;

	#say $content;
	my $prerender = $template->render();
	say $prerender;
	return "";
}

# inspect - inspects the URL and translate to view path
# @scope - private
# @returns - path or false (if not found)
sub parseurl
{
	my ( $io, @paths, %params ) = ( Barbershop::IO::Factory->instance(), (), () );
	my @segments = split '/', $QUERY_STRING;

	if ( scalar (@segments) == 0 )
	{
		return Barbershop::IO::Factory->instance()->base( "app","welcome" );
	}

	while ( my $path = shift @segments )
	{
		break if ( not $io->is_dir( "app", @paths, $path ) )
		push @paths, $path;
	}

	my $parameters = scalar( @segments );
	
	if ( $parameters )
	{
		push @params, 1 if (  $parameters % 2 != 0 );
		%params = @segments ;
	}

	return ( 
		( scalar (@paths) == 0  ) ? Barbershop::IO::Factory->instance()->base( "app", "welcome" ) : Barbershop::IO::Factory->instance()->base( "app", @paths ),
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
	my $html = Barbershop::IO::Factory->instance()->slurp( "public", '404.html' );
	my $headers = $_[0]->headers( 
		'status' => 404
	);
	return ( $headers, $body );
}

sub parse
{
	my ( $self, $args ) = @_;
	# set up context
	
	return Template::Mustache->render()
	#my $template = Template::Mus
}


1;