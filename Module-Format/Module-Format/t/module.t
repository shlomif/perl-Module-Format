use strict;
use warnings;

use Test::More tests => 2;

use Module::Format::Module;

{
    my $module = Module::Format::Module->from(
        {
            format => 'colon',
            value => 'XML::Grammar::Fiction',
        }
    );

    # TEST
    ok ($module);

    # TEST
    is_deeply(
        $module->get_components_list(),
        [qw(XML Grammar Fiction)],
        "get_components_list() is sane.",
    );
}
