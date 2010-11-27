
use strict;
use warnings;

use Test::More;
use Module::Format::PerlMF_App;

use vars qw($trap);

eval q{use Test::Trap qw( trap $trap :flow:stderr(systemsafe):stdout(systemsafe):warn );};

if ($@)
{
    plan skip_all => "Test::Trap not found.";
}

plan tests => 3;

# TEST
ok(1, "Test is OK.");

{
    trap(sub {
        Module::Format::PerlMF_App->new(
            {
                argv => [qw/as_rpm_colon Data::Dump XML-Grammar-Fortune/],
            },
        )->run();
    });

    # TEST
    is (
        $trap->stdout(), 
        qq{perl(Data::Dump) perl(XML::Grammar::Fortune)\n},
        'as_rpm_colon works as expected.',
    );
}

{
    trap(sub {
        Module::Format::PerlMF_App->new(
            {
                argv => [qw/as_colon Data::Dump XML-Grammar-Fortune/],
            },
        )->run();
    });

    # TEST
    is (
        $trap->stdout(), 
        qq{Data::Dump XML::Grammar::Fortune\n},
        'as_colon works as expected.',
    );
}
