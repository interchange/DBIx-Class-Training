package TravelDance::Schema::Result::User;

=head1 NAME

TravelDance::Schema::Result::User

=head1 DESCRIPTION

Users (people).

=head1 COMPONENTS

The following components are loaded:

=over

=item * L<InflateColumn::DateTime|DBIx::Class::InflateColumn::DateTime>

=item * L<PassphraseColumn|DBIx::Class::PassphraseColumn>

=item * L<TimeStamp|DBIx::Class::TimeStamp>

=back

=cut

use TravelDance::Schema::Candy -components =>
  [qw(InflateColumn::DateTime PassphraseColumn TimeStamp)];

use Class::Method::Modifiers;
use DateTime;

=head1 ACCESSORS

=head2 users_id

Primary key.

=cut

primary_column users_id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 username

We need to check that username is not undefined or empty and also convert it
to lowercase since we want case-insensitive uniqueness.

=cut

unique_column username => {
    data_type => "varchar",
    size      => 255,
    accessor  => '_username',
};

sub username {
    my $self = shift;
    if (@_) {
        my $value = shift;
        $value = check_username($value);
        $self->_username($value);
    }
    return $self->_username();
}

=head2 nickname

Unique nickname for user.

Is nullable.

=cut

unique_column nickname => {
    data_type   => "varchar",
    is_nullable => 1,
    size        => 255,
};

=head2 email

email address.

=cut

column email => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 password

Hashed password using L<Authen::Passphrase::BlowfishCrypt>. Check password
method is C<check_password>.

=cut

column password => {
    data_type        => "text",
    default_value    => "",
    passphrase       => 'rfc2307',
    passphrase_class => 'BlowfishCrypt',
    passphrase_args  => {
        cost        => 14,
        key_nul     => 1,
        salt_random => 1,
    },
    passphrase_check_method => 'check_password',
};

around 'check_password' => sub {
    my $orig = shift;
    my $self = shift;
    my $ret  = $orig->( $self, @_ );
    if ($ret) {
        $self->update( { fail_count => 0, last_login => DateTime->now } );
    }
    else {
        $self->update( { fail_count => ( $self->fail_count || 0 ) + 1 } );
    }
    return $ret;
};

=head2 first_name

User's first name.

=cut

column first_name => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 last_name

User's last name.

=cut

column last_name => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 last_login

Last login returned as L<DateTime> object. Updated on successful call to
C<check_password>.

=cut

column last_login => {
    data_type   => "datetime",
    is_nullable => 1,
};

=head2 fail_count

Count of failed logins since last successful login. On successful call to
C<check_password> gets reset to zero but on fail is incremented.

=cut

column fail_count => {
    data_type     => "integer",
    default_value => 0,
};

=head2 created

Date and time when this record was created returned as L<DateTime> object.
Value is auto-set on insert.

=cut

column created => {
    data_type     => "datetime",
    set_on_create => 1,
};

=head2 last_modified

Date and time when this record was last modified returned as L<DateTime> object.
Value is auto-set on insert and update.

=cut

column last_modified => {
    data_type     => "datetime",
    set_on_create => 1,
    set_on_update => 1,
};

=head1 RELATIONSHIPS

=head2 locations

Type: has_many

Related object: L<TravelDance::Schema::Result::Location>

=cut

has_many locations => "TravelDance::Schema::Result::Location", "users_id";

=head2 countries

Type: many_to_many

Composing relationships: L</locations> -> user

=cut

many_to_many countries => "locations", "country";

=head1 METHODS

=head2 new

Overloaded method.

Check username using L</check_username>.

=cut

sub new {
    my ( $class, $attrs ) = @_;
    $attrs->{username} = check_username( $attrs->{username} );
    return $class->next::method($attrs);
}

=head2 update

Overloaded method. Check username using L</check_username> if supplied.

=cut

sub update {
    my ( $self, $upd ) = @_;

    my $username;

    # username may have been passed as arg or previously set

    if ( exists $upd->{username} ) {
        $upd->{username} = check_username( $upd->{username} );
    }

    return $self->next::method($upd);
}

=head2 check_username( $username )

Die if C<$username> is undef or empty string. Otherwise return C<lc($username)>

=cut

sub check_username {
    my $value = shift;
    die "username cannot be undef" unless defined $value;
    $value =~ s/(^\s+|\s+$)//g;
    die "username cannot be empty string" if $value eq '';
    return lc($value);
}

1;
