package Module::Format::Module;

use warnings;
use strict;

=head1 NAME

Module::Format::Module - encapsulates a single Perl module.

=head1 SYNOPSIS

    use Module::Format::Module ();

    my $module = Module::Format::Module->from(
        {
            format => 'colon',
            value => 'XML::RSS',
        }
        );

    my $module = Module::Format::Module->from(
        {
            format => 'dash',
            value => 'XML-RSS',
        }
        );

    my $module = Module::Format::Module->from(
        {
            format => 'unix',
            value => 'XML/RSS.pm',
        }
        );

    my $module = Module::Format::Module->from(
        {
            format => 'rpm_dash',
            value => 'perl-XML-RSS',
        }
        );

    my $module = Module::Format::Module->from(
        {
            format => 'rpm_colon',
            value => 'perl(XML::RSS)',
        }
        );

    my $module = Module::Format::Module->from_guess(
        {
            value => # All of the above...
        }
    );

    # Prints "XML-RSS"
    print $module->format_as('dash'), "\n";

    # Prints "perl(XML::RSS)"
    print $module->format_as('rpm_colon'), "\n";

    # Prints "libxml-rss-perl"
    print $module->format_as('debian'), "\n";

=cut

sub _new
{
    my $class = shift;
    my $self  = bless {}, $class;
    $self->_init(@_);
    return $self;
}

sub _components
{
    my $self = shift;

    if (@_)
    {
        $self->{_components} = shift;
    }
    return $self->{_components};
}

sub _init
{
    my ( $self, $args ) = @_;

    $self->_components( [ @{ $args->{_components} } ] );

    return;
}

=head1 FUNCTIONS

=head2 my $module = Module::Format::Module->from_components({components => [@components]})

Constructs a module from @components which are strings that indicate the
individual components of the module. For example:

    my $module = Module::Format::Module->from_components(
        {
            components => [qw(XML Grammar Fiction)],
        }
    );

=cut

sub from_components
{
    my ( $class, $args ) = @_;

    return $class->_new( { _components => [ @{ $args->{components} } ] } );
}

=head2 my $module = Module::Format::Module->from({format => $format, value => $string});

Construct a Module::Format::Module object from the given format $format
and the string value $string .

Valid formats are:

=over 4

=item * 'colon'

Separated by a double colon, e.g: C<XML::RSS>, C<Data::Dumper>,
C<Catalyst::Plugin::Model::DBIx::Class>, etc.

=item * 'dash'

Separated by a double colon, e.g: C<XML-RSS>, C<Data-Dumper>,
C<Catalyst-Plugin-Model-DBIx-Class>, etc.

=item * 'unix'

UNIX path, e.g: C<XML/RSS.pm>, C<Catalyst/Plugin/Model/DBIx/Class.pm> .

This is commonly displayed in Perl error messages.

=item * 'rpm_dash'

Like dash, only with C<'perl-'> prefixed: C<perl-XML-RSS>, C<perl-Data-Dumper>.

=item * 'rpm_colon'

Like colon only wrapped inside C<perl(...)> - useful for rpm provides for
individual modules. E.g: C<perl(XML::RSS)>,
C<perl(Catalyst::Plugin::Authentication)> .

=item * 'metacpan_rel'

A MetaCPAN release page URL, e.g:
C<https://metacpan.org/release/Text-Sprintf-Named> , C<https://metacpan.org/release/Class-XSAccessor> .

=item * 'metacpan_pod'

A MetaCPAN POD page URL, e.g:
C<https://metacpan.org/pod/Module::Format> , C<https://metacpan.org/pod/Data::ParseBinary> .

=item * 'debian'

Debian package format, such as C<libxml-rss-perl>,
C<libcatalyst-plugin-authentication-perl> . Output only.

=item * 'freebsd_dash'

Like dash, only with C<'p5-'> prefixed: C<p5-XML-RSS>, C<p5-Data-Dumper>.

=back

=cut

my $dash_re      = qr{(?:\w+-)*\w+};
my $colon_re     = qr{(?:\w+::)*\w+};
my $METACPAN_REL = 'https://metacpan.org/release/';

sub _gen_dash_format
{
    my ($args) = @_;

    my $prefix = $args->{prefix};
    my $name   = $args->{name};

    return +{
        name  => $name,
        regex => qr{\A\Q$prefix\E$dash_re\z},
        input => sub {
            my ( $class, $value ) = @_;

            if ( $value !~ s{\A\Q$prefix\E}{} )
            {
                die "$name value does not start with the '$prefix' prefix.";
            }

            return $class->_calc_components_from_string(
                { format => 'dash', value => $value } );
        },
        format => sub {
            my ($self) = @_;

            return $prefix . $self->format_as('dash');
        },
    };
}

sub _gen_colon_format
{
    my ($args) = @_;

    my $prefix = $args->{prefix};
    my $suffix = $args->{suffix};
    my $name   = $args->{name};

    return +{
        name  => $name,
        regex => qr{\A\Q$prefix\E$colon_re\Q$suffix\E\z},
        input => sub {
            my ( $class, $value ) = @_;

            if ( $value !~ m{\A\Q$prefix\E((?:\w+::)*\w+)\Q$suffix\E\z} )
            {
                die "Improper value for $name";
            }

            return $class->_calc_components_from_string(
                { format => 'colon', value => $1 } );
        },
        format => sub {
            my ($self) = @_;

            return $prefix . $self->format_as('colon') . $suffix;
        },
    };
}

my @formats_by_priority = (
    _gen_dash_format(
        {
            name   => 'rpm_dash',
            prefix => 'perl-',
        }
    ),
    _gen_colon_format(
        {
            name   => 'rpm_colon',
            prefix => 'perl(',
            suffix => ')',
        }
    ),
    {
        name  => 'colon',
        regex => qr{\A$colon_re\z},
        input => sub {
            my ( $class, $value ) = @_;
            return [ split( /::/, $value, -1 ) ];
        },
        format => sub {
            my ($self) = @_;

            return join( '::', @{ $self->_components() } );
        },
    },
    {
        name  => 'dash',
        regex => qr{\A$dash_re\z},
        input => sub {
            my ( $class, $value ) = @_;
            return [ split( /-/, $value, -1 ) ];
        },
        format => sub {
            my ($self) = @_;

            return join( '-', @{ $self->_components() } );
        },
    },
    {
        name  => 'unix',
        regex => qr{\A(?:\w+/)*\w+\.pm\z},
        input => sub {
            my ( $class, $value ) = @_;

            if ( $value !~ s{\.pm\z}{} )
            {
                die "Cannot find a .pm suffix in the 'unix' format.";
            }

            return [ split( m{/}, $value, -1 ) ];
        },
        format => sub {
            my ($self) = @_;

            return join( '/', @{ $self->_components() } ) . '.pm';
        },
    },
    _gen_dash_format(
        {
            name   => 'metacpan_rel',
            prefix => $METACPAN_REL,
        }
    ),
    _gen_colon_format(
        {
            name   => 'metacpan_pod',
            prefix => 'https://metacpan.org/pod/',
            suffix => '',
        }
    ),
    {
        name   => 'debian',
        format => sub {
            my ($self) = @_;

            return 'lib' . lc( $self->format_as('dash') ) . '-perl';
        },
    },
    _gen_dash_format(
        {
            name   => 'freebsd_dash',
            prefix => 'p5-',
        }
    ),
);

my %formats = ( map { $_->{name} => $_ } @formats_by_priority );

sub _calc_components_from_string
{
    my ( $class, $args ) = @_;

    my $format = $args->{format};
    my $value  = $args->{value};

    if ( exists( $formats{$format} ) )
    {
        if ( my $handler = $formats{$format}->{'input'} )
        {
            return $class->$handler($value);
        }
        else
        {
            die "Format $format is output-only!";
        }
    }
    else
    {
        die "Unknown format '$format'!";
    }
}

sub from
{
    my ( $class, $args ) = @_;

    my $format = $args->{format};
    my $value  = $args->{value};

    return $class->_new(
        {
            _components => $class->_calc_components_from_string($args)
        }
    );
}

=head2 my $array_ref = $module->get_components_list()

Returns the components list of the module as an array reference. For
example for the module C<One::Two::Three> it would be
C<["One", "Two", "Three"]>.

=cut

sub get_components_list
{
    my $self = shift;

    return [ @{ $self->_components() } ];
}

=head2 $module->format_as($format)

Format the module in the given format. See from() for a list.

=cut

sub format_as
{
    my ( $self, $format ) = @_;

    if ( exists( $formats{$format} ) )
    {
        my $handler = $formats{$format}->{'format'};
        return $self->$handler();
    }
    else
    {
        die "Unknown format '$format';";
    }

    return;
}

=head2 my $clone = $module->clone()

Duplicates the object.

=cut

sub clone
{
    my $self = shift;

    return
        ref($self)
        ->from_components( { components => $self->get_components_list() } );
}

=head2 my $bool = $module->is_sane();

Returns a boolean depending on if the component of the module do not contain
any funny character (only alphanumeric characters and underscore.).

=cut

sub _all
{
    my ( $cb, $l ) = @_;

    foreach (@$l)
    {
        if ( not $cb->($_) )
        {
            return;
        }
    }

    return 1;
}

sub is_sane
{
    my $self = shift;

    return _all( sub { m{\A\w+\z}; }, $self->_components() );
}

=head2 my $module = Module::Format::Module->from_guess({ value => $string});

Initialises a module object from a string while trying to guess its format.
It accepts a hash-ref with the following keys: C<'value'> that points to the
string to serve as an input, and an optional C<'format_ref'> that will give
the format that was decided upon.

=cut

sub from_guess
{
    my ( $class, $args ) = @_;

    my $dummy_format_string;

    my $string         = $args->{value};
    my $out_format_ref = ( $args->{format_ref} || ( \$dummy_format_string ) );

    # TODO : After the previous line the indentation in vim is reset to the
    # first column.

    foreach my $format_record (@formats_by_priority)
    {
        if ( my $regex = $format_record->{regex} )
        {
            if ( $string =~ $regex )
            {
                my $format_id = $format_record->{name};

                ${$out_format_ref} = $format_id;

                return $class->from(
                    { value => $string, format => $format_id, } );
            }
        }
    }

    die "Could not guess the format of the value '$string'!";
}

1;    # End of Module::Format::Module
