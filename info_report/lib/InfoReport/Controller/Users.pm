package InfoReport::Controller::Users;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';
use InfoReport::Model::Users;

sub userGET {
    my $self = shift;

    my $data = InfoReport::Model::Users::readUserData($self->param('username'));
    my %defaultResponse = (message => 'Report for user '.$self->param('username').' not found.');

    if (defined $data) {
        return $self->render(
            json => {"message" => "TODO"}, 
        );
    }

    return $self->render(
        json => \%defaultResponse,
    );
}

sub userPOST {
    my $self = shift;
    InfoReport::Model::Users::updateUserData($self->param('username'));

    return $self->render(
        json => {message => ''},
    );
}

sub changedGET {
    my $self = shift;
    return $self->render(
        json => {message => 'Not implemented'},
    );
}

1;
