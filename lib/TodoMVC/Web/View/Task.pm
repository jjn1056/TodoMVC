package  TodoMVC::Web::View::Task;
 
use Moo;
extends 'Catalyst::View::Template::Lace';
with 'Template::Lace::Model::AutoTemplate';

has 'title' => (is=>'ro', required=>1);
has 'errors_by_name' => (is=>'ro', required=>1);

sub process_dom {
  my ($self, $dom) = @_;
  $dom->at('input[name="title"]')
    ->attr('value', $self->title)
    ->root
    ->at('.input_with_errors span')
    ->repeat(sub {
      my ($dom, $item, $idx) = @_;
      $dom->content($item);
    }, @{$self->errors_by_name->{title}});
}

1;

