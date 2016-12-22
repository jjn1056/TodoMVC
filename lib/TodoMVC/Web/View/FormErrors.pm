package  TodoMVC::Web::View::FormErrors;

use Moose;
use HTTP::Status qw(:constants);
use Catalyst::View::Template::Pure::Helpers (':All');

extends 'Catalyst::View::Template::Pure';

has 'id' => (is=>'ro', required=>1);
has 'errors_by_name' => (is=>'ro', isa=>'HashRef', required=>1);
has 'input_wrapper' => (is=>'ro', required=>1);

__PACKAGE__->config(
  returns_status => [HTTP_BAD_REQUEST],
  directives => [
    'form#={id}' => {
      'errs<-errors_by_name' => [
        '^input[name="={i.index}"]' => '/input_wrapper',
      ],
    },
  ],
);

__PACKAGE__->meta->make_immutable;

