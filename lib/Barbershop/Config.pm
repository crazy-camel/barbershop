package Barbershop::Config;

use base 'Class::Singleton';
use Path::Tiny qw/path/; 

sub _new_instance
{
        my $class = shift;
        my $self  = bless { }, $class;
        
        $self->{'base'} = path( shift );

        return $self;
}

sub parse
{
	return $_[0]->sibling( $_[1] )->stringify;
}

sub exists
{
	return $_[0]->sibling( $_[1] )->exists;
}

sub touch
{	
	$_[0]->sibling( $_[1] )->touchpath->stringify;
}

sub slurp
{
	return ( wantarray )
		? $_[0]->sibling( $_[1] )->lines_utf8
		: $_[0]->sibling( $_[1] )->slurp_utf8;
}


1;