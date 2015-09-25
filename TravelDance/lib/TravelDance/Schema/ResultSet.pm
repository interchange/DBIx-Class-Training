package TravelDance::Schema::ResultSet;

=head1 NAME

TravelDance::Schema::ResultSet - the default ResultSet class for TravelDance

=cut

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

=head1 DESCRIPTION

This is the default ResultSet class from which all custom ResultSet
classes must inherit. It is also defined as the default resultset class
in L<TravelDance::Schema>.

We use this class to load components that we want to make available to all
of our resultsets.

=head1 COMPONENTS

The following components are loaded:

=over

=item * none

=back

=cut

__PACKAGE__->load_components();

1;
