package Barbershop::Database::Base;

use Class::Tiny qw/db/;
use DBI;

sub query
{
	my ($self, $stmt, @bind) = @_;

	my $sth = $_[0]->db->prepare($stmt);
	
	$sth->execute(@bind);

	my $results = $sth->fetchall_arrayref;

 	$sth->finish;

 	return $results;
}

1;