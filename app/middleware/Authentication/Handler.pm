package Authentication::Handler;

use CGI::Session;
use CGI::Cookie;
use CGI::Header::Redirect;

sub new
{
  return bless {}, $_[0];
}

sub handle
{
  
  my ( $self, $header ) = @_;

   # CGI::Session object for session handling
  my $session = CGI::Session->new( $query );
  
  $header->cookie( CGI::Cookie->new( -name=> $session->name, -value => $session->id, -expires => '+30m' ) );
  
  # check if visitor has already logged in
  if ( $session->param("logged-in") )
  {
      return $header;
  }

  return CGI::Header::Redirect->new( -location => '/login' );
}


1;