use strict;
use warnings;

use Test::More tests => 7;

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

    # TEST
    is ($module->format_as('colon'), 'XML::Grammar::Fiction',
        "Format as colon is sane."
    );

    # TEST
    is ($module->format_as('dash'), 'XML-Grammar-Fiction',
        "Format as dash is sane.",
    );

    # TEST
    is ($module->format_as('unix'), 'XML/Grammar/Fiction.pm',
        "Format as unix is sane.",
    );

    # TEST
    is ($module->format_as('rpm_dash'), 'perl-XML-Grammar-Fiction',
        "Format as rpm_dash is sane.",
    );

    # TEST
    is ($module->format_as('rpm_colon'), 'perl(XML::Grammar::Fiction)',
        "Format as rpm_colon is sane.",
    );

}
