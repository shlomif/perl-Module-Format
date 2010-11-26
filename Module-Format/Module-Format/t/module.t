use strict;
use warnings;

use Test::More tests => 41;

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

{
    my $module = Module::Format::Module->from(
        {
            format => 'rpm_colon',
            value => 'perl(HTML::TreeBuilder::LibXML)',
        }
    );

    # TEST
    ok ($module);

    # TEST
    is_deeply(
        $module->get_components_list(),
        [qw(HTML TreeBuilder LibXML)],
        "from rpm_colon get_components_list() is sane.",
    );

    # TEST
    is ($module->format_as('colon'), 'HTML::TreeBuilder::LibXML',
        "from rpm_colon Format as colon is sane."
    );

    # TEST
    is ($module->format_as('dash'),  'HTML-TreeBuilder-LibXML',
        "from rpm_colon Format as dash is sane.",
    );
}

{
    my $module = Module::Format::Module->from(
        {
            format => 'rpm_dash',
            value => 'perl-HTML-TreeBuilder-LibXML',
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
    my $orig_module = Module::Format::Module->from(
        {
            format => 'colon',
            value => 'XML::Grammar::Fiction',
        }
    );

    # TEST
    ok ($orig_module, '$orig_module is defined');

    my $clone = $orig_module->clone();

    # TEST
    ok ($clone, '$clone is defined');

    # TEST
    is_deeply(
        $clone->get_components_list(),
        [qw(XML Grammar Fiction)],
        "get_components_list() is sane.",
    );

    # TEST
    is ($clone->format_as('colon'), 'XML::Grammar::Fiction',
        "Format as colon is sane."
    );

    # TEST
    is ($clone->format_as('dash'), 'XML-Grammar-Fiction',
        "Format as dash is sane.",
    );

    # TEST
    is ($clone->format_as('unix'), 'XML/Grammar/Fiction.pm',
        "Format as unix is sane.",
    );

    # TEST
    is ($clone->format_as('rpm_dash'), 'perl-XML-Grammar-Fiction',
        "Format as rpm_dash is sane.",
    );

    # TEST
    is ($clone->format_as('rpm_colon'), 'perl(XML::Grammar::Fiction)',
        "Format as rpm_colon is sane.",
    );

}

{
    my $module = Module::Format::Module->from_components(
        {
            components => [qw(XML Grammar Fiction)],
        }
    );

    # TEST
    ok ($module, '$module is defined');

    # TEST
    ok ($module, '$clone is defined');

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
    my $module = Module::Format::Module->from_components(
        {
            components => [qw(XML Grammar Fiction)],
        }
    );

    # TEST
    ok (scalar($module->is_sane()), "Module is sane.");
}

{
    my $module = Module::Format::Module->from_components(
        {
            components => ['XML', 'F@L',],
        }
    );

    # TEST
    ok (!scalar($module->is_sane()), "Module is not sane.");
}


