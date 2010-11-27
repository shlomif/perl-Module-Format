package Module::Format::ModuleList;

use warnings;
use strict;

=head1 NAME

Module::Format::ModuleList - an ordered list of L<Module::Format::Module>.

=head1 VERSION

Version 0.0.1

=cut

our $VERSION = '0.0.1';

=head1 SYNOPSIS

    use Module::Format::ModuleList;

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

use Module::Format::Module;

=head2 my $list = Module::Format::ModuleList->new({ modules => \@list})

The generic constructor. Initialises a new module list from a @list which
must be an array of L<Module::Format::Module> modules.

=cut

sub new
{
    my $class = shift;
    my $self = bless {}, $class;
    $self->_init(@_);
    return $self;
}

sub _modules
{
    my $self = shift;

    if (@_) {
        $self->{_modules} = shift;
    }

    return $self->{_modules};
}

sub _add_module
{
    my ($self, $module) = @_;

    if (not $module->isa('Module::Format::Module'))
    {
        die "Module is " . ref($module) . " instead of Module::Format::Module.";
    }

    push @{$self->_modules()}, $module;

    return;
}

sub _init
{
    my ($self, $args) = @_;

    $self->_modules([]);

    foreach my $module (@{$args->{modules}})
    {
        $self->_add_module($module);
    }

    return;
}

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/>

=head1 BUGS

Please report any bugs or feature requests to C<bug-module-format at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Module-Format>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Module::Format::ModuleList


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Module-Format>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Module-Format>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Module-Format>

=item * Search CPAN

L<http://search.cpan.org/dist/Module-Format/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2010 Shlomi Fish.

This program is distributed under the MIT (X11) License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.


=cut

1; # End of Module::Format::ModuleList
