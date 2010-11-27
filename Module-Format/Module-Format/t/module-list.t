use strict;
use warnings;

use Test::More tests => 1;

use Module::Format::ModuleList;

{
    my $list = Module::Format::ModuleList->new(
        {
            modules =>
            [
                Module::Format::Module->from_guess({value => 'XML::RSS'}),
                Module::Format::Module->from_guess({value => 'Data-Dumper'}),
            ],
        }
    );

    # TEST
    ok ($list, "Module::Format::Module->new returns true.");
}
