use strict;
use warnings;

use Test::More tests => 1;

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
}
