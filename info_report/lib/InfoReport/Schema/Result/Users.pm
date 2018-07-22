package InfoReport::Schema::Result::Post;
use base qw/DBIx::Class::Core/;

# Associated table in database
__PACKAGE__->table('users');

__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1,
    },

    solved => {
        data_type => 'integer',
    },

    tried => {
        data_type => 'integer',
    },

    totalSubmissions => {
        data_type => 'integer',
    },

    activityData => {
        data_type => 'text',
    },

    lastSubmission => {
        data_type => 'datetime',
    },
);
