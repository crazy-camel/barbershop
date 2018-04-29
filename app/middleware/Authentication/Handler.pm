package Authentication::Handler;


sub new
{
	return bless {}, $_[0];
}


sub process
{
	return $_[1];
}



1;