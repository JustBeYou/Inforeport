package InfoReport::Schema;

# based on the DBIx::Class Schema base class
use base qw/DBIx::Class::Schema/;

# This will load any classes within
# Moblo::Schema::Result and Moblo::Schema::ResultSet (if any)
__PACKAGE__->load_namespaces();

sub getConnection {
    my $self = shift;
    return $self->connection('dbi:SQLite:inforeport.db');
}
