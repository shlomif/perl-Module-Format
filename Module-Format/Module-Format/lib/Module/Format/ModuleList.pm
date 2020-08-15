package Module::Format::ModuleList;

use warnings;
use strict;

=head1 NAME

Module::Format::ModuleList - an ordered list of L<Module::Format::Module>.

=head1 SYNOPSIS

    use Module::Format::Module ();
    use Module::Format::ModuleList ();

    my $list = Module::Format::ModuleList->new(
        {
            modules =>
            [
                Module::Format::Module->from_guess({ value => 'XML::RSS'}),
                Module::Format::Module->from_guess({ value => 'Data-Dumper'}),
            ],
        }
    );

    foreach my $name (@{$list->format_as('rpm_colon')})
    {
        print "$name\n";
    }

    my $list = Module::Format::ModuleList->sane_from_guesses(
        {
            values =>
            [qw/
                Algorithm::Permutations
                rpm(Foo::Bar::Baz)
                perl-HTML-TreeBuilder-LibXML
            /],
        },
    )

=head1 FUNCTIONS

=cut

use Module::Format::Module ();

=head2 my $list = Module::Format::ModuleList->new({ modules => \@list})

The generic constructor. Initialises a new module list from a @list which
must be an array of L<Module::Format::Module> modules.

=cut

sub new
{
    my $class = shift;
    my $self  = bless {}, $class;
    $self->_init(@_);
    return $self;
}

sub _modules
{
    my $self = shift;

    if (@_)
    {
        $self->{_modules} = shift;
    }

    return $self->{_modules};
}

sub _add_module
{
    my ( $self, $module ) = @_;

    if ( not $module->isa('Module::Format::Module') )
    {
        die "Module is " . ref($module) . " instead of Module::Format::Module.";
    }

    push @{ $self->_modules() }, $module;

    return;
}

sub _init
{
    my ( $self, $args ) = @_;

    $self->_modules( [] );

    foreach my $module ( @{ $args->{modules} } )
    {
        $self->_add_module($module);
    }

    return;
}

=head2 my $array_ref = $self->get_modules_list_copy()

Returns a shallow copy of the modules list contained in the object. Useful
for debugging.

=cut

sub get_modules_list_copy
{
    my ($self) = @_;

    return [ @{ $self->_modules() } ];
}

=head2 my $array_ref_of_strings = $list->format_as($format)

Returns a list containing all the modules formatted in the $format . See
L<Module::Format::Module> for the available formats.

=cut

sub format_as
{
    my ( $self, $format ) = @_;

    return [ map { $_->format_as($format) } @{ $self->_modules() } ];
}

=head2 my $list_obj = Module::Format::ModuleList->sane_from_guesses({values => \@list_of_strings});

Initialises a module list object from a list of strings by using
L<Module::Format::Module>'s from_guess on each string and while checking the
guesses for sanity. See the synposis for an example.

=cut

sub sane_from_guesses
{
    my ( $class, $args ) = @_;

    my @modules;

    foreach my $string ( @{ $args->{'values'} } )
    {
        my $module = Module::Format::Module->from_guess( { value => $string } );

        if ( !$module->is_sane() )
        {
            die "Value '$string' does not evaluate as a sane module.";
        }

        push @modules, $module;
    }

    return $class->new( { modules => \@modules } );
}

1;    # End of Module::Format::ModuleList
