package InfoReport;
use Mojo::Base 'Mojolicious';
use InfoReport::Schema;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  # Deploy DB
  my $schema = InfoReport::Schema->getConnection();
  $schema->deploy();

  # Router
  my $r = $self->routes;

  $r->get('/')->to('index#home');
  $r->get('/users/:username')->to('users#userGET');
  $r->post('/users/:username')->to('users#userPOST');
  $r->get('/users/:username/changed')->to('users#changedGET');
}

1;
