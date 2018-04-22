package Barbershop::View::Factory;

use base 'Class::Singleton';

use Barbershop::IO::Factory;
use Template::Mustache;
use Env;
use feature qw/say/;


sub process
{
	my ($self, $query) = @_;
	my ( $path, $params ) = $self->parseurl();

	if ( $path eq '404' )
	{
		return _404( $params );
	}
	
	say $path;
	my $template = Template::Mustache->new(
		template_path =>  $path,
		partials_path => Barbershop::IO::Factory->instance()->inspect( "resources", "views", "partials" )
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
	my @params = split '/', $QUERY_STRING;

	if ( scalar (@params) == 0 )
	{
		return (
			Barbershop::IO::Factory->instance()->inspect( "resources","views","welcome.mustache" ),
			{}
			)
	}

	while ( my ($path) = splice(@params, 0, 1) )
	{
		break unless ( scalar( @paths ) < 1 && $io->exists( "resources", "views", $path ) ) or $io->exists( "resources", "views", @paths );
		push @paths, $path;
	}

	if ( scalar( @params )  )
	{
		push @params, 1 if ( scalar(@params) % 2 != 0 );
		%params = @params;
	}

	if ( scalar (@paths) == 0 )
	{
		return 
	}

	return ( 
		Barbershop::IO::Factory->instance()->inspect( "resources", "views", @paths ),
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