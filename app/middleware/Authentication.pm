package Authentication;

use CGI::Session;

my $redirect = "/login";

sub new
{
	return bless {}, $_[0] ;
}

sub handle
{
	if (1)
	{
		return $_[1];
	}
}


sub fail
{
	return $redirect ;
}

1;