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
        'Getopt::Long' => '2.36',
        'List::MoreUtils' => 0,
        'Pod::Usage' => 0,
        'strict' => 0,
        'warnings' => 0,
    },
    build_requires =>
    {
        'Test::More' => 0,
        'vars' => 0,
    },
    configure_requires =>
    {
        'Module::Build' => 0,
    },
    add_to_cleanup      => [ 'Module-Format-*' ],
    create_makefile_pl => 'traditional',
    script_files => ["script/perlmf"],
);

$builder->create_build_script();
