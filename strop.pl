#!/usr/bin/perl

use utf8;
use strict
use warnings qw/all/;

use Path::Tiny qw/path/;
use CGI;

use lib 'lib';

my $cli = CGI->new();
my $base = path( '.' )->absolute->stringify;

print $base;

$_->instance( $base ) for ('Barbershop::IO::Factory','Barbershop::Config::Factory', 'Barbershop::Database::Factory', 'Barbershop::Logger::Factory');

