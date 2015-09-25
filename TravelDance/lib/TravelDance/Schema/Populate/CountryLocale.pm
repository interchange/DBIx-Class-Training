package TravelDance::Schema::Populate::CountryLocale;

=head1 NAME

TravelDance::Schema::Populate::CountryLocale

=head1 DESCRIPTION

This module provides population capabilities for the Country class

=cut

use strict;
use warnings;

use Locale::SubCountry;
use Moo;

=head1 METHODS

=head2 records

Returns array reference containing one hash reference per country
ready to populate L<TravelDance::Schema::Result::Country>.

=cut

sub records {
    my $world     = Locale::SubCountry::World->new;
    my %countries = $world->code_full_name_hash;

    my @countries =
      map { { country_iso_code => $_, name => $countries{$_} } }
      sort keys %countries;

    return \@countries;
}

1;
