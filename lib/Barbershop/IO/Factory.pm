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

sub is_dir
{
	my( $self, @paths )= @_;
	return $self->{'base'}->child( @paths )->is_dir();
}

sub template
{
	my( $self, $type, @path )= @_;
	my $template = $self->{'base'}->child( "resources", "templates", $type )->stringify;
	my $clone = $self->{'base'}->child( @path )->touchpath->stringify;
	return path( $template )->copy( $clone );
}


sub children
{
	my( $self, @path )= @_;
	return $self->{'base'}->child( @path )->children();
}

sub inspect
{
	my( $self, @paths )= @_;
	return $self->{'base'}->child( @paths )->stringify;
}

sub base
{
	my( $self, @paths )= @_;
	return $self->{'base'}->child( @paths );	
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