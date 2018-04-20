########################################
# A persitant database manager
########################################
package Barbershop::Database;

use base 'Class::Singleton';

use DBI;


sub _new_instance
{
        my $class = shift;
        my $self  = bless { }, $class;
        
        my ( $config, $dbh ) = ( $_[0], undef );

        if ( $properties->{'type'} eq 'sqlite' )
        {

        }

        $self->{'db'} = ;

        return $self;
}

sub _new_instance
{
	my ($self, $args ) = @_;


	if ( $args->{'properties'}->{'type'} eq 'sqlite' )
	{

		my $dbh = Barbershop::Database::Sqlite->new(
				path => path( $args->{'context'} )->child( $args->{'properties'}->{'path'} )->stringify
			);
		
		return $self->db( $dbh );
	}
	
}



1;
