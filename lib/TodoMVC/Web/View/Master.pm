package  TodoMVC::Web::View::Master;

use Moo;
extends 'Catalyst::View::Template::Pure';

has [qw/title body/] => (is=>'ro', required=>1);

__PACKAGE__->config(
  auto_template_src => 1,
  directives => [
    'title' => 'title',
    '^body' => 'body',
  ],
);

