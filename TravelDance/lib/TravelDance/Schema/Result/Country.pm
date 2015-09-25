package TravelDance::Schema::Result::Country;

=head1 NAME

TravelDance::Schema::Result::Country

=head1 DESCRIPTION

ISO 3166-1 codes for country identification

=head1 COMPONENTS

The following components are loaded:

=over

=item * none

=back

=cut

use TravelDance::Schema::Candy;

=head1 ACCESSORS

=head2 country_iso_code

Primary key.

Two letter country code such as 'SI' = Slovenia.

=cut

primary_column country_iso_code => { data_type => "char", size => 2 };

=head2 name

Full country name.

=cut

column name => { data_type => "varchar", size => 255 };

=head1 RELATIONSHIPS

=head2 locations

Type: has_many

Related object: L<TravelDance::Schema::Result::Location>

=cut

has_many
  locations => "TravelDance::Schema::Result::Location",
  'country_iso_code';

=head2 users

Type: many_to_many

Composing relationships: L</locations> -> user

=cut

has_many users => "locations", "user";

=head1 METHODS

1;
