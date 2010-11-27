use strict;
use warnings;

use Test::More tests => 4;

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

        # TEST
        is_deeply(
            $modules->[0]->get_components_list(),
            [qw(XML RSS)],
            "XML-RSS has the right components.",
        );

        # TEST
        is_deeply(
            $modules->[1]->get_components_list(),
            [qw(Data Dumper)],
            "XML-RSS has the right components.",
        );

    }
}
