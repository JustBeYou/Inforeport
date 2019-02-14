package InfoReport::Controller::Users;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';
use InfoReport::Model::Users;

sub userGET {
    my $self = shift;

    if (not InfoReport::Model::Users::checkIfUserExists($self->param('username'))) {
        print "Username does not exists: ".$self->param('username')."\n";

        my %notFound = (message => 'User '.$self->param('username').' not found or it does not have any submissions.');
        return $self->render(
            json => \%notFound,
        );
    }

    my $data = InfoReport::Model::Users::readUserData($self->param('username'));
    my %defaultResponse = (message => 'Report for user '.$self->param('username').' not found.');

    if (defined $data) {
        my %hashData = InfoReport::Model::Users::userQueryDataToHash($data);

        return $self->render(
            json => \%hashData,
        );
    }

    return $self->render(
        status => 404,
        json => \%defaultResponse,
    );
}

sub userPOST {
    my $self = shift;

    if (not InfoReport::Model::Users::checkIfUserExists($self->param('username'))) {
        my %notFound = (message => 'User '.$self->param('username').' not found or it does not have any submissions.');
        return $self->render(
            json => \%notFound,
        );
    }    

    InfoReport::Model::Users::updateUserData($self->param('username'));
    my $data = InfoReport::Model::Users::readUserData($self->param('username'));
    my %hashData = InfoReport::Model::Users::userQueryDataToHash($data);

    return $self->render(
        json => \%hashData,
    );
}

sub changedGET {
    my $self = shift;
    return $self->render(
        json => {
            value => InfoReport::Model::Users::checkIfUserChanged($self->param('username')),
            username => $self->param('username'),
        },
    );
}

1;
