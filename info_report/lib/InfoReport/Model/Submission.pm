package InfoReport::Model::Submission;

use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    croak "bad arguments" unless 
        defined $self->{id} and 
        defined $self->{username} and
        defined $self->{problem} and
        defined $self->{competition} and
        defined $self->{size} and
        defined $self->{date} and
        defined $self->{status} and
        defined $self->{score};
    return bless { %args }, $class;
}
