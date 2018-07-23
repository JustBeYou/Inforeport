package InfoReport::Model::Scraper;

use strict;
use warnings;

use HTTP::Request ();
use LWP::UserAgent;
use LWP::Protocol::https;
use HTML::TreeBuilder::XPath;

my $defaultUserAgent = 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0';
my $submissionsPage = 'https://www.infoarena.ro/monitor?user=';

sub get {
    my $url = shift;

    my $req = HTTP::Request->new('GET', $url);
    my $ua = LWP::UserAgent->new();
    $ua->agent($defaultUserAgent);
    my $res = $ua->request($req);

    return $res->as_string();
}

sub getUserLastSubmissionDate {
    my $user = shift;
    my $url = $submissionsPage.$user;
    my $contents = get($url);

    $contents =~ m/\d+ [a-z]+ \d+ \d+:\d+:\d+/g;
    return $&; # return first match
}

sub getUserSubmissions { 
    my $user = shift;
    my $url = $submissionsPage.$user;
    my $contents = get($url);

    my @submissions = ();

    my $tree = HTML::TreeBuilder::XPath->new();
    $tree->parse($contents);

    my @rows = $tree->findnodes('//table[@class="monitor"]/tbody/tr');
    
    for my $row (@rows) {
        for my $element ($row->content_list) {
        }
    }

    $tree->delete;
    return @submissions;
}

my @s = getUserSubmissions("GavrilaVlad");
