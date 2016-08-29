package  TodoMVC::Web::View::Summary;
 
use Moose;
use HTTP::Status qw(:constants);
 
extends 'Catalyst::View::Template::Pure';

has 'set' => (is=>'ro', required=>1);
has 'tasks' => (is=>'ro', required=>1);
 
__PACKAGE__->config(
  timestamp => scalar(localtime),
  returns_status => [HTTP_OK],
  auto_template_src => 1,
  directives => [
    'ul.todo-list li' => {
      '.<-tasks' => [
        '.@class' => 'completed | cond("completed", undef)',
        '.destroy@formaction+' => '={id}/delete',
        '.@id+' => 'id',
        'label@data-task' => 'id',
        'form@action+' => 'id',
        'label' => 'title',
        'input[name="title"]@value' => 'title',
        'input[name="completed"]@checked' => 'completed | cond("on",undef)',
      ],
    },
    '.todo-count strong' => 'tasks.active.count',
    '.filters a.={set}@class' => '"selected"',
  ],
);
 
__PACKAGE__->meta->make_immutable
