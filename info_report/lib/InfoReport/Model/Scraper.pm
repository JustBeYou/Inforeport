package InfoReport::Model::Scraper;

use strict;
use warnings;

# HOW THIS SHOULD LOOK LIKE???
use InfoReport::Model::Submission;

use HTTP::Request ();
use LWP::UserAgent;
use LWP::Protocol::https;
use HTML::TreeBuilder::XPath;

my $defaultUserAgent = 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0';
my $submissionsPage = 'https://www.infoarena.ro/monitor?user=';
my $monitorParameters = '&display_entries=250&first_entry=';

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
    my $firstEntry = shift;

    my $url = $submissionsPage.$user.$monitorParameters.$firstEntry;
    my $contents = get($url);

    my @submissions = ();

    my $tree = HTML::TreeBuilder::XPath->new();
    $tree->parse($contents);

    my @rows = $tree->findnodes('//table[@class="monitor"]/tbody/tr');
    
    for my $row (@rows) {
        my @attributes = ();
        for my $element ($row->content_list) {
            push @attributes, $element;
        }
        my $status;
        my $score;

        if ($attributes[6] eq "Submisie ignorata") {
            $status = "ignored";
            $score = -1;
        } elsif ($attributes[6] eq "Evaluare completa") {
            $status = "hidden";
            $score = -1;
        } elsif ($attributes[6] =~ m/Evaluare completa: \d+ puncte/g) {
            $status = "complete";
            $score = $&;
        } else {
            $status = "error";
            $score = -1;
        }

        for my $i (0..$#attributes) {
            $attributes[$i] = $attributes[$i]->as_trimmed_text;
        }

        my $toAdd = InfoReport::Model::Submission->new(
            id => $attributes[0],
            username => $user,
            problem => $attributes[2],
            competition => $attributes[3],
            size => $attributes[4],
            date => $attributes[5],
            status => "",
            score => 0
        );

        push @submissions, $toAdd;
    }

    $tree->delete;
    return @submissions;
}

sub scrapeUser {
    my $username = shift;

    my @submissions = ();
    my $index = 0;
    my @toAdd = getUserSubmissions($username, $index);
    while (@toAdd) {
        push @submissions, @toAdd;
        $index += 250;
        @toAdd = getUserSubmissions($username, $index);
    }

    return @submissions;
}

1;
