package InfoReport::Model::Submission;

use strict;
use warnings;

sub new {
    my ($class, %args) = @_;

    my $date = $args{date};
    $date =~ m/(\d+) ([a-z]+) (\d+)/; # day
    $args{day} = $1;
    $args{month} = $2;
    $args{year} = '20'.$3;

    return bless { %args }, $class;
}

1;
