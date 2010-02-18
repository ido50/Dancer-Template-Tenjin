package Dancer::Template::Tenjin;

use warnings;
use strict;
use Dancer::ModuleLoader;
use Dancer::FileUtils 'path';

use base 'Dancer::Template::Abstract';

our $VERSION = 0.1;

our $ENGINE;

sub init {
	my $self = shift;

	die "Tenjin is needed by Dancer::Template::Tenjin"
		unless Dancer::ModuleLoader->load('Tenjin');

	# set Tenjin configuration options
	my $conf = { postfix => '.tt' };

	$conf->{path} = path($self->{settings}{'appdir'}, 'views')
		if $self->{settings} && $self->{settings}{'appdir'};

	# get an instance of Tenjin
	$ENGINE = Tenjin->new($conf);
}

sub render($$$) {
	my ($self, $template, $tokens) = @_;

	die "'$template' is not a regular file"
		if !ref($template) && (!-f $template);

	# ignore 'bad' tokens - this is here because for some reason
	# Dancer is passing the entire user agent as a token, and I can't
	# find the cause of that yet.
	my %vars = %$tokens;
	foreach (keys %vars) {
		delete $vars{$_} if m/[ ()]/;
	}

	return $ENGINE->render($template, \%vars) or die $ENGINE->error;
}

1;

__END__

=pod

=head1 NAME

Dancer::Template::Tenjin - Tenjin wrapper for Dancer

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

	# in your config.yml
	template: "tenjin"

	# note: templates must used the '.tt' extension

=head1 DESCRIPTION

This class is an interface between Dancer's template engine abstraction layer
and the L<Tenjin> module.

Tenjin is a fast and feature-full templating engine that can be used by
Dancer for production purposes. In comparison to L<Template::Toolkit|Template>,
it is much more lightweight, has almost no dependencies, and supports
embedded Perl code instead of defining its own language.

In order to use this engine, you need to set your webapp's template engine
in your app's configuration file (config.yml) like so:

    template: "tenjin"

You can also directly set it in your app code with the B<set> keyword.

Now you can create Tenjin templates normally, but note that due to a
Dancer restriction your templates files must end in the '.tt' extension.

=head1 SEE ALSO

L<Dancer>, L<Tenjin>

=head1 AUTHOR

Ido Perlmuter, C<< <ido at ido50.net> >>

=head1 TODO

=over 2

=item * Non-file sources

Find a way to allow using templates from other source, such as
a database, just like in L<Catalyst::View::Tenjin>.

=item * Fine-tune Tenjin

Allow passing arguments to Tenjin, such as USE_STRICT.

=back

=head1 BUGS

Please report any bugs or feature requests to C<bug-dancer-template-tenjin at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Dancer-Template-Tenjin>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Dancer::Template::Tenjin

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dancer-Template-Tenjin>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Dancer-Template-Tenjin>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Dancer-Template-Tenjin>

=item * Search CPAN

L<http://search.cpan.org/dist/Dancer-Template-Tenjin/>

=back

=head1 ACKNOWLEDGEMENTS

Alexis Sukrieh, author of L<Dancer>, who wrote L<Dancer::Template::Toolkit>,
on which this module is based.

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Ido Perlmuter.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
