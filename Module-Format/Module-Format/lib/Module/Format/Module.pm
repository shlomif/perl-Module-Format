package Module::Format::Module;

use warnings;
use strict;

=head1 NAME

Module::Format::Module - encapsulates a single Perl module.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Module::Format::Module;

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
    my $self = bless {}, $class;
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
    my ($self, $args) = @_;

    $self->_components([ @{ $args->{_components} } ]);

    return;
}

=head1 FUNCTIONS

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

=back

=cut

sub from
{
    my ($class, $args) = @_;

    my $format = $args->{format};
    my $value = $args->{value};

    my @components;

    if ($format eq 'colon')
    {
        @components = split(/::/, $value, -1);
    }
    elsif ($format eq 'dash')
    {
        @components = split(/-/, $value, -1);
    }
    elsif ($format eq 'unix')
    {
        if ($value !~ s{\.pm\z}{})
        {
            die "Cannot find a .pm suffix in the 'unix' format.";
        }

        @components = split(m{/}, $value, -1);
    }
    elsif ($format eq 'rpm_colon')
    {
        if ($value !~ m{\Aperl\(((?:\w+::)*\w+)\)\z})
        {
            die "Improper value for rpm_colon";
        }
        return $class->from({format => 'colon', value => $1});
    }
    else
    {
        die "Unknown format '$format'!";
    }

    return $class->_new({_components => \@components});
}

=head2 my $array_ref = $module->get_components_list()

Returns the components list of the module as an array reference. For
example for the module C<One::Two::Three> it would be 
C<["One", "Two", "Three"]>.

=cut

sub get_components_list
{
    my $self = shift;

    return [ @{$self->_components()} ];
}

=head2 $module->format_as($format)

Format the module in the given format. See from() for a list.

=cut

sub format_as
{
    my ($self, $format) = @_;

    if ($format eq 'colon')
    {
        return join('::', @{$self->_components()});
    }
    elsif ($format eq 'dash')
    {
        return join('-', @{$self->_components()});
    }
    elsif ($format eq 'unix')
    {
        return join('/', @{$self->_components()}) . '.pm';
    }
    elsif ($format eq 'rpm_dash')
    {
        return 'perl-' . $self->format_as('dash');
    }
    elsif ($format eq 'rpm_colon')
    {
        return 'perl(' . $self->format_as('colon') . ')';
    }
    else
    {
        die "Unknown format '$format'";
    }

    return;
}

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/> .

=head1 BUGS

Please report any bugs or feature requests to C<bug-module-format at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Module-Format>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Module::Format::Module


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

1; # End of Module::Format::Module
