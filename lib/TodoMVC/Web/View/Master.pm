package  TodoMVC::Web::View::Master;

use Moo;
extends 'Catalyst::View::Template::Lace';
with 'Template::Lace::ModelRole',
  'Template::Lace::Model::AutoTemplate';

has [qw/title body/] => (is=>'ro', required=>1);
has scripts => (is=>'ro');

sub template {q{
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1" name="viewport">
    <title>Page Title</title>
    <link href="/static/base.css" rel="stylesheet">
    <link href="/static/index.css" rel="stylesheet">
  </head>
  <body>
    <p>It goes here...</p>
  </body>
  </html>
}}

sub on_component_add {
  my ($self, $dom) = @_;
  $dom->title($self->title)
    ->head(sub { $_->append_content($self->scripts->join) if $self->scripts })
    ->body(sub { $_->content($self->body) });
}

1;
