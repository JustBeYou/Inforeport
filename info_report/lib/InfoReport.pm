package InfoReport;
use Mojo::Base 'Mojolicious';
use InfoReport::Model::Scraper;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  # Router
  my $r = $self->routes;

  $r->get('/')->to('index#home');

  my $data = InfoReport::Model::Scraper::getUserSubmissions('GavrilaVlad', 0);
}

1;
