package TravelDance::Schema::Result::Location;

=head1 NAME

TravelDance::Schema::Result::Location

=head1 DESCRIPTION

Locations including (possibly) geo data and address.

=head1 COMPONENTS

The following components are loaded:

=over

=item * L<InflateColumn::DateTime|DBIx::Class::InflateColumn::DateTime>

=item * L<TimeStamp|DBIx::Class::TimeStamp>

=back

=cut

use TravelDance::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 ACCESSORS

=head2 locations_id

Primary key.

=cut

primary_column locations_id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 address

First line of address. Defaults to empty string.

=cut

column address => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 address_2

Second line of address. Defaults to empty string.

=cut

column address_2 => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 postal_code

Postal/zip code. Defaults to empty string.

=cut

column postal_code => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 city

City/town name. Defaults to empty string.

=cut

column city => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 region

Region/state/province. Defaults to empty string.

=cut

column region => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 country_iso_code

Two character country ISO code. Foreign key constraint on
L<TravelDance::Schema::Result::Country/country_iso_code> via L</country>
relationship.

A location B<usually> has a country but not if it is in a neutral zone like
in the middle of an ocean so this is nullable.

=cut

column country_iso_code => {
    data_type      => "char",
    size           => 2,
    is_foreign_key => 1,
    is_nullable    => 1,
};

=head2 visited

Date and time when this location was visited returned as L<DateTime> object.
Value is auto-set on insert if not supplied in new/create.

=cut

column visited => {
    data_type     => "datetime",
    set_on_create => 1,
};

=head2 users_id

Foreign key constraint on L<TravelDance::Schema::Result::User/users_id>
via L</user> relationship.

=cut

column users_id => {
    data_type      => "integer",
    is_foreign_key => 1,
};

=head1 RELATIONSHIPS

=head2 country

Type: belongs_to

Related object: L<TravelDance::Schema::Result::Country>

Since L</country_iso_code> is nullable we force a LEFT JOIN here.

=cut

belongs_to
  country => "TravelDance::Schema::Result::Country",
  "country_iso_code", { join_type => 'left' };

=head2 user

Type: belongs_to

Related object: L<TravelDance::Schema::Result::User>

=cut

belongs_to
  user => "TravelDance::Schema::Result::User",
  { users_id => "users_id" };

=head1 METHODS

=cut

1;
