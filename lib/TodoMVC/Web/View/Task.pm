package  TodoMVC::Web::View::Task;
 
use Moose;
use HTTP::Status qw(:constants);
use Catalyst::View::Template::Pure::Helpers (':All');

extends 'Catalyst::View::Template::Pure';

has 'fif' => (is=>'ro', required=>1);
has 'errors_by_name' => (is=>'ro', required=>1);

__PACKAGE__->config(
  returns_status => [HTTP_OK, HTTP_BAD_REQUEST],
  auto_template_src => 1,
  directives => [
    '^input[name="title"]' => [
      '.@value' => 'fif.title',
      '^.' => {
        'errs<-errors_by_name' => Wrap('Summary::InputErrWrapper'),
      },
    ],
  ],
);

__PACKAGE__->meta->make_immutable;
