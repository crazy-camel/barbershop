package Barbershop::Database::Sqlite;

use parent 'Barbershop::Database::Base';

use Barbershop::IO;

sub BUILD
{
	my ($self, $args) = @_;

use Data::Dump 'dump';
print dump($args);
	my $path = path( $args->{'path'} );

	if ( ! $path->exists )
	{
		$path->touchpath;
	}

	my $dbh = DBI->connect("dbi:SQLite:dbname=".$path->stringify,"","");

	$self->db( $dbh );
}

1;