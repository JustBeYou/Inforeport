package InfoReport::Controller::Index;
use Mojo::Base 'Mojolicious::Controller';

sub home {
    my $self = shift;
    $self->render('index/home');
}

1;
