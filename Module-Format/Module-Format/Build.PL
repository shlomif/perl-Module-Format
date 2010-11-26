use strict;
use warnings;

use lib "./inc";

use Test::Run::Builder;

my $builder = Test::Run::Builder->new(
    module_name         => 'Module::Format',
    license             => 'mit',
    dist_author         => q{Shlomi Fish <shlomif@cpan.org>},
    dist_version_from   => 'lib/Module/Format.pm',
    requires =>
    {
        'List::MoreUtils' => 0,
    },
    build_requires =>
    {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Module-Format-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
