package InfoReport::Model::Users;
use InfoReport::Schema;
use InfoReport::Model::Scraper;

my $schema = InfoReport::Schema->getConnection();
my $resultset = $schema->resultset('Users');

# debug
use Data::Dumper;

sub generateUserActivity {
    my @data = @_;
    my %activity = ();

    my $year, $month, $day;
    foreach my $elem (@data) {
        $year = $elem->{year};
        $month = $elem->{month};
        $day = $elem->{day};

        if (defined $activity{$year}) {
            if (defined $activity{$year}{competitions}{$elem->{competition}}) {
                $activity{$year}{competitions}{$elem->{competition}} += 1;
            } else {
                $activity{$year}{competitions}{$elem->{competition}} = 1;
            }
            $activity{$year}{totalSubmissions} += 1;
            $activity{$year}{solutions} += $elem->{score} eq "100" ? 1 : 0;
        } else {
            $activity{$year}{months} = {};
            $activity{$year}{competitions}{$elem->{competition}} = 1;
            $activity{$year}{totalSubmissions} = 1;
            $activity{$year}{solutions} = $elem->{score} eq "100" ? 1 : 0;
        }

        if (defined $activity{$year}{months}{$month}) {
            $activity{$year}{months}{$month}{totalSubmissions} += 1;
            $activity{$year}{months}{$month}{solutions} += $elem->{score} eq "100" ? 1 : 0;
        } else {
            $activity{$year}{months}{$month}{days} = {};
            $activity{$year}{months}{$month}{totalSubmissions} = 1;
            $activity{$year}{months}{$month}{solutions} = $elem->{score} eq "100" ? 1 : 0;
        }

        if (defined $activity{$year}{months}{$month}{days}{$day}) {
            $activity{$year}{months}{$month}{days}{$day} += 1;
        } else {
            $activity{$year}{months}{$month}{days}{$day} = 1;
        }
    }
    print Dumper(\%activity)."\n\n";

    return %activity;
}

sub updateUserData {
    my $username = shift;

    my $data = readUserData($username);

    if (defined $data and checkIfUserChanged($username)) {
        # if already exists, update
    } else {
        # else create entry
        @submissions = InfoReport::Model::Scraper::scrapeUser($username);
        %userActivity = generateUserActivity(@submissions);               
    }


}

sub readUserData {
    my $username = shift;

    my $query = $resultset->search({username => $username});
    return $query->first;
}

sub userQueryDataToHash {
    my $data = shift;
    my %hash = ();

    if (defined data) {
        $hash{id} = $data->id;
        $hash{username} = $data->username;
        $hash{solved} = $data->solved;
        $hash{tried} = $data->tried;
        $hash{totalSubmissions} = $data->totalSubmissions;
        $hash{activityData} = $data->activityData;
        $hash{lastSubmission} = $data->lastSubmission;
    }

    return %hash; 
}

sub checkIfUserChanged {
    my $username = shift;
    my $lastDate = shift;

    return 1;
}

sub generateActivityReport {
    my $username = shift;
    my $data     = shift;
}

1;
