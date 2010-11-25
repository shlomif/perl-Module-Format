use strict;
use warnings;

use Test::More tests => 15;

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

{
    my $module = Module::Format::Module->from(
        {
            format => 'dash',
            value => 'HTML-TreeBuilder-LibXML',
        }
    );

    # TEST
    ok ($module);

    # TEST
    is_deeply(
        $module->get_components_list(),
        [qw(HTML TreeBuilder LibXML)],
        "get_components_list() is sane.",
    );

    # TEST
    is ($module->format_as('colon'), 'HTML::TreeBuilder::LibXML',
        "Format as colon is sane."
    );

    # TEST
    is ($module->format_as('dash'),  'HTML-TreeBuilder-LibXML',
        "Format as dash is sane.",
    );
}

{
    my $module = Module::Format::Module->from(
        {
            format => 'unix',
            value => 'HTML/TreeBuilder/LibXML.pm',
        }
    );

    # TEST
    ok ($module);

    # TEST
    is_deeply(
        $module->get_components_list(),
        [qw(HTML TreeBuilder LibXML)],
        "get_components_list() is sane.",
    );

    # TEST
    is ($module->format_as('colon'), 'HTML::TreeBuilder::LibXML',
        "Format as colon is sane."
    );

    # TEST
    is ($module->format_as('dash'),  'HTML-TreeBuilder-LibXML',
        "Format as dash is sane.",
    );
}
