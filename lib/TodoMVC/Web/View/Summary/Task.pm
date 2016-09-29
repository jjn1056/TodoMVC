package  TodoMVC::Web::View::Summary::Task;

use Moose;
use HTTP::Status qw(:constants);
use Catalyst::View::Template::Pure::Helpers (':All');

extends 'Catalyst::View::Template::Pure';

has 'id' => (is=>'ro', required=>1);
has 'title' => (is=>'ro', required=>1);
has 'completed' => (is=>'ro', required=>1);

__PACKAGE__->config(
  directives => [
    'li@class' => 'completed | cond("completed", undef)',
    'li@id+' => 'id',
    '.destroy@formaction' => Uri('Task.delete',['={id}']),
    'label@data-task' => 'id',
    'form@action' => Uri('Task.update',['={id}']),
    'label' => 'title',
    'input[name="title"]@value' => 'title',
    'input[name="completed"]@checked' => 'completed | cond("on",undef)',
  ],
);

__PACKAGE__->meta->make_immutable;

