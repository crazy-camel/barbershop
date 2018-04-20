########################################
# A persitant database manager
########################################
package Barbershop::Database;

use base 'Class::Singleton';

use Barbershop::IO;
use Barbershop::Config;
use DBI;


sub _new_instance
{
        my $class = shift;
        my $self  = bless { }, $class;

        my ( $config, $io ) = ( Barbershop::Config->instance(), Barbershop::IO->instance() );
        # SQLITE
        if ( $config->get('database.type') eq 'sqlite' )
        {

        	my $path = ( $io->exists( $config->get('database.path') ) )
        			? $io->inspect( $config->get('database.path')  )
        			: $io->touch( $config->get('database.path') );

        	$self->{'db'} = DBI->connect("dbi:SQLite:dbname=".$path,"","");
        	return $self;
        }

        return $self;
}


sub query
{
	my ($self, $stmt, @bind) = @_;

	my $sth = $self->{'db'}->prepare($stmt);
	$sth->execute(@bind);

	my $results = $sth->fetchall_arrayref;
 	$sth->finish;

 	return $results;
}

1;
