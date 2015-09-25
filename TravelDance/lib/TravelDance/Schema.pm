package TravelDance::Schema;

=head1 NAME

TravelDance::Schema - Database schema class loader for TravelDance

=cut

use warnings;
use strict;

use base 'DBIx::Class::Schema';
use TravelDance::Schema::Populate::CountryLocale;

=head1 COMPONENTS

The following components are currently loaded:

=over

=item * none

=back

=cut

__PACKAGE__->load_components();

=head1 METHODS

=head2 deploy

Override L<DBIx::Class::Schema/deploy> in order to populate the Country class
using L<TravelDance::Schema::Populate::CountryLocale>.

=cut

sub deploy {
    my $self = shift;
    my $new  = $self->next::method(@_);

    my $pop_country =
      TravelDance::Schema::Populate::CountryLocale->new->records;

    $self->resultset('Country')->populate($pop_country)
      or die "Failed to populate Country";
}

=head1 NAMESPACES

=head2 default_resultset_class => 'ResultSet'

Our custom default ResultSet class for Result classes with no corresponding
ResultSet. The full class name is L<TravelDance::Schema::ResultSet>. This
class must be used as base (parent) for any ResultSet classes we create.

=cut

__PACKAGE__->load_namespaces( default_resultset_class => 'ResultSet', );

1;
