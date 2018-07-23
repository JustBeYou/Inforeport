package InfoReport::Model::Users;
use InfoReport::Schema;
use InfoReport::Model::Scraper;

my $schema = InfoReport::Schema->getConnection();
my $resultset = $schema->resultset('Users');

sub updateUserData {
    my $username = shift;

    my $data = readUserData($username);

    if (defined $data) {
        # if already exists, update
    } else {
        # else create entry
        # TODO: implement this for real

        $resultset->create({
                id => 1,
                username => 'mihai',
                solved => 100,
                tried => 10,
                totalSubmissions => 500,
                activityData => '{}',
                lastSubmission => ''
            });
    }


}

sub readUserData {
    my $username = shift;

    my $query = $resultset->search({username => $username});
    return $query->first;
}

sub checkIfUserChanged {
    my $username = shift;
    my $lastDate = shift;


}

sub generateActivityReport {
    my $username = shift;
    my $data     = shift;
}

1;
