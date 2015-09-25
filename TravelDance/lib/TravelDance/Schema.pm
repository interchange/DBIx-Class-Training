package TravelDance::Schema;

=head1 NAME

TravelDance::Schema - Database schema class loader for TravelDance

=cut

use warnings;
use strict;

use base 'DBIx::Class::Schema';

=head1 COMPONENTS

The following components are currently loaded:

=over

=item * none

=back

=cut

__PACKAGE__->load_components();

=head1 NAMESPACES

=head2 default_resultset_class => 'ResultSet'

Our custom default ResultSet class for Result classes with no corresponding
ResultSet. The full class name is L<TravelDance::Schema::ResultSet>. This
class must be used as base (parent) for any ResultSet classes we create.

=cut

__PACKAGE__->load_namespaces( default_resultset_class => 'ResultSet', );

1;
