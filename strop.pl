#!/usr/bin/perl

use utf8;
use strict;
use warnings qw/all/;

use Path::Tiny qw/path/;
use Module::Load;


use lib 'lib';

use Barbershop::Config::Factory;
use Barbershop::IO::Factory;
use Barbershop::Database::Factory;
use Barbershop::Logger::Factory;

use Barbershop::Console::Commands::Log::Clear;
use Barbershop::Console::Commands::Make::Path;


my $base = path( '.' )->absolute->stringify;

$_->instance( $base ) for ('Barbershop::IO::Factory','Barbershop::Config::Factory', 'Barbershop::Database::Factory', 'Barbershop::Logger::Factory');

my $addressed;
foreach my $available ("Log::Clear", "Make::Path")
{
	my $module = "Barbershop::Console::Commands::".$available;
	if ( $module->can( $ARGV[0] ) )
	{
		$module->handle( $ARGV[1] );
		$addressed = 1;
	}
}

if ( !defined $addressed )
{
	print "[HELP SCREEN]"
}
