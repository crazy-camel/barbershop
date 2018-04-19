#!/usr/bin/perl

use utf8;
use strict;
use warnings qw/all/;

use CGI::Carp qw(fatalsToBrowser);
use CGI::Fast;

use Path::Tiny qw/path/;

use lib path($0)->absolute->parent(2)->child('lib')->stringify;

use Barbershop::Application;

my $app = Barbershop::Application->new( basedir => path($0)->parent(2) );

while ( my $q = CGI::Fast->new() )
{	
	print $app->respond( $q );
}
