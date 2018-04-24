package Controller;

use Class::Tiny qw/model/;

use YAML::Tiny;
use Cwd qw(abs_path);
use File::Basename;;

sub BUILD
{
	my ($self, $args) = @_;

	
	$self->model( YAML::Tiny->read( dirname (abs_path(__FILE__) ) . "Model.yml" );
}

sub process
{

}

1;