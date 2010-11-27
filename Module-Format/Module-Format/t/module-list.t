use strict;
use warnings;

use Test::More tests => 2;

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

    {
        my $modules = $list->get_modules_list_copy();

        # TEST
        is (scalar(@$modules), 2, "Got 2 modules");

    }
}
