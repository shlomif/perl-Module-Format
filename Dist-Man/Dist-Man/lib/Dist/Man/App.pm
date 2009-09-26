package Dist::Man::App;

=head1 NAME

Dist::Man::App - the code behind the command line program

=cut

use warnings;
use strict;

our $VERSION = '0.0.3';

use Getopt::Long;
use Pod::Usage;
use Carp qw( croak );

sub _config_read {
    my $filename = shift;

    return unless -e $filename;

    open( my $config_file, '<', $filename )
        or die "couldn't open config file $filename: $!\n";

    my %config;
    while (<$config_file>) {
        chomp;
        next if /\A\s*\Z/sm;
        if (/\A(\w+):\s*(.+)\Z/sm) { $config{$1} = $2; }
    }
    return %config;
}

=head2 run

  Dist::Man::App->run;

This is equivalent to running F<pl-dist-man>.  Its behavior is still subject
to change.

=cut

sub run
{
    my $configdir = $ENV{MODULE_STARTER_DIR} || '';
    if ( !$configdir && $ENV{HOME} ) {
        $configdir = "$ENV{HOME}/.perl-dist-man";
    }

    my %config    = _config_read( "$configdir/config" );

    # The options that accept multiple arguments must be set to an
    # arrayref

    $config{plugins} = [ split /(?:\s*,\s*|\s+)/, $config{plugins} ] if $config{plugins};
    $config{builder} = [ split /(?:\s*,\s*|\s+)/, $config{builder} ] if $config{builder};

    foreach my $key ( qw( plugins modules builder ) ){
        $config{$key} = [] unless exists $config{$key};
    }

    pod2usage(2) unless @ARGV;
    my $operation = shift(@ARGV);

    GetOptions(
        'class=s'    => \$config{class},
        'plugin=s'   => $config{plugins},
        'dir=s'      => \$config{dir},
        'distro=s'   => \$config{distro},
        'module=s'   => $config{modules},
        'builder=s'  => $config{builder},
        eumm         => sub { push @{$config{builder}}, 'ExtUtils::MakeMaker' },
        mb           => sub { push @{$config{builder}}, 'Module::Build' },
        mi           => sub { push @{$config{builder}}, 'Module::Install' },

        'author=s'   => \$config{author},
        'email=s'    => \$config{email},
        'license=s'  => \$config{license},
        force        => \$config{force},
        verbose      => \$config{verbose},
        version      => 
            sub {
                require Dist::Man;
                print "pl-dist-man v$Dist::Man::VERSION\n";
                exit 1;
            },
        help         => sub { pod2usage(1); },
    ) or pod2usage(2);

    if (@ARGV) {
        pod2usage(
            -msg =>  "Unparseable arguments received: " . join(',', @ARGV),
            -exitval => 2,
        );
    }


    $config{class} ||= 'Dist::Man';

    $config{builder} = ['ExtUtils::MakeMaker'] unless @{$config{builder}};

    eval "require $config{class};";
    croak "invalid manager class $config{class}: $@" if $@;
    $config{class}->import(@{$config{plugins}});

    if (! ( ($operation eq "setup") || ($operation eq "create") ) )
    {
        pod2usage(
            -msg => "Not a valid operation - '$operation'",
            -exitval => 2,
        );
    }

    $config{class}->create_distro( %config );

    print "Created manager directories and files\n";
}

1;
