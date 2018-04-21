package Barbershop::View::Factory;

use base 'Class::Singleton';

use Barbershop::IO::Factory;
use Template::Mustache;
use Env;

sub process
{
	my ($self, $query) = @_;
	
	my $path = $self->_inspect();

	
	return $_[0]->{'config'}->{ $_[1] };
}

# inspect - inspects the URL and translate to view path
# @scope - private
# @returns - path or false (if not found)
sub _inspect
{
	my $io = Barbershop::IO::Factory->instance();
	my @params = split '/', $QUERY_STRING;
	
	use Data::Dump qw/dump/;
	
	print Barbershop::Logger::Factory->instance()->carp( dump(@params) );

}

sub headers
{
    return (
        { 'key' => 'charset', 'value' => 'utf-8' }
    );
}


1;