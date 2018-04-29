package Barbershop::Console::Command;

use Module::Pluggable search_path => ["Barbershop::Console::Command"], require => 1;

sub new
{
    return bless { }, shift;
}

1;