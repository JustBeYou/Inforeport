package InfoReport::Model::Users;
use InfoReport::Schema;
use InfoReport::Model::Scraper;
use JSON;

my $schema = InfoReport::Schema->getConnection();
my $resultset = $schema->resultset('Users');

sub generateUserActivity {
    my @data = @_;
    my %activity = ();
    $activity{totalSubmissions} = scalar @data;
    $activity{solved} = 0;

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

        $activity{solved} += $elem->{score} eq "100" ? 1 : 0;
    }

    return %activity;
}

sub updateUserData {
    my $username = shift;

    my $data = readUserData($username);

    if (defined $data and checkIfUserChanged($username)) {
        # if already exists, update
        @submissions = InfoReport::Model::Scraper::scrapeUser($username);
        %userActivity = generateUserActivity(@submissions);
        
        $data->update({
            totalSubmissions => $userActivity{totalSubmissions},
            activityData => encode_json \%userActivity,
            lastSubmission => InfoReport::Model::Scraper::getUserLastSubmissionDate($username),
            solved => $userActivity{solved}
            });
    } else {
        # else create entry
        @submissions = InfoReport::Model::Scraper::scrapeUser($username);
        %userActivity = generateUserActivity(@submissions);               
      
        $resultset->create({
            username => $username,
            totalSubmissions => $userActivity{totalSubmissions},
            activityData => encode_json \%userActivity,
            lastSubmission => InfoReport::Model::Scraper::getUserLastSubmissionDate($username),
            solved => $userActivity{solved}
            });
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
        $hash{totalSubmissions} = $data->totalSubmissions;
        $hash{activityData} = decode_json $data->activityData;
        $hash{lastSubmission} = $data->lastSubmission;
    }

    return %hash; 
}

sub checkIfUserChanged {
    my $username = shift;
    
    $data = readUserData($username);
    if (not defined $data) { return 1; }

    %data = userQueryDataToHash($data); 

    print "$lastDate $data{lastSubmission}\n";
    $lastDate = InfoReport::Model::Scraper::getUserLastSubmissionDate($username);
    if ($lastDate eq $data{lastSubmission}) { return 0; }

    return 1;
}

sub checkIfUserExists {
    my $username = shift;
    return InfoReport::Model::Scraper::checkUser($username);
}

1;
