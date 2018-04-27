package Controller;

use Class::Tiny qw/model/;

sub BUILD
{
	my ($self, $args) = @_;

	# process args
	$args->{'title'} = "Controller added - ".$args->{'title'};
	$self->model( $args );
}

1;