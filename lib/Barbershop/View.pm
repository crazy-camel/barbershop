package Barbershop::View;

use base 'Class::Singleton';

sub _new_instance
{

	my ( $class, $base ) = @_;
    my $self  = bless { }, $class;

    

    return $self;
}

sub generate
{
	
}



1;