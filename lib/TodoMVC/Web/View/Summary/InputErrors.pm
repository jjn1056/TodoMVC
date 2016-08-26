package  TodoMVC::Web::View::Summary::InputErrors;

use Moose;
use HTTP::Status qw(:constants);

extends 'Catalyst::View::Template::Pure';

has 'errors_by_name' => (is=>'ro', isa=>'HashRef', required=>1);

__PACKAGE__->config(
  returns_status => [HTTP_BAD_REQUEST],
  directives => [
    'input[name="title"]+' => {
      'err<-errors_by_name.optional:title' => [
        '.' => sub {
           my ($t, $dom, $data) = @_;
           return $t->encoded_string(
              '<span style="background-color:#fff0f0; width=100%;">'. 
              $t->data_at_path($data, 'err') .
              '</span>');
        },
      ],
    },
  ],
);

__PACKAGE__->meta->make_immutable;

