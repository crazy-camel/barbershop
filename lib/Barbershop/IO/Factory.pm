package Barbershop::IO::Factory;

use base 'Class::Singleton';
use Path::Tiny qw/path/; 

sub _new_instance
{
        my $class = shift;
        my $self  = bless { }, $class;

        $self->{'base'} = path( shift );

        return $self;

}

sub inspect
{
	my( $self, @paths )= @_;
	return $self->{'base'}->child( @paths )->stringify;
}
ß
sub base
{
	my( $self, @paths )= @_;
	return $self->{'base'}->child( @paths )->stringify;
}

sub exists
{
	my( $self, @paths )= @_;
	return $self->{'base'}->child( @paths )->exists;
}

sub touch
{	
	my( $self, @paths )= @_;
	return $self->{'base'}->child( @paths )->touchpath;
}

sub slurp
{
	my( $self, @paths )= @_;
	return ( wantarray )
		? $self->{'base'}->child( @paths )->lines_utf8
		: $self->{'base'}->child( @paths )->slurp_utf8;
}

sub append
{
	my( $self, $text, @paths )= @_;
	return $self->{'base'}->child( @paths )->append_utf8( $text );
}

sub clear
{
	my( $self, @paths )= @_;
	$self->{'base'}->child( @paths )->touchpath->spew_utf8( "" );
}


1;