
use strict;
use warnings;

use Test::More;
use Module::Format::PerlMF_App;

eval q{use Test::Trap qw( trap $trap :flow:stderr(systemsafe):stdout(systemsafe):warn );};

if ($@)
{
    plan skip_all => "Test::Trap not found.";
}

plan tests => 1;

# TEST
ok(1, "Test is OK.");


